From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 4/6] psi: introduce state_mask to represent stalled psi states
Date: Mon, 17 Dec 2018 17:14:53 -0800
Message-ID: <CAJuCfpHrQB7OtEC535=s4iJqwan17nAc-mbycV1aJ3RUQTWCPA@mail.gmail.com>
References: <20181214171508.7791-1-surenb@google.com> <20181214171508.7791-5-surenb@google.com>
 <20181217155525.GC2218@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MtV8grmjLA0rwx3YhGhQj1UX/LL1RwYw0cDYDYDCZQ4=;
        b=HhtqGWhr4ELtOVTsQaCzl2jfH5UQSFbjJ7o0cQPu3tty6slMA5FrhcMyuWO1862TPC
         TovMgF0u9tuNUPWYSU3wBU+0sTAK7m7KKZ51S+rSpJNjy8Z5TEPt8HN2xJLke0aWMze2
         g6huHXJmZfpJgb82OUlb80GH6G72sXqfTLAkuFGOO8uML3Dw7NUlIwBiaAubDnk6GyiC
         RQxOzg3vvGHYzXPfDRWdgwrvpD3M3+HNrEUpI1oAKGR9FrpzlZ9mRzp4lf3qUM9Pij8v
         Uq/mmngb36fGkAijmpWMUx7rWM5WCXfaRx8ZyJokBUrz8Gt2kg+Fals6cH5C1wyK/Q4h
         qobQ==
In-Reply-To: <20181217155525.GC2218@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Mon, Dec 17, 2018 at 7:55 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Dec 14, 2018 at 09:15:06AM -0800, Suren Baghdasaryan wrote:
> > The psi monitoring patches will need to determine the same states as
> > record_times(). To avoid calculating them twice, maintain a state mask
> > that can be consulted cheaply. Do this in a separate patch to keep the
> > churn in the main feature patch at a minimum.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  include/linux/psi_types.h |  3 +++
> >  kernel/sched/psi.c        | 29 +++++++++++++++++++----------
> >  2 files changed, 22 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
> > index 2cf422db5d18..2c6e9b67b7eb 100644
> > --- a/include/linux/psi_types.h
> > +++ b/include/linux/psi_types.h
> > @@ -53,6 +53,9 @@ struct psi_group_cpu {
> >       /* States of the tasks belonging to this group */
> >       unsigned int tasks[NR_PSI_TASK_COUNTS];
> >
> > +     /* Aggregate pressure state derived from the tasks */
> > +     u32 state_mask;
> > +
> >       /* Period time sampling buckets for each state of interest (ns) */
> >       u32 times[NR_PSI_STATES];
> >
>
> Since we spend so much time counting space in that line, maybe add a
> note to the Changlog about how this fits.

Will do.

> Also, since I just had to re-count, you might want to add explicit
> numbers to the psi_res and psi_states enums.

Sounds reasonable.

> > +             if (state_mask & (1 << s))
>
> We have the BIT() macro, but I'm honestly not sure that will improve
> things.

I was mimicking the rest of the code in psi.c that uses this kind of
bit masking. Can change if you think that would be better.
