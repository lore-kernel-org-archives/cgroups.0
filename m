From: Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Sat, 9 Jul 2016 16:38:08 +0000
Message-ID: <3a53aeaf-b1fb-0567-3dde-7fa318751c46@gmail.com>
References: <20160624172447.GA3262@mtj.duckdns.org>
 <47890d79-0891-dd13-4f60-e7e5f1f3fed3@gmail.com>
 <CAOS58YMxz5HfJUayqjw+SPj485M+wquTqQouk367rV2mfvVRHg@mail.gmail.com>
 <20160627145457.GA26980@mail.hallyn.com>
 <58938c8b-aca6-a5b8-9533-58e78d878e85@gmail.com>
 <CAOS58YM+h0w_UciXLbiJcKizPkXV66FL57LT7Mc+RRWspN+Y2Q@mail.gmail.com>
 <20160627194941.GA31843@mail.hallyn.com>
 <218f2bef-5e5e-89c4-154b-24dc49c82c31@gmail.com>
 <20160707091645.GG3238@pathway.suse.cz>
 <e81401b8-a731-9c22-f5a3-ce25eefb1471@gmail.com>
 <20160708091332.GD3556@pathway.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Ie3iKsUBpWhN86TgisplCVAwmlxP4s2/QPBkAGxnuB0=;
        b=thbKng1oxrVXzoi+Kn3ggHKdGV0QAbxRsSAJNu9RDUgKgkh0ulng0JoHlbxA3gwmG+
         f1ShpnnP9U5MRLrRumFY7ts+lPDOc4+t6H7okv+h+xT/n/Y3O163paWNRpEOrVywdIap
         9VE+AtiNmEJBiQqK3Alp9Ih0w++Uk2/OEgbohM5esQCchHH+msziVIcA3qU/SnBCG/HL
         0vAkSLQ/scmrjzpbfBnFgI6Zychf7wNQ5ULQ2e5tS98KOIMByAIQXiD6ndOsnaUYcQdH
         G6BTLT6YSTkKQ9vV9ccqhamcUHSipd1+hZ347+9FhSIVUqlXUEnvJA7kMmDKpc4IFnCT
         JYAA==
In-Reply-To: <20160708091332.GD3556@pathway.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Petr Mladek <pmladek@suse.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>, luto@kernel.org, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

