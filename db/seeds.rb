#encoding: utf-8

if StatisticIndex.count == 0
  StatisticIndex.create!([
     {id:1, es_type_key:'subscription', label:I18n.t('statistics.subscriptions')},
     {id:2, es_type_key:'machine', label:I18n.t('statistics.machines_hours')},
     {id:3, es_type_key:'training', label:I18n.t('statistics.trainings')},
     {id:4, es_type_key:'event', label:I18n.t('statistics.events')},
     {id:5, es_type_key:'account', label:I18n.t('statistics.registrations'), ca: false},
     {id:6, es_type_key:'project', label:I18n.t('statistics.projects'), ca: false},
     {id:7, es_type_key:'user', label:I18n.t('statistics.users'), table: false, ca: false}
  ])
  connection = ActiveRecord::Base.connection
  if connection.instance_values['config'][:adapter] == 'postgresql'
    connection.execute("SELECT setval('statistic_indices_id_seq', 7);")
  end
end

if StatisticField.count == 0
  StatisticField.create!([
    # available data_types : index, number, date, text, list
    {key:'trainingId', label:I18n.t('statistics.training_id'), statistic_index_id: 3, data_type: 'index'},
    {key:'trainingDate', label:I18n.t('statistics.training_date'), statistic_index_id: 3, data_type: 'date'},
    {key:'eventId', label:I18n.t('statistics.event_id'), statistic_index_id: 4, data_type: 'index'},
    {key:'eventDate', label:I18n.t('statistics.event_date'), statistic_index_id: 4, data_type: 'date'},
    {key:'themes', label:I18n.t('statistics.themes'), statistic_index_id: 6, data_type: 'list'},
    {key:'components', label:I18n.t('statistics.components'), statistic_index_id: 6, data_type: 'list'},
    {key:'machines', label:I18n.t('statistics.machines'), statistic_index_id: 6, data_type: 'list'},
    {key:'name', label:I18n.t('statistics.event_name'), statistic_index_id: 4, data_type: 'text'},
    {key:'userId', label:I18n.t('statistics.user_id'), statistic_index_id: 7, data_type: 'index'},
    {key:'eventTheme', label:I18n.t('statistics.event_theme'), statistic_index_id: 4, data_type: 'text'},
    {key:'ageRange', label:I18n.t('statistics.age_range'), statistic_index_id: 4, data_type: 'text'}
  ])
end

unless StatisticField.find_by(key:'groupName').try(:label)
  field = StatisticField.find_or_initialize_by(key: 'groupName')
  field.label = 'Groupe'
  field.statistic_index_id = 1
  field.data_type = 'text'
  field.save!
end

if StatisticType.count == 0
  StatisticType.create!([
    {statistic_index_id: 2, key: 'booking', label:I18n.t('statistics.bookings'), graph: true, simple: true},
    {statistic_index_id: 2, key: 'hour', label:I18n.t('statistics.hours_number'), graph: true, simple: false},
    {statistic_index_id: 3, key: 'booking', label:I18n.t('statistics.bookings'), graph: false, simple: true},
    {statistic_index_id: 3, key: 'hour', label:I18n.t('statistics.hours_number'), graph: false, simple: false},
    {statistic_index_id: 4, key: 'booking', label:I18n.t('statistics.tickets_number'), graph: false, simple: false},
    {statistic_index_id: 4, key: 'hour', label:I18n.t('statistics.hours_number'), graph: false, simple: false},
    {statistic_index_id: 5, key: 'member', label:I18n.t('statistics.users'), graph: true, simple: true},
    {statistic_index_id: 6, key: 'project', label:I18n.t('statistics.projects'), graph: false, simple: true},
    {statistic_index_id: 7, key: 'revenue', label:I18n.t('statistics.revenue'), graph: false, simple: false}
  ])
end

if StatisticSubType.count == 0
  StatisticSubType.create!([
    {key: 'created', label:I18n.t('statistics.account_creation'), statistic_types: StatisticIndex.find_by(es_type_key: 'account').statistic_types},
    {key: 'published', label:I18n.t('statistics.project_publication'), statistic_types: StatisticIndex.find_by(es_type_key: 'project').statistic_types}
  ])
end

