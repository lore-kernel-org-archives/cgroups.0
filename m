From: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Subject: Re: [RFC 0/4] Migrate timers away from cpuset on setting cpuset.quiesce
Date: Thu, 24 Apr 2014 18:24:33 +0900
Message-ID: <201404240924.s3O9OYCC021688@toshiba.co.jp>
References: <cover.1395322529.git.viresh.kumar@linaro.org>	<201404240725.s3O7PrUv003720@toshiba.co.jp>	<CAKohpokt-O3BAGMzE_=heVBZQOwp0C7eT8ZA2485DgNi3+Xcqg@mail.gmail.com>	<201404240832.s3O8WHd0011014@toshiba.co.jp> <CAKohpokk4rGeP3QfVT5_HBO4pc=22yPBLV78D++y1Ab72y1OJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKohpokk4rGeP3QfVT5_HBO4pc=22yPBLV78D++y1Ab72y1OJQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Viresh Kumar <viresh.kumar@linaro.org>, Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYg==?= =?UTF-8?B?ZWNrZXI=?= <fweisbec@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Lists linaro-kernel <linaro-kernel@lists.linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On 2014/04/24 17:41, Viresh Kumar wrote:
> On 24 April 2014 14:01, Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp> wrote:
>> In kernel/cpuset.c:quiesce_cpuset() you are using the function
>> 'smp_call_function_any' which asks CPU cores in 'cpumask' to
>> execute the functions 'hrtimer_quiesce_cpu' and 'timer_quiesce_cpu'.
>>
>> In the case above, 'cpumask' corresponds to core 0. Since I'm forcing
>> the call to be executed from core 1 (by using taskset),
>> an inter-processor interrupt is sent to core 0 for those functions
>> to be executed.
> 
> Ahh, I understood that now :) .. So we are setting cpuset.quiesce from CPU1
> which will do a IPI to get migrate_timers called on CPU0.. I was setting quiesce
> from CPU0 only in my tests :)
> 
> But how does this work fine on x86 then? There we should have exactly same
> problem, isn't it?

Yeah, I'm not sure why it is working on 3.15 x86_64 but not in 3.10 x86_64.
Perhaps it's related to this patch: https://lkml.org/lkml/2013/9/19/349

>> Ok, thank you! I see that you have already fixed the problem. I tested
>> your tree on ARM and now it seems to work correctly.
> 
> Yeah, I just pushed your changes as well at the time I wrote last mail :)

Oh, I see!

Why didn't you just apply the patch on top of your tree so that the
information included in the git commit (e.g: my name and mail) remains?

This part:

cpuset: quiesce: change irq disable/enable by irq save/restore

The function __migrate_timers can be called under interrupt context
or thread context depending on the core where the system call was
executed. In case it executes under interrupt context, it
seems a bad idea to leave interrupts enabled after migrating the
timers. In fact, this caused kernel errors on the ARM architecture and
on the x86_64 architecture with the 3.10 kernel (backported version
of the cpuset-quiesce patch).

Signed-off-by: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Signed-off-by: Yoshitake Kobayashi <yoshitake.kobayashi@toshiba.co.jp>

Thanks,
Daniel

-- 
Toshiba Corporate Software Engineering Center
Daniel SANGORRIN
E-mail:  daniel.sangorrin@toshiba.co.jp
