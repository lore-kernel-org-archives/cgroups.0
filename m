From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 3/6] sched,perf,kvm: Fix preemption condition
Date: Wed, 2 Jun 2021 15:30:16 +0100
Message-ID: <20210602143016.GE12753@C02TD0UTHF1T.local>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.398289363@infradead.org>
 <1873020549.5854.1622642347895.JavaMail.zimbra@efficios.com>
 <YLeRVQbXt2hCiO8f@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YLeRVQbXt2hCiO8f-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, bristot <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNP/PtFMR13I2A@public.gmane.org>

On Wed, Jun 02, 2021 at 04:10:29PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 02, 2021 at 09:59:07AM -0400, Mathieu Desnoyers wrote:
> > ----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
> > 
> > > When ran from the sched-out path (preempt_notifier or perf_event),
> > > p->state is irrelevant to determine preemption. You can get preempted
> > > with !task_is_running() just fine.
> > > 
> > > The right indicator for preemption is if the task is still on the
> > > runqueue in the sched-out path.
> > > 
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > > ---
> > > kernel/events/core.c |    7 +++----
> > > virt/kvm/kvm_main.c  |    2 +-
> > > 2 files changed, 4 insertions(+), 5 deletions(-)
> > > 
> > > --- a/kernel/events/core.c
> > > +++ b/kernel/events/core.c
> > > @@ -8568,13 +8568,12 @@ static void perf_event_switch(struct tas
> > > 		},
> > > 	};
> > > 
> > > -	if (!sched_in && task->state == TASK_RUNNING)
> > > +	if (!sched_in && current->on_rq) {
> > 
> > This changes from checking task->state to current->on_rq, but this change
> > from "task" to "current" is not described in the commit message, which is odd.
> > 
> > Are we really sure that task == current here ?
> 
> Yeah, @task == @prev == current at this point, but yes, not sure why I
> changed that... lemme change that back to task.

FWIW, with that:

Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

I have no strong feelings either way w.r.t. the whitespace cleanup. ;)

Thanks,
Mark
