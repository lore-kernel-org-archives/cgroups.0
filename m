From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] do not abuse ->cred_guard_mutex in threadgroup_lock()
Date: Fri, 22 Mar 2013 14:20:11 +0100
Message-ID: <20130322132011.GA13261@redhat.com>
References: <20130307180139.GD29601@htj.dyndns.org> <20130307180332.GE29601@htj.dyndns.org> <20130307191242.GA18265@redhat.com> <20130307193820.GB3209@htj.dyndns.org> <513A9A67.60909@huawei.com> <20130309032936.GT14556@mtj.dyndns.org> <513AE918.7020704@huawei.com> <20130309200046.GA8149@redhat.com> <20130321162138.GA21859@redhat.com> <20130321150626.a7934d989fb80d835fa92255@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130321150626.a7934d989fb80d835fa92255-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On 03/21, Andrew Morton wrote:
>
> On Thu, 21 Mar 2013 17:21:38 +0100 Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> > threadgroup_lock() takes signal->cred_guard_mutex to ensure that
> > thread_group_leader() is stable. This doesn't look nice, the scope
> > of this lock in do_execve() is huge.
> >
> > And as Dave pointed out this can lead to deadlock, we have the
> > following dependencies:
> >
> > 	do_execve:		cred_guard_mutex -> i_mutex
> > 	cgroup_mount:		i_mutex -> cgroup_mutex
> > 	attach_task_by_pid:	cgroup_mutex -> cred_guard_mutex
> >
> > Change de_thread() to take threadgroup_change_begin() around the
> > switch-the-leader code and change threadgroup_lock() to avoid
> > ->cred_guard_mutex.
> >
> > Note that de_thread() can't sleep with ->group_rwsem held, this
> > can obviously deadlock with the exiting leader if the writer is
> > active, so it does threadgroup_change_end() before schedule().
>
> <formletter>
> When writing a changelog, please describe the end-user-visible effects
> of the bug, so that others can more easily decide which kernel
> version(s) should be fixed, and so that downstream kernel maintainers
> can more easily work out whether this patch will fix a problem which
> they or their customers are observing.
> </formletter>
>
> > Reported-by: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> Perhaps Dave's report provides the needed info?  trinity went titsup?

Yes, trinity. Please see the original report below.

I tried to translate the lockdep's output into the human-readable form.

Oleg.

-------------------------------------------------------------------------------
Looks like this happens when my fuzzer tries to look up garbage in /sys/fs/cgroup/freezer/

trinity -c execve -V /sys/fs/cgroup/freezer/

will reproduce it very quickly.

This isn't a new trace. I've seen it in the past from iknowthis also.

	Dave


