From: =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 4/4] numa: introduce numa cling feature
Date: Tue, 9 Jul 2019 10:15:37 +0800
Message-ID: <b9a58067-194b-221d-111c-ed1f7661976b@linux.alibaba.com>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <b24c6aa0-7a89-b0b4-984a-a775b8df40a5@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b24c6aa0-7a89-b0b4-984a-a775b8df40a5@linux.alibaba.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hillf Danton <hdanton@sina.com>
Cc: Peter Zijlstra <peterz@infradead.org>, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org, keescook@chromium.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On 2019/7/8 下午4:07, Hillf Danton wrote:
> 
> On Mon, 8 Jul 2019 10:25:27 +0800 Michael Wang wrote:
>> /* Attempt to migrate a task to a CPU on the preferred node. */
>> static void numa_migrate_preferred(struct task_struct *p)
>> {
>> +	bool failed, target;
>> 	unsigned long interval = HZ;
>>
>> 	/* This task has no NUMA fault statistics yet */
>> @@ -1891,8 +2117,12 @@ static void numa_migrate_preferred(struct task_struct *p)
>> 	if (task_node(p) == p->numa_preferred_nid)
>> 		return;
>>
>> +	target = p->numa_preferred_nid;
>> +
> Something instead of bool can be used, too.

Thx for point out :-) to be fix in v3.

> 
>> 	/* Otherwise, try migrate to a CPU on the preferred node */
>> -	task_numa_migrate(p);
>> +	failed = (task_numa_migrate(p) != 0);
>> +
>> +	update_migrate_stat(p, target, failed);
>> }
>>
>> static void
>> @@ -6195,6 +6447,13 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
>> 	if ((unsigned)i < nr_cpumask_bits)
>> 		return i;
>>
>> +	/*
>> +	 * Failed to find an idle cpu, wake affine may want to pull but
>> +	 * try stay on prev-cpu when the task cling to it.
>> +	 */
>> +	if (task_numa_cling(p, cpu_to_node(prev), cpu_to_node(target)))
>> +		return prev;
>> +
> Curious to know what test figures would look like without the above line.

It depends on the wake affine condition then, when waker task consider wakee
suitable for pull, wakee may leave the preferred node, or maybe pull to the
preferred node, just randomly and follow the fate.

In mysql case when there are many such wakeup cases and system is very busy,
the observed workloads could be 4:6 or 3:7 distributed in two nodes.

Regards,
Michael Wang

> 
>> 	return target;
>> }
>>
>> Tested on a 2 node box with 96 cpus, do sysbench-mysql-oltp_read_write
>> testing, X mysqld instances created and attached to X cgroups, X sysbench
>> instances then created and attached to corresponding cgroup to test the
>> mysql with oltp_read_write script for 20 minutes, average eps show:
>>
>> 				origin		ng + cling
>> 4 instances each 24 threads	7545.28		7790.49		+3.25%
>> 4 instances each 48 threads	9359.36		9832.30		+5.05%
>> 4 instances each 72 threads	9602.88		10196.95	+6.19%
>>
>> 8 instances each 24 threads	4478.82		4508.82		+0.67%
>> 8 instances each 48 threads	5514.90		5689.93		+3.17%
>> 8 instances each 72 threads	5582.19		5741.33		+2.85%
> 
