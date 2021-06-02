From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/6] sched,perf,kvm: Fix preemption condition
Date: Wed, 2 Jun 2021 16:10:29 +0200
Message-ID: <YLeRVQbXt2hCiO8f@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.398289363@infradead.org>
 <1873020549.5854.1622642347895.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Sziljs0Kulfo1/57Liy6kTpQt/mrzjVM95lhyl4pzA4=; b=di9dQnw7YWomw7sRDOsQo7PUMD
        TJInYkPIDn+/QK90Sos0c8Rezc7X8ImBRnaDqxkesZTzU3zBWgy4G6U4xXqLz09/hpYATAA8slRuH
        z5QgLBkbaBJf/nxSrsbFRF31HH3ARg56XBhL22G9hLm1sHL0quLpRuKbqF/t2jaxsG2aoKnSpz0J6
        JwRCyVRR/4oZYywGxUDYGOan1B+cIaFO1YcfQl0rAlpcHTiWKkj2/IJRMvkKXL0znHPsw7bjE4bnM
        9Z7WPFFotrWHc/x+VwwKdH54p9rhGCj4A2ocBzrxy0h4dJrMU7v/Kb9Xu0TyOL8TyMumyZPfiWVKG
        NNissGXA==;
Content-Disposition: inline
In-Reply-To: <1873020549.5854.1622642347895.JavaMail.zimbra@efficios.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, bristot <bristot@redhat.com>, Borislav Petkov <bp@alien8.de>, x86 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Zefan Li <liz>

On Wed, Jun 02, 2021 at 09:59:07AM -0400, Mathieu Desnoyers wrote:
> ----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:
> 
> > When ran from the sched-out path (preempt_notifier or perf_event),
> > p->state is irrelevant to determine preemption. You can get preempted
> > with !task_is_running() just fine.
> > 
> > The right indicator for preemption is if the task is still on the
> > runqueue in the sched-out path.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> > kernel/events/core.c |    7 +++----
> > virt/kvm/kvm_main.c  |    2 +-
> > 2 files changed, 4 insertions(+), 5 deletions(-)
> > 
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -8568,13 +8568,12 @@ static void perf_event_switch(struct tas
> > 		},
> > 	};
> > 
> > -	if (!sched_in && task->state == TASK_RUNNING)
> > +	if (!sched_in && current->on_rq) {
> 
> This changes from checking task->state to current->on_rq, but this change
> from "task" to "current" is not described in the commit message, which is odd.
> 
> Are we really sure that task == current here ?

Yeah, @task == @prev == current at this point, but yes, not sure why I
changed that... lemme change that back to task.
