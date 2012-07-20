From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: + hugetlb-cgroup-simplify-pre_destroy-callback.patch added to
 -mm tree
Date: Fri, 20 Jul 2012 10:20:29 +0900
Message-ID: <5008B25D.5000902@jp.fujitsu.com>
References: <20120718212637.133475C0050@hpza9.eem.corp.google.com> <20120719113915.GC2864@tiehlicka.suse.cz> <87r4s8gcwe.fsf@skywalker.in.ibm.com> <20120719123820.GG2864@tiehlicka.suse.cz> <87ipdjc15j.fsf@skywalker.in.ibm.com> <5008AEC2.9090707@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5008AEC2.9090707-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mm-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

(2012/07/20 10:05), Kamezawa Hiroyuki wrote:
> (2012/07/19 22:48), Aneesh Kumar K.V wrote:
>> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:
>>
>>> On Thu 19-07-12 17:51:05, Aneesh Kumar K.V wrote:
>>>> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:
>>>>
>>>>>  From 621ed1c9dab63bd82205bd5266eb9974f86a0a3f Mon Sep 17 00:00:00 2001
>>>>> From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>>>>> Date: Thu, 19 Jul 2012 13:23:23 +0200
>>>>> Subject: [PATCH] cgroup: keep cgroup_mutex locked for pre_destroy
>>>>>
>>>>> 3fa59dfb (cgroup: fix potential deadlock in pre_destroy) dropped the
>>>>> cgroup_mutex lock while calling pre_destroy callbacks because memory
>>>>> controller could deadlock because force_empty triggered reclaim.
>>>>> Since "memcg: move charges to root cgroup if use_hierarchy=0" there is
>>>>> no reclaim going on from mem_cgroup_force_empty though so we can safely
>>>>> keep the cgroup_mutex locked. This has an advantage that no tasks might
>>>>> be added during pre_destroy callback and so the handlers don't have to
>>>>> consider races when new tasks add new charges. This simplifies the
>>>>> implementation.
>>>>> ---
>>>>>   kernel/cgroup.c |    2 --
>>>>>   1 file changed, 2 deletions(-)
>>>>>
>>>>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>>>>> index 0f3527d..9dba05d 100644
>>>>> --- a/kernel/cgroup.c
>>>>> +++ b/kernel/cgroup.c
>>>>> @@ -4181,7 +4181,6 @@ again:
>>>>>           mutex_unlock(&cgroup_mutex);
>>>>>           return -EBUSY;
>>>>>       }
>>>>> -    mutex_unlock(&cgroup_mutex);
>>>>>
>>>>>       /*
>>>>>        * In general, subsystem has no css->refcnt after pre_destroy(). But
>>>>> @@ -4204,7 +4203,6 @@ again:
>>>>>           return ret;
>>>>>       }
>>>>>
>>>>> -    mutex_lock(&cgroup_mutex);
>>>>>       parent = cgrp->parent;
>>>>>       if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
>>>>>           clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
>>>>
>>>> mem_cgroup_force_empty still calls
>>>>
>>>> lru_add_drain_all
>>>>     ->schedule_on_each_cpu
>>>>          -> get_online_cpus
>>>>             ->mutex_lock(&cpu_hotplug.lock);
>>>>
>>>> So wont we deadlock ?
>>>
>>> Yes you are right. I got it wrong. I thought that the reclaim is the
>>> main problem. It won't be that easy then and the origin mm patch
>>> (hugetlb-cgroup-simplify-pre_destroy-callback.patch) still needs a fix
>>> or to be dropped.
>>
>
> Aha, then the problematic schedule_on_each_cpu(), Andrew pointed out in this month,
> is in front of us :( ...and drain_all_stock_sync() should be fixed too.
> Hmm...
>
>> We just need to remove the VM_BUG_ON() right ? The rest of the patch is
>> good right ? Otherwise how about the below
>>
>
> I'm personally okay but....ugly ?
>

Hmm, can't cgroup_lock() be implemented as


void cgroup_lock()
{
	get_online_cpus()
	lock_memory_hotplug()
	mutex_lock(&cgroup_mutex);
}


?

Thanks,
-Kame



