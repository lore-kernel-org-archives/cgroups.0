From: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Fix a race between cpuset_attach() and cpu
 hotplug
Date: Sat, 22 Jan 2022 15:54:09 +0800
Message-ID: <12975f48-0419-9c34-8751-c3d3fca4f7b3@huawei.com>
References: <20220121101210.84926-1-zhangqiao22@huawei.com>
 <a166a39f-aa9f-95af-3f3f-f4e17e7c3305@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a166a39f-aa9f-95af-3f3f-f4e17e7c3305-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, bblum-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



在 2022/1/21 20:43, Waiman Long 写道:
> On 1/21/22 05:12, Zhang Qiao wrote:
>> As previously discussed(https://lkml.org/lkml/2022/1/20/51),
>> cpuset_attach() is affected with similar cpu hotplug race,
>> as follow scenario:
>>
>>       cpuset_attach()                cpu hotplug
>>      ---------------------------            ----------------------
>>      down_write(cpuset_rwsem)
>>      guarantee_online_cpus() // (load cpus_attach)
>>                     sched_cpu_deactivate
>>                       set_cpu_active()
>>                       // will change cpu_active_mask
>>      set_cpus_allowed_ptr(cpus_attach)
>>        __set_cpus_allowed_ptr_locked()
>>         // (if the intersection of cpus_attach and
>>           cpu_active_mask is empty, will return -EINVAL)
>>      up_write(cpuset_rwsem)
>>
>> To avoid races such as described above, protect cpuset_attach() call
>> with cpu_hotplug_lock.
>>
>> Fixes: be367d099270 ("cgroups: let ss->can_attach and ss->attach do whole threadgroups at a time")
>> Reported-by: Zhao Gongyi <zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>   kernel/cgroup/cpuset.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index dc653ab26e50..0af5725cc1df 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2252,6 +2252,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>>       cgroup_taskset_first(tset, &css);
>>       cs = css_cs(css);
>>
>> +    cpus_read_lock();
>>       percpu_down_write(&cpuset_rwsem);
>>
>>       guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
>> @@ -2305,6 +2306,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>>           wake_up(&cpuset_attach_wq);
>>
>>       percpu_up_write(&cpuset_rwsem);
>> +    cpus_read_unlock();
>>   }
>>
>>   /* The various types of files and directories in a cpuset file system */
>> -- 
>> 2.18.0
> 
> The locking sequence looks right.
> 
> Acked-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
Thanks for your review!

Regards,
Qiao
.

> .
