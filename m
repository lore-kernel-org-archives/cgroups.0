From: Odin Ugedal <odin@uged.al>
Subject: Re: [PATCH 2/3] sched/fair: Correctly insert cfs_rq's to list on unthrottle
Date: Fri, 28 May 2021 17:06:28 +0200
Message-ID: <CAFpoUr0x=tgayPWYPORR+-h8gNhiE1t12Ko2o15Y8JwOCLp=yw@mail.gmail.com>
References: <20210518125202.78658-1-odin@uged.al> <20210518125202.78658-3-odin@uged.al>
 <CAKfTPtCiV5LMoXBQVdSsvNq-vurFVVd4aVWW-C=8Tza8uJTCjg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EDD8L3cpZ2uFFlamRa44nzf+hjozNU1Vk7p0K9J8i9o=;
        b=KoaQZLCadrqQc1MDei7B5DjdK62FAI6dbnLjokWjqw0ebQKCen8jKX4GfN00n378Tp
         XaW8JKB9/lX9jENFAGzAmVEw3tn7p3uX4pLNSsyw6hBL86Zs328QRsWKb7oBoY0z21/b
         I/kKqYabSEmiCvBTAw70SMd7+1hSn1oEdpo1cjnHKrkeFTe4wq8UNniWQHp6y/GA06kh
         7R6SbOIG2fbVNz/rcKg3LvvzwAh8FvVqbmQwSpDfJSli9LLyQwvBfztM6HCbd/FjDj0U
         PpBO1YAodzZDoH2gA2j/dDZZLZlh3PsiRZZWvmkj9vFVJ2W+C6K17nH4ljIKOuzCUrwd
         MgWw==
In-Reply-To: <CAKfTPtCiV5LMoXBQVdSsvNq-vurFVVd4aVWW-C=8Tza8uJTCjg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Odin Ugedal <odin@uged.al>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Hi,

> What would be the other condition in addition to the current one
> :cfs_rq->nr_running >= 1 ?

The condition is that if it has load, we should add it (I don't have
100% control on util_avg and runnable_avg tho.). Using
"!cfs_rq_is_decayed()" is another way, but imo. that is a bit
overkill.

> We need to add a cfs_rq in the list if it still contributes to the
> tg->load_avg and the split of the share. Can't we add a condition for
> this instead of adding a new field ?

Yes, using cfs_rq->tg_load_avg_contrib as below would also work the
same way. I still think being explicit that we insert it if we have
removed it is cleaner in a way, as it makes it consistent with the
other use of list_add_leaf_cfs_rq() and list_del_leaf_cfs_rq(), but
that is about preference I guess. I do however think that using
tg_load_avg_contrib will work just fine, as it should always be
positive in case the cfs_rq has some load. I can resent v2 of this
patch using this instead;

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ad7556f99b4a..969ae7f930f5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4720,7 +4720,7 @@ static int tg_unthrottle_up(struct task_group
*tg, void *data)
                                             cfs_rq->throttled_clock_task;

                /* Add cfs_rq with already running entity in the list */
-               if (cfs_rq->nr_running >= 1)
+               if (cfs_rq->tg_load_avg_contrib)
                        list_add_leaf_cfs_rq(cfs_rq);
        }
