From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Deadlock due to "cpuset: Make cpuset hotplug synchronous"
Date: Wed, 25 Mar 2020 21:20:57 +0100
Message-ID: <20200325202057.GY2452@worktop.programming.kicks-ass.net>
References: <F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC@lca.pw>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ci5iFvGhHF6tWhyZWX+xX9UW+5e3UsqDnrKA6rWtpLw=; b=dKS3phA4PDenCe/isC7zViKnkb
        QQcQlDM+FuTAv/mHQuAtlr1U93Bw20MZEZy1WFQMOIgMKyHelfGQe5VrQZFA1lC9C2gYxoUu3F9sQ
        8Ka5Q/Tkvg2TS5PRBbU/0P8bkO7CyRNseffKUvnvlS6VvJsLHMYY1G1RzPKrewX0H/JxwDSyZ9vxS
        qhZFw1Y5CuCDEXIrlvc90rBkxysh/ZRgrjTdxOWl9TXmP12WBrcb1P4zN981yt8gE6F5lDFwF8pRi
        +GTjILQsy4ieLQiftuOyz00tHeHPZ2h9hUivZO157BX+cwmcGizwpg3MBvkEJuKH1KnnjejHIMHNs
        rFGqTdBQ==;
Content-Disposition: inline
In-Reply-To: <F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC-J5quhbR+WMc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Mar 25, 2020 at 03:16:56PM -0400, Qian Cai wrote:
> [17602.773334][   T15] ======================================================
> [17602.780207][   T15] WARNING: possible circular locking dependency detected
> [17602.787081][   T15] 5.6.0-rc7-next-20200325+ #13 Tainted: G             L   
> [17602.794125][   T15] ------------------------------------------------------
> [17602.800997][   T15] cpuhp/1/15 is trying to acquire lock:
> [17602.806392][   T15] ffff900012cb7bf0 (cgroup_mutex){+.+.}-{3:3}, at: cgroup_transfer_tasks+0x130/0x2d8
> [17602.815718][   T15] 
> [17602.815718][   T15] but task is already holding lock:
> [17602.822934][   T15] ffff900012aeb2b0 (cpuhp_state-down){+.+.}-{0:0}, at: cpuhp_lock_acquire+0x8/0x48
> [17602.832078][   T15] 
> [17602.832078][   T15] which lock already depends on the new lock.
> [17602.832078][   T15] 
> [17602.842334][   T15] 
> [17602.842334][   T15] the existing dependency chain (in reverse order) is:

> [17602.946473][   T15] -> #1 (cpu_hotplug_lock){++++}-{0:0}:
> [17602.954050][   T15]        lock_acquire+0xe4/0x25c
> [17602.958841][   T15]        cpus_read_lock+0x50/0x154
> [17602.963807][   T15]        static_key_slow_inc+0x18/0x30
> [17602.969117][   T15]        mem_cgroup_css_alloc+0x824/0x8b0
> [17602.974689][   T15]        cgroup_apply_control_enable+0x1d8/0x56c
> [17602.980867][   T15]        cgroup_apply_control+0x40/0x344
> [17602.986352][   T15]        cgroup_subtree_control_write+0x664/0x69c
> [17602.992618][   T15]        cgroup_file_write+0x130/0x2e8
> [17602.997928][   T15]        kernfs_fop_write+0x228/0x32c
> [17603.003152][   T15]        __vfs_write+0x84/0x1d8
> [17603.007854][   T15]        vfs_write+0x13c/0x1b4
> [17603.012470][   T15]        ksys_write+0xb0/0x120
> [17603.017087][   T15]        __arm64_sys_write+0x54/0x88
> [17603.022223][   T15]        do_el0_svc+0x128/0x1dc
> [17603.026926][   T15]        el0_sync_handler+0x150/0x250
> [17603.032149][   T15]        el0_sync+0x164/0x180
> [17603.036674][   T15] 
> [17603.036674][   T15] -> #0 (cgroup_mutex){+.+.}-{3:3}:

> [17603.123392][   T15] other info that might help us debug this:
> [17603.123392][   T15] 
> [17603.133473][   T15] Chain exists of:
> [17603.133473][   T15]   cgroup_mutex --> cpu_hotplug_lock --> cpuhp_state-down
> [17603.133473][   T15] 

> [17603.194111][   T15] 2 locks held by cpuhp/1/15:
> [17603.198636][   T15]  #0: ffff900012ae9408 (cpu_hotplug_lock){++++}-{0:0}, at: lockdep_acquire_cpus_lock+0xc/0x3c

> [17603.218397][   T15] stack backtrace:
> [17603.224146][   T15] CPU: 1 PID: 15 Comm: cpuhp/1 Tainted: G             L    5.6.0-rc7-next-20200325+ #13
> [17603.233708][   T15] Hardware name: HPE Apollo 70             /C01_APACHE_MB         , BIOS L50_5.13_1.11 06/18/2019
> [17603.244138][   T15] Call trace:

> [17603.287957][   T15]  mutex_lock_nested+0x40/0x50
> [17603.292573][   T15]  cgroup_transfer_tasks+0x130/0x2d8
> [17603.297711][   T15]  cpuset_hotplug_update_tasks+0x6d4/0x794
> remove_tasks_in_empty_cpuset at kernel/cgroup/cpuset.c:2932
> (inlined by) hotplug_update_tasks_legacy at kernel/cgroup/cpuset.c:2973
> (inlined by) cpuset_hotplug_update_tasks at kernel/cgroup/cpuset.c:3097
> [17603.303368][   T15]  cpuset_hotplug+0x42c/0x5bc
> [17603.307897][   T15]  cpuset_update_active_cpus+0x14/0x1c
> cpuset_update_active_cpus at kernel/cgroup/cpuset.c:3230
> [17603.313208][   T15]  sched_cpu_deactivate+0x144/0x208
> [17603.318258][   T15]  cpuhp_invoke_callback+0x1dc/0x534
> [17603.323394][   T15]  cpuhp_thread_fun+0x27c/0x36c

Hurmph,.. that one is vexing indeed. The only possible solution is
changing mem_cgroup_css_alloc(), but that also doesn't look too pretty.
I so hate hotplug...
