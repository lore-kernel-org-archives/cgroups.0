From: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2] sched/cpuset: distribute tasks within affinity masks
Date: Fri, 20 Mar 2020 11:28:26 +0000
Message-ID: <20200320112825.gn5glqsy6uebxp3w@e107158-lin.cambridge.arm.com>
References: <20200311010113.136465-1-joshdon@google.com>
 <20200311140533.pclgecwhbpqzyrks@e107158-lin.cambridge.arm.com>
 <20200317192401.GE20713@hirez.programming.kicks-ass.net>
 <CABk29NuAYvkqNmZZ6cjZBC6=hv--2siPPjZG-BUpNewxm02O6A@mail.gmail.com>
 <20200318113456.3h64jpyb6xiczhcj@e107158-lin.cambridge.arm.com>
 <CABk29NvvJCYyEnEkDt4JgZacf6XLd+0wxx_BNGnX8oZcrBp4EA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CABk29NvvJCYyEnEkDt4JgZacf6XLd+0wxx_BNGnX8oZcrBp4EA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 03/19/20 15:45, Josh Don wrote:
> On Wed, Mar 18, 2020 at 4:35 AM Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org> wrote:
> >
> > On 03/17/20 14:35, Josh Don wrote:
> > > On Wed, Mar 11, 2020 at 7:05 AM Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org> wrote:
> > > >
> > > > It might be a good idea to split the API from the user too.
> > >
> > > Not sure what you mean by this, could you clarify?
> >
> > I meant it'd be a good idea to split the cpumask API into its own patch and
> > have a separate patch for the user in sched/core.c. But that was a small nit.
> > If the user (in sched/core.c) somehow introduces a regression, reverting it
> > separately should be trivial.
> >
> > Thanks
> 
> Ah, yes I agree that sounds like a good idea, I can do that.
> 
> Peter, any other nit before I re-send?

AFAICT it was already picked up, so no need to resend to fix the nits from my
side.
