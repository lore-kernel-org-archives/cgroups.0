From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [RFC PATCH 2/7] memcg: do not disable interrupts when holding stats_flush_lock
Date: Wed, 22 Mar 2023 21:32:42 -0700
Message-ID: <CALvZod5MnM8UJ0pj44QYb4sVwgFZ1B2KpSL6oqBQbJU3wH6eNA@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com> <20230323040037.2389095-3-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679545974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wrIDK0fVrbx7cxzc4APSQQIB8Tdld7ibFj4Oysy8xfU=;
        b=FIzImCYRhfKjUT9pnu01dLLA4HDQ3BXtcjgTBHFJpnBLcGZGoGO939DvVsE0ACCLBD
         HAUrEyMh7dQYQpfiSzh1z2T4aoliQXDY2PtH8zUgWHZJ+Wlzj09Hc57J7+LzbWPLwJ30
         QPFFiP3KO6t2VwC9VgJYqd0EckGB6umtsMwnb3yJ2JSFju2Dm4jDvh5VHkd965tUFaZj
         W+NjP9qTR3O5ZH/o08OwnNf2A5eKq4nOVV2mM+FZmrLAYG0SehoQ+EDazL9xDG8TNlTx
         kCxHR0bIyEU/UZVe+dMYjlb9si4q45Gfnc1KLNTqhs8UX7jHYv+TWSPptwMfEaiMEV+x
         pf/g==
In-Reply-To: <20230323040037.2389095-3-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Wed, Mar 22, 2023 at 9:00=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com>=
 wrote:
>
> The rstat flushing code was modified so that we do not disable interrupts
> when we hold the global rstat lock. Do the same for stats_flush_lock on
> the memcg side to avoid unnecessarily disabling interrupts throughout
> flushing.
>
> Since the code exclusively uses trylock to acquire this lock, it should
> be fine to hold from interrupt contexts or normal contexts without
> disabling interrupts as a deadlock cannot occur. For interrupt contexts
> we will return immediately without flushing anyway.
>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  mm/memcontrol.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5abffe6f8389..e0e92b38fa51 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -636,15 +636,17 @@ static inline void memcg_rstat_updated(struct mem_c=
group *memcg, int val)
>
>  static void __mem_cgroup_flush_stats(void)
>  {
> -       unsigned long flag;
> -
> -       if (!spin_trylock_irqsave(&stats_flush_lock, flag))
> +       /*
> +        * This lock can be acquired from interrupt context,

How? What's the code path?

> but we only acquire
> +        * using trylock so it should be fine as we cannot cause a deadlo=
ck.
> +        */
> +       if (!spin_trylock(&stats_flush_lock))
>                 return;
>
>         flush_next_time =3D jiffies_64 + 2*FLUSH_TIME;
>         cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
>         atomic_set(&stats_flush_threshold, 0);
> -       spin_unlock_irqrestore(&stats_flush_lock, flag);
> +       spin_unlock(&stats_flush_lock);
>  }
>
>  void mem_cgroup_flush_stats(void)
> --
> 2.40.0.rc1.284.g88254d51c5-goog
>
