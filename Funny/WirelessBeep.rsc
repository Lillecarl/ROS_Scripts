:global ConnCount0

:if ([:typeof $ConnCount0] = "nothing") do={
    :set ConnCount0 0
}

:local ConnCount1 0
:foreach i in=[/interface wireless registration-table find] do={ :set ConnCount1 ($ConnCount1 + 1) }

:if ($ConnCount0 < $ConnCount1) do={
    :for i from=800 to=2000 step=100 do={
        :beep frequency=$i length=11ms;
        :delay 11ms;
    }
}
:if ($ConnCount1 < $ConnCount0) do={
    :for i from=2000 to=50 step=-100 do={
        :beep frequency=$i length=11ms;
        :delay 11ms;
    }
}

:set ConnCount0 $ConnCount1