if StatisticGraph.count == 0
  StatisticGraph.create!([
    {statistic_index_id:1, chart_type:'stackedAreaChart', limit:0},
    {statistic_index_id:2, chart_type:'stackedAreaChart', limit:0},
    {statistic_index_id:3, chart_type:'discreteBarChart', limit:10},
    {statistic_index_id:4, chart_type:'discreteBarChart', limit:10},
    {statistic_index_id:5, chart_type:'lineChart', limit:0},
    {statistic_index_id:7, chart_type:'discreteBarChart', limit:10}
  ])
end

if Group.count == 0
  Group.create!([
    {name: 'standard member', slug: 'standard'},
    {name: 'student, senior, veteran, first responder, unemployed', slug: 'student'},
    {name: 'supporter member (limited use)', slug: 'merchant'},
    {name: 'resident maker, volunteer', slug: 'business'},
    {name: 'paused membership', slug: 'paused-membership'}
  ])
end

unless Group.find_by(slug: 'admins')
  Group.create! name: I18n.t('group.admins'), slug: 'admins'
end

# Create the default admin if none exists yet
if Role.where(name: 'admin').joins(:users).count === 0
    admin = User.new(username: 'admin', email: ENV["ADMIN_EMAIL"], password: ENV["ADMIN_PASSWORD"], password_confirmation: Rails.application.secrets.admin_password, group_id: Group.find_by(slug: 'admins').id, profile_attributes: {first_name: 'admin', last_name: 'admin', gender: true, phone: '0123456789', birthday: Time.now})
    admin.add_role 'admin'
    admin.save!
end

if Component.count == 0
  Component.create!([
    {name: 'Silicone'},
    {name: 'Vinyle'},
    {name: 'Bois Contre plaqué'},
    {name: 'Bois Medium'},
    {name: 'Plexi / PMMA'},
    {name: 'Flex'},
    {name: 'Vinyle'},
    {name: 'Parafine'},
    {name: 'Fibre de verre'},
    {name: 'Résine'}
  ])
end

if Licence.count == 0
  Licence.create!([
    {name: 'Attribution (BY)', description: 'The owner of the rights authorizes any exploitation of the work, including for commercial purposes, as well as the creation of derivative works, the distribution of which is also authorized without restriction, provided that it is attributed to its author by quoting his name. This license is recommended for the dissemination and maximum use of works.'},
    {name: 'Attribution + No modifications (BY ND)', description: 'The rights holder authorizes any use of the original work (including for commercial purposes), but does not authorize the creation of derivative works.'},
    {name: "Attribution + No Commercial Use + No Modification (BY NC ND)", description: 'The rights holder authorizes the use of the original work for non-commercial purposes, but does not authorize the creation of derivative works.'},
    {name: "Attribution + No Commercial Use (BY NC)", description: 'The owner of the rights authorizes the exploitation of the work, as well as the creation of derivative works, provided that it is not a commercial use (the commercial uses remaining subject to its authorization).'},
    {name: "Attribution + No Commercial Use + Sharing under the same conditions (BY NC SA)", description: 'The rights holder authorizes the exploitation of the original work for non-commercial purposes, as well as the creation of derivative works, provided that they are distributed under a license identical to that governing the original work.'},
    {name: 'Attribution + Sharing under the same conditions (BY SA)', description: 'The rights holder authorizes any use of the original work (including for commercial purposes) as well as the creation of derivative works, provided that they are distributed under a license identical to that governing the original work. This license is often compared to copyleft licenses for free software. This is the license used by Wikipedia.'}
  ])
end

if Theme.count == 0
  Theme.create!([
    {name: 'Everyday life'},
    {name: 'Robotics'},
    {name: 'Arduino'},
    {name: 'Sensors'},
    {name: 'Music'},
    {name: 'Sports'},
    {name: 'Other'}
  ])
end

