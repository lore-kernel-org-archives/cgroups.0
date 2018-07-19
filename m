From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 9/9] cpuset: Allow reporting of sched domain
 generation info
Date: Thu, 19 Jul 2018 09:56:47 -0400
Message-ID: <f1761707-28be-3e72-d87d-6e9a0f1653c8@redhat.com>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-10-git-send-email-longman@redhat.com>
 <20180719135429.GF2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180719135429.GF2494@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 07/19/2018 09:54 AM, Peter Zijlstra wrote:
> On Sun, Jun 24, 2018 at 03:30:40PM +0800, Waiman Long wrote:
>> This patch enables us to report sched domain generation information.
>>
>> If DYNAMIC_DEBUG is enabled, issuing the following command
>>
>>   echo "file cpuset.c +p" > /sys/kernel/debug/dynamic_debug/control
>>
>> and setting loglevel to 8 will allow the kernel to show what scheduling
>> domain changes are being made.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>  kernel/cgroup/cpuset.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 07a5575..62b7e61 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -836,6 +836,23 @@ static int generate_sched_domains(cpumask_var_t **domains,
>>  	return ndoms;
>>  }
>>  
>> +#ifdef CONFIG_DEBUG_KERNEL
>> +static inline void debug_print_domains(cpumask_var_t *doms, int ndoms)
>> +{
>> +	int i;
>> +	char buf[200];
>> +	char *ptr, *end = buf + sizeof(buf) - 1;
>> +
>> +	for (i = 0, ptr = buf, *end = '\0'; i < ndoms; i++)
>> +		ptr += snprintf(ptr, end - ptr, "dom%d=%*pbl ", i,
>> +				cpumask_pr_args(doms[i]));
>> +
>> +	pr_debug("Generated %d domains: %s\n", ndoms, buf);
>> +}
>> +#else
>> +static inline void debug_print_domains(cpumask_var_t *doms, int ndoms) { }
>> +#endif
> I still hate this patch.. it prints information already available in
> sched_debug and has that rediculous on-stack buffer.

This patch is just for my own testing purpose. We can certainly drop that.

Tejun, please drop this one.

Thanks,
Longman

