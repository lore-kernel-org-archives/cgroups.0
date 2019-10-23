From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH v3 1/2] sched/topology: Don't try to build empty sched
 domains
Date: Wed, 23 Oct 2019 15:12:03 +0100
Message-ID: <595dc187-bbe7-bd24-a322-db0d777697c0@arm.com>
References: <20191015154250.12951-1-valentin.schneider@arm.com>
 <20191015154250.12951-2-valentin.schneider@arm.com>
 <9134acf7-69bb-403b-2e9c-0eb7fb7efabd@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9134acf7-69bb-403b-2e9c-0eb7fb7efabd@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dietmar Eggemann <dietmar.eggemann@arm.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org, morten.rasmussen@arm.com, qperret@google.com, stable@vger.kernel.org

On 23/10/2019 12:46, Dietmar Eggemann wrote:
> Can you not just prevent that a cpuset pointer (cp) is added to the
> cpuset array (csa[]) in case cpumask_empty(cp->effective_cpus)?
> 
> @@ -798,9 +800,14 @@ static int generate_sched_domains(cpumask_var_t
> **domains, cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
>                         continue;
> 
> -   if (is_sched_load_balance(cp))
> +   if (is_sched_load_balance(cp) && !cpumask_empty(cp->effective_cpus))
>             csa[csn++] = cp;
> 

I think you're right. Let me give it a shot and I'll spin a v4 with this +
better changelog for the key.

>>  		dp = doms[nslot];
>>  
>>  		if (nslot == ndoms) {
> 
> [...]
> 
