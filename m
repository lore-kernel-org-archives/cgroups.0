From: Qi Zheng <qi.zheng-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix missing cpus_read_{lock,unlock}() in
 cgroup_transfer_tasks()
Date: Mon, 22 May 2023 10:23:10 +0800
Message-ID: <9a60d198-8c0a-9287-7c87-f129197d76f5@linux.dev>
References: <20230517074545.2045035-1-qi.zheng@linux.dev>
 <75E872A8-652F-40B0-80D0-378569E77775@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684722196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UHYDEvtNUWQuWC8UlRB684xx3KqIVrHp5jpKfKK7/Rs=;
        b=mLyJnuISRSOn7JYqLqW/9fffUHnxwZ4K7bCP+b0RJL95YYS1JYBp5ZsMaS0AwQVeAWju4W
        SC1S9MehptXFK2pfj2KorF/IIHgYcRUs4pZoV7UKnfk+Epe/orgRxJQ3AgyAcIsVrtpP4s
        Uqz7Q5wSm5fpZD87c040T+aK3PV/eno=
Content-Language: en-US
In-Reply-To: <75E872A8-652F-40B0-80D0-378569E77775-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Qi Zheng <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Zhao Gongyi <zhaogongyi-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>



On 2023/5/17 15:51, Muchun Song wrote:
> 
> 
>> On May 17, 2023, at 15:45, Qi Zheng <qi.zheng-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
>>
>> From: Qi Zheng <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>>
>> The commit 4f7e7236435c ("cgroup: Fix threadgroup_rwsem <-> cpus_read_lock()
>> deadlock") fixed the deadlock between cgroup_threadgroup_rwsem and
>> cpus_read_lock() by introducing cgroup_attach_{lock,unlock}() and removing
>> cpus_read_{lock,unlock}() from cpuset_attach(). But cgroup_transfer_tasks()
>> was missed and not handled, which will cause th following warning:
>>
>> WARNING: CPU: 0 PID: 589 at kernel/cpu.c:526 lockdep_assert_cpus_held+0x32/0x40
>> CPU: 0 PID: 589 Comm: kworker/1:4 Not tainted 6.4.0-rc2-next-20230517 #50
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
>> Workqueue: events cpuset_hotplug_workfn
>> RIP: 0010:lockdep_assert_cpus_held+0x32/0x40
>> <...>
>> Call Trace:
>>   <TASK>
>>   cpuset_attach+0x40/0x240
>>   cgroup_migrate_execute+0x452/0x5e0
>>   ? _raw_spin_unlock_irq+0x28/0x40
>>   cgroup_transfer_tasks+0x1f3/0x360
>>   ? find_held_lock+0x32/0x90
>>   ? cpuset_hotplug_workfn+0xc81/0xed0
>>   cpuset_hotplug_workfn+0xcb1/0xed0
>>   ? process_one_work+0x248/0x5b0
>>   process_one_work+0x2b9/0x5b0
>>   worker_thread+0x56/0x3b0
>>   ? process_one_work+0x5b0/0x5b0
>>   kthread+0xf1/0x120
>>   ? kthread_complete_and_exit+0x20/0x20
>>   ret_from_fork+0x1f/0x30
>>   </TASK>
>>
>> So just use the cgroup_attach_{lock,unlock}() helper to fix it.
>>
>> Fixes: 4f7e7236435c ("cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock")
>> Reported-by: Zhao Gongyi <zhaogongyi-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>> Signed-off-by: Qi Zheng <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Acked-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks. And hi Tejun, Can this patch be applied?

> 
> Thanks.
> 

-- 
Thanks,
Qi
