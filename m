From: Odin Ugedal <odin@uged.al>
Subject: Re: [PATCH 2/3] sched/fair: Correctly insert cfs_rq's to list on unthrottle
Date: Sat, 29 May 2021 11:33:32 +0200
Message-ID: <CAFpoUr04ziEzvNBJx0xKSuuEnapGzyABwaM-FU3TUaCZkQ4WPw@mail.gmail.com>
References: <20210518125202.78658-1-odin@uged.al> <20210518125202.78658-3-odin@uged.al>
 <CAKfTPtCiV5LMoXBQVdSsvNq-vurFVVd4aVWW-C=8Tza8uJTCjg@mail.gmail.com>
 <CAFpoUr0x=tgayPWYPORR+-h8gNhiE1t12Ko2o15Y8JwOCLp=yw@mail.gmail.com> <CAKfTPtA6AyL2f-KqHXecZrYKmZ9r9mT=Ks6BeNLjV9dfbSZJxQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t2zk5Z9qlmuHt7s59WmntMYgLXKVD6H7rp//7T7Ci/8=;
        b=hDCCEJVAZKetxCHmjId0bnmlfkx3k16wWn12wNDc5P5idPT0ngrHc3rLGObhkyriBA
         mvWG+3CPFlSemwRz6/fXgFfplhLrrwCh98FXV9wmSTImqhMKUrgx0gMSuP/84D0d+8F1
         7mFB4u54hKeRmrfeBxbOlnCpASZOQXTn6idAD5hD5+lB3QNbcG/BxCWObvGJvZ8GRaob
         qMPvxz97lervJeKwHD2gCa4qLV9+4lkpECE3tnM832PMwWx4zZURXY5u3hfI4DhsDqyR
         3h4CZOWLvtZjihPvbgqkqq5T+aN0xCp4TYoid+7HEBLzgoQ/+zTp9LvGewApdQg5gMFH
         H9Lw==
In-Reply-To: <CAKfTPtA6AyL2f-KqHXecZrYKmZ9r9mT=Ks6BeNLjV9dfbSZJxQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Odin Ugedal <odin@uged.al>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Hi,

> normally tg_load_avg_contrib should be null when cfs_rq_is_decayed()

Yeah, I think that is an ok assumption of how it _should_ work (given
the other patches in flight are merged).

> The reason of this list is to ensure that the load of all cfs_rq are
> periodically updated  as it is then used to share the runtime between
> groups so we should keep to use the rule whenever possible.

Yeah, right.

> we probably need to keep (cfs_rq->nr_running >= 1) as we can have case
> where tg_load_avg_contrib is null but a task is enqueued

Yeah, there is probably a chance of enqueuing a task without any load,
and then a parent gets throttled.
So (cfs_rq->tg_load_avg_contrib || cfs_rq->nr_running) is probably the
way to go if we want to avoid
a new field. Will resend a patch with that instead.

In case the new field is the main issue with the original solution, we
could also change the on_list int to have three modes like; NO, YES,
THROTTLED/PAUSED, but that would require a bigger rewrite of the other
logic, so probably outside the scope of this patch.

Thanks
Odin
