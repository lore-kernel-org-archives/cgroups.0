From: Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Thu, 7 Jul 2016 20:27:13 +0000
Message-ID: <e81401b8-a731-9c22-f5a3-ce25eefb1471@gmail.com>
References: <20160624163527.GZ3262@mtj.duckdns.org>
 <20160624165910.GA9675@mail.hallyn.com>
 <20160624172447.GA3262@mtj.duckdns.org>
 <47890d79-0891-dd13-4f60-e7e5f1f3fed3@gmail.com>
 <CAOS58YMxz5HfJUayqjw+SPj485M+wquTqQouk367rV2mfvVRHg@mail.gmail.com>
 <20160627145457.GA26980@mail.hallyn.com>
 <58938c8b-aca6-a5b8-9533-58e78d878e85@gmail.com>
 <CAOS58YM+h0w_UciXLbiJcKizPkXV66FL57LT7Mc+RRWspN+Y2Q@mail.gmail.com>
 <20160627194941.GA31843@mail.hallyn.com>
 <218f2bef-5e5e-89c4-154b-24dc49c82c31@gmail.com>
 <20160707091645.GG3238@pathway.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=wPbO0zfSk7D345zC+W03FXyiCBy+XTiuS0C7asQ4XKo=;
        b=pEkXh0aqDxsaUoKyKOwH7SQNbyDCU809b0MXR4Zmlgx9j52rJLvV8pfBSFi7RDQncZ
         VNvNt2LzQ2GtqsmX0sreCGmASdw+evfaDAWUcH6hegbiMLFqbza6PUhkFXk+oGe0Uadj
         5EMX1ECemaS3cQnKD2oN0mxTvOXhUzUU6gV/jIBzZtCwlx2ITUCA1iMpG938491LK7Np
         UVUHI+fCjcg5FhJxVVFohjixsAf4Xx4xkcRM5E0ixeAVf70jZoQRdYm9SS12cYtzHePe
         Vf1E0OVuu2igZxuVhVFUpFAZbBMExfgFsRI3huTAeDUsPAAgKzoFJZiUtYbCX/c9QwOZ
         H5dQ==
In-Reply-To: <20160707091645.GG3238@pathway.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Petr Mladek <pmladek@suse.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>, luto@kernel.org, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

On 07/07/16 09:16, Petr Mladek wrote:
> On Sun 2016-07-03 15:08:07, Topi Miettinen wrote:
>> The attached patch would make any uses of capabilities generate audit
>> messages. It works for simple tests as you can see from the commit
>> message, but unfortunately the call to audit_cgroup_list() deadlocks the
>> system when booting a full blown OS. There's no deadlock when the call
>> is removed.
>>
>> I guess that in some cases, cgroup_mutex and/or css_set_lock could be
>> already held earlier before entering audit_cgroup_list(). Holding the
>> locks is however required by task_cgroup_from_root(). Is there any way
>> to avoid this? For example, only print some kind of cgroup ID numbers
>> (are there unique and stable IDs, available without locks?) for those
>> cgroups where the task is registered in the audit message?
> 
> I am not sure if anyone know what really happens here. I suggest to
> enable lockdep. It might detect possible deadlock even before it
> really happens, see Documentation/locking/lockdep-design.txt
> 
> It can be enabled by
> 
>    CONFIG_PROVE_LOCKING=y
> 
> It depends on
> 
>     CONFIG_DEBUG_KERNEL=y
> 
> and maybe some more options, see lib/Kconfig.debug

Thanks a lot! I caught this stack dump:

starting version 230
[    3.416647] ------------[ cut here ]------------
[    3.417310] WARNING: CPU: 0 PID: 95 at
/home/topi/d/linux.git/kernel/locking/lockdep.c:2871
lockdep_trace_alloc+0xb4/0xc0
[    3.417605] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
[    3.417923] Modules linked in:
[    3.418288] CPU: 0 PID: 95 Comm: systemd-udevd Not tainted 4.7.0-rc5+ #97
[    3.418444] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Debian-1.8.2-1 04/01/2014
[    3.418726]  0000000000000086 000000007970f3b0 ffff88000016fb00
ffffffff813c9c45
[    3.418993]  ffff88000016fb50 0000000000000000 ffff88000016fb40
ffffffff81091e9b
[    3.419176]  00000b3705e2c798 0000000000000046 0000000000000410
00000000ffffffff
[    3.419374] Call Trace:
[    3.419511]  [<ffffffff813c9c45>] dump_stack+0x67/0x92
[    3.419644]  [<ffffffff81091e9b>] __warn+0xcb/0xf0
[    3.419745]  [<ffffffff81091f1f>] warn_slowpath_fmt+0x5f/0x80
[    3.419868]  [<ffffffff810e9a84>] lockdep_trace_alloc+0xb4/0xc0
[    3.419988]  [<ffffffff8120dc42>] kmem_cache_alloc_node+0x42/0x600
[    3.420156]  [<ffffffff8110432d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[    3.420170]  [<ffffffff8163183b>] __alloc_skb+0x5b/0x1d0
[    3.420170]  [<ffffffff81144f6b>] audit_log_start+0x29b/0x480
[    3.420170]  [<ffffffff810a2925>] ? __lock_task_sighand+0x95/0x270
[    3.420170]  [<ffffffff81145cc9>] audit_log_cap_use+0x39/0xf0
[    3.420170]  [<ffffffff8109cd75>] ns_capable+0x45/0x70
[    3.420170]  [<ffffffff8109cdb7>] capable+0x17/0x20
[    3.420170]  [<ffffffff812a2f50>] oom_score_adj_write+0x150/0x2f0
[    3.420170]  [<ffffffff81230997>] __vfs_write+0x37/0x160
[    3.420170]  [<ffffffff810e33b7>] ? update_fast_ctr+0x17/0x30
[    3.420170]  [<ffffffff810e3449>] ? percpu_down_read+0x49/0x90
[    3.420170]  [<ffffffff81233d47>] ? __sb_start_write+0xb7/0xf0
[    3.420170]  [<ffffffff81233d47>] ? __sb_start_write+0xb7/0xf0
[    3.420170]  [<ffffffff81231048>] vfs_write+0xb8/0x1b0
[    3.420170]  [<ffffffff812533c6>] ? __fget_light+0x66/0x90
[    3.420170]  [<ffffffff81232078>] SyS_write+0x58/0xc0
[    3.420170]  [<ffffffff81001f2c>] do_syscall_64+0x5c/0x300
[    3.420170]  [<ffffffff81849c9a>] entry_SYSCALL64_slow_path+0x25/0x25
[    3.420170] ---[ end trace fb586899fb556a5e ]---
[    3.447922] random: systemd-udevd urandom read with 3 bits of entropy
available
[    4.014078] clocksource: Switched to clocksource tsc
Begin: Loading essential drivers ... done.

This is with qemu and the boot continues normally. With real computer,
there's no such output and system just seems to freeze.

Could it be possible that the deadlock happens because there's some IO
towards /sys/fs/cgroup, which causes a capability check and that in turn
causes locking problems when we try to print cgroup list?

-Topi

