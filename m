From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: "Regression" with cd3d09527537
Date: Thu, 28 Jun 2012 03:07:37 +0400
Message-ID: <4FEB9239.6080408@parallels.com>
References: <4FE9AE57.4090007@parallels.com> <20120627230823.GU15811@google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------080306080409070400080908"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120627230823.GU15811-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

--------------080306080409070400080908
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 06/28/2012 03:08 AM, Tejun Heo wrote:
> On Tue, Jun 26, 2012 at 04:43:03PM +0400, Glauber Costa wrote:
>> Hi,
>>
>> I've recently started seeing a lockdep warning at the end of *every*
>> "init 0" issued in my machine. Actually, reboots are fine, and
>> that's probably why I've never seen it earlier. The log is quite
>> extensively, but shows the following dependency chain:
>>
>> [   83.982111] -> #4 (cpu_hotplug.lock){+.+.+.}:
>> [...]
>> [   83.982111] -> #3 (jump_label_mutex){+.+...}:
>> [...]
>> [   83.982111] -> #2 (sk_lock-AF_INET){+.+.+.}:
>> [...]
>> [   83.982111] -> #1 (&sig->cred_guard_mutex){+.+.+.}:
>> [...]
>> [   83.982111] -> #0 (cgroup_mutex){+.+.+.}:
>>
>> I've recently fixed bugs with the lock ordering imposed by cpusets
>> on cpu_hotplug.lock through jump_label_mutex, and initially thought
>> it to be the same kind of issue. But that was not the case.
>>
>> I've omitted the full backtrace for readability, but I run this with
>> all cgroups disabled but the cpuset, so it can't be sock memcg
>> (after my initial reaction of "oh, fuck, not again"). That
>> jump_label is there for years, and it comes from the code that
>> disables socket timestamps.
>> (net_enable_timestamp)
> 
> Yeah, there are multiple really large locks at play here - jump label,
> threadgroup and cgroup_mutex.  It isn't pretty.  Can you please post
> the full lockdep dump?  The above only shows single locking chain.
> I'd like to see the other.
> 
> Thanks.
> 



--------------080306080409070400080908
Content-Type: text/plain; charset="UTF-8"; name="REBOOT-BUG"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="REBOOT-BUG"

