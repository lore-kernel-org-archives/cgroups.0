From: Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH v2] sched/fair: Correctly insert cfs_rq's to list on unthrottle
Date: Thu, 3 Jun 2021 15:40:51 +0200
Message-ID: <CAKfTPtDLiN2GXxPG9AhxAihx++jV+W6VeBRdYgVwNmb8RiTkhQ@mail.gmail.com>
References: <20210603113847.163512-1-odin@uged.al> <CAKfTPtAK3gEqChUmoUXo7KLqPAFo=shH4Yi=QLjrwpuu6Ow6-Q@mail.gmail.com>
 <CAFpoUr2HBexs5784nU7hyDSs0eNiEut=-4wWcnpMtSVtFeaLLA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QTp3vmqt4JhYvd2bJK89SITP9H+81cHGdf+Hvc3N0js=;
        b=P11xYanSpOJL2lIsQLEOdAs2S9eaHOU+2Q8yfObrnHB2QY+uzvNxFgmOhSf+U/tstY
         EOoJOft+DZa62Leh4t2CadOV/3k0dCoZ5uC0zW9Rf+uKfklUQ7a3EksL2fSgKLD2fMzj
         ajD3i6vU5D5YjO0fXoUAe8CRf1yde12OZlMBd2rVUNnI0MeYYuUYRTAMRcY4Yv2iioTG
         1+Wz/j3lyFM3WYEuVil/ZCMcFXoJw1/yo28xa++blIVd8hZxHGpuIIKuwuzPXOn7x0gy
         PQtKZImXzjXP50mbDUXG36+PCuIy9/jg6x2FBouv8gs1/gXbWQuo6uYNkvG3DP00K9hL
         xdwA==
In-Reply-To: <CAFpoUr2HBexs5784nU7hyDSs0eNiEut=-4wWcnpMtSVtFeaLLA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin@uged.al>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, 3 Jun 2021 at 15:13, Odin Ugedal <odin@uged.al> wrote:
>
> Hi,
>
> > Out of curiosity, why did you decide to use
> > cfs_rq->tg_load_avg_contrib instead of !cfs_rq_is_decayed(cfs_rq)
> > which is used to delete the cfs_rq from the list when updating blocked
> > load ?
>
> Well, the main reason was that it is currently (without the other in
> flight patches) not safe to just use "cfs_rq_is_decayed" directly,
> since that could result in
> a situation where tg_load_avg_contrib!=0 while
> cfs_rq_is_decayed()==true. I guess we can use cfs_rq_is_decayed() if
> you prefer that,
> and all the other PELT patches are merged. (This was initially why I
> thought a new field was a simpler and more elegant solution to make
> sure we book-keep correctly,
> but when the PELT stuff is fixed properly, that should be no real
> issue as long it works as we expect).

If it's only a matter of waiting other PELT patches to be merged, we
should use cfs_rq_is_decayed().

cfs_rq->tg_load_avg_contrib is used to reduce contention on
tg->load_avg but it is outside the scope of PELT and the update of
blocked load so we should avoid using it there

>
> I was also thinking about the cfs_rq->nr_running part; is there a
> chance of a situation where a cfs_rq->nr_running==1 and it has no
> load, resulting in it being decayed and
> removed from the list in "__update_blocked_fair"? I have not looked
> properly at it, but just wondering if that is actually possible..
>
>
> Also, out of curiosity, are there some implications of a situation
> where tg_load_avg_contrib=0 while *_load!=0, or would that not cause

do you mean all cfs_rq->avg.load_avg with *_load ?

> fairness issues?

if load_avg!=0, we will update it periodically and sync
tg_load_avg_contrib with the former. So it's not a problem.

The other way was a problem because we stop updating load_avg and
tg_load_avg_contrib when load_avg/load_sum is null so the
tg_load_avg_contrib is stalled with a possibly very old value


>
> Thanks
> Odin
