From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v8 4/6] cpuset: Make generate_sched_domains() recognize
 isolated_cpus
Date: Wed, 23 May 2018 16:18:53 -0400
Message-ID: <bf4cb72b-9ff3-eb8b-ca2c-f6c4fee5c123@redhat.com>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-5-git-send-email-longman@redhat.com>
 <20180523173453.GY30654@e110439-lin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523173453.GY30654@e110439-lin>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On 05/23/2018 01:34 PM, Patrick Bellasi wrote:
> Hi Waiman,
>
> On 17-May 16:55, Waiman Long wrote:
>
> [...]
>
>> @@ -672,13 +672,14 @@ static int generate_sched_domains(cpumask_var_t **domains,
>>  	int ndoms = 0;		/* number of sched domains in result */
>>  	int nslot;		/* next empty doms[] struct cpumask slot */
>>  	struct cgroup_subsys_state *pos_css;
>> +	bool root_load_balance = is_sched_load_balance(&top_cpuset);
>>  
>>  	doms = NULL;
>>  	dattr = NULL;
>>  	csa = NULL;
>>  
>>  	/* Special case for the 99% of systems with one, full, sched domain */
>> -	if (is_sched_load_balance(&top_cpuset)) {
>> +	if (root_load_balance && !top_cpuset.isolation_count) {
> Perhaps I'm missing something but, it seems to me that, when the two
> conditions above are true, then we are going to destroy and rebuild
> the exact same scheduling domains.
>
> IOW, on 99% of systems where:
>
>    is_sched_load_balance(&top_cpuset)
>    top_cpuset.isolation_count = 0
>
> since boot time and forever, then every time we update a value for
> cpuset.cpus we keep rebuilding the same SDs.
>
> It's not strictly related to this patch, the same already happens in
> mainline based just on the first condition, but since you are extending
> that optimization, perhaps you can tell me where I'm possibly wrong or
> which cases I'm not considering.
>
> I'm interested mainly because on Android systems those conditions
> are always true and we see SDs rebuilds every time we write
> something in cpuset.cpus, which ultimately accounts for almost all the
> 6-7[ms] time required for the write to return, depending on the CPU
> frequency.
>
> Cheers Patrick
>
Yes, that is true. I will look into how to further optimize this. Thanks
for the suggestion.

-Longman

