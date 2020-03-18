From: Qais Yousef <qais.yousef@arm.com>
Subject: Re: [PATCH v2] sched/cpuset: distribute tasks within affinity masks
Date: Wed, 18 Mar 2020 11:34:56 +0000
Message-ID: <20200318113456.3h64jpyb6xiczhcj@e107158-lin.cambridge.arm.com>
References: <20200311010113.136465-1-joshdon@google.com>
 <20200311140533.pclgecwhbpqzyrks@e107158-lin.cambridge.arm.com>
 <20200317192401.GE20713@hirez.programming.kicks-ass.net>
 <CABk29NuAYvkqNmZZ6cjZBC6=hv--2siPPjZG-BUpNewxm02O6A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CABk29NuAYvkqNmZZ6cjZBC6=hv--2siPPjZG-BUpNewxm02O6A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josh Don <joshdon@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Paul Turner <pjt@google.com>

On 03/17/20 14:35, Josh Don wrote:
> On Wed, Mar 11, 2020 at 7:05 AM Qais Yousef <qais.yousef@arm.com> wrote:
> >
> > This actually helps me fix a similar problem I faced in RT [1]. If multiple RT
> > tasks wakeup at the same time we get a 'thundering herd' issue where they all
> > end up going to the same CPU, just to be pushed out again.
> >
> > Beside this will help fix another problem for RT tasks fitness, which is
> > a manifestation of the problem above. If two tasks wake up at the same time and
> > they happen to run on a little cpu (but request to run on a big one), one of
> > them will end up being migrated because find_lowest_rq() will return the first
> > cpu in the mask for both tasks.
> >
> > I tested the API (not the change in sched/core.c) and it looks good to me.
> 
> Nice, glad that the API already has another use case. Thanks for taking a look.
> 
> > nit: cpumask_first_and() is better here?
> 
> Yea, I would also prefer to use it, but the definition of
> cpumask_first_and() follows this section, as it itself uses
> cpumask_next_and().
> 
> > It might be a good idea to split the API from the user too.
> 
> Not sure what you mean by this, could you clarify?

I meant it'd be a good idea to split the cpumask API into its own patch and
have a separate patch for the user in sched/core.c. But that was a small nit.
If the user (in sched/core.c) somehow introduces a regression, reverting it
separately should be trivial.

Thanks

--
Qais Yousef

> 
> On Tue, Mar 17, 2020 at 12:24 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > > Anyway, for the API.
> > >
> > > Reviewed-by: Qais Yousef <qais.yousef@arm.com>
> > > Tested-by: Qais Yousef <qais.yousef@arm.com>
> >
> > Thanks guys!
> 
> Thanks Peter, any other comments or are you happy with merging this patch as-is?
