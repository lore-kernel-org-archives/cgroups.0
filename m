From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and IO
Date: Wed, 6 Jun 2018 17:46:26 -0700
Message-ID: <CAJuCfpHAqYZN++CSEMa3fd00ZBB-2Lxu5QW2b_kccrWrRzD+7w@mail.gmail.com>
References: <20180507210135.1823-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=b5jR4waz0kJTh2Dr0wl4gGj/NkC95TTbHHWtCGqHHlw=;
        b=ilpLBmi1KtyhIKLJ5wMzndh+2ZC5FOhjEY5ilXJGq1/wzpWsDtDPP9pSDJcGui2GQa
         B/CeA5yaOgwySQRQJ3P/jD+vWUSwjFU3P5elPMNan0i/ozUzseFbf7o7JwRknJg+nlVe
         IN/LweTSXuiS1wG3SON1iJYQgcqIwZerwRAyZOnXtV0miX568SG+nyMMXWUdgRxWlmt2
         IcgCACeOcWAbkMG+lhhYGOAfFDaKwujmBlkPBpyBy21gkxx48Kc71gq9/YdErtOczb6g
         +6ZHV+4YijbTuTjxpBff5TwYK2GqgrMsM5v+/joRx8wmumXU+va/nhRMWtYDTPtsz/K7
         oZvw==
In-Reply-To: <20180507210135.1823-7-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

Hi Johannes,


On Mon, May 7, 2018 at 2:01 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> +static void psi_clock(struct work_struct *work)
> +{
> +       u64 some[NR_PSI_RESOURCES] = { 0, };
> +       u64 full[NR_PSI_RESOURCES] = { 0, };
> +       unsigned long nonidle_total = 0;
> +       unsigned long missed_periods;
> +       struct delayed_work *dwork;
> +       struct psi_group *group;
> +       unsigned long expires;
> +       int cpu;
> +       int r;
> +
> +       dwork = to_delayed_work(work);
> +       group = container_of(dwork, struct psi_group, clock_work);
> +
> +       /*
> +        * Calculate the sampling period. The clock might have been
> +        * stopped for a while.
> +        */
> +       expires = group->period_expires;
> +       missed_periods = (jiffies - expires) / MY_LOAD_FREQ;
> +       group->period_expires = expires + ((1 + missed_periods) * MY_LOAD_FREQ);
> +
> +       /*
> +        * Aggregate the per-cpu state into a global state. Each CPU
> +        * is weighted by its non-idle time in the sampling period.
> +        */

Would it be possible to move this aggregation code (excluding
calc_avgs()) into a separate function which is called from here as
well as from psi_show() before group->some[] and group->full[] are
reported? This would not affect the performance if the information is
not requested and at the same time would keep at least the "total"
field up-to-date when the data is requested. For calc_avgs() I think
we would have to calculate the change in nonidle_total, group->some[]
and group->full[] fields differently because a call to psi_show() in
the middle of two psi_clock() calls would refresh these fields before
2secs expire, however calculating that change is trivial if we store
previous group->some[], group->full[] and nonidle_total values inside
psi_clock(). This would require new fields in psi_group struct to
store these previous values but the upside is that we would eliminate
the problem with reporting potentially stale data (up to 2sec update
delay) and provide a function one can use to refresh group->some[] and
group->full[] and implement custom averaging.

> +       for_each_online_cpu(cpu) {
> +               struct psi_group_cpu *groupc = per_cpu_ptr(group->cpus, cpu);
> +               unsigned long nonidle;
> +
> +               nonidle = nsecs_to_jiffies(groupc->nonidle_time);
> +               groupc->nonidle_time = 0;
> +               nonidle_total += nonidle;
> +
> +               for (r = 0; r < NR_PSI_RESOURCES; r++) {
> +                       struct psi_resource *res = &groupc->res[r];
> +
> +                       some[r] += (res->times[0] + res->times[1]) * nonidle;
> +                       full[r] += res->times[1] * nonidle;
> +
> +                       /* It's racy, but we can tolerate some error */
> +                       res->times[0] = 0;
> +                       res->times[1] = 0;
> +               }
> +       }
> +
> +       for (r = 0; r < NR_PSI_RESOURCES; r++) {
> +               /* Finish the weighted aggregation */
> +               some[r] /= max(nonidle_total, 1UL);
> +               full[r] /= max(nonidle_total, 1UL);
> +
> +               /* Accumulate stall time */
> +               group->some[r] += some[r];
> +               group->full[r] += full[r];
> +
> +               /* Calculate recent pressure averages */
> +               calc_avgs(group->avg_some[r], some[r], missed_periods);
> +               calc_avgs(group->avg_full[r], full[r], missed_periods);
> +       }
> +
> +       /* Keep the clock ticking only when there is action */
> +       if (nonidle_total)
> +               schedule_delayed_work(dwork, MY_LOAD_FREQ);
> +}
> +

Thanks,
Suren.
