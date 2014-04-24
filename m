From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/4] Migrate timers away from cpuset on setting cpuset.quiesce
Date: Thu, 24 Apr 2014 14:11:52 +0530
Message-ID: <CAKohpokk4rGeP3QfVT5_HBO4pc=22yPBLV78D++y1Ab72y1OJQ@mail.gmail.com>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
	<201404240725.s3O7PrUv003720@toshiba.co.jp>
	<CAKohpokt-O3BAGMzE_=heVBZQOwp0C7eT8ZA2485DgNi3+Xcqg@mail.gmail.com>
	<201404240832.s3O8WHd0011014@toshiba.co.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201404240832.s3O8WHd0011014-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lists linaro-kernel <linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 24 April 2014 14:01, Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org> wrote:
> In kernel/cpuset.c:quiesce_cpuset() you are using the function
> 'smp_call_function_any' which asks CPU cores in 'cpumask' to
> execute the functions 'hrtimer_quiesce_cpu' and 'timer_quiesce_cpu'.
>
> In the case above, 'cpumask' corresponds to core 0. Since I'm forcing
> the call to be executed from core 1 (by using taskset),
> an inter-processor interrupt is sent to core 0 for those functions
> to be executed.

Ahh, I understood that now :) .. So we are setting cpuset.quiesce from CPU1
which will do a IPI to get migrate_timers called on CPU0.. I was setting quiesce
from CPU0 only in my tests :)

But how does this work fine on x86 then? There we should have exactly same
problem, isn't it?

> Ok, thank you! I see that you have already fixed the problem. I tested
> your tree on ARM and now it seems to work correctly.

Yeah, I just pushed your changes as well at the time I wrote last mail :)
