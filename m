From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v5 5/5] cpuset: Rebuild root domain deadline accounting
 information
Date: Tue, 25 Sep 2018 15:08:24 +0200
Message-ID: <20180925130824.GB25664@localhost.localdomain>
References: <20180903142801.20046-1-juri.lelli@redhat.com>
 <20180903142801.20046-6-juri.lelli@redhat.com>
 <20180925125359.GB29985@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180925125359.GB29985@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 25/09/18 14:53, Peter Zijlstra wrote:
> On Mon, Sep 03, 2018 at 04:28:01PM +0200, Juri Lelli wrote:
> > diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> > index fb7ae691cb82..08128bdf3944 100644
> > --- a/kernel/sched/topology.c
> > +++ b/kernel/sched/topology.c
> > @@ -1883,8 +1883,19 @@ void partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new[],
> >  	for (i = 0; i < ndoms_cur; i++) {
> >  		for (j = 0; j < n && !new_topology; j++) {
> >  			if (cpumask_equal(doms_cur[i], doms_new[j])
> > -			    && dattrs_equal(dattr_cur, i, dattr_new, j))
> > +			    && dattrs_equal(dattr_cur, i, dattr_new, j)) {
> 
> While there, please also fix that wrongly placed operator.

Sure.

Thanks,

- Juri
