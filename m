From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: Re: [PATCH 0/2] schd/fair: fix stalled cfs_rq->tg_load_avg_contrib
Date: Thu, 27 May 2021 16:24:24 +0200
Message-ID: <CAFpoUr0FrSV5VO40q7pbnqiiqCYbgS_YUp1Kktfn6YgOgh8whw@mail.gmail.com>
References: <20210527122916.27683-1-vincent.guittot@linaro.org> <CAKfTPtAK2fkzhzKA8iFT8cEcCG6Q=8WfLskPYADvTrQ=nF7kDA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D5ioh6/kmyR43pZvyyWx3jgh3NQ4aOfCzd/5djtqWu8=;
        b=uk1Clutn08ap0T0eYiCfBLwIre/sRgapht3WRTSb/OUz86VJK5yz1vBTHMxu/U6zTM
         YqtL/akei9DOsGUBMzxBwyWrksY5LQriwy+lYebt/K15XJVyvstz+BQ4izwCBbA6v85u
         o4N5jnOcO+4jk7cB4+k84aVnCN6+qkks38BBc6HPuA4f+UriPgZNqQ6oGHQjjiZ//4MT
         ypgXJjp0y+y2zzRQ1awvIiR+TVc3zxChipuUFY5u4wShlpQGC3K14lDxFs6rxWxxPufK
         h3L2wVOWANe9dPni62OaXYZV95+oNGkyNDclB4aLoBToQnycLzpEg9WfiXSx3Tlz4MtX
         jHjQ==
In-Reply-To: <CAKfTPtAK2fkzhzKA8iFT8cEcCG6Q=8WfLskPYADvTrQ=nF7kDA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

Yes, this does the trick!

I have tested this locally and it works as expected, as discussed in
the previous thread (more info there). Together with the patch "[PATCH
2/3] sched/fair: Correctly insert cfs_rq's to list on unthrottle", I
am unable to reproduce the issue locally; so this is good to go.

Feel free to add this to both patches when the warnings on the first
patch are fixed;

Reviewed-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>

Thanks
Odin
