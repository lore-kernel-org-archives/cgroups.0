From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 1/5] sched/topology: Add check to backup comment
 about hotplug lock
Date: Thu, 14 Jun 2018 09:33:24 -0400
Message-ID: <20180614093324.7ea45448@gandalf.local.home>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
        <20180613121711.5018-2-juri.lelli@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613121711.5018-2-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Wed, 13 Jun 2018 14:17:07 +0200
Juri Lelli <juri.lelli@redhat.com> wrote:

> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> The comment above function partition_sched_domains() clearly state that
> the cpu_hotplug_lock should be held but doesn't mandate one to abide to
> it.
> 
> Add an explicit check backing that comment, so to make it impossible
> for anyone to miss the requirement.
> 
> Suggested-by: Juri Lelli <juri.lelli@redhat.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> [modified changelog]
> Signed-off-by: Juri Lelli <juri.lelli@redhat.com>

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

> ---
>  kernel/sched/topology.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 61a1125c1ae4..96eee22fafe8 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -1858,6 +1858,7 @@ void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
>  	int i, j, n;
>  	int new_topology;
>  
> +	lockdep_assert_cpus_held();
>  	mutex_lock(&sched_domains_mutex);
>  
>  	/* Always unregister in case we don't destroy any domains: */

