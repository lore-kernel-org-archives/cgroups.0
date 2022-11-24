From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Optimize update_tasks_nodemask()
Date: Thu, 24 Nov 2022 11:33:39 +0800
Message-ID: <4de8821b-e0c0-bf63-4d76-b0ce208cce3b@shopee.com>
References: <20221123082157.71326-1-haifeng.xu@shopee.com>
 <2ac6f207-e08a-2a7f-01ae-dfaf15eefaf6@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0A6IGdis8UFb2G4Z4L2JyFM1cHNL6BHSqh/4YAf0zi4=;
        b=kujSbxlTKyrW4i9i1/6mTJGpSMZE0X6OJ5IPMp3RRmF7qSCPjYv+2bVxe8n5Z8h/1g
         bJGk7Cy/wlCFbrYiAvpjMcNitplpF2Irh4BVshd+J0kP2wCcUImQPf7nRdWE0KFTBCBA
         lUI3rkT+qdxxs4B5g9tz4i2utI3kBEdq2Z51ez6CUhh/TLH5lZGFJlLxdgiXfecaVzJR
         TOJx8T7q5eFaM7U0Lm/aFpSPHRnULvKj6FlOBrG6m8NdlPkNBKxV+tDtgNgcv0Kf4Fpg
         9O/nQtv9++vzQ8l/n6hQMNKzXkEgHwAAHgN6yKPHGneCTt+7qdcfdgrJ8uepOPM1Q7kM
         RAdA==
In-Reply-To: <2ac6f207-e08a-2a7f-01ae-dfaf15eefaf6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2022/11/24 04:23, Waiman Long wrote:
> On 11/23/22 03:21, haifeng.xu wrote:
>> When change the 'cpuset.mems' under some cgroup, system will hung
>> for a long time. From the dmesg, many processes or theads are
>> stuck in fork/exit. The reason is show as follows.
>>
>> thread A:
>> cpuset_write_resmask /* takes cpuset_rwsem */
>>    ...
>>      update_tasks_nodemask
>>        mpol_rebind_mm /* waits mmap_lock */
>>
>> thread B:
>> worker_thread
>>    ...
>>      cpuset_migrate_mm_workfn
>>        do_migrate_pages /* takes mmap_lock */
>>
>> thread C:
>> cgroup_procs_write /* takes cgroup_mutex and cgroup_threadgroup_rwsem */
>>    ...
>>      cpuset_can_attach
>>        percpu_down_write /* waits cpuset_rwsem */
>>
>> Once update the nodemasks of cpuset, thread A wakes up thread B to
>> migrate mm. But when thread A iterates through all tasks, including
>> child threads and group leader, it has to wait the mmap_lock which
>> has been take by thread B. Unfortunately, thread C wants to migrate
>> tasks into cgroup at this moment, it must wait thread A to release
>> cpuset_rwsem. If thread B spends much time to migrate mm, the
>> fork/exit which acquire cgroup_threadgroup_rwsem also need to
>> wait for a long time.
>>
>> There is no need to migrate the mm of child threads which is
>> shared with group leader. Just iterate through the group
>> leader only.
>>
>> Signed-off-by: haifeng.xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
>> ---
>>   kernel/cgroup/cpuset.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 589827ccda8b..43cbd09546d0 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1968,6 +1968,9 @@ static void update_tasks_nodemask(struct cpuset
>> *cs)
>>             cpuset_change_task_nodemask(task, &newmems);
>>   +        if (!thread_group_leader(task))
>> +            continue;
>> +
>>           mm = get_task_mm(task);
>>           if (!mm)
>>               continue;
> 
> Could you try the attached test patch to see if it can fix your problem?
> Something along the line of this patch will be more acceptable.
> 
> Thanks,
> Longman
> 

Hi, Longman.
Thanks for your patch, but there are still some problems.

1）
  (group leader, node: 0,1)
         cgroup0
         /     \
        /       \
    cgroup1   cgroup2
   (threads)  (threads)

If set node 0 in cgroup1 and node 1 in cgroup2, both of them will update
the mm. And the nodemask of mm depends on who set the node last.

2）
   (process, node: 0,1)
         cgroup0
         /     \
        /       \
    cgroup1   cgroup2
   (node: 0)  (node: 1)

If migrate thread from cgroup0 to cgroup1 or cgroup2, cpuset_attach
won't update the mm. So the nodemask of thread, including mems_allowed
and mempolicy（updated in cpuset_change_task_nodemask）, is different from
the vm_policy in vma(updated in mpol_rebind_mm).


In a word, if threads have different cpusets with different nodemask, it
will cause inconsistent memory behavior.

Thanks,
Haifeng.


