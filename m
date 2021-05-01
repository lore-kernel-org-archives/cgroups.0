From: Odin Ugedal <odin@ugedal.com>
Subject: Re: [PATCH 1/1] sched/fair: Fix unfairness caused by missing load decay
Date: Sat, 1 May 2021 16:41:03 +0200
Message-ID: <CAFpoUr3vMQq8QYajXZsQ6zWQOncO5Q8-2gFWOJLFm-APUznuZA@mail.gmail.com>
References: <20210425080902.11854-1-odin@uged.al> <20210425080902.11854-2-odin@uged.al>
 <20210427142611.GA22056@vingu-book> <CAFpoUr1KOvLSUoUac8MMTD+TREDWmDpeku950U=_p-oBDE4Avw@mail.gmail.com>
 <CAKfTPtCtt9V69AvkJTuMDRPJXGPboFsnSmwLM5RExnU2h5stSw@mail.gmail.com> <4ba77def-c7e9-326e-7b5c-cd491b063888@arm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+9JnfpgxvBiyhUpVXmBLUzz03NBbrZEjK+KMYKJ2t20=;
        b=RnQunxucB260CYXVbm79inYUHgZ5kmjIdmnW3OLRGx5Q+i4uqZCiTmKRoKd0R0TXLV
         P6L8xkfjAcIlpz2bAmkNzp+L9/JpLVObdX27DZEcg1F9p+BCVj364+5+rces1tNfa5U/
         I8UPM+Ya3vSjP4F5N3Dqg4/XCVuoUSHmiQVqb8hXDcrR/amfimYOkdx3EefnQaOnVIxg
         tLbrEAHfJZ5LvRMFZJWULKFp+nASHLjP64VqxjGylJvIXlAdfGkU3WXhYQfXAfP8u3IQ
         Sezbjwgv+EJe6NEYmcNoE7zGIV6U/G2Hhz2dZ6geBBw85xFAQY5QdrVb4DWUSRrjsMrp
         0t5g==
In-Reply-To: <4ba77def-c7e9-326e-7b5c-cd491b063888@arm.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, Odin Ugedal <odin@uged.al>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

Hi,

> I think what I see on my Juno running the unfairness_missing_load_decay.sh script is
> in sync which what you discussed here:

Thanks for taking a look!

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 794c2cb945f8..7214e6e89820 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -10854,6 +10854,8 @@ static void propagate_entity_cfs_rq(struct sched_entity *se)
>                         break;
>
>                 update_load_avg(cfs_rq, se, UPDATE_TG);
> +               if (!cfs_rq_is_decayed(cfs_rq))
> +                       list_add_leaf_cfs_rq(cfs_rq);
>         }
> }

This might however lead to "loss" at /slice/cg-2/sub and
slice/cg-1/sub in this particular case tho, since
propagate_entity_cfs_rq skips one cfs_rq
by taking the parent of the provided se. The loss in that case would
however not be equally big, but will still often contribute to some
unfairness.


Thanks
Odin
