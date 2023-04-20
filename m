From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH mm-unstable RFC 5/5] cgroup: remove cgroup_rstat_flush_atomic()
Date: Thu, 20 Apr 2023 12:40:24 -0700
Message-ID: <CALvZod79Au=Fw9MTW7fP0P7KwQQ_NUiKgRHsNUFnv9v61pKnZA@mail.gmail.com>
References: <20230403220337.443510-1-yosryahmed@google.com> <20230403220337.443510-6-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682019635; x=1684611635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWz8KeUWsabxybWxiN5KihW65aZnZuzamu2iaxIUYWQ=;
        b=5/j+YFuZMStm9e2iO/ipkrsa2LdUF1SNvtLNHwugoyYSsCQKMQue9JXQIakK2Sw0WU
         Wwjir2Vk1OMmOskjWngO0ESKAMDsptNSuo09gV/5QRZW5W8BQ9iMjvumS1k8RQnoXgOL
         7QkKMY/J5LQkz6+5J4PH84vnF85GhfActqCsLNHBVsQFYF+PvYs6ns1u/RYEmGSx5mPD
         AkN24JBdy2Ucvj2bMd5NJup/cObu22q8uICbnabF/uvOP7KNKI9LF9Jbp+9EshGpOaYQ
         /uKWf57USSlHvXnbQWfPzv0CMy0Ikth4sL9Oquuoc8TlAAtalyron/zEhtRI2r8h4bJv
         5HEw==
In-Reply-To: <20230403220337.443510-6-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

+Tejun


On Mon, Apr 3, 2023 at 3:03=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com> =
wrote:
>
> Previous patches removed the only caller of cgroup_rstat_flush_atomic().
> Remove the function and simplify the code.


I would say let cgroup maintainers decide this and this patch can be
decoupled from the series.

>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  include/linux/cgroup.h |  1 -
>  kernel/cgroup/rstat.c  | 26 +++++---------------------
>  2 files changed, 5 insertions(+), 22 deletions(-)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 885f5395fcd04..567c547cf371f 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -692,7 +692,6 @@ static inline void cgroup_path_from_kernfs_id(u64 id,=
 char *buf, size_t buflen)
>   */
>  void cgroup_rstat_updated(struct cgroup *cgrp, int cpu);
>  void cgroup_rstat_flush(struct cgroup *cgrp);
> -void cgroup_rstat_flush_atomic(struct cgroup *cgrp);
>  void cgroup_rstat_flush_hold(struct cgroup *cgrp);
>  void cgroup_rstat_flush_release(void);
>
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index d3252b0416b69..f9ad33f117c82 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -171,7 +171,7 @@ __weak noinline void bpf_rstat_flush(struct cgroup *c=
grp,
>  __diag_pop();
>
>  /* see cgroup_rstat_flush() */
> -static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_slee=
p)
> +static void cgroup_rstat_flush_locked(struct cgroup *cgrp)
>         __releases(&cgroup_rstat_lock) __acquires(&cgroup_rstat_lock)
>  {
>         int cpu;
> @@ -207,9 +207,8 @@ static void cgroup_rstat_flush_locked(struct cgroup *=
cgrp, bool may_sleep)
>                 }
>                 raw_spin_unlock_irqrestore(cpu_lock, flags);
>
> -               /* if @may_sleep, play nice and yield if necessary */
> -               if (may_sleep && (need_resched() ||
> -                                 spin_needbreak(&cgroup_rstat_lock))) {
> +               /* play nice and yield if necessary */
> +               if (need_resched() || spin_needbreak(&cgroup_rstat_lock))=
 {
>                         spin_unlock_irq(&cgroup_rstat_lock);
>                         if (!cond_resched())
>                                 cpu_relax();
> @@ -236,25 +235,10 @@ __bpf_kfunc void cgroup_rstat_flush(struct cgroup *=
cgrp)
>         might_sleep();
>
>         spin_lock_irq(&cgroup_rstat_lock);
> -       cgroup_rstat_flush_locked(cgrp, true);
> +       cgroup_rstat_flush_locked(cgrp);
>         spin_unlock_irq(&cgroup_rstat_lock);
>  }
>
> -/**
> - * cgroup_rstat_flush_atomic- atomic version of cgroup_rstat_flush()
> - * @cgrp: target cgroup
> - *
> - * This function can be called from any context.
> - */
> -void cgroup_rstat_flush_atomic(struct cgroup *cgrp)
> -{
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&cgroup_rstat_lock, flags);
> -       cgroup_rstat_flush_locked(cgrp, false);
> -       spin_unlock_irqrestore(&cgroup_rstat_lock, flags);
> -}
> -
>  /**
>   * cgroup_rstat_flush_hold - flush stats in @cgrp's subtree and hold
>   * @cgrp: target cgroup
> @@ -269,7 +253,7 @@ void cgroup_rstat_flush_hold(struct cgroup *cgrp)
>  {
>         might_sleep();
>         spin_lock_irq(&cgroup_rstat_lock);
> -       cgroup_rstat_flush_locked(cgrp, true);
> +       cgroup_rstat_flush_locked(cgrp);
>  }
>
>  /**
> --
> 2.40.0.348.gf938b09366-goog
>
