From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Subject: Re: [PATCH 2/3] sched/deadline: fix bandwidth check/update when migrating
 tasks between exclusive cpusets
Date: Tue, 23 Sep 2014 15:08:52 +0200
Message-ID: <542170E4.80304@bmw-carit.de>
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com>	<1411118561-26323-3-git-send-email-juri.lelli@arm.com> <87k34vo3vb.fsf@cecht.legt.fr> <54212AB7.3070406@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54212AB7.3070406-5wv7dgnIgG8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli-5wv7dgnIgG8@public.gmane.org>, Vincent Legout <vincent-9z8vmPu0pS/iB9QmIjCX8w@public.gmane.org>
Cc: "peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "raistlin-k2GhghHVRtY@public.gmane.org" <raistlin-k2GhghHVRtY@public.gmane.org>, "michael-dyjBcgdgk7Pe9wHmmfpqLFaTQe2KTcn/@public.gmane.org" <michael-dyjBcgdgk7Pe9wHmmfpqLFaTQe2KTcn/@public.gmane.org>, "fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "luca.abeni-3IIOeSMMxS4@public.gmane.org" <luca.abeni-3IIOeSMMxS4@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

On 09/23/2014 10:09 AM, Juri Lelli wrote:
>> Sep 19 09:54:37 starbuck kernel: [ 1309.728678] ------------[ cut here ]------------
>> Sep 19 09:54:37 starbuck kernel: [ 1309.728699] kernel BUG at kernel/sched/deadline.c:819!
>> Sep 19 09:54:37 starbuck kernel: [ 1309.728719] invalid opcode: 0000 [#1] PREEMPT SMP 
>> Sep 19 09:54:37 starbuck kernel: [ 1309.728744] Modules linked in: nfsv3 rpcsec_gss_krb5 nfsv4 dm_crypt nfsd auth_rpcgss oid_registry exportfs nfs_acl nfs lockd sunrpc bridge stp llc lp coretemp kvm_intel kvm ppdev ioatdma microcode ipmi_si parport_pc lpc_ich dca mfd_core parport ipmi_msghandler joydev serio_raw hid_generic usbhid hid crc32c_intel psmouse e1000e ptp pps_core
>> Sep 19 09:54:37 starbuck kernel: [ 1309.728928] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 3.16.0+ #20
>> Sep 19 09:54:37 starbuck kernel: [ 1309.728950] Hardware name: empty empty/S7002, BIOS 'V1.10.B10   ' 05/03/2011
>> Sep 19 09:54:37 starbuck kernel: [ 1309.728977] task: ffff88023691c920 ti: ffff88023692c000 task.ti: ffff88023692c000
>> Sep 19 09:54:37 starbuck kernel: [ 1309.729003] RIP: 0010:[<ffffffff810a543e>]  [<ffffffff810a543e>] enqueue_task_dl+0x44e/0x450
>> Sep 19 09:54:37 starbuck kernel: [ 1309.729041] RSP: 0018:ffff88043fc23e68  EFLAGS: 00010082
>> Sep 19 09:54:37 starbuck kernel: [ 1309.729060] RAX: 0000000000000000 RBX: ffff880434edb0c0 RCX: ffff880434edb2f8
>> Sep 19 09:54:37 starbuck kernel: [ 1309.729086] RDX: 0000000000000008 RSI: ffff880434edb0c0 RDI: 0000000000000000
>> Sep 19 09:54:37 starbuck kernel: [ 1309.729140] RBP: ffff88043fc23ea8 R08: 0000000000000001 R09: 000002cb4aebb39d
>> Sep 19 09:54:37 starbuck kernel: [ 1309.729193] R10: 13955a8129438cf2 R11: 0000000000000202 R12: 0000000000000008
>> Sep 19 09:54:37 starbuck kernel: [ 1309.729247] R13: ffff88043fc33f00 R14: ffff88043fc2e0e0 R15: ffff880434edb2f8
>> Sep 19 09:54:37 starbuck kernel: [ 1309.729301] FS:  0000000000000000(0000) GS:ffff88043fc20000(0000) knlGS:0000000000000000
>> Sep 19 09:54:37 starbuck kernel: [ 1309.729383] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> Sep 19 09:54:37 starbuck kernel: [ 1309.729436] CR2: 0000000000000000 CR3: 0000000435a07000 CR4: 00000000000027e0
>>
> 
> This can be related to the problems Daniel is also experiencing.

I nailed my problem down to mutex with PI inheritance. This will trigger

  kernel BUG at kernel/sched/deadline.c:819!

reliable.

cheers,
daniel
