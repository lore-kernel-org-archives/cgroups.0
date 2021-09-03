From: Hao Xu <haoxu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH 2/2] io_uring: consider cgroup setting when binding sqpoll
 cpu
Date: Fri, 3 Sep 2021 23:04:07 +0800
Message-ID: <c49d9b26-1c74-316a-c933-e6964695a286@linux.alibaba.com>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210901124322.164238-3-haoxu@linux.alibaba.com>
 <YS+tPq1eiQLx4P3M@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YS+tPq1eiQLx4P3M-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

在 2021/9/2 上午12:41, Tejun Heo 写道:
Hi Tejun,
> Hello,
> 
> On Wed, Sep 01, 2021 at 08:43:22PM +0800, Hao Xu wrote:
>> @@ -7112,11 +7113,9 @@ static int io_sq_thread(void *data)
>>   
>>   	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
>>   	set_task_comm(current, buf);
>> +	if (sqd->sq_cpu != -1 && test_cpu_in_current_cpuset(sqd->sq_cpu))
>>   		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
>> +
> 
> Would it make sense to just test whether set_cpus_allowed_ptr() succeeded
> afterwards?
Do you mean: if (sqd->sq_cpu != -1 && !set_cpus_allowed_ptr(current, 
cpumask_of(sqd->sq_cpu)))

I'm not familiar with set_cpus_allowed_ptr(), you mean it contains the
similar logic of test_cpu_in_current_cpuset?
> 
>> @@ -8310,8 +8309,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>>   			int cpu = p->sq_thread_cpu;
>>   
>>   			ret = -EINVAL;
>> -			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
>> +			if (cpu >= nr_cpu_ids || !cpu_online(cpu) ||
>> +			    !test_cpu_in_current_cpuset(cpu))
>>   				goto err_sqpoll;
>> +
> 
> Failing operations on transient conditions like this may be confusing. Let's
> ignore cpuset for now. CPU hotplug is sometimes driven automatically for
> power saving purposes, so failing operation based on whether a cpu is online
> means that the success or failure of the operation can seem arbitrary. If
> the operation takes place while the cpu happens to be online, it succeeds
> and the thread gets unbound and rebound automatically as the cpu goes
This is a bit beyond of my knowledge, so you mean if the cpu back
online, the task will automatically schedule to this cpu? if it's true,
I think the code logic here is fine.
> offline and online. If the operation takes place while the cpu happens to be
> offline, the operation fails.
It's ok that it fails, we leave the option of retry to users themselves.
> 
> I don't know what the intended behavior here should be and we haven't been
> pretty bad at defining reasonable behavior around cpu hotplug, so it'd
> probably be worthwhile to consider what the behavior should be.
> 
> Thanks.
> 
Thanks,
Hao

