From: Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v3 1/2] sched/topology: Don't try to build empty sched
 domains
Date: Wed, 23 Oct 2019 13:46:17 +0200
Message-ID: <9134acf7-69bb-403b-2e9c-0eb7fb7efabd@arm.com>
References: <20191015154250.12951-1-valentin.schneider@arm.com>
 <20191015154250.12951-2-valentin.schneider@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20191015154250.12951-2-valentin.schneider@arm.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Valentin Schneider <valentin.schneider@arm.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org, morten.rasmussen@arm.com, qperret@google.com, stable@vger.kernel.org

On 15/10/2019 17:42, Valentin Schneider wrote:

[...]

> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index c52bc91f882b..a859e5539440 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -817,6 +817,11 @@ static int generate_sched_domains(cpumask_var_t **domains,
>  		struct cpuset *a = csa[i];
>  		int apn = a->pn;
>  
> +		if (cpumask_empty(a->effective_cpus)) {
> +			ndoms--;
> +			continue;
> +		}
> +
>  		for (j = 0; j < csn; j++) {
>  			struct cpuset *b = csa[j];
>  			int bpn = b->pn;
> @@ -859,6 +864,9 @@ static int generate_sched_domains(cpumask_var_t **domains,
>  			continue;
>  		}
>  
> +		if (cpumask_empty(a->effective_cpus))
> +			continue;
> +

Can you not just prevent that a cpuset pointer (cp) is added to the
cpuset array (csa[]) in case cpumask_empty(cp->effective_cpus)?

@@ -798,9 +800,14 @@ static int generate_sched_domains(cpumask_var_t
**domains, cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
                        continue;

-   if (is_sched_load_balance(cp))
+   if (is_sched_load_balance(cp) && !cpumask_empty(cp->effective_cpus))
            csa[csn++] = cp;

>  		dp = doms[nslot];
>  
>  		if (nslot == ndoms) {

[...]
