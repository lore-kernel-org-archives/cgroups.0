From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: Re: [PATCH v2] sched/fair: Correctly insert cfs_rq's to list on unthrottle
Date: Thu, 3 Jun 2021 15:12:35 +0200
Message-ID: <CAFpoUr2HBexs5784nU7hyDSs0eNiEut=-4wWcnpMtSVtFeaLLA@mail.gmail.com>
References: <20210603113847.163512-1-odin@uged.al> <CAKfTPtAK3gEqChUmoUXo7KLqPAFo=shH4Yi=QLjrwpuu6Ow6-Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CBnvtPJLdU3kbekuheh4qc6OMIUkdKF2nOgchdFq6rc=;
        b=YydysQuJcuB2zxLOLbU7aPah7Lb9RIs2OcRo39zEyZjr57DV83DYJnlesShXVJ/QiQ
         OE6cEKWBwFj9wQk7+c5zcnkWBG54Kkxqbl0M6gEgwbP9dS/rvWFPp4cub55w8/YvXPJ4
         ZFERiNBM+Cd4rd+RFXXpgR98D4/TL67NEbVKyJ7BLxl8fkqjOVGC9YvpCzEnyREsUAnS
         bf0nyIKcT8C8/5soIFtGyBGiTRiG2Xgvl7Y2a20N9wXoTizrqKcrnvflGNSAUbTT4s/8
         dL3l5XRaR6DQt5pW+i0CaDjUpMTGsww5MQnDP1M6A+xnZIp6AK3AxMIRKWCDgTRszgzh
         7H0Q==
In-Reply-To: <CAKfTPtAK3gEqChUmoUXo7KLqPAFo=shH4Yi=QLjrwpuu6Ow6-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

> Out of curiosity, why did you decide to use
> cfs_rq->tg_load_avg_contrib instead of !cfs_rq_is_decayed(cfs_rq)
> which is used to delete the cfs_rq from the list when updating blocked
> load ?

Well, the main reason was that it is currently (without the other in
flight patches) not safe to just use "cfs_rq_is_decayed" directly,
since that could result in
a situation where tg_load_avg_contrib!=0 while
cfs_rq_is_decayed()==true. I guess we can use cfs_rq_is_decayed() if
you prefer that,
and all the other PELT patches are merged. (This was initially why I
thought a new field was a simpler and more elegant solution to make
sure we book-keep correctly,
but when the PELT stuff is fixed properly, that should be no real
issue as long it works as we expect).

I was also thinking about the cfs_rq->nr_running part; is there a
chance of a situation where a cfs_rq->nr_running==1 and it has no
load, resulting in it being decayed and
removed from the list in "__update_blocked_fair"? I have not looked
properly at it, but just wondering if that is actually possible..


Also, out of curiosity, are there some implications of a situation
where tg_load_avg_contrib=0 while *_load!=0, or would that not cause
fairness issues?

Thanks
Odin
