From: Juri Lelli <juri.lelli@arm.com>
Subject: Re: [PATCH 2/3] sched/deadline: fix bandwidth check/update when migrating
 tasks between exclusive cpusets
Date: Tue, 23 Sep 2014 09:09:27 +0100
Message-ID: <54212AB7.3070406@arm.com>
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com>	<1411118561-26323-3-git-send-email-juri.lelli@arm.com> <87k34vo3vb.fsf@cecht.legt.fr>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87k34vo3vb.fsf@cecht.legt.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vincent Legout <vincent@legout.info>
Cc: "peterz@infradead.org" <peterz@infradead.org>, "mingo@redhat.com" <mingo@redhat.com>, "juri.lelli@gmail.com" <juri.lelli@gmail.com>, "raistlin@linux.it" <raistlin@linux.it>, "michael@amarulasolutions.com" <michael@amarulasolutions.com>, "fchecconi@gmail.com" <fchecconi@gmail.com>, "daniel.wagner@bmw-carit.de" <daniel.wagner@bmw-carit.de>, "luca.abeni@unitn.it" <luca.abeni@unitn.it>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

Hi Vincent,

On 22/09/14 20:24, Vincent Legout wrote:
> Hello,
> 
> Juri Lelli <juri.lelli@arm.com> writes:
> 
>> Exclusive cpusets are the only way users can restrict SCHED_DEADLINE tasks
>> affinity (performing what is commonly called clustered scheduling).
>> Unfortunately, such thing is currently broken for two reasons:
>>
>>  - No check is performed when the user tries to attach a task to
>>    an exlusive cpuset (recall that exclusive cpusets have an
>>    associated maximum allowed bandwidth).
>>
>>  - Bandwidths of source and destination cpusets are not correctly
>>    updated after a task is migrated between them.
>>
>> This patch fixes both things at once, as they are opposite faces
>> of the same coin.
>>
>> The check is performed in cpuset_can_attach(), as there aren't any
>> points of failure after that function. The updated is split in two
>> halves. We first reserve bandwidth in the destination cpuset, after
>> we pass the check in cpuset_can_attach(). And we then release
>> bandwidth from the source cpuset when the task's affinity is
>> actually changed. Even if there can be time windows when sched_setattr()
>> may erroneously fail in the source cpuset, we are fine with it, as
>> we can't perfom an atomic update of both cpusets at once.
> 
> Thanks, this seems to fix the other problem I had. However, this bug,
> which I never had before, now happens randomly (with or without patch
> 3/3):
> 
> Sep 19 09:54:37 starbuck kernel: [ 1309.728678] ------------[ cut here ]------------
> Sep 19 09:54:37 starbuck kernel: [ 1309.728699] kernel BUG at kernel/sched/deadline.c:819!
> Sep 19 09:54:37 starbuck kernel: [ 1309.728719] invalid opcode: 0000 [#1] PREEMPT SMP 
> Sep 19 09:54:37 starbuck kernel: [ 1309.728744] Modules linked in: nfsv3 rpcsec_gss_krb5 nfsv4 dm_crypt nfsd auth_rpcgss oid_registry exportfs nfs_acl nfs lockd sunrpc bridge stp llc lp coretemp kvm_intel kvm ppdev ioatdma microcode ipmi_si parport_pc lpc_ich dca mfd_core parport ipmi_msghandler joydev serio_raw hid_generic usbhid hid crc32c_intel psmouse e1000e ptp pps_core
> Sep 19 09:54:37 starbuck kernel: [ 1309.728928] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 3.16.0+ #20
> Sep 19 09:54:37 starbuck kernel: [ 1309.728950] Hardware name: empty empty/S7002, BIOS 'V1.10.B10   ' 05/03/2011
> Sep 19 09:54:37 starbuck kernel: [ 1309.728977] task: ffff88023691c920 ti: ffff88023692c000 task.ti: ffff88023692c000
> Sep 19 09:54:37 starbuck kernel: [ 1309.729003] RIP: 0010:[<ffffffff810a543e>]  [<ffffffff810a543e>] enqueue_task_dl+0x44e/0x450
> Sep 19 09:54:37 starbuck kernel: [ 1309.729041] RSP: 0018:ffff88043fc23e68  EFLAGS: 00010082
> Sep 19 09:54:37 starbuck kernel: [ 1309.729060] RAX: 0000000000000000 RBX: ffff880434edb0c0 RCX: ffff880434edb2f8
> Sep 19 09:54:37 starbuck kernel: [ 1309.729086] RDX: 0000000000000008 RSI: ffff880434edb0c0 RDI: 0000000000000000
> Sep 19 09:54:37 starbuck kernel: [ 1309.729140] RBP: ffff88043fc23ea8 R08: 0000000000000001 R09: 000002cb4aebb39d
> Sep 19 09:54:37 starbuck kernel: [ 1309.729193] R10: 13955a8129438cf2 R11: 0000000000000202 R12: 0000000000000008
> Sep 19 09:54:37 starbuck kernel: [ 1309.729247] R13: ffff88043fc33f00 R14: ffff88043fc2e0e0 R15: ffff880434edb2f8
> Sep 19 09:54:37 starbuck kernel: [ 1309.729301] FS:  0000000000000000(0000) GS:ffff88043fc20000(0000) knlGS:0000000000000000
> Sep 19 09:54:37 starbuck kernel: [ 1309.729383] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Sep 19 09:54:37 starbuck kernel: [ 1309.729436] CR2: 0000000000000000 CR3: 0000000435a07000 CR4: 00000000000027e0
> 

This can be related to the problems Daniel is also experiencing.

> My script launches 6 processes and schedules them on 2 cpusets where
> each cpuset contains only one cpu. It moves processes from one cpuset to
> another and also updates their runtime. I can investigate more and try
> to provide a short script to reproduce if needed.
> 

I should be able to dig into this next week. But yes, in the meantime a
script would be useful to reproduce the problem.

Thanks,

- Juri
