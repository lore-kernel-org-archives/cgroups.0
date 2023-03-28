From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v1 7/9] workingset: memcg: sleep when flushing stats in workingset_refault()
Date: Tue, 28 Mar 2023 08:18:11 -0700
Message-ID: <CALvZod5_NVTrYUhLjc3Me=CC6y3R4bhA71mCt-jXo0rX+2zUxw@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com> <20230328061638.203420-8-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680016702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Oo7t3uH5L5XgCZ1uKSglRiPDhZouQp2W4do7dpcvfk=;
        b=sloJNSy6jcyr8V+bl2KDVZrUIx+CgEgGJSFJ4w5WaC8TdDbJCtG+r3mp7IA616+rDp
         vp5xon0cmgSmMxTl22bo4RSzS9zf/7Kn97mBl99ky4OeP2XRyg6onKPOdON3LsP3G/5l
         XANyH+1QqjNiVr6oKoANqKgz1Ajr/GLOPr3j2cYawyyWbFlBNgScTCm22rzxJwSb9p82
         VRIEQDNvWgAhrcsWYx4ovZiheIKaE6I+lr3iNOLgZUWrzZB/z7jbm0dfyF5GYULBzeUy
         sOr3fI0aibAi2tvxQGwIW5wXdwecj11oK32tp95GWC1wSYzzlaWZF+3LUtQI/ppp1xXc
         o8Fw==
In-Reply-To: <20230328061638.203420-8-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Mon, Mar 27, 2023 at 11:16=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com=
> wrote:
>
> In workingset_refault(), we call mem_cgroup_flush_stats_ratelimited()
> to flush stats within an RCU read section and with sleeping disallowed.
> Move the call to mem_cgroup_flush_stats_ratelimited() above the RCU read
> section and allow sleeping to avoid unnecessarily performing a lot of
> work without sleeping.
>
> Since workingset_refault() is the only caller of
> mem_cgroup_flush_stats_ratelimited(), just make it call the non-atomic
> mem_cgroup_flush_stats().
>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

A nit below:

Acked-by: Shakeel Butt <shakeelb@google.com>

> ---
>  mm/memcontrol.c | 12 ++++++------
>  mm/workingset.c |  4 ++--
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 57e8cbf701f3..0c0e74188e90 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -674,12 +674,6 @@ void mem_cgroup_flush_stats_atomic(void)
>                 __mem_cgroup_flush_stats_atomic();
>  }
>
> -void mem_cgroup_flush_stats_ratelimited(void)
> -{
> -       if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
> -               mem_cgroup_flush_stats_atomic();
> -}
> -
>  /* non-atomic functions, only safe from sleepable contexts */
>  static void __mem_cgroup_flush_stats(void)
>  {
> @@ -695,6 +689,12 @@ void mem_cgroup_flush_stats(void)
>                 __mem_cgroup_flush_stats();
>  }
>
> +void mem_cgroup_flush_stats_ratelimited(void)
> +{
> +       if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
> +               mem_cgroup_flush_stats();
> +}
> +
>  static void flush_memcg_stats_dwork(struct work_struct *w)
>  {
>         __mem_cgroup_flush_stats();
> diff --git a/mm/workingset.c b/mm/workingset.c
> index af862c6738c3..7d7ecc46521c 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -406,6 +406,8 @@ void workingset_refault(struct folio *folio, void *sh=
adow)
>         unpack_shadow(shadow, &memcgid, &pgdat, &eviction, &workingset);
>         eviction <<=3D bucket_order;
>
> +       /* Flush stats (and potentially sleep) before holding RCU read lo=
ck */

I think the only reason we use rcu lock is due to
mem_cgroup_from_id(). Maybe we should add mem_cgroup_tryget_from_id().
The other caller of mem_cgroup_from_id() in vmscan is already doing
the same and could use mem_cgroup_tryget_from_id().

Though this can be done separately to this series (if we decide to do
it at all).
