﻿get-aduser -filter * -properties passwordlastset | select name, passwordlastset 