From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: lockdep trace from prepare_bprm_creds
Date: Thu, 7 Mar 2013 18:25:45 +0100
Message-ID: <20130307172545.GA10353@redhat.com>
References: <20130306223657.GA7392@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130306223657.GA7392-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 03/06, Dave Jones wrote:
>
> Looks like this happens when my fuzzer tries to look up garbage in /sys/fs/cgroup/freezer/
>
> trinity -c execve -V /sys/fs/cgroup/freezer/
>
> will reproduce it very quickly.
>
> This isn't a new trace. I've seen it in the past from iknowthis also.
>
> 	Dave
>
>
> [  943.971541] ======================================================
> [  943.972451] [ INFO: possible circular locking dependency detected ]
> [  943.973370] 3.9.0-rc1+ #69 Not tainted
> [  943.973927] -------------------------------------------------------
> [  943.974838] trinity-child0/1301 is trying to acquire lock:
> [  943.975650] blocked:  (&sb->s_type->i_mutex_key#9){+.+.+.}, instance: ffff880127ea1680, at: [<ffffffff811c03fc>] do_last+0x35c/0xe30
> [  943.977522]
> but task is already holding lock:
> [  943.978371] held:     (&sig->cred_guard_mutex){+.+.+.}, instance: ffff880123937578, at: [<ffffffff811b8866>] prepare_bprm_creds+0x36/0x80
> [  943.980260]
> which lock already depends on the new lock.
>
> [  943.981434]
> the existing dependency chain (in reverse order) is:
> [  943.982499]
> -> #2 (&sig->cred_guard_mutex){+.+.+.}:
> [  943.983280]        [<ffffffff810b7b82>] lock_acquire+0x92/0x1d0
> [  943.984196]        [<ffffffff816c1923>] mutex_lock_nested+0x73/0x3b0
> [  943.985173]        [<ffffffff810d45f2>] attach_task_by_pid+0x122/0x8d0
> [  943.986151]        [<ffffffff810d4dd3>] cgroup_tasks_write+0x13/0x20
> [  943.987127]        [<ffffffff810d0f10>] cgroup_file_write+0x130/0x2f0
> [  943.988118]        [<ffffffff811b119f>] vfs_write+0xaf/0x180
> [  943.988985]        [<ffffffff811b14e5>] sys_write+0x55/0xa0
> [  943.989853]        [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
> [  943.990853]
> -> #1 (cgroup_mutex){+.+.+.}:
> [  943.991616]        [<ffffffff810b7b82>] lock_acquire+0x92/0x1d0
> [  943.992527]        [<ffffffff816c1923>] mutex_lock_nested+0x73/0x3b0
> [  943.993492]        [<ffffffff810d33a7>] cgroup_mount+0x2e7/0x520
> [  943.994423]        [<ffffffff811b5123>] mount_fs+0x43/0x1b0
> [  943.995275]        [<ffffffff811d3051>] vfs_kern_mount+0x61/0x100
> [  943.996220]        [<ffffffff811d5821>] do_mount+0x211/0xa00
> [  943.997103]        [<ffffffff811d609e>] sys_mount+0x8e/0xe0
> [  943.997965]        [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
> [  943.998972]
> -> #0 (&sb->s_type->i_mutex_key#9){+.+.+.}:
> [  943.999886]        [<ffffffff810b7406>] __lock_acquire+0x1b86/0x1c80
> [  944.000864]        [<ffffffff810b7b82>] lock_acquire+0x92/0x1d0
> [  944.001771]        [<ffffffff816c1923>] mutex_lock_nested+0x73/0x3b0
> [  944.002750]        [<ffffffff811c03fc>] do_last+0x35c/0xe30
> [  944.003620]        [<ffffffff811c0f8a>] path_openat+0xba/0x4f0
> [  944.004517]        [<ffffffff811c1691>] do_filp_open+0x41/0xa0
> [  944.005427]        [<ffffffff811b74d3>] open_exec+0x53/0x130
> [  944.006296]        [<ffffffff811b8c3d>] do_execve_common.isra.26+0x31d/0x710
> [  944.007373]        [<ffffffff811b9048>] do_execve+0x18/0x20
> [  944.008222]        [<ffffffff811b933d>] sys_execve+0x3d/0x60
> [  944.009093]        [<ffffffff816cdf39>] stub_execve+0x69/0xa0
> [  944.009983]
> other info that might help us debug this:
>
> [  944.011126] Chain exists of:
>   &sb->s_type->i_mutex_key#9 --> cgroup_mutex --> &sig->cred_guard_mutex
>
> [  944.012745]  Possible unsafe locking scenario:
>
> [  944.013617]        CPU0                    CPU1
> [  944.014280]        ----                    ----
> [  944.014942]   lock(&sig->cred_guard_mutex);
> [  944.021332]                                lock(cgroup_mutex);
> [  944.028094]                                lock(&sig->cred_guard_mutex);
> [  944.035007]   lock(&sb->s_type->i_mutex_key#9);
> [  944.041602]

And cgroup_mount() does i_mutex -> cgroup_mutex...

Add cc's. I do not think we can move open_exec() outside of cred_guard_mutex.
We can change do_execve_common(), but binfmt->load_binary() does open() too.

And it is not easy to avoid ->cred_guard_mutex in threadgroup_lock(), we can't
change de_thread() to do threadgroup_change_begin/end...

Or perhaps we can? It doesn't need to sleep under ->group_rwsem, we only
need it around ->group_leader changing. Otherwise cgroup_attach_proc()
can rely on do_exit()->threadgroup_change_begin() ?

But perhaps someone can suggest another fix in cgroup.c.

Oleg.

--- x/fs/exec.c
+++ x/fs/exec.c
@@ -898,11 +898,13 @@ static int de_thread(struct task_struct 
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
+			threadgroup_change_begin();
 			write_lock_irq(&tasklist_lock);
 			if (likely(leader->exit_state))
 				break;
 			__set_current_state(TASK_KILLABLE);
 			write_unlock_irq(&tasklist_lock);
+			threadgroup_change_end();
 			schedule();
 			if (unlikely(__fatal_signal_pending(tsk)))
 				goto killed;
@@ -960,6 +962,7 @@ static int de_thread(struct task_struct 
 		if (unlikely(leader->ptrace))
 			__wake_up_parent(leader, leader->parent);
 		write_unlock_irq(&tasklist_lock);
+		threadgroup_change_end();
 
 		release_task(leader);
 	}
