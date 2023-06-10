# HA_3dPrinter_ProgressCard
very dirty way to visually update 3d printing progress.

![preview_printer_animation](https://github.com/propiro/HA_3dPrinter_ProgressCard/assets/21067369/1bbf4514-c7a7-4d42-ae96-47324079f197)

### Features

- Works on standard HA cards, no additional installation required.
- Foolproof after you set it up
- Three color schemes to pick from (white icons, gray and black), depending on your HA theme.

### Requirements
- a sensor that outputs integer value with progress in range from 0 to 100. Must be integer, as in "0", "15" "99", not "0.4" or "21.37"
- default name of sensor that will affect animation is set to "prusa_completion_integer", but youre free to replace it
- around 5mb of space for image sequence
- notepad++
- sftp program to push lot of images to HA www folder
- patience for dumb solution for simple problem

### INSTALATION
- Lets start with copying neccessary files to correct location. This example will use white theme, adjust values/paths accordin to picked up theme.
- Download this repo "source/3dp_w" folder, inside there is image sequence of percentage print completion, in white.
- Put it with any preferred method into "config/www/" directory in your home assistant installation, so it looks like this:
![image](https://github.com/propiro/HA_3dPrinter_ProgressCard/assets/21067369/4856529f-9add-406f-972a-4dfc0199dee2)

I've used SFTP transfer, to do it, you need first to install "Advanced SSH and WebTerminal" addon, and enable SFTP in config ( https://github.com/hassio-addons/addon-ssh ) - If you have other means of uploading lot of files, ignore this step, just make sure you put them into correct place.
- Make sure your browser can access any of the images, You need to know either domain name your home assistant is running, or local IP adress of its installation, In my network I could access it under adress "http://10.0.0.24:8123/local/3dp_w/" + filename, like http://10.0.0.24:8123/local/3dp_w/3d_printer_mesh_1.png. All files are numbered from 0 to 100, so You access them by http://10.0.0.24:8123/local/3dp_w/3d_printer_mesh_XXX.png, where XXX is number of percentage. You probably should guess where were heading with this. 
- Now the dumb part of work - using a conditional cards set up, that will display ONLY ONE card, depending on value of prusa_completion_integer sensor in my example. Adjust the code according to your sensor, or be sure that you have template sensor named prusa_completion_integer. If you don't have one or have no idea how to, I'll show example how to create one based on prusalink api in later section. But in reality, you can feed it any integer value from 0 to 100, so if you're using octoprint or parsing some other api, You'll probably be set up. Back to setting up cards.
- Create new vertical stack card, and create one conditional card inside, pick_completion_integer sensor as source entity, and put value as 0. Click on "card" tab, pick Picture Card, and paste path to your "0" sequenced image, in my example: http://10.0.0.24:8123/local/3dp_w/3d_printer_mesh_0.png. Depending on your browser cache and network speed, you might see picture immidiately:
 
![first_card_creation](https://github.com/propiro/HA_3dPrinter_ProgressCard/assets/21067369/a4fd9a4b-f068-4563-bfe8-faf6148fd71b)
- Click on "Save", you should end up with image of printer with "0" on it, assuming youre not printing anything.

- Now, do that 100 more times. Or use my uploaded YAML file for vertical card that I've generated using... maxscript, a scripting language for 3D Studio max, software that was used to render that printer animation - Since I had to script the percentage change every frame, I've realised I'll save myself lot of work if i also force it to generate and example YAML file for me, where I'd just replace values later. So, download the file (source/verticalCard.yaml.txt), open it up in your favorite text editing application that support replacing text (Notepad++ worked for me) and make sure that you:
1. replace string SENSOR.REPLACE_THIS_SENSOR_NAME with string that points to your sensor (In my case it'll be sensor.prusa_completion_integer string). In total, there should be 101 replacements:
![image](https://github.com/propiro/HA_3dPrinter_ProgressCard/assets/21067369/802796c8-3d96-4bc3-b8b2-dfa6785e59b2)

2. replace string URL.REPLACE_THIS_URL with url to your 3dp_w folder that is accessible by your browser. In my example, its http://10.0.0.24:8123/local, so it should look like this (101 replacements as well):
![image](https://github.com/propiro/HA_3dPrinter_ProgressCard/assets/21067369/e4e5ab30-fd29-4a80-9a7c-ae680ea5e3e9)

End result should be a file that is around 1214 lines long. Ctrl+A, Ctrl+C. Now we'll replace previously made vertical card with this prepped up code. Go back to your Home Asistant, and go into editing vertical card, "show code editor":
![replacement_prepped_code](https://github.com/propiro/HA_3dPrinter_ProgressCard/assets/21067369/1d6c2c70-1601-4352-a05d-18a1c7c1b18e)

Thats all for getting animating printer picture, that will change progress alongside printing percentage.
Dont be scared if in edit mode your card looks like this:

![image](https://github.com/propiro/HA_3dPrinter_ProgressCard/assets/21067369/2e47881e-48cf-40e9-a52d-373f5cbe975d)

Keep in mind that you've basically stacked 101 "invisible" cards into one vertical stack. They wont be visible after you exit edit mode.




If you want the card to look like mine with additional information:

![image](https://github.com/propiro/HA_3dPrinter_ProgressCard/assets/21067369/ea86c67b-6bf4-4188-9391-2aaa3cb89b35)


You'll need to add another one (102nd) card to vertical stack, and fill it with details (in my case its another vertical stack, with two time sensors and one horizontal stack for temperature). You'll also need to have the printer data in your home assistant installation, which depending on your setup, might be named/parsed completely different than mine. But I'll include gif that present how I've set up the card on my side nonentheless:



As well fragment of the YAML configuration file (remember, this goes at the END of your vertical card stack, dont replace your code with it, add it at the end and make sure it parses correctly):

```
- type: vertical-stack
    cards:
      - type: entity
        entity: sensor.prusa_timeleft_ts
        state_color: true
        name: Remaining Time
        icon: mdi:send-clock
      - type: entity
        entity: sensor.prusa_printtime_ts
        state_color: true
        name: Printing Time
        icon: mdi:clock-edit
      - type: horizontal-stack
        cards:
          - type: entity
            entity: sensor.prusamk3s_printer
            attribute: temp-nozzle
            name: Nozzle
            state_color: true
            icon: mdi:temperature-celsius
          - type: entity
            entity: sensor.prusamk3s_printer
            icon: mdi:temperature-celsius
            name: Bed
            attribute: temp-bed 
```
Remember that this is my config, so it have my sensors/entities - if you copy it without editing sensors, it wont work!.

### FAQ
- why its so inefficient and use 101 Conditional cards?
___I'm 3D Designer, not a frontend guy - I've tried creating fake camera that'd update still picture according to sensor, but ran into lot of troubles, and using HTML Template card would require too much external resources that I really didn't wanted to use___
- This could be done using XYZ component of QWERTY.js 
___You're most likely right, but I'm neither aware of that solution, nor had time to test everything. Youre more than welcome to do pull request or contact me directly and suggest simple, working alternative that wont take 1200 lines of yaml___
- Could this animation show my current printing object?
___While technically possible, It'd require implementing much wider technological stack, including 3d software to render set of sliced images, and that would need to be scripted as well (unless you're happy with just one picture from slicer software) - Again, you're welcome to do changes___
- Could you make a ping and blue version of the icon, and replace that box with a teapot?
___Could? Probably yes. Would? No, because simply I dont have time to work on this stuff. Funny thing is, just to render that 3d printer image, I had to go far beyond time I wanted to spend on it, and do some callbacks to pre-rendered frames, just to update the mesh (yes, that animation is in 3d, rendered flat!) with percentage, and make a pretty font out of it. So my time budget for silly stuff became exhausted for this project___

### BONUS! Creating sensor.prusa_completion_integer and feeding it from prusa api!

TBD writeup about prusalink openapi, but you can see how I've pulled data from prusalink host using REST, as well what jinji2 syntax I've used to parse data into things usable by home assistant. Write sob story how I've wasted 2 days trying to scrape prusalink website and how opensource stuff should be better documented.

Most important (to make this animating icon work) things are "prusamk3d_progress" REST sensor with "completion" attribute, and TEMPLATE sensor prusa_completion_integer, which is used in this tutorial to feed integer progress data.

``` 
sensor: 
  - platform: rest 
    name: prusamk3s_progress 
    authentication: digest 
    username: USER
    password: PASSWORD
    scan_interval: 30 
    resource: http://10.0.0.158/api/job 
    value_template: "OK"
    #value_template: "{{ value_json.value }}"
    json_attributes_path: "progress" 
    json_attributes: 
      - "completion" 
      - "pos_z_mm" 
      - "printTime" 
      - "printTimeLeft" 
      - "printTimeLeftOrigin"
      - "printSpeed"
      - "flow_factor"

      
  - platform: rest 
    name: prusamk3s_printer 
    authentication: digest 
    username: USER
    password: PASSWORD
    scan_interval: 30 
    resource: http://10.0.0.158/api/printer
    value_template: "OK" 
    json_attributes_path: "telemetry" 
    json_attributes: 
      - "temp-bed" 
      - "temp-nozzle" 
      - "z-height" 
      - "print-speed"
      
  - platform: rest 
    name: prusamk3s_job 
    authentication: digest 
    username: USER
    password: PASSWORD
    scan_interval: 30 
    resource: http://10.0.0.158/api/job 
    value_template: "OK" 
    json_attributes_path: "job" 
    json_attributes: 
      - "file" 
      - "estimatedPrintTime"


  - platform: template
    sensors:
       prusa_timeleft:
         unit_of_measurement: minutes
         value_template: >
            {% if (state_attr('sensor.prusamk3s_progress', 'printTimeLeft') is number) %}
            {{ (state_attr('sensor.prusamk3s_progress', 'printTimeLeft') /60) }}
            {% else %}
            0
            {% endif %}
       prusa_printtime:
         unit_of_measurement: minutes
         value_template: >
            {% if (state_attr('sensor.prusamk3s_progress', 'printTime') is number) %}
            {{ (state_attr('sensor.prusamk3s_progress', 'printTime') /60 |round(1, 'floor')) }}
            {% else %}
            0
            {% endif %}            
       prusa_estimatedprinttime:
         unit_of_measurement: minutes
         value_template: >
           {{ (state_attr('sensor.prusamk3s_job', 'estimatedPrintTime') /60)|round(0, 'floor') }}
           
       prusa_completion:
         unit_of_measurement: '%'
         value_template: >
           {% if (state_attr('sensor.prusamk3s_progress', 'completion') is number) %}
           {{ (state_attr('sensor.prusamk3s_progress', 'completion') *100) }}
           {% else %}
           0
           {% endif %}
           
       prusa_completion_integer:
         unit_of_measurement: '%'
         value_template: >
           {% if (state_attr('sensor.prusamk3s_progress', 'completion') is number) %}
           {{ (state_attr('sensor.prusamk3s_progress', 'completion') *100)|round(0, 'floor') }}
           {% else %}
           0
           {% endif %}
           
       print_completion_integer:
         unit_of_measurement: '%'
         value_template: >
           {% if (state_attr('sensor.prusamk3s_progress', 'completion') is number) %}
           {{ (state_attr('sensor.prusamk3s_progress', 'completion') *100)|round(0, 'floor') }}
           {% else %}
           0
           {% endif %}
           
       prusa_timeleft_ts:
          value_template: >
           {% if (state_attr('sensor.prusamk3s_progress', 'printTimeLeft') is number) %}
           {% set t = state_attr('sensor.prusamk3s_progress', 'printTimeLeft')|int %}
           {{'{:02d}:{:02d}:{:02d}'.format((t // 3600) % 24, (t % 3600) // 60, (t % 3600) % 60) }}
           {% else %}
           "Done"
           {% endif %}
           
       prusa_printtime_ts:
          value_template: >
           {% if (state_attr('sensor.prusamk3s_progress', 'printTime') is number) %}
           {% set t = state_attr('sensor.prusamk3s_progress', 'printTime')|int %}
           {{'{:02d}:{:02d}:{:02d}'.format((t // 3600) % 24, (t % 3600) // 60, (t % 3600) % 60) }}
           {% else %}
           "Done"
           {% endif %}              
           
       prusa_estimatedprinttime_ts:
          value_template: >
           {% if (state_attr('sensor.prusamk3s_job', 'estimatedPrintTime') is number) %}
           {% set t = state_attr('sensor.prusamk3s_job', 'estimatedPrintTime')|int %}
           {{'{:02d}:{:02d}:{:02d}'.format((t // 3600) % 24, (t % 3600) // 60, (t % 3600) % 60) }}
           {% else %}
           "unavailable"
           {% endif %}              

```



