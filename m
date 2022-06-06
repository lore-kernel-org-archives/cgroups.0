From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Sun, 5 Jun 2022 21:59:50 -0400
Message-ID: <c9ab0e91-76db-430f-272c-558c269d62ce@redhat.com>
References: <20220602192020.166940-1-longman@redhat.com>
 <20220602192020.166940-4-longman@redhat.com> <YprYgdV0IxAeJZsz@T590>
 <ee754359-cefd-7d4b-7861-1405860bba9b@redhat.com> <Yp1atoLkZPvA1Zd3@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654480795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bvyf6sQjmkfCDLNK49ZrMJaEbj0blM3ELQjytG3RjZU=;
        b=ZR9ufxC6N1Y13Eirk3u3Gst0VjJeo476OD2r15OPjBIMkoP3dBxBdwovJX2BVuRni+hzgN
        Us1Mfkm+jF6djfpSanZJ2eTDi0omp/ZYi0z6H7Rlp/4CA4mpKgG2iXqN0DbWJuBDwFs9a/
        yke8+MviJfIqWdcpeKMKTvzbIGKIoG0=
Content-Language: en-US
In-Reply-To: <Yp1atoLkZPvA1Zd3@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 6/5/22 21:39, Ming Lei wrote:
> On Sun, Jun 05, 2022 at 07:15:27PM -0400, Waiman Long wrote:
>> On 6/3/22 23:58, Ming Lei wrote:
>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index abec50f31fe6..8c4f204dbf5b 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -622,7 +622,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
>>>    {
>>>    	unsigned int x;
>>> -	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
>>> +	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id(), NULL);
>>>    	x = __this_cpu_add_return(stats_updates, abs(val));
>>>    	if (x > MEMCG_CHARGE_BATCH) {
>> I think the rstat set of functions are doing that already. So flush will
>> only call CPUs that have called cgroup_rstat_updated() before. However, one
> Yeah, I guess the detail is in cgroup_rstat_cpu_pop_updated(), but the
> percpu lock(raw_spin_lock_irqsave) is still required, and cgroup_rstat_cpu_pop_updated()
> is still called even through there isn't any update on this CPU.
Yes, I think we may need to add a bitmask of what controllers have 
updates in cgroup_rstat_cpu structure.
>
>> deficiency that I am aware of is that there is no bitmap of which controller
>> have update. The problem that I saw in cgroup v2 is that in a cgroup with
>> both memory controller and block controller enabled, a
>> cgroup_rstat_updated() call from memory cgroup later causes the rstat
>> function to call into block cgroup flush method even though there is no
>> update in the block controller. This is an area that needs improvement.
>>
>> Your code does allow the block controller to be aware of that and avoid
>> further action, but I think it has to be done in the rstat code to be
>> applicable to all controllers instead of just specific to block controller.
> I guess it can be done by adding one percpu variable to 'struct cgroup'.
>
>> There is another problem that this approach. Suppose the system have 20
>> block devices and one of them has an IO operation. Now the flush method
>> still needs to iterate all the 20 blkg's to do an update. The block
>> controller is kind of special that the number of per-cgroup IO stats depends
>> on the number of block devices present. Other controllers just have one set
>> of stats per cgroup.
> Yeah, and this one is really blkio specific issue, and your patch does
> cover this one. Maybe you can add one callback to
> cgroup_rstat_updated(), so the "blkg_iostat_set" instance is added into
> percpu list under percpu lock of cgroup_rstat_cpu_lock, then the lockless
> list isn't needed.

The rstat API is generic. It may not be a good idea to put controller 
specific information into it. Yes, cgroup_rstat_cpu_lock is taken at the 
read side (flush). It may not taken on the write side (update). So it 
may not be easy to rely on this lock for synchronization between the 
read and write side.

Cheers,
Longman