if Training.count == 0
  Training.create!([
    {name: '3D Printer Training', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
    {name: 'Laser / Vinyl Training', description: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'},
    {name: 'Small Digital Milling Machine Training', description: 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'},
    {name: 'Shopbot Training Large Milling Machine', description: 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'},
    {name: '2D Software Training', description: 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.'}
  ])

  TrainingsPricing.all.each do |p|
    p.update_columns(amount: (rand * 50 + 5).floor * 100)
  end
end

if Machine.count == 0
  Machine.create!([
    {name: 'Laser Cutting Machine', description: "Preparing to use the EPILOG Legend 36EXT General information For cutting, simply bring your vector file illustrator, svg or dxf with \"cut lines\" of a thickness less than 0.01 mm and the machine will take care of the rest!\r\nThe engraving is based on the black and white spectrum. Shades are obtained by different engraving depths corresponding to the gray levels of your image. Simply bring a scanned image or a photo file in black and white to reproduce it on your support! What types of materials can we engrave/cut? From wood to fabric, from plexiglass to leather, this machine can cut and engrave most materials except metals. Engraving is nevertheless possible on the metals covered with a layer of paint or the anodized aluminum. Regarding the thickness of the cut materials, it is preferable not to exceed 5 mm for wood and 6 mm for plexiglass.\r\n", spec: "Power: 40W Working surface: 914x609mm Maximum thickness of the material: 305mm Laser source: CO2-type laser tube Speed and power controls: these two parameters are adjustable according to the material (from 1% to 100%).\r\n", slug: 'laser-cutter'},
    {name: 'Vinyl Cutter', description: "Preparing to use the Roland CAMM-1 GX24 General Information Want to make a custom t-shirt? A sticker with the effigy your favorite band? A mask for the realization of a printed circuit? For that, it is enough simply to come with your vectorized file (do not forget to vectorize the texts) type illustrator svg or dxf. Materials used: This machine makes it possible to cut mainly vinyl, reflective vinyl, flex.\r\n", spec: "Accepted support widths: from 50 mm to 700 mm Cutting speed: 50 cm / sec Mechanical resolution: 0.0125 mm / pitch\r\n", slug: 'vinyl-cutter'},
    {name: 'Shopbot/Large Milling Machine', description: "The standard ShopBot PRS digital milling machine \r\nGeneral information\r\nThis machine is a 3-axis milling machine ideal for machining large workpieces. From the creation of a chair or a piece of furniture to the construction of a huge house or assembly, the ShopBot opens many doors to your imagination! Machinable Materials The main machinable materials are wood, plastic, brass and many others. This machine does not machine metals.\r\n", spec: "Maximum working area: 2440x1220x150 (Z) mm Software used: 2D & 3D parts Mechanical resolution: 0.015 mm Position accuracy: +/- 0.127mm Accepted formats: DXF, STL \r\n", slug: 'shopbot-large-milling'},
    {name: '3D Printer', description: "The utimaker is a low cost 3D printer using FFF (Fused Filament Fabrication) technology with thermoplastic extrusion.\r\nIt is an ideal machine to quickly make 3D prototypes in different colors.\r\n", spec: "Maximum working surface: 210x210x220mm Mechanical resolution: 0.02 mm Position accuracy: +/- 0.05 Software used: Cura \r\n Accepted file formats: STL \r\n Materials used : PLA (in stock).", slug: '3d-printer'},
    {name: 'Small Milling Machine', description: "Roland Modela MDX-20 Digital Milling Machine General Information This machine is used for precision machining and 3D scanning. It mainly makes it possible to machine printed circuits and small molds. The small diameter of the cutters used (Ø 0.3 mm to Ø 6 mm) induces that some machining times can be long (> 12h), which is why this milling machine can be left in autonomy all night to obtain the more precise machining at FabLab. Machinable Materials: The main machinable materials are wood, plaster, resin, machinable wax, copper.\r\n", spec: "X / Y table size: 220 mm x 160 mm Maximum working volume: 203.2 mm (X), 152.4 mm (Y), 60.5 mm (Z) Machining accuracy: 0.00625 mm Scanning accuracy: adjustable from 0.05 to 5 mm (X, Y axes) and 0.025 mm (Z axis) Scanning speed: 4-15 mm / sec Software used for milling: Roland Modela player 4 Software used for PCB machining: Cad.py (linux) Accepted formats: STL, PNG 3D Export format of scanned data: DXF, VRML, STL, 3DMF, IGES, Grayscale, Point Group and BMP\r\n", slug: 'small-milling-machine'},
    {name: 'FORM1 + 3D Printer', description: "Form 1+, stereolithography 3D printer. \n\n Colopolymerization is the first rapid prototyping process to have been developed in the 1980s. The name of SLA (for StereoLithography Apparatus) was given to it. It is based on the properties of certain resins to polymerize under the effect of light and heat. (Source: <a href=\"http://en.wikipedia.org/wiki/Stampolography,\" target=\"_blank\">wikipedia</a>) \n\n <i>Ability to use 3 resins of different colors at Lab: black, white and translucent. </i> \n\n <a href=\"http://formlabs.com/en/products/materials/standard/\" Title=\"http://formlabs.com/en/products/materials/standard/\" target=\"_blank\"> More information on the Formlab website </a>", spec: "Printer: \n- Dimensions: 30 × 28 × 45 cm \n- Weight: 8 kg \n- Operating temperature: 18-28 ° C \n- Power supply: 100-240 V; 1.5 at 50/60 Hz; 60 W. \n \nLaser Features: \n- EN 60825-1: 2007 Certified \n- Class 1 Laser Product \n- 405nm Purple Laser \n \nPrint Properties: \n- Stereolithography Technology (SLA) \n- Print volume: 125 × 125 × 165 mm \n- Minimum size: 300 microns \n- Thickness of layers (vertical resolution): 25, 50, 100 microns \n- Automatically generated resources \n- Easily removable", slug: 'form1-3d-printer'}
  ])

  Price.all.each do |p|
    p.update_columns(amount: (rand()*50+5).floor*100)
  end
end

# if Plan.count == 0
#   Group.all.each do |group|
#     %w(month year).each do |interval|
#       Plan.create!(base_name: "plan #{SecureRandom.hex(4)}", amount: (rand()*200+50).floor*100, interval: interval, group: group)
#     end
#   end
# end

if Category.count == 0
  Category.create!([
    {name: 'Training'},
    {name: 'Workshop'}
  ])
end

unless Setting.find_by(name: 'about_body').try(:value)
  setting = Setting.find_or_initialize_by(name: 'about_body')
  setting.value = "We are a community of inventive, creative, artistic, innovative, fun and welcoming people who love to make things and have a great time doing it. Make Nashville is a member-led organization that was founded in 2012 to be the focal point of the maker movement in the region and became a registered federal 501(c)(3) nonprofit in 2015. Our purpose is to provide the community, training, tools, and opportunity for everyone to experience the transformative experience of making. We want to help more people make, and to help makers make more.

  We’ve been putting on the Nashville Mini Maker Faire for the last four years, sharing STEAM education and our passion for making with as many as 6,000 people. This year’s Faire will be held at Vanderbilt University on September 30th and October 1st and will feature Bot Battles, Competitive PowerWheels Exhibitions, and Drone Competitions along with dozens of maker exhibits, workshops, demonstrations, and performances, both inside and out!

  Around a year and a half ago, after years of planning, fundraising, and the efforts of dozens of volunteers we opened Nashville’s first all-ages non-profit makerspace! This over 9,500 square foot facility shared with two nonprofit partners enables us to host workshops, builds, events, and provide members with the space and equipment to create some truly amazing things. In the last year, we have seen inspiring art installations, amazing concerts, innovative inventions, incredible feats of science and technology, market-changing entrepreneurial prototypes, skill-strengthening projects, crazy and fun maker builds, and awesome feats of education in the space. We hope you will join us! Become a member today!"
  setting.save
end

unless Setting.find_by(name: 'about_title').try(:value)
  setting = Setting.find_or_initialize_by(name: 'about_title')
  setting.value = 'Imaginer, Fabriquer, <br>Partager au Fab Lab <br> de La Casemate'
  setting.save
end

unless Setting.find_by(name: 'about_contacts').try(:value)
  setting = Setting.find_or_initialize_by(name: 'about_contacts')
  setting.value = 'Information:
  info@makenashville.org

  Member Experience:
  Joel Lindsey
  joel@makenashville.org

  Workshops Lead:
  Jenn Deafenbaugh
  jenn@makenashville.org

  Facilities Director:
  Jonathan Taufer
  jonathan@makenashville.org

  Makerspace President:
  Matt Kenigson
  matt@makenashville.org

  Visit the Make Nashville Website'
  setting.save
end

unless Setting.find_by(name: 'twitter_name').try(:value)
  setting = Setting.find_or_initialize_by(name: 'twitter_name')
  setting.value = 'makenashville'
  setting.save
end

unless Setting.find_by(name: 'machine_explications_alert').try(:value)
  setting = Setting.find_or_initialize_by(name: 'machine_explications_alert')
  setting.value = 'Any purchase of machine time is final. No cancellation can be made, however no later than 24 hours before the fixed window, you can change the date and time at your convenience and according to the proposed schedule. After this time, no change can be made.'
  setting.save
end

unless Setting.find_by(name: 'training_explications_alert').try(:value)
  setting = Setting.find_or_initialize_by(name: 'training_explications_alert')
  setting.value = 'Any reservation of training is final. No cancellation can be made, however no later than 24 hours before the fixed window, you can change the date and time at your convenience and according to the proposed schedule. After this time, no change can be made.'
  setting.save
end

unless Setting.find_by(name: 'subscription_explications_alert').try(:value)
  setting = Setting.find_or_initialize_by(name: 'subscription_explications_alert')
  setting.value = 'Rule on the start date of subscriptions

  If you are a new user - i.e no registration training on the site - your subscription will start on the date of booking your first training.
  If you already have a training or more validated, your subscription will start on the date of your subscription purchase.

  Thank you for taking this information into account, and thank you for your understanding. The Make Nashville team.'
  setting.save
end

unless Setting.find_by(name: 'invoice_logo').try(:value)
  setting = Setting.find_or_initialize_by(name: 'invoice_logo')
  setting.value = 'data:image/png;base64,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'
  setting.save
end

unless Setting.find_by(name: 'invoice_reference').try(:value)
  setting = Setting.find_or_initialize_by(name: 'invoice_reference')
  setting.value = 'YYMMmmmX[/VL]R[/A]'
  setting.save
end

unless Setting.find_by(name: 'invoice_code-active').try(:value)
  setting = Setting.find_or_initialize_by(name: 'invoice_code-active')
  setting.value = 'true'
  setting.save
end

unless Setting.find_by(name: 'invoice_code-value').try(:value)
  setting = Setting.find_or_initialize_by(name: 'invoice_code-value')
  setting.value = 'INMEDFABLAB'
  setting.save
end

unless Setting.find_by(name: 'invoice_order-nb').try(:value)
  setting = Setting.find_or_initialize_by(name: 'invoice_order-nb')
  setting.value = 'nnnnnn-MM-YY'
  setting.save
end

unless Setting.find_by(name: 'invoice_VAT-active').try(:value)
  setting = Setting.find_or_initialize_by(name: 'invoice_VAT-active')
  setting.value = 'false'
  setting.save
end

unless Setting.find_by(name: 'invoice_VAT-rate').try(:value)
  setting = Setting.find_or_initialize_by(name: 'invoice_VAT-rate')
  setting.value = '20.0'
  setting.save
end

unless Setting.find_by(name: 'invoice_text').try(:value)
  setting = Setting.find_or_initialize_by(name: 'invoice_text')
  setting.value = "Notre association n'est pas assujettie à la TVA"
  setting.save
end

unless Setting.find_by(name: 'invoice_legals').try(:value)
  setting = Setting.find_or_initialize_by(name: 'invoice_legals')
  setting.value = 'Make Nashville<br/>'+
                  '947 Woodland Street, Nashville, TN 37206<br/>'+
                  'Tél. 615.450.6253<br/>'
  setting.save
end

unless Setting.find_by(name: 'booking_window_start').try(:value)
  setting = Setting.find_or_initialize_by(name: 'booking_window_start')
  setting.value = '1970-01-01 08:00:00'
  setting.save
end

unless Setting.find_by(name: 'booking_window_end').try(:value)
  setting = Setting.find_or_initialize_by(name: 'booking_window_end')
  setting.value = '1970-01-01 23:59:59'
  setting.save
end

unless Setting.find_by(name: 'booking_move_enable').try(:value)
  setting = Setting.find_or_initialize_by(name: 'booking_move_enable')
  setting.value = 'true'
  setting.save
end

unless Setting.find_by(name: 'booking_move_delay').try(:value)
  setting = Setting.find_or_initialize_by(name: 'booking_move_delay')
  setting.value = '24'
  setting.save
end

unless Setting.find_by(name: 'booking_cancel_enable').try(:value)
  setting = Setting.find_or_initialize_by(name: 'booking_cancel_enable')
  setting.value = 'false'
  setting.save
end

unless Setting.find_by(name: 'booking_cancel_delay').try(:value)
  setting = Setting.find_or_initialize_by(name: 'booking_cancel_delay')
  setting.value = '24'
  setting.save
end

unless Setting.find_by(name: 'main_color').try(:value)
  setting = Setting.find_or_initialize_by(name: 'main_color')
  setting.value = '#cb1117'
  setting.save
end

unless Setting.find_by(name: 'secondary_color').try(:value)
  setting = Setting.find_or_initialize_by(name: 'secondary_color')
  setting.value = '#ffdd00'
  setting.save
end

Stylesheet.build_sheet!

unless Setting.find_by(name: 'training_information_message').try(:value)
  setting = Setting.find_or_initialize_by(name: 'training_information_message')
  setting.value = 'Before booking a course, we advise you to consult our subscription offers that offer advantageous conditions on the price of training and machine hours.'
  setting.save
end


unless Setting.find_by(name: 'fablab_name').try(:value)
  setting = Setting.find_or_initialize_by(name: 'fablab_name')
  setting.value = 'Make Nashville'
  setting.save
end

unless Setting.find_by(name: 'name_genre').try(:value)
  setting = Setting.find_or_initialize_by(name: 'name_genre')
  setting.value = 'male'
  setting.save
end


unless DatabaseProvider.count > 0
  db_provider = DatabaseProvider.new
  db_provider.save

  unless AuthProvider.find_by(providable_type: DatabaseProvider.name)
    provider = AuthProvider.new
    provider.name = 'Fablab'
    provider.providable = db_provider
    provider.status = 'active'
    provider.save
  end
end

unless Setting.find_by(name: 'reminder_enable').try(:value)
  setting = Setting.find_or_initialize_by(name: 'reminder_enable')
  setting.value = 'true'
  setting.save
end

unless Setting.find_by(name: 'reminder_delay').try(:value)
  setting = Setting.find_or_initialize_by(name: 'reminder_delay')
  setting.value = '24'
  setting.save
end

unless Setting.find_by(name: 'visibility_yearly').try(:value)
  setting = Setting.find_or_initialize_by(name: 'visibility_yearly')
  setting.value = '3'
  setting.save
end

unless Setting.find_by(name: 'visibility_others').try(:value)
  setting = Setting.find_or_initialize_by(name: 'visibility_others')
  setting.value = '1'
  setting.save
end

if StatisticCustomAggregation.count == 0
  # available reservations hours for machines
  machine_hours = StatisticType.find_by(key: 'hour', statistic_index_id: 2)

  available_hours = StatisticCustomAggregation.new({
                       statistic_type_id: machine_hours.id,
                       es_index: 'fablab',
                       es_type: 'availabilities',
                       field: 'available_hours',
                       query: '{"size":0, "aggregations":{"%{aggs_name}":{"sum":{"field":"bookable_hours"}}}, "query":{"bool":{"must":[{"range":{"start_at":{"gte":"%{start_date}", "lte":"%{end_date}"}}}, {"match":{"available_type":"machines"}}]}}}'
                    })
  available_hours.save!

  # available training tickets
  training_bookings = StatisticType.find_by(key: 'booking', statistic_index_id: 3)

  available_tickets = StatisticCustomAggregation.new({
                         statistic_type_id: training_bookings.id,
                         es_index: 'fablab',
                         es_type: 'availabilities',
                         field: 'available_tickets',
                         query: '{"size":0, "aggregations":{"%{aggs_name}":{"sum":{"field":"nb_total_places"}}}, "query":{"bool":{"must":[{"range":{"start_at":{"gte":"%{start_date}", "lte":"%{end_date}"}}}, {"match":{"available_type":"training"}}]}}}'
                      })
  available_tickets.save!
end

unless StatisticIndex.find_by(es_type_key: 'space')
  index = StatisticIndex.create!({es_type_key:'space', label:I18n.t('statistics.spaces')})
  StatisticType.create!([
    {statistic_index_id: index.id, key: 'booking', label:I18n.t('statistics.bookings'), graph: true, simple: true},
    {statistic_index_id: index.id, key: 'hour', label:I18n.t('statistics.hours_number'), graph: true, simple: false}
  ])
end
