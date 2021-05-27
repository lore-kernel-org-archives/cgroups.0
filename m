From: Odin Ugedal <odin@uged.al>
Subject: Re: [PATCH 1/3] sched/fair: Add tg_load_contrib cfs_rq decay checking
Date: Thu, 27 May 2021 11:45:58 +0200
Message-ID: <CAFpoUr0SOqyGifT5Lpf=t+A+REWdWezR-AY2fM_u1-CCs8KFYQ@mail.gmail.com>
References: <20210518125202.78658-1-odin@uged.al> <20210518125202.78658-2-odin@uged.al>
 <CAKfTPtCCZhjOCZR6DMSxb9qffG2KceWONP_MzoY6TpYBmWp+hg@mail.gmail.com>
 <CAFpoUr0f50hKUtWvpTy221xT+pUocY7LXCMCo3cPJupjgMtotg@mail.gmail.com>
 <CAKfTPtCaZOSEzRXVN9fTR2vTxGiANEARo6iDNMFiQV5=qAA4Tw@mail.gmail.com>
 <CAKfTPtAFn3=anfTCxKTDXF0wpttpEiAhksLvcEPdSiYZTj38_A@mail.gmail.com>
 <CAFpoUr1zGNf9vTbWjwsfY9E8YBjyE5xJ0SwzLebPiS7b=xz_Zw@mail.gmail.com> <CAKfTPtDRdFQqphysOL+0g=befwtJky0zixyme_V5eDz71hC5pQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CGSqh763sJ9tRWKESBK9C6KkYC01mkebqHWMvcOi984=;
        b=PZqwC6CnqXIdNEBEYc5be4bb5TccuGjFHDTVOl6jEnmBTLckP6WY85jbCuEoM7Hn89
         uyKnQniI/yGgivD73pop7f7tmhTCzq2sEclTRfSApZZihg+b4jBZvtgGXXjFkwFVx7TA
         0eNicuik9UNu5kptl4bnyD2lz1SXH4eV01tQxhn0cKNXT0IAxDGbChUbVPipuhb3SnkK
         JQG6FCCHir0bSm0RBZCX1wYCBd2gH02QUaYNrSC1Iu3YPJzcPwD9B/qIknRrdSoiVL61
         ag3Pa47muV/fq2zJ2RLaG1Vg2FYVkWdvcTnEXfvdKIc62AwNLBG39/9uoRDG0RgiUGyl
         JZaA==
In-Reply-To: <CAKfTPtDRdFQqphysOL+0g=befwtJky0zixyme_V5eDz71hC5pQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Odin Ugedal <odin@uged.al>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Hi,

> I finally got it this morning with your script and I confirm that the
> problem of load_sum == 0 but load_avg != 0 comes from
> update_tg_cfs_load(). Then, it seems that we don't call
> update_tg_load_avg for this cfs_rq in __update_blocked_fair() because
> of a recent update while propagating child's load changes. At the end
> we remove the cfs_rq from the list without updating its contribution.
>
> I'm going to prepare a patch to fix this

Yeah, that is another way to look at it. Have not verified, but
wouldn't update_tg_load_avg() in this case
just remove the diff (load_avg - tg_load_avg_contrib)? Wouldn't we
still see some tg_load_avg_contrib
after the cfs_rq is removed from the list then? Eg. in my example
above, the cfs_rq will be removed from
the list while tg_load_avg_contrib=2, or am I missing something? That
was my thought when I looked
at it last week at least..

Thanks
Odin
