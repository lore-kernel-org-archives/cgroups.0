From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: remove unneeded nodes_or() in
 cpuset_change_task_nodemask()
Date: Tue, 20 Jun 2023 12:02:58 +0800
Message-ID: <6f3e30f7-8781-2cf3-07a5-b0635c7d9045@huawei.com>
References: <20230617083043.2065556-1-linmiaohe@huawei.com>
 <c32a0bad-b20f-e53b-a38a-5da687b8a205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c32a0bad-b20f-e53b-a38a-5da687b8a205-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2023/6/19 22:37, Waiman Long wrote:
> On 6/17/23 04:30, Miaohe Lin wrote:
>> The tsk->mems_allowed is changed before calling mpol_rebind_task() and
>> being reassigned right after it. But tsk->mems_allowed is not needed
>> inside mpol_rebind_task(). So remove unneeded tsk->mems_allowed modify
>> via nodes_or() here.
>>
>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>   kernel/cgroup/cpuset.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 58e6f18f01c1..33a429c1179f 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1941,7 +1941,6 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
>>       local_irq_disable();
>>       write_seqcount_begin(&tsk->mems_allowed_seq);
>>   -    nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
>>       mpol_rebind_task(tsk, newmems);
>>       tsk->mems_allowed = *newmems;
>>   
> 
> That line was inserted by commit cc9a6c8776615 ("cpuset: mm: reduce large amounts of memory barrier related damage v3"). At first glance, it does looks like it is not necessary. However, I am not sure if a race is possible that will produce a false failure because of missing this line.
> 

Thanks for your comment. IMHO, the code is protected with mems_allowed_seq seqlock. So it should be fine even if there's a race.
I will take a closer look to make sure whether race exists.

> My 2 cents.

Thanks.

> 
> Cheers,
> Longman
> 
> .

