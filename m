From: Hao Xu <haoxu@linux.alibaba.com>
Subject: Re: [PATCH for-5.15 v2] io_uring: consider cgroup setting when
 binding sqpoll cpu
Date: Sat, 28 Aug 2021 00:57:23 +0800
Message-ID: <592ba01a-a128-f781-d920-2b480f91c451@linux.alibaba.com>
References: <20210827141315.235974-1-haoxu@linux.alibaba.com>
 <0988b0dc-232f-80cd-c984-2364c0dee69f@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <io-uring-owner@vger.kernel.org>
In-Reply-To: <0988b0dc-232f-80cd-c984-2364c0dee69f@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, cgroups@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>

在 2021/8/27 下午10:18, Jens Axboe 写道:
> On 8/27/21 8:13 AM, Hao Xu wrote:
>> Since sqthread is userspace like thread now, it should respect cgroup
>> setting, thus we should consider current allowed cpuset when doing
>> cpu binding for sqthread.
> 
> In general, this looks way better than v1. Just a few minor comments
> below.
> 
>> @@ -7000,6 +7001,16 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
>>   	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
>>   }
>>   
>> +static int io_sq_bind_cpu(int cpu)
>> +{
>> +	if (!test_cpu_in_current_cpuset(cpu))
>> +		pr_warn("sqthread %d: bound cpu not allowed\n", current->pid);
>> +	else
>> +		set_cpus_allowed_ptr(current, cpumask_of(cpu));
>> +
>> +	return 0;
>> +}
> 
> This should not be triggerable, unless the set changes between creation
> and the thread being created. Hence maybe the warn is fine. I'd probably
> prefer terminating the thread at that point, which would result in an
> -EOWNERDEAD return when someone attempts to wake the thread.
> 
> Which is probably OK, as we really should not hit this path.
Actually I think cpuset change offen happen in container environment(
at leaset in my practice), eg. by resource monitor and balancer. So I
did this check to make sure we are still maintain sq_cpu logic at that
time as possible as we can. Though the problem is still there during
sqthread running time(the cpuset can change at anytime, which changes
the cpumask of sqthread)

Regards,
Hao
> 
>> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
>> index 04c20de66afc..fad77c91bc1f 100644
>> --- a/include/linux/cpuset.h
>> +++ b/include/linux/cpuset.h
>> @@ -116,6 +116,8 @@ static inline int cpuset_do_slab_mem_spread(void)
>>   
>>   extern bool current_cpuset_is_being_rebound(void);
>>   
>> +extern bool test_cpu_in_current_cpuset(int cpu);
>> +
>>   extern void rebuild_sched_domains(void);
>>   
>>   extern void cpuset_print_current_mems_allowed(void);
>> @@ -257,6 +259,11 @@ static inline bool current_cpuset_is_being_rebound(void)
>>   	return false;
>>   }
>>   
>> +static inline bool test_cpu_in_current_cpuset(int cpu)
>> +{
>> +	return false;
>> +}
>> +
>>   static inline void rebuild_sched_domains(void)
>>   {
>>   	partition_sched_domains(1, NULL, NULL);
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index adb5190c4429..a63c27e9430e 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1849,6 +1849,17 @@ bool current_cpuset_is_being_rebound(void)
>>   	return ret;
>>   }
>>   
>> +bool test_cpu_in_current_cpuset(int cpu)
>> +{
>> +	bool ret;
>> +
>> +	rcu_read_lock();
>> +	ret = cpumask_test_cpu(cpu, task_cs(current)->effective_cpus);
>> +	rcu_read_unlock();
>> +
>> +	return ret;
>> +}
>> +
>>   static int update_relax_domain_level(struct cpuset *cs, s64 val)
>>   {
>>   #ifdef CONFIG_SMP
> 
> In terms of review and so forth, I'd split this into a prep patch. Then
> patch 2 just becomes the io_uring consumer of it.
> 