On 07/08/16 09:13, Petr Mladek wrote:
> On Thu 2016-07-07 20:27:13, Topi Miettinen wrote:
>> On 07/07/16 09:16, Petr Mladek wrote:
>>> On Sun 2016-07-03 15:08:07, Topi Miettinen wrote:
>>>> The attached patch would make any uses of capabilities generate audit
>>>> messages. It works for simple tests as you can see from the commit
>>>> message, but unfortunately the call to audit_cgroup_list() deadlocks the
>>>> system when booting a full blown OS. There's no deadlock when the call
>>>> is removed.
>>>>
>>>> I guess that in some cases, cgroup_mutex and/or css_set_lock could be
>>>> already held earlier before entering audit_cgroup_list(). Holding the
>>>> locks is however required by task_cgroup_from_root(). Is there any way
>>>> to avoid this? For example, only print some kind of cgroup ID numbers
>>>> (are there unique and stable IDs, available without locks?) for those
>>>> cgroups where the task is registered in the audit message?
>>>
>>> I am not sure if anyone know what really happens here. I suggest to
>>> enable lockdep. It might detect possible deadlock even before it
>>> really happens, see Documentation/locking/lockdep-design.txt
>>>
>>> It can be enabled by
>>>
>>>    CONFIG_PROVE_LOCKING=y
>>>
>>> It depends on
>>>
>>>     CONFIG_DEBUG_KERNEL=y
>>>
>>> and maybe some more options, see lib/Kconfig.debug
>>
>> Thanks a lot! I caught this stack dump:
>>
>> starting version 230
>> [    3.416647] ------------[ cut here ]------------
>> [    3.417310] WARNING: CPU: 0 PID: 95 at
>> /home/topi/d/linux.git/kernel/locking/lockdep.c:2871
>> lockdep_trace_alloc+0xb4/0xc0
>> [    3.417605] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
>> [    3.417923] Modules linked in:
>> [    3.418288] CPU: 0 PID: 95 Comm: systemd-udevd Not tainted 4.7.0-rc5+ #97
>> [    3.418444] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>> BIOS Debian-1.8.2-1 04/01/2014
>> [    3.418726]  0000000000000086 000000007970f3b0 ffff88000016fb00
>> ffffffff813c9c45
>> [    3.418993]  ffff88000016fb50 0000000000000000 ffff88000016fb40
>> ffffffff81091e9b
>> [    3.419176]  00000b3705e2c798 0000000000000046 0000000000000410
>> 00000000ffffffff
>> [    3.419374] Call Trace:
>> [    3.419511]  [<ffffffff813c9c45>] dump_stack+0x67/0x92
>> [    3.419644]  [<ffffffff81091e9b>] __warn+0xcb/0xf0
>> [    3.419745]  [<ffffffff81091f1f>] warn_slowpath_fmt+0x5f/0x80
>> [    3.419868]  [<ffffffff810e9a84>] lockdep_trace_alloc+0xb4/0xc0
>> [    3.419988]  [<ffffffff8120dc42>] kmem_cache_alloc_node+0x42/0x600
>> [    3.420156]  [<ffffffff8110432d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
>> [    3.420170]  [<ffffffff8163183b>] __alloc_skb+0x5b/0x1d0
>> [    3.420170]  [<ffffffff81144f6b>] audit_log_start+0x29b/0x480
>> [    3.420170]  [<ffffffff810a2925>] ? __lock_task_sighand+0x95/0x270
>> [    3.420170]  [<ffffffff81145cc9>] audit_log_cap_use+0x39/0xf0
>> [    3.420170]  [<ffffffff8109cd75>] ns_capable+0x45/0x70
>> [    3.420170]  [<ffffffff8109cdb7>] capable+0x17/0x20
>> [    3.420170]  [<ffffffff812a2f50>] oom_score_adj_write+0x150/0x2f0
>> [    3.420170]  [<ffffffff81230997>] __vfs_write+0x37/0x160
>> [    3.420170]  [<ffffffff810e33b7>] ? update_fast_ctr+0x17/0x30
>> [    3.420170]  [<ffffffff810e3449>] ? percpu_down_read+0x49/0x90
>> [    3.420170]  [<ffffffff81233d47>] ? __sb_start_write+0xb7/0xf0
>> [    3.420170]  [<ffffffff81233d47>] ? __sb_start_write+0xb7/0xf0
>> [    3.420170]  [<ffffffff81231048>] vfs_write+0xb8/0x1b0
>> [    3.420170]  [<ffffffff812533c6>] ? __fget_light+0x66/0x90
>> [    3.420170]  [<ffffffff81232078>] SyS_write+0x58/0xc0
>> [    3.420170]  [<ffffffff81001f2c>] do_syscall_64+0x5c/0x300
>> [    3.420170]  [<ffffffff81849c9a>] entry_SYSCALL64_slow_path+0x25/0x25
>> [    3.420170] ---[ end trace fb586899fb556a5e ]---
>> [    3.447922] random: systemd-udevd urandom read with 3 bits of entropy
>> available
>> [    4.014078] clocksource: Switched to clocksource tsc
>> Begin: Loading essential drivers ... done.
>>
>> This is with qemu and the boot continues normally. With real computer,
>> there's no such output and system just seems to freeze.
>>
>> Could it be possible that the deadlock happens because there's some IO
>> towards /sys/fs/cgroup, which causes a capability check and that in turn
>> causes locking problems when we try to print cgroup list?
> 
> The above warning is printed by the code from
> kernel/locking/lockdep.c:2871
> 
> static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
> {
> [...]
> 	/* We're only interested __GFP_FS allocations for now */
> 	if (!(gfp_mask & __GFP_FS))
> 		return;
> 
> 	/*
> 	 * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
> 	 */
> 	if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
> 		return;
> 
> 
> The backtrace shows that your new audit_log_cap_use() is called
> from vfs_write(). You might try to use audit_log_start() with
> GFP_NOFS instead of GFP_KERNEL.
> 
> Note that this is rather intuitive advice. I still need to learn a lot
> about memory management and kernel in general to be more sure about
> a correct solution.

Here's what I got now:

[   18.043181]
[   18.044123] ======================================================
[   18.044123] [ INFO: possible circular locking dependency detected ]
[   18.044123] 4.7.0-rc5+ #99 Not tainted
[   18.044123] -------------------------------------------------------
[   18.044123] systemd/1 is trying to acquire lock:
[   18.044123]  (tasklist_lock){.+.+..}, at: [<ffffffff81137ae1>]
cgroup_mount+0x4f1/0xc10
[   18.044123]
[   18.044123] but task is already holding lock:
[   18.044123]  (css_set_lock){......}, at: [<ffffffff81137a9d>]
cgroup_mount+0x4ad/0xc10
[   18.044123]
[   18.044123] which lock already depends on the new lock.
[   18.044123]
[   18.044123]
[   18.044123] the existing dependency chain (in reverse order) is:
[   18.044123]
-> #3 (css_set_lock){......}:
[   18.044123]        [<ffffffff810e92b3>] lock_acquire+0xe3/0x1c0
[   18.044123]        [<ffffffff8184e187>] _raw_spin_lock_irq+0x37/0x50
[   18.044123]        [<ffffffff811374be>] cgroup_setup_root+0x19e/0x2d0
[   18.044123]        [<ffffffff821911fc>] cgroup_init+0xec/0x41d
[   18.044123]        [<ffffffff82171f68>] start_kernel+0x40c/0x465
[   18.044123]        [<ffffffff82171294>]
x86_64_start_reservations+0x2f/0x31
[   18.044123]        [<ffffffff8217140e>] x86_64_start_kernel+0x178/0x18b
[   18.044123]
-> #2 (cgroup_mutex){+.+...}:
[   18.044123]        [<ffffffff810e92b3>] lock_acquire+0xe3/0x1c0
[   18.044123]        [<ffffffff8184afaf>] mutex_lock_nested+0x5f/0x350
[   18.044123]        [<ffffffff8113967a>] audit_cgroup_list+0x4a/0x2f0
[   18.044123]        [<ffffffff81145d69>] audit_log_cap_use+0xd9/0xf0
[   18.044123]        [<ffffffff8109cd75>] ns_capable+0x45/0x70
[   18.044123]        [<ffffffff8109cdb7>] capable+0x17/0x20
[   18.044123]        [<ffffffff812a2f50>] oom_score_adj_write+0x150/0x2f0
[   18.044123]        [<ffffffff81230997>] __vfs_write+0x37/0x160
[   18.044123]        [<ffffffff81231048>] vfs_write+0xb8/0x1b0
[   18.044123]        [<ffffffff81232078>] SyS_write+0x58/0xc0
[   18.044123]        [<ffffffff81001f2c>] do_syscall_64+0x5c/0x300
[   18.044123]        [<ffffffff8184ea5a>] return_from_SYSCALL_64+0x0/0x7a
[   18.044123]
-> #1 (&(&sighand->siglock)->rlock){+.+...}:
[   18.044123]        [<ffffffff810e92b3>] lock_acquire+0xe3/0x1c0
[   18.044123]        [<ffffffff8184e011>] _raw_spin_lock+0x31/0x40
[   18.044123]        [<ffffffff810901d9>]
copy_process.part.34+0x10f9/0x1b40
[   18.044123]        [<ffffffff81090e23>] _do_fork+0xf3/0x6b0
[   18.044123]        [<ffffffff81091409>] kernel_thread+0x29/0x30
[   18.044123]        [<ffffffff810b71d7>] kthreadd+0x187/0x1e0
[   18.044123]        [<ffffffff8184ebbf>] ret_from_fork+0x1f/0x40
[   18.044123]
-> #0 (tasklist_lock){.+.+..}:
[   18.044123]        [<ffffffff810e8dfb>] __lock_acquire+0x13cb/0x1440
[   18.044123]        [<ffffffff810e92b3>] lock_acquire+0xe3/0x1c0
[   18.044123]        [<ffffffff8184e444>] _raw_read_lock+0x34/0x50
[   18.044123]        [<ffffffff81137ae1>] cgroup_mount+0x4f1/0xc10
[   18.044123]        [<ffffffff81234de8>] mount_fs+0x38/0x170
[   18.044123]        [<ffffffff812562bb>] vfs_kern_mount+0x6b/0x150
[   18.044123]        [<ffffffff81258fdc>] do_mount+0x24c/0xe30
[   18.044123]        [<ffffffff81259ef5>] SyS_mount+0x95/0xe0
[   18.044123]        [<ffffffff8184e9a5>]
entry_SYSCALL_64_fastpath+0x18/0xa8
[   18.044123]
[   18.044123] other info that might help us debug this:
[   18.044123]
[   18.044123] Chain exists of:
  tasklist_lock --> cgroup_mutex --> css_set_lock

[   18.044123]  Possible unsafe locking scenario:
[   18.044123]
[   18.044123]        CPU0                    CPU1
[   18.044123]        ----                    ----
[   18.044123]   lock(css_set_lock);
[   18.044123]                                lock(cgroup_mutex);
[   18.044123]                                lock(css_set_lock);
[   18.044123]   lock(tasklist_lock);
[   18.044123]
[   18.044123]  *** DEADLOCK ***
[   18.044123]
[   18.044123] 1 lock held by systemd/1:
[   18.044123]  #0:  (css_set_lock){......}, at: [<ffffffff81137a9d>]
cgroup_mount+0x4ad/0xc10
[   18.044123]
[   18.044123] stack backtrace:
[   18.044123] CPU: 0 PID: 1 Comm: systemd Not tainted 4.7.0-rc5+ #99
[   18.044123] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Debian-1.8.2-1 04/01/2014
[   18.044123]  0000000000000086 0000000008966b11 ffff880006d13bb0
ffffffff813c9c45
[   18.044123]  ffffffff829dbed0 ffffffff829cf2a0 ffff880006d13bf0
ffffffff810e60a3
[   18.044123]  ffff880006d13c30 ffff880006d067b0 ffff880006d06040
0000000000000001
[   18.044123] Call Trace:
[   18.044123]  [<ffffffff813c9c45>] dump_stack+0x67/0x92
[   18.044123]  [<ffffffff810e60a3>] print_circular_bug+0x1e3/0x250
[   18.044123]  [<ffffffff810e8dfb>] __lock_acquire+0x13cb/0x1440
[   18.044123]  [<ffffffff810e92b3>] lock_acquire+0xe3/0x1c0
[   18.044123]  [<ffffffff81137ae1>] ? cgroup_mount+0x4f1/0xc10
[   18.044123]  [<ffffffff8184e444>] _raw_read_lock+0x34/0x50
[   18.044123]  [<ffffffff81137ae1>] ? cgroup_mount+0x4f1/0xc10
[   18.044123]  [<ffffffff81137ae1>] cgroup_mount+0x4f1/0xc10
[   18.044123]  [<ffffffff810e5637>] ? lockdep_init_map+0x57/0x1f0
[   18.044123]  [<ffffffff81234de8>] mount_fs+0x38/0x170
[   18.044123]  [<ffffffff812562bb>] vfs_kern_mount+0x6b/0x150
[   18.044123]  [<ffffffff81258fdc>] do_mount+0x24c/0xe30
[   18.044123]  [<ffffffff8121060b>] ? kmem_cache_alloc_trace+0x28b/0x5e0
[   18.044123]  [<ffffffff811cc1c6>] ? strndup_user+0x46/0x80
[   18.044123]  [<ffffffff81259ef5>] SyS_mount+0x95/0xe0
[   18.044123]  [<ffffffff8184e9a5>] entry_SYSCALL_64_fastpath+0x18/0xa8

This is with GFP_KERNEL changed to GFP_NOFS for both allocations.

-Topi