[  943.971541] ======================================================
[  943.972451] [ INFO: possible circular locking dependency detected ]
[  943.973370] 3.9.0-rc1+ #69 Not tainted
[  943.973927] -------------------------------------------------------
[  943.974838] trinity-child0/1301 is trying to acquire lock:
[  943.975650] blocked:  (&sb->s_type->i_mutex_key#9){+.+.+.}, instance: ffff880127ea1680, at: [<ffffffff811c03fc>] do_last+0x35c/0xe30
[  943.977522] 
but task is already holding lock:
[  943.978371] held:     (&sig->cred_guard_mutex){+.+.+.}, instance: ffff880123937578, at: [<ffffffff811b8866>] prepare_bprm_creds+0x36/0x80
[  943.980260] 
which lock already depends on the new lock.

[  943.981434] 
the existing dependency chain (in reverse order) is:
[  943.982499] 
-> #2 (&sig->cred_guard_mutex){+.+.+.}:
[  943.983280]        [<ffffffff810b7b82>] lock_acquire+0x92/0x1d0
[  943.984196]        [<ffffffff816c1923>] mutex_lock_nested+0x73/0x3b0
[  943.985173]        [<ffffffff810d45f2>] attach_task_by_pid+0x122/0x8d0
[  943.986151]        [<ffffffff810d4dd3>] cgroup_tasks_write+0x13/0x20
[  943.987127]        [<ffffffff810d0f10>] cgroup_file_write+0x130/0x2f0
[  943.988118]        [<ffffffff811b119f>] vfs_write+0xaf/0x180
[  943.988985]        [<ffffffff811b14e5>] sys_write+0x55/0xa0
[  943.989853]        [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
[  943.990853] 
-> #1 (cgroup_mutex){+.+.+.}:
[  943.991616]        [<ffffffff810b7b82>] lock_acquire+0x92/0x1d0
[  943.992527]        [<ffffffff816c1923>] mutex_lock_nested+0x73/0x3b0
[  943.993492]        [<ffffffff810d33a7>] cgroup_mount+0x2e7/0x520
[  943.994423]        [<ffffffff811b5123>] mount_fs+0x43/0x1b0
[  943.995275]        [<ffffffff811d3051>] vfs_kern_mount+0x61/0x100
[  943.996220]        [<ffffffff811d5821>] do_mount+0x211/0xa00
[  943.997103]        [<ffffffff811d609e>] sys_mount+0x8e/0xe0
[  943.997965]        [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
[  943.998972] 
-> #0 (&sb->s_type->i_mutex_key#9){+.+.+.}:
[  943.999886]        [<ffffffff810b7406>] __lock_acquire+0x1b86/0x1c80
[  944.000864]        [<ffffffff810b7b82>] lock_acquire+0x92/0x1d0
[  944.001771]        [<ffffffff816c1923>] mutex_lock_nested+0x73/0x3b0
[  944.002750]        [<ffffffff811c03fc>] do_last+0x35c/0xe30
[  944.003620]        [<ffffffff811c0f8a>] path_openat+0xba/0x4f0
[  944.004517]        [<ffffffff811c1691>] do_filp_open+0x41/0xa0
[  944.005427]        [<ffffffff811b74d3>] open_exec+0x53/0x130
[  944.006296]        [<ffffffff811b8c3d>] do_execve_common.isra.26+0x31d/0x710
[  944.007373]        [<ffffffff811b9048>] do_execve+0x18/0x20
[  944.008222]        [<ffffffff811b933d>] sys_execve+0x3d/0x60
[  944.009093]        [<ffffffff816cdf39>] stub_execve+0x69/0xa0
[  944.009983] 
other info that might help us debug this:

[  944.011126] Chain exists of:
  &sb->s_type->i_mutex_key#9 --> cgroup_mutex --> &sig->cred_guard_mutex

[  944.012745]  Possible unsafe locking scenario:

[  944.013617]        CPU0                    CPU1
[  944.014280]        ----                    ----
[  944.014942]   lock(&sig->cred_guard_mutex);
[  944.021332]                                lock(cgroup_mutex);
[  944.028094]                                lock(&sig->cred_guard_mutex);
[  944.035007]   lock(&sb->s_type->i_mutex_key#9);
[  944.041602] 
 *** DEADLOCK ***

[  944.059241] 1 lock on stack by trinity-child0/1301:
[  944.065496]  #0: held:     (&sig->cred_guard_mutex){+.+.+.}, instance: ffff880123937578, at: [<ffffffff811b8866>] prepare_bprm_creds+0x36/0x80
[  944.073100] 
stack backtrace:
[  944.085269] Pid: 1301, comm: trinity-child0 Not tainted 3.9.0-rc1+ #69
[  944.091788] Call Trace:
[  944.097633]  [<ffffffff816b95f5>] print_circular_bug+0x1fe/0x20f
[  944.104041]  [<ffffffff810b7406>] __lock_acquire+0x1b86/0x1c80
[  944.110223]  [<ffffffff810b21bd>] ? trace_hardirqs_off+0xd/0x10
[  944.116282]  [<ffffffff810b7b82>] lock_acquire+0x92/0x1d0
[  944.122293]  [<ffffffff811c03fc>] ? do_last+0x35c/0xe30
[  944.128287]  [<ffffffff816c1923>] mutex_lock_nested+0x73/0x3b0
[  944.134460]  [<ffffffff811c03fc>] ? do_last+0x35c/0xe30
[  944.140497]  [<ffffffff811c03fc>] ? do_last+0x35c/0xe30
[  944.146446]  [<ffffffff811c03fc>] do_last+0x35c/0xe30
[  944.152303]  [<ffffffff811bd098>] ? inode_permission+0x18/0x50
[  944.158260]  [<ffffffff811bd315>] ? link_path_walk+0x245/0x880
[  944.164165]  [<ffffffff811c0f8a>] path_openat+0xba/0x4f0
[  944.169934]  [<ffffffff811c1691>] do_filp_open+0x41/0xa0
[  944.175834]  [<ffffffff811b8c2e>] ? do_execve_common.isra.26+0x30e/0x710
[  944.181817]  [<ffffffff810b2042>] ? get_lock_stats+0x22/0x70
[  944.187828]  [<ffffffff810b24ae>] ? put_lock_stats.isra.23+0xe/0x40
[  944.193892]  [<ffffffff810b2bcb>] ? lock_release_holdtime.part.24+0xcb/0x130
[  944.200099]  [<ffffffff811b74d3>] open_exec+0x53/0x130
[  944.206046]  [<ffffffff811b8c3d>] do_execve_common.isra.26+0x31d/0x710
[  944.212123]  [<ffffffff811b8a42>] ? do_execve_common.isra.26+0x122/0x710
[  944.218275]  [<ffffffff811b9048>] do_execve+0x18/0x20
[  944.224206]  [<ffffffff811b933d>] sys_execve+0x3d/0x60
[  944.230155]  [<ffffffff816cdf39>] stub_execve+0x69/0xa0

