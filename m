From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroups v2 cpuset partition bug
Date: Mon, 29 Aug 2022 22:19:24 -0400
Message-ID: <23924a85-1ddc-64c7-68c7-2dbd53eea4ee@redhat.com>
References: <C98773C9-F5ED-4664-BED1-5C03351130D4@gmail.com>
 <YwT/BNqIdCEyUpFR@slm.duckdns.org>
 <ef183fe9-8458-8a7f-2b8e-1c38666b6399@redhat.com>
 <26A2A485-B70C-4361-8368-1A0081570E7C@gmail.com>
 <961450c4-6b32-63ba-ff81-2f6184032de9@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661825966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=acxiXerhGK/mk1WIiLY7l7lFOnLhh2aPqN8iFAXUUqg=;
        b=ICmSuLKJXCyiXF+TNE5ioSfGe33YVOIiwzRSKQIdTlRYDyQ+5cUjLe+PIrpNjfq1lry4bR
        Cl9n3sU1KERUrBHhJ7Nd8VGZQwywGrC/acoAPbpX73saveVP3v1GLLa7IwccbrsNkNlubl
        bJ1+YumcEVdry65LB6EycExrqQV7R2g=
Content-Language: en-US
In-Reply-To: <961450c4-6b32-63ba-ff81-2f6184032de9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?B?TWF4aW0g4oCcTUFYUEFJTuKAnSBNYWthcm92?= <maxpain177-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 8/29/22 13:48, Waiman Long wrote:
>
> On 8/29/22 13:16, Maxim “MAXPAIN” Makarov wrote:
>> Hi. I used top and htop programs to check what CPU is using, and it's 
>> showing that this task is running on CPU 2, so I think it shows the 
>> correct CPU that is currently being used.
>> Please note that the containerd process has /system/runtime cgroup, 
>> which inherits cpuset from the root cgroup. /system/runtime cgroup 
>> doesn't have any cpuset settings. Maybe this is the reason?
> Oh, that could be the reason. Yes, it is probably a bug that other 
> sibling cgroups should also be updated. I will look into that.
>>
>> I tried to remove the lowlatency group with 
>> cpuset.cpus.partition=root and do taskset -cp 4 1079 manually, and it 
>> works without any restart.
>>
>> I updated my post on StackExchange and added some new screenshots, so 
>> please check it out.

I tried to reproduce it but couldn't so far. Would you mind telling me 
what kernel version are you using to show this bug? BTW, how do you make 
htop show the CPU number, the CPU number isn't there by default.  What 
htop version are you using?

Thanks,
Longman

