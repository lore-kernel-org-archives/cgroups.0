From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Fri, 11 Oct 2013 18:05:04 +0200
Message-ID: <CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de>
	<5257F7CE.90702@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:content-type;
        bh=wSCZwTFzWOV2OmsKIauf2QZzKTWvL2vpHgZezAXa2fw=;
        b=ND9twWV6pk106NwLfi50v+OfiOpoODLC1kmluw5+iLIruF/uP7gAx7OEQPQCb7LALU
         EdZ9LAuuA22VPEFWgWPvtXaokVuLNtnQFI6UQa0/K16g7NvJR04ztV/9Ixzb2zcCt7mB
         6otcUnUnhE9DPEIFtIhahTzgcKJDCTgabHhQi2s9ucL7mVehlGFpQCU8KybzkHNpSC14
         qhn6XMjzFALE4LvpSrK0R9sO5wfKOlqRVrulT5YqfCWxtDIzeBK6opkjwxonFfvz9soV
         k6HzEig/F4Q38BCIwDp3uKt9ncsTTzbOlXRXHtxbWjNVOCx4/pUo1zua6M/gWCCwVCKp
         u5ag==
In-Reply-To: <5257F7CE.90702-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I rechecked the logs and found no information about who may be holding
the lock. I have only identified more different stack traces, waiting
for locks. These are for instance:

Oct  8 11:01:27 kaa-12 kernel: [86845.048183]  [<ffffffff813c3b58>]
mutex_lock+0x12/0x22
Oct  8 11:01:27 kaa-12 kernel: [86845.048192]  [<ffffffff81085e57>]
cgroup_rmdir+0x15/0x35
Oct  8 11:01:27 kaa-12 kernel: [86845.048200]  [<ffffffff810fe7d6>]
vfs_rmdir+0x69/0xb4
Oct  8 11:01:27 kaa-12 kernel: [86845.048207]  [<ffffffff810fe8eb>]
do_rmdir+0xca/0x137
Oct  8 11:01:27 kaa-12 kernel: [86845.048217]  [<ffffffff8100c259>] ?
syscall_trace_enter+0xd5/0x14c

Oct  8 11:01:27 kaa-12 kernel: [86845.048359]  [<ffffffff813c3b58>]
mutex_lock+0x12/0x22
Oct  8 11:01:27 kaa-12 kernel: [86845.048368]  [<ffffffff8108286a>]
cgroup_free_fn+0x1f/0xc3
Oct  8 11:01:27 kaa-12 kernel: [86845.048378]  [<ffffffff81047cb7>]
process_one_work+0x15f/0x21e

Oct  8 11:01:27 kaa-12 kernel: [86845.048762]  [<ffffffff813c3b58>]
mutex_lock+0x12/0x22
Oct  8 11:01:27 kaa-12 kernel: [86845.048770]  [<ffffffff810841e8>]
cgroup_release_agent+0x24/0x141
Oct  8 11:01:27 kaa-12 kernel: [86845.048778]  [<ffffffff813c56d6>] ?
__schedule+0x4b2/0x560
Oct  8 11:01:27 kaa-12 kernel: [86845.048787]  [<ffffffff81047cb7>]
process_one_work+0x15f/0x21e

Oct  8 11:01:27 kaa-12 kernel: [86845.049639]  [<ffffffff813c3b58>]
mutex_lock+0x12/0x22
Oct  8 11:01:27 kaa-12 kernel: [86845.049647]  [<ffffffff8108286a>]
cgroup_free_fn+0x1f/0xc3
Oct  8 11:01:27 kaa-12 kernel: [86845.049657]  [<ffffffff81047cb7>]
process_one_work+0x15f/0x21e

But i suppose, the lock is lost elsewhere. Are there any kernel
options i could activate for more debug output or some tools to find
out, who is holding the lock (or who forgot to unlock).

On Fri, Oct 11, 2013 at 3:06 PM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> On 2013/10/10 16:50, Markus Blank-Burian wrote:
>> Hi,
>>
>
> Thanks for the report.
>
>> I have upgraded all nodes on our computing cluster to 3.11.3 last week (from
>> 3.10.9) and experience deadlocks in kernel threads connected to cgroups. They
>> appear sometimes, when our queuing system (slurm 2.6.0) tries to clean up its
>> cgroups (using freezer, cpuset, memory and devices subsets). I have attached
>> the associated kernel messages as well als the cleanup script.
>>
>
> We've changed the cgroup destroy path dramatically including using per-cpu
> ref, so those changes probably introduced this bug.
>
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617545] INFO: task kworker/7:0:5201 blocked for more than 120 seconds.
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617557] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617563] kworker/7:0     D ffff88077e873328     0  5201      2 0x00000000
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617583] Workqueue: events cgroup_offline_fn
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617590]  ffff8804a4129d70 0000000000000002 ffff8804adc60000 ffff8804a4129fd8
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617599]  ffff8804a4129fd8 0000000000011c40 ffff88077e872ee0 ffffffff81634ae0
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617608]  ffffffff81634ae4 ffff88077e872ee0 ffffffff81634ae8 00000000ffffffff
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617617] Call Trace:
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617634]  [<ffffffff813c57e4>] schedule+0x60/0x62
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617645]  [<ffffffff813c5a6b>] schedule_preempt_disabled+0x13/0x1f
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617654]  [<ffffffff813c4987>] __mutex_lock_slowpath+0x143/0x1d4
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617665]  [<ffffffff8105a3e8>] ? arch_vtime_task_switch+0x6a/0x6f
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617673]  [<ffffffff813c3b58>] mutex_lock+0x12/0x22
>> Oct 10 00:39:48 kaa-14 kernel: [169967.617681]  [<ffffffff81084f4f>] cgroup_offline_fn+0x36/0x137
>
> All the tasks are blocked in cgroup mutex, but it doesn't tell us who's
> holding this lock, which is vital.
>
> Is there any other kernel warnings in the kernel log?
>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
