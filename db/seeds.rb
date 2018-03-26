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
