From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] schd/fair: fix stalled cfs_rq->tg_load_avg_contrib
Date: Thu, 27 May 2021 16:19:08 +0200
Message-ID: <CAKfTPtAK2fkzhzKA8iFT8cEcCG6Q=8WfLskPYADvTrQ=nF7kDA@mail.gmail.com>
References: <20210527122916.27683-1-vincent.guittot@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=LatqtaP/aGx6woxQl/xZuLro5ci8AMLtHb6rQktXh24=;
        b=M7YJUkv0b9ZqkYCDwgcBFIcG5MN4CKndmPnWQdY2RJQHhZFVfdRUJHVRnhKAumFP7L
         xB0gbKrxCsAVajM8z2yvoA1bc7kvVBybZX48Htc446q/1kNtqtm5hoaVse9MYQh660Wv
         E56HXbe9YBGsOWvDV03VnedvUY8Mat1bdqAGkqtC0LuSynuSgH8hjijzLj+Xy6bhjsK/
         5u/9h3epeiMaAH7QNiIm4MIhBuom/9p5Fw+VhVhcAg3mg0GxMNmAPhNCio3HOiAC+6U5
         oM94F79Pvp3i6mfXvE8WGMbW0XSv7cApEYZHQ4BeedsDydhMkYNurUGs9FfJ6NnDhxvv
         QHOQ==
In-Reply-To: <20210527122916.27683-1-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Odin,

On Thu, 27 May 2021 at 14:29, Vincent Guittot
<vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
> Odin reported some fairness problem between cgroup because of stalled
> value in cfs_rq->tg_load_avg_contrib:
>
> https://lkml.org/lkml/2021/5/18/566
>
>
> 2 problems generated this situation:
> -1st: After propagating load in the hierarchy, load_sum can be null
>  whereas load_avg isn't so the cfs_rq is removed whereas it still
>  contribute to th tg's load
> -2nd: cfs_rq->tg_load_avg_contrib was not always updated after
>  significant changes like becoming null because cfs_rq had already
>  been updated when propagating a child load.
>

This series fixes the problem triggered by your 1st script on my test
machine. But could you confirm that this patchset also fixes the
problem on yours

Regards,
Vincent

>
> Vincent Guittot (2):
>   sched/fair: keep load_avg and load_sum synced
>   sched/fair: make sure to update tg contrib for blocked load
>
>  kernel/sched/fair.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> --
> 2.17.1
>
