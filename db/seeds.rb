# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Jede neue Band sollte diese Werte zunächst zur Verfügung gestellt bekommen, damit sie direkt beginnen kann, die Anwendung zu nutzen
StatusValue.create(text: "unbearbeitet", order: 1)
StatusValue.create(text: "Kontakt aufgenommen", order: 2)
StatusValue.create(text: "erledigt", order: 3)

Band.create(name: "Band")