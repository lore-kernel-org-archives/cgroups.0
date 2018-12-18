From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 6/6] psi: introduce psi monitor
Date: Mon, 17 Dec 2018 17:22:35 -0800
Message-ID: <CAJuCfpFp7v4oc9LL0TVMiYavOMOvDs5y=kQ8S7URtKojkWmH7Q@mail.gmail.com>
References: <20181214171508.7791-1-surenb@google.com> <20181214171508.7791-7-surenb@google.com>
 <20181217162713.GE2218@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sFGWv6X8z3NwFialNaeSsACmFB5fqtUuW9oC4mugWj4=;
        b=l3yIC1z24v0r3Yyxrmq1CCmwuEpPGGLweeNlEXuGnjDG//zHj98KJs+aO07RlEWBJu
         EV91sC4cK59Ckg3Dws+kWuu4UFAIjAkw0VnO1ND8uINmrTH5BvLLqNQkhtg81i8LypjB
         KDXThdLTJoDH/kvvlzp/npeS4W63wz3InzwaXy2BIv83yINt9LwsktznaONO7pjFocSS
         TQAST/KPYuCDPGYTmFRXaJbnXYZ7CLeAwBnTCL1irL8YTL+7pPzVqT4t5Srl5QtOnK9R
         fyhyHFu7pmHzLq7eUhESXu5N88IaFh9VOF1AfVUmQ9waNF38I/Lne4mUwBs4lKQswV9j
         oloQ==
In-Reply-To: <20181217162713.GE2218@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Mon, Dec 17, 2018 at 8:37 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Dec 14, 2018 at 09:15:08AM -0800, Suren Baghdasaryan wrote:
> > @@ -358,28 +526,23 @@ static void psi_update_work(struct work_struct *work)
> >  {
> >       struct delayed_work *dwork;
> >       struct psi_group *group;
> > +     u64 next_update;
> >
> >       dwork = to_delayed_work(work);
> >       group = container_of(dwork, struct psi_group, clock_work);
> >
> >       /*
> > +      * Periodically fold the per-cpu times and feed samples
> > +      * into the running averages.
> >        */
> >
> > +     psi_update(group);
> >
> > +     /* Calculate closest update time */
> > +     next_update = min(group->polling_next_update,
> > +                             group->avg_next_update);
> > +     schedule_delayed_work(dwork, min(PSI_FREQ,
> > +             nsecs_to_jiffies(next_update - sched_clock()) + 1));
>
> See, so I don't at _all_ like how there is no idle option..

Copy that. Will see what we can do to bring it back.
Thanks!

> >  }
>
>
> --
> You received this message because you are subscribed to the Google Groups "kernel-team" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
