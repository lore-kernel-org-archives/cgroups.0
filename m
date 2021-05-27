From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] sched/fair: keep load_avg and load_sum synced
Date: Thu, 27 May 2021 15:37:13 +0200
Message-ID: <YK+giS1pPECFZ+oU@hirez.programming.kicks-ass.net>
References: <20210527122916.27683-1-vincent.guittot@linaro.org>
 <20210527122916.27683-2-vincent.guittot@linaro.org>
 <YK+ZGlfPxK3JCySS@hirez.programming.kicks-ass.net>
 <CAKfTPtAE6DJTwxZ996BJoUJF++fFHdFk-C2bpUQ8aG0NQusApA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3bZ/LkqfBhJhawvK2heoarmGy4iJoc0yGvgh3vim5Nw=; b=FXZPg1F1fbulTYZ8znR1bssXMq
        dpYlRBnqpR0h7cS53Eg4LcmPAxiBL0BOOdoZR/Hiz5bBrsw29gzEadYLNwOSCoQPG8YcANlxcrASc
        OFmr82sMAAgEpMhlknstrfPqaci2qAi5oUPrA1wihuDgPJ0G2R2qWVwM954Rp6XhPgDQG4mLWqCZI
        sXKtxYdumvMRJcrDKkwKdI/kmbsx74dh9A61k2k1jILx4aTbhC8cBcqNgkAcB9M8bZhqlS6rBsL4q
        ZsQHBgz22fMF0GzFwpiHnPniApiedCiKYQFR7kAeM8PBYnO3NMEaHyC4wv0YeRm4d3S8IVSLoGHp3
        13FhhmAA==;
Content-Disposition: inline
In-Reply-To: <CAKfTPtAE6DJTwxZ996BJoUJF++fFHdFk-C2bpUQ8aG0NQusApA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, May 27, 2021 at 03:18:35PM +0200, Vincent Guittot wrote:
> > -       delta_sum = load_sum - (s64)se_weight(se) * se->avg.load_sum;
> > -       delta_avg = load_avg - se->avg.load_avg;
> > -
> >         se->avg.load_sum = runnable_sum;
> >         se->avg.load_avg = load_avg;
> > -       add_positive(&cfs_rq->avg.load_avg, delta_avg);
> > -       add_positive(&cfs_rq->avg.load_sum, delta_sum);
> > +
> > +       add_positive(&cfs_rq->avg.load_avg, (long)(load_avg - se->avg.load_avg));
> 
> you have to keep:
> delta_avg = load_avg - se->avg.load_avg
> or move se->avg.load_avg = load_avg after
> add_positive(&cfs_rq->avg.load_avg, ..);
> because otherwise (load_avg - se->avg.load_avg) == 0

Duh. /me goes fix.
