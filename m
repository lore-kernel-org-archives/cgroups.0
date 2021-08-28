From: Hao Xu <haoxu@linux.alibaba.com>
Subject: Re: [PATCH for-5.15 v2] io_uring: consider cgroup setting when
 binding sqpoll cpu
Date: Sat, 28 Aug 2021 15:29:31 +0800
Message-ID: <0ceebbaa-a5ce-1e85-4be2-95331bca34ef@linux.alibaba.com>
References: <20210827141315.235974-1-haoxu@linux.alibaba.com>
 <YSkgKN/LviOvmeVH@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <io-uring-owner@vger.kernel.org>
In-Reply-To: <YSkgKN/LviOvmeVH@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, cgroups@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>, Waiman Long <longman@redhat.com>

在 2021/8/28 上午1:26, Tejun Heo 写道:
> Hello,
> 
> On Fri, Aug 27, 2021 at 10:13:15PM +0800, Hao Xu wrote:
>> +static int io_sq_bind_cpu(int cpu)
>> +{
>> +	if (!test_cpu_in_current_cpuset(cpu))
>> +		pr_warn("sqthread %d: bound cpu not allowed\n", current->pid);
>> +	else
>> +		set_cpus_allowed_ptr(current, cpumask_of(cpu));
>> +
>> +	return 0;
>> +}
> ...
>> @@ -8208,8 +8217,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>>   			int cpu = p->sq_thread_cpu;
>>   
>>   			ret = -EINVAL;
>> -			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
>> +			if (cpu >= nr_cpu_ids || !cpu_online(cpu) ||
>> +			    !test_cpu_in_current_cpuset(cpu))
>>   				goto err_sqpoll;
> 
> Given that sq_thread is user-like thread and belongs to the right cgroup,
> I'm not quite sure what the above achieves - the affinities can break
A user of io_uring can pass a cpu id to the kernel to indicate which cpu
the sq_thread should be bound to.
> anytime, so one-time check doesn't really solve the problem. All it seems to
Yes, this a problem.
> add is warning messages. What's the expected behavior when an io thread
> can't run on the target cpu anymore?
A user binds sqthread to some cpu due to some reason which we may not
know, so if the target cpu isn't available anymore, I think cpuset of
sqthread should be as same as the task group's it sits, since we don't
know which cpu we should re-bind it to. And this is the current
behavior. I think Jens knows this question better than I do, Jens?

> 
> Thanks.
> 

