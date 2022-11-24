From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] cgroup/cpuset: Optimize update_tasks_nodemask()
Date: Wed, 23 Nov 2022 23:24:57 -0500
Message-ID: <dfcbffb9-b58a-6d25-2174-39394eb0ccde@redhat.com>
References: <20221123082157.71326-1-haifeng.xu@shopee.com>
 <2ac6f207-e08a-2a7f-01ae-dfaf15eefaf6@redhat.com>
 <4de8821b-e0c0-bf63-4d76-b0ce208cce3b@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669263907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QjVToG+OhKw4vvhYVNzjybjOZkvj6GH2PdUap1ZiVFE=;
        b=UTZpG+lcO3qSJhbxHgl25JEDb5YsstILtWyaWD/Jjj8z0Iqsiyb+cUL+vprPi+ut4Lx1KH
        GYfx0zVVqTqmtUfsW2WGDHkv0JzFNYKGT0uDBgnkNncoZxalOrRnCu+SoxJgvaWiFjZe0j
        9UoTWnzYsCcmlMAs0Jt6wtO202bdgH0=
Content-Language: en-US
In-Reply-To: <4de8821b-e0c0-bf63-4d76-b0ce208cce3b@shopee.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Haifeng Xu <haifeng.xu@shopee.com>
Cc: lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/23/22 22:33, Haifeng Xu wrote:
>
> On 2022/11/24 04:23, Waiman Long wrote:
>> On 11/23/22 03:21, haifeng.xu wrote:
>>> When change the 'cpuset.mems' under some cgroup, system will hung
>>> for a long time. From the dmesg, many processes or theads are
>>> stuck in fork/exit. The reason is show as follows.
>>>
>>> thread A:
>>> cpuset_write_resmask /* takes cpuset_rwsem */
>>>     ...
>>>       update_tasks_nodemask
>>>         mpol_rebind_mm /* waits mmap_lock */
>>>
>>> thread B:
>>> worker_thread
>>>     ...
>>>       cpuset_migrate_mm_workfn
>>>         do_migrate_pages /* takes mmap_lock */
>>>
>>> thread C:
>>> cgroup_procs_write /* takes cgroup_mutex and cgroup_threadgroup_rwsem */
>>>     ...
>>>       cpuset_can_attach
>>>         percpu_down_write /* waits cpuset_rwsem */
>>>
>>> Once update the nodemasks of cpuset, thread A wakes up thread B to
>>> migrate mm. But when thread A iterates through all tasks, including
>>> child threads and group leader, it has to wait the mmap_lock which
>>> has been take by thread B. Unfortunately, thread C wants to migrate
>>> tasks into cgroup at this moment, it must wait thread A to release
>>> cpuset_rwsem. If thread B spends much time to migrate mm, the
>>> fork/exit which acquire cgroup_threadgroup_rwsem also need to
>>> wait for a long time.
>>>
>>> There is no need to migrate the mm of child threads which is
>>> shared with group leader. Just iterate through the group
>>> leader only.
>>>
>>> Signed-off-by: haifeng.xu <haifeng.xu@shopee.com>
>>> ---
>>>    kernel/cgroup/cpuset.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> index 589827ccda8b..43cbd09546d0 100644
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -1968,6 +1968,9 @@ static void update_tasks_nodemask(struct cpuset
>>> *cs)
>>>              cpuset_change_task_nodemask(task, &newmems);
>>>    +        if (!thread_group_leader(task))
>>> +            continue;
>>> +
>>>            mm = get_task_mm(task);
>>>            if (!mm)
>>>                continue;
>> Could you try the attached test patch to see if it can fix your problem?
>> Something along the line of this patch will be more acceptable.
>>
>> Thanks,
>> Longman
>>
> Hi, Longman.
> Thanks for your patch, but there are still some problems.
>
> 1）
>    (group leader, node: 0,1)
>           cgroup0
>           /     \
>          /       \
>      cgroup1   cgroup2
>     (threads)  (threads)
>
> If set node 0 in cgroup1 and node 1 in cgroup2, both of them will update
> the mm. And the nodemask of mm depends on who set the node last.

Yes, that is the existing behavior. It was not that well defined in the 
past and so it is somewhat ambiguous as to what we need to do about it.

BTW, cgroup1 has a memory_migrate flag which will force page migration 
if set. I guess you may have it set in your case as it will introduce a 
lot more delay as page migration takes time. That is probably the reason 
why you are seeing a long delay. So one possible solution is to turn 
this flag off. Cgroup v2 doesn't have this flag.

>
> 2）
>     (process, node: 0,1)
>           cgroup0
>           /     \
>          /       \
>      cgroup1   cgroup2
>     (node: 0)  (node: 1)
>
> If migrate thread from cgroup0 to cgroup1 or cgroup2, cpuset_attach
> won't update the mm. So the nodemask of thread, including mems_allowed
> and mempolicy（updated in cpuset_change_task_nodemask）, is different from
> the vm_policy in vma(updated in mpol_rebind_mm).

Yes, that can be the case.

>
>
> In a word, if threads have different cpusets with different nodemask, it
> will cause inconsistent memory behavior.

So do you have suggestion of what we need to do going forward?

Cheers,
Longman


