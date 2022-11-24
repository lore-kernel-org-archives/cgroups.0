From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: Re: [PATCH] cgroup/cpuset: Optimize update_tasks_nodemask()
Date: Thu, 24 Nov 2022 15:49:02 +0800
Message-ID: <21e73dad-c6d0-21ea-dcdf-355b71c8537b@shopee.com>
References: <20221123082157.71326-1-haifeng.xu@shopee.com>
 <2ac6f207-e08a-2a7f-01ae-dfaf15eefaf6@redhat.com>
 <4de8821b-e0c0-bf63-4d76-b0ce208cce3b@shopee.com>
 <dfcbffb9-b58a-6d25-2174-39394eb0ccde@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G7mIOYx5XpbGQFlC8Ida0reEU5Je0qsdFez1FBYqNyg=;
        b=NjotXgc97HbmEPcoHrS+QOmRpacOKDb6QdXBznUNud1zfBEYbcLcS0Xt2g3PItbFnr
         h2QU44T4XntjX+yX5aGFm63L8ScVMzk1QnKOSbFWpMjeDfEt7yvCS4NDOuIXfg82fZnh
         DZzGBg5gfIpGza1QU53WZ6sK/ar+0Nz7Mf6oySCBTtb8gXxzc2hXUes7f3Je+8/5ietR
         9h/mbj4vZ4lepK0FPHfAd8Y215fWJxhs+X16DRMm8Nj8EduGiaUZuO9UvZWHyabH7cNa
         kqGuLQR40VQZmVKmSTG+2MvAwq4nPCFJCV8Pos7IuGYCwARs3J6QL7bZBK6+bnipJ8iM
         coPA==
In-Reply-To: <dfcbffb9-b58a-6d25-2174-39394eb0ccde@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman@redhat.com>
Cc: lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org



On 2022/11/24 12:24, Waiman Long wrote:
> On 11/23/22 22:33, Haifeng Xu wrote:
>>
>> On 2022/11/24 04:23, Waiman Long wrote:
>>> On 11/23/22 03:21, haifeng.xu wrote:
>>>> When change the 'cpuset.mems' under some cgroup, system will hung
>>>> for a long time. From the dmesg, many processes or theads are
>>>> stuck in fork/exit. The reason is show as follows.
>>>>
>>>> thread A:
>>>> cpuset_write_resmask /* takes cpuset_rwsem */
>>>>     ...
>>>>       update_tasks_nodemask
>>>>         mpol_rebind_mm /* waits mmap_lock */
>>>>
>>>> thread B:
>>>> worker_thread
>>>>     ...
>>>>       cpuset_migrate_mm_workfn
>>>>         do_migrate_pages /* takes mmap_lock */
>>>>
>>>> thread C:
>>>> cgroup_procs_write /* takes cgroup_mutex and
>>>> cgroup_threadgroup_rwsem */
>>>>     ...
>>>>       cpuset_can_attach
>>>>         percpu_down_write /* waits cpuset_rwsem */
>>>>
>>>> Once update the nodemasks of cpuset, thread A wakes up thread B to
>>>> migrate mm. But when thread A iterates through all tasks, including
>>>> child threads and group leader, it has to wait the mmap_lock which
>>>> has been take by thread B. Unfortunately, thread C wants to migrate
>>>> tasks into cgroup at this moment, it must wait thread A to release
>>>> cpuset_rwsem. If thread B spends much time to migrate mm, the
>>>> fork/exit which acquire cgroup_threadgroup_rwsem also need to
>>>> wait for a long time.
>>>>
>>>> There is no need to migrate the mm of child threads which is
>>>> shared with group leader. Just iterate through the group
>>>> leader only.
>>>>
>>>> Signed-off-by: haifeng.xu <haifeng.xu@shopee.com>
>>>> ---
>>>>    kernel/cgroup/cpuset.c | 3 +++
>>>>    1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>>> index 589827ccda8b..43cbd09546d0 100644
>>>> --- a/kernel/cgroup/cpuset.c
>>>> +++ b/kernel/cgroup/cpuset.c
>>>> @@ -1968,6 +1968,9 @@ static void update_tasks_nodemask(struct cpuset
>>>> *cs)
>>>>              cpuset_change_task_nodemask(task, &newmems);
>>>>    +        if (!thread_group_leader(task))
>>>> +            continue;
>>>> +
>>>>            mm = get_task_mm(task);
>>>>            if (!mm)
>>>>                continue;
>>> Could you try the attached test patch to see if it can fix your problem?
>>> Something along the line of this patch will be more acceptable.
>>>
>>> Thanks,
>>> Longman
>>>
>> Hi, Longman.
>> Thanks for your patch, but there are still some problems.
>>
>> 1）
>>    (group leader, node: 0,1)
>>           cgroup0
>>           /     \
>>          /       \
>>      cgroup1   cgroup2
>>     (threads)  (threads)
>>
>> If set node 0 in cgroup1 and node 1 in cgroup2, both of them will update
>> the mm. And the nodemask of mm depends on who set the node last.
> 
> Yes, that is the existing behavior. It was not that well defined in the
> past and so it is somewhat ambiguous as to what we need to do about it.
> 

The test patch works if the child threads are in same cpuset with group
leader which has same logic with my patch. But if they are in different
cpusets, the test patch will fail because the contention of mmap_lock
still exsits and seems similar to the original logic.

> BTW, cgroup1 has a memory_migrate flag which will force page migration
> if set. I guess you may have it set in your case as it will introduce a
> lot more delay as page migration takes time. That is probably the reason
> why you are seeing a long delay. So one possible solution is to turn
> this flag off. Cgroup v2 doesn't have this flag.
> 

Dou you mean 'CS_MEMORY_MIGRATE'? This flag can be turn off in Cgroup
v1, but it has been set in Cgroup v2 (cpuset_css_alloc) in default and
couldn't be changed.

>>
>> 2）
>>     (process, node: 0,1)
>>           cgroup0
>>           /     \
>>          /       \
>>      cgroup1   cgroup2
>>     (node: 0)  (node: 1)
>>
>> If migrate thread from cgroup0 to cgroup1 or cgroup2, cpuset_attach
>> won't update the mm. So the nodemask of thread, including mems_allowed
>> and mempolicy（updated in cpuset_change_task_nodemask）, is different
>> from
>> the vm_policy in vma(updated in mpol_rebind_mm).
> 
> Yes, that can be the case.
> 
>>
>>
>> In a word, if threads have different cpusets with different nodemask, it
>> will cause inconsistent memory behavior.
> 
> So do you have suggestion of what we need to do going forward?

Should we prevent thread from migrating to those cgroups which have
different nodemask with the cgroup that contains the group leader?

In addition, the group leader and child threads should be in same cgroup
tree, also the level of cgroup containes group leader must be higher
than these cgroups contain child threads, so update_nodemask will work.

Or just disable thread migration in cpuset？It's easy to achieve but will
affect cpu bind.
> 
> Cheers,
> Longman
> 
> 
