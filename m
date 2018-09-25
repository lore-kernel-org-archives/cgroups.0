From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v5 5/5] cpuset: Rebuild root domain deadline accounting
 information
Date: Tue, 25 Sep 2018 15:07:50 +0200
Message-ID: <20180925130750.GA25664@localhost.localdomain>
References: <20180903142801.20046-1-juri.lelli@redhat.com>
 <20180903142801.20046-6-juri.lelli@redhat.com>
 <20180925123222.GA29985@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180925123222.GA29985@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 25/09/18 14:32, Peter Zijlstra wrote:
> On Mon, Sep 03, 2018 at 04:28:01PM +0200, Juri Lelli wrote:
> > +/*
> > + * Called with cpuset_mutex held (rebuild_sched_domains())
> > + * Called with hotplug lock held (rebuild_sched_domains_locked())
> > + * Called with sched_domains_mutex held (partition_and_rebuild_domains())
> 
> Isn't that what we have lockdep_assert_held() for?

Indeed. I can put three of them inside the function, even though we have
a single path to here atm. Guess makes sense to protect any future change.

> > + */
> > +static void rebuild_root_domains(void)
> > +{
> > +	struct cpuset *cs = NULL;
> > +	struct cgroup_subsys_state *pos_css;
> > +
> > +	rcu_read_lock();
> > +
> > +	/*
> > +	 * Clear default root domain DL accounting, it will be computed again
> > +	 * if a task belongs to it.
> > +	 */
> > +	dl_clear_root_domain(&def_root_domain);
> > +
> > +	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
> > +
> > +		if (cpumask_empty(cs->effective_cpus)) {
> > +			pos_css = css_rightmost_descendant(pos_css);
> > +			continue;
> > +		}
> > +
> > +		css_get(&cs->css);
> > +
> > +		rcu_read_unlock();
> 
> That looks really dodgy, but I suppose the comment near
> css_next_descendant_pre() spells out that this is in fact OK.

Plus update_cpumasks_hier() seems to do something similar. Maybe I
should switch to use css_tryget_online() as well?

Thanks,

- Juri
