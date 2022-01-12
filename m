From: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] sched/core: Forced idle accounting per-cpu
Date: Tue, 11 Jan 2022 17:59:22 -0800
Message-ID: <CABk29NtonxXS53J-+3w_GTLTVurf8HS4v35T9evoGyERB0uDqA@mail.gmail.com>
References: <1641894961-9241-1-git-send-email-CruzZhao@linux.alibaba.com> <1641894961-9241-3-git-send-email-CruzZhao@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cVxEczww7H9SKUQS4bM3hqv/i/BHfSqFjaglAC6lVKQ=;
        b=Ts2boQ0OQ6dUg+Q1bgi1eRic89TubkUE0VQ2NPiyhgnU3O0OzuHrNsR/aYTnxham6j
         QkFUVZHsgmjs/3IJLRiePUPt2SyMyFnLJAjc+jITIcvu+aD44BkdZK20a5pA5ojpVZjz
         aOvkgkwHgYrqe31l/rstBihzrSuX6cCEeJOTCrj9q4I/BeqQFvPfpTlLSoJoJmqH6J3V
         yuAgSyr6Z0SbVWOFs00A9/fwH4X5uc6aBbvOAdytDX6Tn7l/PeZz0eXeYkvh9LgU2UoE
         lWPQDZt03th6mEf0Qj5U2yfEOk7ebdD/9B8nEoucVNGOBtU98dqeVrDKcGwN/HY+e6yu
         CB8A==
In-Reply-To: <1641894961-9241-3-git-send-email-CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cruz Zhao <CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jan 11, 2022 at 1:56 AM Cruz Zhao <CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
> Accounting for "forced idle" time per cpu, which is the time a cpu is
> forced to idle by its SMT sibling.
>
> As it's not accurate to measure the capacity loss only by cookie'd forced
> idle time, and it's hard to trace the forced idle time caused by all the
> uncookie'd tasks, we account the forced idle time from the perspective of
> the cpu.
>
> Forced idle time per cpu is displayed via /proc/schedstat, we can get the
> forced idle time of cpu x from the 10th column of the row for cpu x. The
> unit is ns. It also requires that schedstats is enabled.
>
> Signed-off-by: Cruz Zhao <CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---

Two quick followup questions:

1) From your v1, I still wasn't quite sure if the per-cpu time was
useful or not for you versus a single overall sum (ie. I think other
metrics could be more useful for analyzing steal_cookie if that's what
you're specifically interested in). Do you definitely want the per-cpu
totals?

2) If your cgroup accounting patch is merged, do you still want this
patch? You can grab the global values from the root cgroup (assuming
you have cgroups enabled). The only potential gap is if you need
per-cpu totals, though I'm working to add percpu stats to cgroup-v2:
https://lkml.kernel.org/r/%3C20220107234138.1765668-1-joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org%3E
