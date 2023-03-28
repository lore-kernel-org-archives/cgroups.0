From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v1 5/9] memcg: replace stats_flush_lock with an atomic
Date: Tue, 28 Mar 2023 12:28:00 -0700
Message-ID: <CALvZod4Gsngc6MjXdk4s5+ePVjsgcVppdRmsQovN6gSrxzdbfA@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-6-yosryahmed@google.com> <20230328141523.txyhl7wt7wtvssea@google.com>
 <CAJD7tkYo=CeXJPUi_KxjzC0QCxC2qd_J2_FQi_aXh7svD8u60A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680031691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YujjpUZD+Q1jEde3/ZaCZtJJBkVmO1XlOY4kEzyMtns=;
        b=PhhYKJhXpGjlraKgnxTA1ox1zCuQDINg4H+NjqECLIwcVewsJ2UmF/XldtrOxzUW8F
         FtkMxK9XYIcC/gvDvo1cxA29U3ULWGCBaajKqJk4rgMHA4ss0Alf25G8t46R7Lp02Xut
         O+DxLHWvNCJdltEaU/xNOPwle2JDPTEN6cuVv0Zhrr8Lkz33KxXfau2W3yTNNCA9y3Xp
         LQiDdGk9NrgkoMvxC8Ehixwa8p3N51flc75mRDOp0exVkF6k6E4Hs69JMi+L3/TWelEW
         6mlpBQZHrXZuZqhCm7o9gUs274DyVLH9j018hTkghuZN3NqPxQMPN2+CHF+Zi2aGJdO3
         GnjQ==
In-Reply-To: <CAJD7tkYo=CeXJPUi_KxjzC0QCxC2qd_J2_FQi_aXh7svD8u60A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Tue, Mar 28, 2023 at 11:53=E2=80=AFAM Yosry Ahmed <yosryahmed@google.com=
> wrote:
>
[...]
> > > +     if (atomic_xchg(&stats_flush_ongoing, 1))
> >
> > Have you profiled this? I wonder if we should replace the above with
> >
> >         if (atomic_read(&stats_flush_ongoing) || atomic_xchg(&stats_flu=
sh_ongoing, 1))
>
> I profiled the entire series with perf and I haven't noticed a notable
> difference between before and after the patch series -- but maybe some
> specific access patterns cause a regression, not sure.
>
> Does an atomic_cmpxchg() satisfy the same purpose? it's easier to read
> / more concise I guess.
>
> Something like
>
>     if (atomic_cmpxchg(&stats_flush_ongoing, 0, 1))
>
> WDYT?
>

No, I don't think cmpxchg will be any different from xchg(). On x86,
the cmpxchg will always write to stats_flush_ongoing and depending on
the comparison result, it will either be 0 or 1 here.

If you see the implementation of queued_spin_trylock(), it does the
same as well.
