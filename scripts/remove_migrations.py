import os, shutil
from django.apps import apps
    
print("Removing migrations...")
for app in apps.app_configs.keys():
    
    if os.path.isdir(os.path.join('project','apps', app,'migrations')):    
        folder = os.path.join('project','apps', app,'migrations')
        for file in os.listdir(folder):
            
            if file != "__init__.py":
                file_to_delete = os.path.join(folder,file)
                
                if os.path.isdir(file_to_delete):
                    shutil.rmtree(file_to_delete)
                    
                if os.path.isfile(file_to_delete):
                    os.remove(file_to_delete)
