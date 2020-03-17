From: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] sched/cpuset: distribute tasks within affinity masks
Date: Tue, 17 Mar 2020 14:35:32 -0700
Message-ID: <CABk29NuAYvkqNmZZ6cjZBC6=hv--2siPPjZG-BUpNewxm02O6A@mail.gmail.com>
References: <20200311010113.136465-1-joshdon@google.com> <20200311140533.pclgecwhbpqzyrks@e107158-lin.cambridge.arm.com>
 <20200317192401.GE20713@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ftj10VLsYaiA6T3F2kq6t1b/UKFGKg8xJC5CD9CHAZg=;
        b=S2s7zvMjdQS2YL59qrGpnLepk5Dx85cXsRT8C8oanXXydslCXFue7WW16zAr2sbNWt
         GS0Ow5CjYtZ0ItjiAm9xGPsgxXdFUCAJLI4+BU6pp066EycbGudGs8YJ9oGWz77drJfs
         L5qDqxz/TFwYKR1g0hglZEOej9vrYI3LtRPk6gSO+og/Du5tsULTG1eEzxNiuI57m0te
         B6Q4cTJ+swdm/VASYkZ9awnNV54Y/orFynKe+GXK/Gu5WMJElMCmGcSjBW0kxQ5hEHHh
         7lFSnHZBE7WwssCb/3Qtg++PwYrQe9HkJrDA9mL3+MwrF02zhjMZn8VqA97fPiEtH+IZ
         Gagg==
In-Reply-To: <20200317192401.GE20713-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Mar 11, 2020 at 7:05 AM Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org> wrote:
>
> This actually helps me fix a similar problem I faced in RT [1]. If multiple RT
> tasks wakeup at the same time we get a 'thundering herd' issue where they all
> end up going to the same CPU, just to be pushed out again.
>
> Beside this will help fix another problem for RT tasks fitness, which is
> a manifestation of the problem above. If two tasks wake up at the same time and
> they happen to run on a little cpu (but request to run on a big one), one of
> them will end up being migrated because find_lowest_rq() will return the first
> cpu in the mask for both tasks.
>
> I tested the API (not the change in sched/core.c) and it looks good to me.

Nice, glad that the API already has another use case. Thanks for taking a look.

> nit: cpumask_first_and() is better here?

Yea, I would also prefer to use it, but the definition of
cpumask_first_and() follows this section, as it itself uses
cpumask_next_and().

> It might be a good idea to split the API from the user too.

Not sure what you mean by this, could you clarify?

On Tue, Mar 17, 2020 at 12:24 PM Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> > Anyway, for the API.
> >
> > Reviewed-by: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
> > Tested-by: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
>
> Thanks guys!

Thanks Peter, any other comments or are you happy with merging this patch as-is?
