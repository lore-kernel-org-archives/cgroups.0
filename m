From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Optimize update_tasks_nodemask()
Date: Wed, 23 Nov 2022 13:48:46 -0500
Message-ID: <5fccf438-fdbe-1bc8-6460-b3911cc51566@redhat.com>
References: <20221123082157.71326-1-haifeng.xu@shopee.com>
 <Y35Swdpq+rJe+Tu3@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669229334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gaE/aOdW+dlAJ1rXJX3+9BcoLCIGWukFU4WSM4KWxKA=;
        b=gGmDCNpszosK6+LzbaPPZrgYt0YBVKYkREhsC+DlV0g51u7/0p+dfsnktLmOYBseRJ8K9Z
        mKgKSByRtXZRGKhfzHh51dKWQ91+p1OlPEjeF2YEWIsxXVrxySbMfbLetISYrLUzFxgoxp
        YDDUmwblJXCLrlnXMHwYftToD9ZupjM=
Content-Language: en-US
In-Reply-To: <Y35Swdpq+rJe+Tu3-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On 11/23/22 12:05, Tejun Heo wrote:
> On Wed, Nov 23, 2022 at 08:21:57AM +0000, haifeng.xu wrote:
>> When change the 'cpuset.mems' under some cgroup, system will hung
>> for a long time. From the dmesg, many processes or theads are
>> stuck in fork/exit. The reason is show as follows.
>>
>> thread A:
>> cpuset_write_resmask /* takes cpuset_rwsem */
>>    ...
>>      update_tasks_nodemask
>>        mpol_rebind_mm /* waits mmap_lock */
>>
>> thread B:
>> worker_thread
>>    ...
>>      cpuset_migrate_mm_workfn
>>        do_migrate_pages /* takes mmap_lock */
>>
>> thread C:
>> cgroup_procs_write /* takes cgroup_mutex and cgroup_threadgroup_rwsem */
>>    ...
>>      cpuset_can_attach
>>        percpu_down_write /* waits cpuset_rwsem */
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
>> shared with group leader.
> This is only a problem in cgroup1 and cgroup1 doesn't require the threads of
> a given task to be in the same cgroup. I don't think you can optimize it
> this way.

I think it is an issue anyway if different threads of a process are in 
different cpusets with different node mask. It is not a configuration 
that should be used at all.

This patch makes update_tasks_nodemask() somewhat similar to 
cpuset_attach() where all tasks are iterated to update the node mask but 
only the task leaders are required to update the mm. For a non-group 
leader task, maybe we can check if the group leader is in the same 
cpuset. If so, we can skip the mm update. Do we need similar change in 
cpuset_attach()?

I do think the "migrate = is_memory_migrate(cs);" line can be moved 
outside of the loop, though. Of course, that won't help much in this case.

Cheers,
Longman


