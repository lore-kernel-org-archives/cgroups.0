From: Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Subject: Re: [RFC 0/4] Migrate timers away from cpuset on setting cpuset.quiesce
Date: Fri, 25 Apr 2014 09:31:02 +0900
Message-ID: <201404250031.s3P0V2DY022219@toshiba.co.jp>
References: <cover.1395322529.git.viresh.kumar@linaro.org>	<201404240725.s3O7PrUv003720@toshiba.co.jp>	<CAKohpokt-O3BAGMzE_=heVBZQOwp0C7eT8ZA2485DgNi3+Xcqg@mail.gmail.com>	<201404240832.s3O8WHd0011014@toshiba.co.jp>	<CAKohpokk4rGeP3QfVT5_HBO4pc=22yPBLV78D++y1Ab72y1OJQ@mail.gmail.com>	<201404240924.s3O9OYCC021688@toshiba.co.jp> <CAKohponA4-cm2_FB=8R8aVEWNhtUfOUebcfzn7W+XR0zKHCtxw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKohponA4-cm2_FB=8R8aVEWNhtUfOUebcfzn7W+XR0zKHCtxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYg==?= =?UTF-8?B?ZWNrZXI=?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lists linaro-kernel <linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


>> I can't keep it as a separate patch and so would be required to merge
>> it into my original patch..
> 
> And the reason being: "No patch is supposed to break things, otherwise
> git bisect wouldn't work smoothly".. And so git bisect would complain
> this issue after my patch and so I have to merge the fixes you gave into
> the original patch as its not yet merged.
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Ok, no problem then.

Thanks,
Daniel

-- 
Toshiba Corporate Software Engineering Center
Daniel SANGORRIN
E-mail:  daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org
