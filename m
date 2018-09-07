From: Liu Bo <obuil.liubo@gmail.com>
Subject: Re: [PATCH 02/12] blkcg: update blkg_lookup_create to do locking
Date: Thu, 6 Sep 2018 23:17:56 -0700
Message-ID: <CANQeFDCVr=8MF-TPYr7oULZQVdBJ6wTn5N792QDodiz2ezF_ag@mail.gmail.com>
References: <20180906211045.29055-1-dennisszhou@gmail.com> <20180906211045.29055-3-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=i2ul3SyBZE3L/f+n/d50KIsjUWKjrby2SXdJL+3XjX0=;
        b=Ks0lJN1Cq+YE7586k6j2Z98QuuE20c7i8S03Jn59EmCgzkFnbUsZGxqSIHav8dbdsj
         77D+OYAW0oXrCYZuqcgCOBG82KFHc2//0oLHX2MOo4uEaNgOH62mVzqpAPVjr1Qm58ar
         9d9UebUcyhqGzqdGEa6fagxsx3WkTvEWOK3j0pcfO8/ca44NhavytoJ1c317Zb6oxkDi
         brGpBvv72DW+vW8XZ5F1QlBHjHNhK7G1Z6jhKGlm1O/B7/34qDZDfObdYx/4zA10QkXT
         DIMlBRuuB8cGjT9a/OG9xAdsDQjCmFiqnNOsda4JLAcA1MiUuqqZNZyDh9fF4PtF6Cfn
         yyHA==
In-Reply-To: <20180906211045.29055-3-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Sep 6, 2018 at 2:10 PM, Dennis Zhou <dennisszhou@gmail.com> wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
>
> To know when to create a blkg, the general pattern is to do a
> blkg_lookup and if that fails, lock and then do a lookup again and if
> that fails finally create. It doesn't make much sense for everyone who
> wants to do creation to write this themselves.
>
> This changes blkg_lookup_create to do locking and implement this
> pattern. The old blkg_lookup_create is renamed to __blkg_lookup_create.
> If a call site wants to do its own error handling or already owns the
> queue lock, they can use __blkg_lookup_create. This will be used in
> upcoming patches.
>


Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
liubo

> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
>  block/blk-cgroup.c         | 31 ++++++++++++++++++++++++++++---
>  block/blk-iolatency.c      |  2 +-
>  include/linux/blk-cgroup.h |  4 +++-
>  3 files changed, 32 insertions(+), 5 deletions(-)
>
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index c19f9078da1e..cd0d97bed83d 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -259,7 +259,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>  }
>
>  /**
> - * blkg_lookup_create - lookup blkg, try to create one if not there
> + * __blkg_lookup_create - lookup blkg, try to create one if not there
>   * @blkcg: blkcg of interest
>   * @q: request_queue of interest
>   *
> @@ -272,8 +272,8 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>   * value on error.  If @q is dead, returns ERR_PTR(-EINVAL).  If @q is not
>   * dead and bypassing, returns ERR_PTR(-EBUSY).
>   */
> -struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
> -                                   struct request_queue *q)
> +struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
> +                                     struct request_queue *q)
>  {
>         struct blkcg_gq *blkg;
>
> @@ -310,6 +310,31 @@ struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
>         }
>  }
>
> +/**
> + * blkg_lookup_create - find or create a blkg
> + * @blkcg: target block cgroup
> + * @q: target request_queue
> + *
> + * This looks up or creates the blkg representing the unique pair
> + * of the blkcg and the request_queue.
> + */
> +struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
> +                                   struct request_queue *q)
> +{
> +       struct blkcg_gq *blkg = blkg_lookup(blkcg, q);
> +       unsigned long flags;
> +
> +       if (unlikely(!blkg)) {
> +               spin_lock_irqsave(q->queue_lock, flags);
> +
> +               blkg = __blkg_lookup_create(blkcg, q);
> +
> +               spin_unlock_irqrestore(q->queue_lock, flags);
> +       }
> +
> +       return blkg;
> +}
> +
>  static void blkg_destroy(struct blkcg_gq *blkg)
>  {
>         struct blkcg *blkcg = blkg->blkcg;
> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
> index 62fdd9002c29..22b2ff0440cc 100644
> --- a/block/blk-iolatency.c
> +++ b/block/blk-iolatency.c
> @@ -410,7 +410,7 @@ static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio,
>         if (unlikely(!blkg)) {
>                 if (!lock)
>                         spin_lock_irq(q->queue_lock);
> -               blkg = blkg_lookup_create(blkcg, q);
> +               blkg = __blkg_lookup_create(blkcg, q);
>                 if (IS_ERR(blkg))
>                         blkg = NULL;
>                 if (!lock)
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index 24067a1f8b36..cc0f238530f6 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -184,6 +184,8 @@ extern struct cgroup_subsys_state * const blkcg_root_css;
>
>  struct blkcg_gq *blkg_lookup_slowpath(struct blkcg *blkcg,
>                                       struct request_queue *q, bool update_hint);
> +struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
> +                                     struct request_queue *q);
>  struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
>                                     struct request_queue *q);
>  int blkcg_init_queue(struct request_queue *q);
> @@ -897,7 +899,7 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
>         blkg = blkg_lookup(blkcg, q);
>         if (unlikely(!blkg)) {
>                 spin_lock_irq(q->queue_lock);
> -               blkg = blkg_lookup_create(blkcg, q);
> +               blkg = __blkg_lookup_create(blkcg, q);
>                 if (IS_ERR(blkg))
>                         blkg = NULL;
>                 spin_unlock_irq(q->queue_lock);
> --
> 2.17.1
>
