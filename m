From: Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Subject: Re: [RFC 0/4] Migrate timers away from cpuset on setting cpuset.quiesce
Date: Thu, 24 Apr 2014 17:31:55 +0900
Message-ID: <201404240832.s3O8WHd0011014@toshiba.co.jp>
References: <cover.1395322529.git.viresh.kumar@linaro.org>	<201404240725.s3O7PrUv003720@toshiba.co.jp> <CAKohpokt-O3BAGMzE_=heVBZQOwp0C7eT8ZA2485DgNi3+Xcqg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKohpokt-O3BAGMzE_=heVBZQOwp0C7eT8ZA2485DgNi3+Xcqg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYg==?= =?UTF-8?B?ZWNrZXI=?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lists linaro-kernel <linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


On 2014/04/24 16:43, Viresh Kumar wrote:
> On 24 April 2014 12:55, Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org> wrote:
>> I tried your set of patches for isolating particular CPU cores from unpinned
>> timers. On x86_64 they were working fine, however I found out that on ARM
>> they would fail under the following test:
> 
> I am happy that these drew attention from somebody Atleast :)

Thanks to you for your hard work.

>> # mount -t cpuset none /cpuset
>> # cd /cpuset
>> # mkdir rt
>> # cd rt
>> # echo 1 > cpus
>> # echo 1 > cpu_exclusive
>> # cd
>> # taskset 0x2 ./setquiesce.sh  <--- contains "echo 1 > /cpuset/rt/quiesce"
>> [   75.622375] ------------[ cut here ]------------
>> [   75.627258] WARNING: CPU: 0 PID: 0 at kernel/locking/lockdep.c:2595 __migrate_hrtimers+0x17c/0x1bc()
>> [   75.636840] DEBUG_LOCKS_WARN_ON(current->hardirq_context)
>> [   75.636840] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc1-37710-g23c8f02 #1
>> [   75.649627] [<c0014d18>] (unwind_backtrace) from [<c00119e8>] (show_stack+0x10/0x14)
>> [   75.649627] [<c00119e8>] (show_stack) from [<c065b61c>] (dump_stack+0x78/0x94)
>> [   75.662689] [<c065b61c>] (dump_stack) from [<c003e9a4>] (warn_slowpath_common+0x60/0x84)
>> [   75.670410] [<c003e9a4>] (warn_slowpath_common) from [<c003ea24>] (warn_slowpath_fmt+0x30/0x40)
>> [   75.677673] [<c003ea24>] (warn_slowpath_fmt) from [<c005d7b0>] (__migrate_hrtimers+0x17c/0x1bc)
>> [   75.677673] [<c005d7b0>] (__migrate_hrtimers) from [<c009e004>] (generic_smp_call_function_single_interrupt+0x8c/0x104)
>> [   75.699645] [<c009e004>] (generic_smp_call_function_single_interrupt) from [<c00134d0>] (handle_IPI+0xa4/0x16c)
>> [   75.706970] [<c00134d0>] (handle_IPI) from [<c0008614>] (gic_handle_irq+0x54/0x5c)
>> [   75.715087] [<c0008614>] (gic_handle_irq) from [<c0012624>] (__irq_svc+0x44/0x5c)
>> [   75.725311] Exception stack(0xc08a3f58 to 0xc08a3fa0)
> 
> I couldn't understand why we went via a interrupt here ? Probably CPU1
> was idle and was woken up with a IPI and then this happened. But in
> that case too,
> shouldn't the script run from process context instead ?

In kernel/cpuset.c:quiesce_cpuset() you are using the function
'smp_call_function_any' which asks CPU cores in 'cpumask' to
execute the functions 'hrtimer_quiesce_cpu' and 'timer_quiesce_cpu'.

In the case above, 'cpumask' corresponds to core 0. Since I'm forcing
the call to be executed from core 1 (by using taskset),
an inter-processor interrupt is sent to core 0 for those functions
to be executed.

>> I also backported your patches to Linux 3.10.y and found the same problem
>> both in ARM and x86_64.
> 
> There are very few changes in between 3.10 and latest for timers/hrtimers
> and so things are expected to be the same.
> 
>> However, I think I figured out the reason for those
>> errors. Please, could you check the patch below (it applies on the top of
>> your tree, branch isolate-cpusets) and let me know what you think?
> 
> Okay, just to let you know, I have also found some issues and they are
> now pushed in my tree.. Also it is rebased over 3.15-rc2 now.

Ok, thank you! I see that you have already fixed the problem. I tested
your tree on ARM and now it seems to work correctly.



> 
>> -------------------------PATCH STARTS HERE---------------------------------
>> cpuset: quiesce: change irq disable/enable by irq save/restore
>>
>> The function __migrate_timers can be called under interrupt context
>> or thread context depending on the core where the system call was
>> executed. In case it executes under interrupt context, it
> 
> How exactly?

See my reply above.

>> seems a bad idea to leave interrupts enabled after migrating the
>> timers. In fact, this caused kernel errors on the ARM architecture and
>> on the x86_64 architecture with the 3.10 kernel (backported version
>> of the cpuset-quiesce patch).
> 
> I can't keep it as a separate patch and so would be required to merge
> it into my original patch..
> 
> Thanks for your inputs :)
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Thanks,
Daniel

-- 
Toshiba Corporate Software Engineering Center
Daniel SANGORRIN
E-mail:  daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org