[   72.027124] ======================================================
[   72.027617] [ INFO: possible circular locking dependency detected ]
[   72.027617] 3.5.0-rc4+ #145 Not tainted
[   72.027617] -------------------------------------------------------
[   72.027617] systemd-shutdow/1 is trying to acquire lock:
[   72.027617]  (cgroup_mutex){+.+.+.}, at: [<ffffffff810a3990>] cgroup_lock+0x17/0x19
[   72.027617] 
[   72.027617] but task is already holding lock:
[   72.027617]  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8104ac9b>] cpu_hotplug_begin+0x2c/0x53
[   72.027617] 
[   72.027617] which lock already depends on the new lock.
[   72.027617] 
[   72.027617] 
[   72.027617] the existing dependency chain (in reverse order) is:
[   72.027617] 
[   72.027617] -> #4 (cpu_hotplug.lock){+.+.+.}:
[   72.027617]        [<ffffffff81094028>] lock_acquire+0x8c/0xfc
[   72.027617]        [<ffffffff81513a7f>] __mutex_lock_common+0x47/0x344
[   72.027617]        [<ffffffff81513e4f>] mutex_lock_nested+0x2f/0x36
[   72.027617]        [<ffffffff8104ad40>] get_online_cpus+0x2e/0x42
[   72.027617]        [<ffffffff81012662>] arch_jump_label_transform+0x17/0x4d
[   72.027617]        [<ffffffff810f2c16>] __jump_label_update+0x3a/0x52
[   72.027617]        [<ffffffff810f2cbd>] jump_label_update+0x8f/0x9b
[   72.027617]        [<ffffffff810f304e>] static_key_slow_inc+0x49/0x5d
[   72.027617]        [<ffffffff81b158ef>] activate_jump_labels+0x19/0x35
[   72.027617]        [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[   72.027617]        [<ffffffff81b03d2b>] kernel_init+0x157/0x1db
[   72.027617]        [<ffffffff8151e3b4>] kernel_thread_helper+0x4/0x10
[   72.027617] 
[   72.027617] -> #3 (jump_label_mutex){+.+...}:
[   72.027617]        [<ffffffff81094028>] lock_acquire+0x8c/0xfc
[   72.027617]        [<ffffffff81513a7f>] __mutex_lock_common+0x47/0x344
[   72.027617]        [<ffffffff81513e4f>] mutex_lock_nested+0x2f/0x36
[   72.027617]        [<ffffffff810f2d6a>] jump_label_lock+0x17/0x19
[   72.027617]        [<ffffffff810f3055>] static_key_slow_inc+0x50/0x5d
[   72.027617]        [<ffffffff81427c40>] net_enable_timestamp+0x5d/0x61
[   72.027617]        [<ffffffff8141c8dd>] sock_enable_timestamp+0x36/0x3b
[   72.027617]        [<ffffffff8141cd9d>] sock_setsockopt+0x363/0x57a
[   72.027617]        [<ffffffff81418d99>] sys_setsockopt+0x6d/0xa6
[   72.027617]        [<ffffffff8151cf69>] system_call_fastpath+0x16/0x1b
[   72.027617] 
[   72.027617] -> #2 (sk_lock-AF_INET){+.+.+.}:
[   72.027617]        [<ffffffff81094028>] lock_acquire+0x8c/0xfc
[   72.027617]        [<ffffffff8141b423>] lock_sock_nested+0x70/0x80
[   72.027617]        [<ffffffff81462ee9>] lock_sock+0xb/0xd
[   72.027617]        [<ffffffff81466fba>] tcp_close+0x1e/0x303
[   72.027617]        [<ffffffff814841ae>] inet_release+0xc2/0xcd
[   72.027617]        [<ffffffff81417307>] sock_release+0x1f/0x74
[   72.027617]        [<ffffffff81417383>] sock_close+0x27/0x2b
[   72.027617]        [<ffffffff81140adb>] fput+0x10b/0x20a
[   72.027617]        [<ffffffff8113d89c>] filp_close+0x6f/0x7a
[   72.027617]        [<ffffffff8113ddb3>] sys_close+0xdb/0x11a
[   72.027617]        [<ffffffff81145c11>] setup_new_exec+0x286/0x2b2
[   72.027617]        [<ffffffff8118407c>] load_elf_binary+0x343/0x1813
[   72.027617]        [<ffffffff811443f2>] search_binary_handler+0xd3/0x2d3
[   72.027617]        [<ffffffff8114580e>] do_execve_common.isra.31+0x296/0x393
[   72.027617]        [<ffffffff81145926>] do_execve+0x1b/0x1d
[   72.027617]        [<ffffffff810169fe>] sys_execve+0x43/0x5a
[   72.027617]        [<ffffffff8151d42c>] stub_execve+0x6c/0xc0
[   72.027617] 
[   72.027617] -> #1 (&sig->cred_guard_mutex){+.+.+.}:
[   72.027617]        [<ffffffff81094028>] lock_acquire+0x8c/0xfc
[   72.027617]        [<ffffffff81513a7f>] __mutex_lock_common+0x47/0x344
[   72.027617]        [<ffffffff81513e4f>] mutex_lock_nested+0x2f/0x36
[   72.027617]        [<ffffffff810a8091>] attach_task_by_pid+0x14d/0x4d1
[   72.027617]        [<ffffffff810a8440>] cgroup_tasks_write+0x13/0x15
[   72.027617]        [<ffffffff810a7c1c>] cgroup_file_write+0x101/0x25f
[   72.027617]        [<ffffffff8113f724>] vfs_write+0xa0/0x102
[   72.027617]        [<ffffffff8113f938>] sys_write+0x43/0x70
[   72.027617]        [<ffffffff8151cf69>] system_call_fastpath+0x16/0x1b
[   72.027617] 
[   72.027617] -> #0 (cgroup_mutex){+.+.+.}:
[   72.027617]        [<ffffffff810938a8>] __lock_acquire+0x9b0/0xd0c
[   72.027617]        [<ffffffff81094028>] lock_acquire+0x8c/0xfc
[   72.027617]        [<ffffffff81513a7f>] __mutex_lock_common+0x47/0x344
[   72.027617]        [<ffffffff81513e4f>] mutex_lock_nested+0x2f/0x36
[   72.027617]        [<ffffffff810a3990>] cgroup_lock+0x17/0x19
[   72.027617]        [<ffffffff810ab456>] cpuset_update_active_cpus+0x13/0x6f
[   72.027617]        [<ffffffff8106f6c9>] cpuset_cpu_inactive+0x1a/0x23
[   72.027617]        [<ffffffff815197ad>] notifier_call_chain+0x6c/0x97
[   72.027617]        [<ffffffff8106b14a>] __raw_notifier_call_chain+0xe/0x10
[   72.027617]        [<ffffffff8104ac43>] __cpu_notify+0x20/0x37
[   72.027617]        [<ffffffff814f2ec1>] _cpu_down+0x7d/0x240
[   72.027617]        [<ffffffff8104afb1>] disable_nonboot_cpus+0x67/0x11b
[   72.027617]        [<ffffffff8105bac8>] kernel_power_off+0x48/0x6c
[   72.027617]        [<ffffffff8105c297>] sys_reboot+0x137/0x1ca
[   72.027617]        [<ffffffff8151cf69>] system_call_fastpath+0x16/0x1b
[   72.027617] 
[   72.027617] other info that might help us debug this:
[   72.027617] 
[   72.027617] Chain exists of:
[   72.027617]   cgroup_mutex --> jump_label_mutex --> cpu_hotplug.lock
[   72.027617] 
[   72.027617]  Possible unsafe locking scenario:
[   72.027617] 
[   72.027617]        CPU0                    CPU1
[   72.027617]        ----                    ----
[   72.027617]   lock(cpu_hotplug.lock);
[   72.027617]                                lock(jump_label_mutex);
[   72.027617]                                lock(cpu_hotplug.lock);
[   72.027617]   lock(cgroup_mutex);
[   72.027617] 
[   72.027617]  *** DEADLOCK ***
[   72.027617] 
[   72.027617] 3 locks held by systemd-shutdow/1:
[   72.027617]  #0:  (reboot_mutex){+.+.+.}, at: [<ffffffff8105c222>] sys_reboot+0xc2/0x1ca
[   72.027617]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8104adb9>] cpu_maps_update_begin+0x17/0x19
[   72.027617]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8104ac9b>] cpu_hotplug_begin+0x2c/0x53
[   72.027617] 
[   72.027617] stack backtrace:
[   72.027617] Pid: 1, comm: systemd-shutdow Not tainted 3.5.0-rc4+ #145
[   72.027617] Call Trace:
[   72.027617]  [<ffffffff8150dc86>] print_circular_bug+0x1f8/0x209
[   72.027617]  [<ffffffff810938a8>] __lock_acquire+0x9b0/0xd0c
[   72.027617]  [<ffffffff81515f3a>] ? _raw_spin_unlock_irq+0x2d/0x36
[   72.027617]  [<ffffffff81094028>] lock_acquire+0x8c/0xfc
[   72.027617]  [<ffffffff810a3990>] ? cgroup_lock+0x17/0x19
[   72.027617]  [<ffffffff81513a7f>] __mutex_lock_common+0x47/0x344
[   72.027617]  [<ffffffff810a3990>] ? cgroup_lock+0x17/0x19
[   72.027617]  [<ffffffff810a3990>] ? cgroup_lock+0x17/0x19
[   72.027617]  [<ffffffff81513e4f>] mutex_lock_nested+0x2f/0x36
[   72.027617]  [<ffffffff8127c37b>] ? __bitmap_weight+0x33/0x7f
[   72.027617]  [<ffffffff810a3990>] cgroup_lock+0x17/0x19
[   72.027617]  [<ffffffff810ab456>] cpuset_update_active_cpus+0x13/0x6f
[   72.027617]  [<ffffffff8106f6c9>] cpuset_cpu_inactive+0x1a/0x23
[   72.027617]  [<ffffffff815197ad>] notifier_call_chain+0x6c/0x97
[   72.027617]  [<ffffffff8106b14a>] __raw_notifier_call_chain+0xe/0x10
[   72.027617]  [<ffffffff8104ac43>] __cpu_notify+0x20/0x37
[   72.027617]  [<ffffffff814f2ec1>] _cpu_down+0x7d/0x240
[   72.027617]  [<ffffffff8150cfe1>] ? printk+0x61/0x63
[   72.027617]  [<ffffffff8104afb1>] disable_nonboot_cpus+0x67/0x11b
[   72.027617]  [<ffffffff8105bac8>] kernel_power_off+0x48/0x6c
[   72.027617]  [<ffffffff8105c297>] sys_reboot+0x137/0x1ca
[   72.027617]  [<ffffffff81094044>] ? lock_acquire+0xa8/0xfc
[   72.027617]  [<ffffffff811420ae>] ? iterate_supers+0x83/0xc4
[   72.027617]  [<ffffffff81515f09>] ? _raw_spin_unlock_bh+0x31/0x35
[   72.027617]  [<ffffffff81093f55>] ? lock_release+0x160/0x1a7
[   72.027617]  [<ffffffff8151cf95>] ? sysret_check+0x22/0x5d
[   72.027617]  [<ffffffff810944a7>] ? trace_hardirqs_on_caller+0x117/0x173
[   72.027617]  [<ffffffff8127ac3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   72.027617]  [<ffffffff8151cf69>] system_call_fastpath+0x16/0x1b


--------------080306080409070400080908--
