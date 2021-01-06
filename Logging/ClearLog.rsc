foreach i in=[/system logging action find] do={
    :do {
        :local data [/system logging action get $i];
        /system logging action set $i memory-lines=1;
        /system logging action set $i memory-lines=($data->"memory-lines")
    } on-error={}
}
