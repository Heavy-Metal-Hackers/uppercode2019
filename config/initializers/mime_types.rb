# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
Mime::Type.register "application/xls", :xls
Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx
Mime::Type.register "text/plain", :log
Mime::Type.register "text/plain", :txt
#Mime::Type.register "application/pdf", :pdf
Mime::Type.register_alias "text/html", :amp