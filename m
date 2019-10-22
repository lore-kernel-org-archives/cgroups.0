From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH v3 1/2] sched/topology: Don't try to build empty sched
 domains
Date: Tue, 22 Oct 2019 13:46:08 +0100
Message-ID: <b38c30cd-f990-dd98-b414-c284f8f32cfd@arm.com>
References: <20191015154250.12951-1-valentin.schneider@arm.com>
 <20191015154250.12951-2-valentin.schneider@arm.com>
 <20dc939f-4102-334e-5fde-a442ee7eaa5e@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20dc939f-4102-334e-5fde-a442ee7eaa5e@arm.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dietmar Eggemann <dietmar.eggemann@arm.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org, morten.rasmussen@arm.com, qperret@google.com, stable@vger.kernel.org

On 22/10/2019 12:43, Dietmar Eggemann wrote:
> First I thought we can do with a little less drama by only preventing
> arch_scale_cpu_capacity() from consuming >= nr_cpu_ids.
> 
> @@ -1894,6 +1894,9 @@ static struct sched_domain_topology_level
>         struct sched_domain_topology_level *tl, *asym_tl = NULL;
>         unsigned long cap;
> 
> +       if (cpumask_empty(cpu_map))
> +               return NULL;
> +
> 
> Until I tried to hp'ed in CPU4 after CPU4/5 had been hp'ed out (your
> example further below) and I got another:
> 
> [   68.014564] Unable to handle kernel paging request at virtual address
> fffe8009903d8ee0
> ...
> [   68.191293] Call trace:
> [   68.193712]  partition_sched_domains_locked+0x1a4/0x4a0
> [   68.198882]  rebuild_sched_domains_locked+0x4d0/0x7b0
> [   68.203880]  rebuild_sched_domains+0x24/0x40
> [   68.208104]  cpuset_hotplug_workfn+0xe0/0x5f8
> ...
> 
> @@ -2213,6 +2216,11 @@ void partition_sched_domains_locked(int
> ndoms_new, cpumask_var_t doms_new[],
>                                * will be recomputed in function
>                                * update_tasks_root_domain().
>                                */
> +                             if (cpumask_empty(doms_cur[i]))
> +                                    printk("doms_cur[%d] empty\n", i);
> +
>                               rd = cpu_rq(cpumask_any(doms_cur[i]))->rd;
> 
> doms_cur[i] is empty when hp'ing in CPU4 again.
> 
> Your patch fixes this as well.
> 

Thanks for giving it a spin!

> Might be worth noting that this is not only about asym CPU capacity
> handling but missing checks after cpumask operations in case the cpuset
> is empty.

Aye, we end up saving whatever we're given (doms_cur = doms_new at the end
of the rebuild). As you pointed out this is also an issue for the operation
done by

  f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")

but it has been introduced after the asymmetry check, hence why I'm tagging
the latter for stable.
