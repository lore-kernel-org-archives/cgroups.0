From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup/cpuset: Make cpuset_fork() handle
 CLONE_INTO_CGROUP properly
Date: Thu, 6 Apr 2023 08:17:58 -0400
Message-ID: <1f5e2876-8230-32b5-7bd8-99415d079896@redhat.com>
References: <202304061003.e5e0dc9c-yujie.liu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680783485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x1I6xnPQCFgaa8GiBqNBRb9FGr8oj3ORM8xu7RlaLgc=;
        b=Sn2KDd8AQckFQTsVi8OJ4pDxV7CDrO9KXgYfwfXeIUyW9IT8qHVGDcYirKR/m86yrSTwcJ
        PnbYMbvlGa06ujMc+ZVK+yG+MuBGlTVCVx9WB780M62EV0XT7XuBBSaF8TogUoC1MYdU5f
        cRGgur/X8JbMCdmbjm6+sPnD43o3VNc=
Content-Language: en-US
In-Reply-To: <202304061003.e5e0dc9c-yujie.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: kernel test robot <yujie.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: oe-lkp-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On 4/5/23 22:51, kernel test robot wrote:
> Hello,
>
> kernel test robot noticed "WARNING:suspicious_RCU_usage" on:
>
> commit: a53ab2ba098e6839db602212831c8b62a38c2956 ("[PATCH 1/3] cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly")
> url: https://github.com/intel-lab-lkp/linux/commits/Waiman-Long/cgroup-cpuset-Make-cpuset_fork-handle-CLONE_INTO_CGROUP-properly/20230331-225527
> base: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git 62bad54b26db8bc98e28749cd76b2d890edb4258
> patch link: https://lore.kernel.org/all/20230331145045.2251683-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
> patch subject: [PATCH 1/3] cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly
>
> in testcase: boot
>
> compiler: gcc-11
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
>
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
>
> If you fix the issue, kindly add following tag
> | Reported-by: kernel test robot <yujie.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> | Link: https://lore.kernel.org/oe-lkp/202304061003.e5e0dc9c-yujie.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
>
>
> [    2.798551][    T2] WARNING: suspicious RCU usage
> [    2.799473][    T2] 6.3.0-rc4-00162-ga53ab2ba098e #1 Not tainted
> [    2.799901][    T2] -----------------------------
> [    2.800551][    T2] include/linux/cgroup.h:437 suspicious rcu_dereference_check() usage!
> [    2.802044][    T2]
> [    2.802044][    T2] other info that might help us debug this:
> [    2.802044][    T2]
> [    2.803158][    T2]
> [    2.803158][    T2] rcu_scheduler_active = 1, debug_locks = 1
> [    2.804024][    T2] 1 lock held by kthreadd/2:
> [ 2.804851][ T2] #0: ffffffff84c38230 (cgroup_threadgroup_rwsem){.+.+}-{0:0}, at: cgroup_can_fork (kernel/cgroup/cgroup.c:6515)
> [    2.806112][    T2]
> [    2.806112][    T2] stack backtrace:
> [    2.806958][    T2] CPU: 0 PID: 2 Comm: kthreadd Not tainted 6.3.0-rc4-00162-ga53ab2ba098e #1
> [    2.807537][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
> [    2.807537][    T2] Call Trace:
> [    2.807537][    T2]  <TASK>
> [ 2.807537][ T2] dump_stack_lvl (lib/dump_stack.c:107)
> [ 2.807537][ T2] lockdep_rcu_suspicious (include/linux/context_tracking.h:153 kernel/locking/lockdep.c:6600)
> [ 2.807537][ T2] cpuset_fork (include/linux/cgroup.h:437 kernel/cgroup/cpuset.c:240 kernel/cgroup/cpuset.c:3262)
> [ 2.807537][ T2] cgroup_post_fork (kernel/cgroup/cgroup.c:6635 (discriminator 6))
> [ 2.807537][ T2] ? cgroup_cancel_fork (kernel/cgroup/cgroup.c:6573)
> [ 2.807537][ T2] ? mark_held_locks (kernel/locking/lockdep.c:4237)
> [ 2.807537][ T2] ? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4529)
> [ 2.807537][ T2] copy_process (kernel/fork.c:2499)
> [ 2.807537][ T2] ? __cleanup_sighand (kernel/fork.c:2013)
> [ 2.807537][ T2] ? __lock_acquire (kernel/locking/lockdep.c:186 kernel/locking/lockdep.c:3836 kernel/locking/lockdep.c:5056)
> [ 2.807537][ T2] kernel_clone (include/linux/random.h:26 kernel/fork.c:2680)
> [ 2.807537][ T2] ? create_io_thread (kernel/fork.c:2639)
> [ 2.807537][ T2] ? mark_usage (kernel/locking/lockdep.c:4914)
> [ 2.807537][ T2] ? finish_task_switch+0x21c/0x910
> [ 2.807537][ T2] ? __switch_to (arch/x86/include/asm/bitops.h:55 include/asm-generic/bitops/instrumented-atomic.h:29 include/linux/thread_info.h:89 arch/x86/include/asm/fpu/sched.h:65 arch/x86/kernel/process_64.c:623)
> [ 2.807537][ T2] kernel_thread (kernel/fork.c:2729)
> [ 2.807537][ T2] ? __ia32_sys_clone3 (kernel/fork.c:2729)
> [ 2.807537][ T2] ? lock_downgrade (kernel/locking/lockdep.c:5321)
> [ 2.807537][ T2] ? kthread_complete_and_exit (kernel/kthread.c:331)
> [ 2.807537][ T2] ? do_raw_spin_unlock (arch/x86/include/asm/atomic.h:29 include/linux/atomic/atomic-instrumented.h:28 include/asm-generic/qspinlock.h:57 kernel/locking/spinlock_debug.c:100 kernel/locking/spinlock_debug.c:140)
> [ 2.807537][ T2] kthreadd (kernel/kthread.c:400 kernel/kthread.c:746)
> [ 2.807537][ T2] ? kthread_is_per_cpu (kernel/kthread.c:719)
> [ 2.807537][ T2] ret_from_fork (arch/x86/entry/entry_64.S:314)
> [    2.807537][    T2]  </TASK>
>
It looks like task_cs() can only be used under rcu_read_lock(). I will 
update the patch to add that.

Thanks,
Longman

