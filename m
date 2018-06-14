From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 2/5] sched/topology: Adding function
 partition_sched_domains_locked()
Date: Thu, 14 Jun 2018 09:35:36 -0400
Message-ID: <20180614093536.612712f6@gandalf.local.home>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
        <20180613121711.5018-3-juri.lelli@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613121711.5018-3-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Wed, 13 Jun 2018 14:17:08 +0200
Juri Lelli <juri.lelli@redhat.com> wrote:

> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> Introducing function partition_sched_domains_locked() by taking
> the mutex locking code out of the original function.  That way
> the work done by partition_sched_domains_locked() can be reused
> without dropping the mutex lock.
> 
> No change of functionality is introduced by this patch.
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  include/linux/sched/topology.h | 10 ++++++++++
>  kernel/sched/topology.c        | 18 ++++++++++++++----
>  2 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
> index 26347741ba50..57997caf61b6 100644
> --- a/include/linux/sched/topology.h
> +++ b/include/linux/sched/topology.h
> @@ -162,6 +162,10 @@ static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
>  	return to_cpumask(sd->span);
>  }
>  
> +extern void partition_sched_domains_locked(int ndoms_new,
> +					   cpumask_var_t doms_new[],
> +					   struct sched_domain_attr *dattr_new);
> +
>  extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
>  				    struct sched_domain_attr *dattr_new);
>  
> @@ -206,6 +210,12 @@ extern void set_sched_topology(struct sched_domain_topology_level *tl);
>  
>  struct sched_domain_attr;
>  
> +static inline void
> +partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new[],
> +			       struct sched_domain_attr *dattr_new)
> +{
> +}
> +
>  static inline void
>  partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
>  			struct sched_domain_attr *dattr_new)
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 96eee22fafe8..25a5727d3b48 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -1850,16 +1850,16 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
>   * ndoms_new == 0 is a special case for destroying existing domains,
>   * and it will not create the default domain.
>   *
> - * Call with hotplug lock held
> + * Call with hotplug lock and sched_domains_mutex held
>   */
> -void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
> -			     struct sched_domain_attr *dattr_new)
> +void partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new[],
> +				    struct sched_domain_attr *dattr_new)
>  {
>  	int i, j, n;
>  	int new_topology;
>  
>  	lockdep_assert_cpus_held();
> -	mutex_lock(&sched_domains_mutex);
> +	lockdep_assert_held(&sched_domains_mutex);
>  
>  	/* Always unregister in case we don't destroy any domains: */
>  	unregister_sched_domain_sysctl();
> @@ -1924,6 +1924,16 @@ void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
>  	ndoms_cur = ndoms_new;
>  
>  	register_sched_domain_sysctl();
> +}
>  
> +/*
> + * Call with hotplug lock held
> + */
> +void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
> +			     struct sched_domain_attr *dattr_new)
> +{
> +	lockdep_assert_cpus_held();

Is the above assert really necessary? The assert will happen in
partition_sched_domains_locked() anyway.

-- Steve

> +	mutex_lock(&sched_domains_mutex);
> +	partition_sched_domains_locked(ndoms_new, doms_new, dattr_new);
>  	mutex_unlock(&sched_domains_mutex);
>  }

