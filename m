From: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] sched/cpuset: distribute tasks within affinity masks
Date: Thu, 19 Mar 2020 15:45:47 -0700
Message-ID: <CABk29NvvJCYyEnEkDt4JgZacf6XLd+0wxx_BNGnX8oZcrBp4EA@mail.gmail.com>
References: <20200311010113.136465-1-joshdon@google.com> <20200311140533.pclgecwhbpqzyrks@e107158-lin.cambridge.arm.com>
 <20200317192401.GE20713@hirez.programming.kicks-ass.net> <CABk29NuAYvkqNmZZ6cjZBC6=hv--2siPPjZG-BUpNewxm02O6A@mail.gmail.com>
 <20200318113456.3h64jpyb6xiczhcj@e107158-lin.cambridge.arm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hg6/XErwieCbKEfwaK23H7KvFdhoOokx+O1ndfHjdpU=;
        b=K35Xul1BPwATBVYVGK1BzNwg1AfbzIoEMcMIYFIqZpTfU1JbG3He3l99NhGYwgWPbs
         u+xfPnUrH81APCqnVXY50nhKQe+ibkMS6ecDck1xrFL/vkqdoUZAXjGM5K5s03HW0Aoa
         AV5WoC6OrOCmXVwZewxhhuhbjcgCsDJIrX+EQ2xk5snNqTolW+uP+GRkYkobmARhQsUa
         MX6rxQVC9wEFCyXiEKPNjK2a/ofXMo0ny2KPnalzfVm81aV/W8CND2olyxDgGBeJd/jw
         dD3iSNij3AxA+/LNEFdtOU91evmTLVH+cdGxvLXoCkeAy4wDv4TFfwKjhecSF6aMb0Wb
         kvJg==
In-Reply-To: <20200318113456.3h64jpyb6xiczhcj-AIE2tiYzwxrZROr8t4l/smS4ubULX0JqMm0uRHvK7Nw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Mar 18, 2020 at 4:35 AM Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org> wrote:
>
> On 03/17/20 14:35, Josh Don wrote:
> > On Wed, Mar 11, 2020 at 7:05 AM Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org> wrote:
> > >
> > > It might be a good idea to split the API from the user too.
> >
> > Not sure what you mean by this, could you clarify?
>
> I meant it'd be a good idea to split the cpumask API into its own patch and
> have a separate patch for the user in sched/core.c. But that was a small nit.
> If the user (in sched/core.c) somehow introduces a regression, reverting it
> separately should be trivial.
>
> Thanks

Ah, yes I agree that sounds like a good idea, I can do that.

Peter, any other nit before I re-send?
