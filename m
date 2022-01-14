From: cruzzhao <cruzzhao@linux.alibaba.com>
Subject: Re: [PATCH v2 2/3] sched/core: Forced idle accounting per-cpu
Date: Fri, 14 Jan 2022 19:06:30 +0800
Message-ID: <e071a66e-e7d5-8657-725b-8d48cb8ddbb7@linux.alibaba.com>
References: <1641894961-9241-1-git-send-email-CruzZhao@linux.alibaba.com>
 <1641894961-9241-3-git-send-email-CruzZhao@linux.alibaba.com>
 <Yd7JO1UYlRXR0dWE@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <Yd7JO1UYlRXR0dWE@hirez.programming.kicks-ass.net>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Peter Zijlstra <peterz@infradead.org>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, joshdon@google.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org



在 2022/1/12 下午8:27, Peter Zijlstra 写道:
> On Tue, Jan 11, 2022 at 05:56:00PM +0800, Cruz Zhao wrote:
> 
>> @@ -1115,6 +1118,7 @@ struct rq {
>>  	unsigned int		core_forceidle_seq;
>>  	unsigned int		core_forceidle_occupation;
>>  	u64			core_forceidle_start;
>> +	bool			in_forcedidle;
> 
> naming is wrong
> 
>>  #endif
>>  };
>>  
>> diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
>> index 07dde29..ea22a8c 100644
>> --- a/kernel/sched/stats.c
>> +++ b/kernel/sched/stats.c
>> @@ -108,6 +108,16 @@ void __update_stats_enqueue_sleeper(struct rq *rq, struct task_struct *p,
>>  	}
>>  }
>>  
>> +#ifdef CONFIG_SCHED_CORE
>> +static inline u64 get_rq_forceidle_time(struct rq *rq) {
>> +	return rq->rq_forceidle_time;
>> +}
>> +#else
>> +static inline u64 get_rq_forceidle_time(struct rq *rq) {
>> +	return 0;
>> +}
>> +#endif
> 
> indent is wrong, and if you put the #ifdef inside the function it'll be
> smaller.

Thanks for reviewing and suggestions, I'll fix these problems in the
next version.

Best,
Cruz Zhao
