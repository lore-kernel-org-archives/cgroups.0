From: Liu Bo <obuil.liubo@gmail.com>
Subject: Re: [PATCH v3] block: fix blk-iolatency accounting underflow
Date: Mon, 17 Dec 2018 11:42:28 -0800
Message-ID: <CANQeFDAO5PdMOrZnn0UgFHcHGvXEs7qS9Kqrk1KRCAwgfRzSOg@mail.gmail.com>
References: <20181217160351.27903-1-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3PPDNFe9g5OsR5LN7ZnTRGlAKV1rIaOnirACR3WcmzQ=;
        b=BlxLEIN267TRyXxBbfImYhIvz5DkHmmZoBMXgoKD+ZONxkERmiWwZlPdqxG/BK5XIk
         F4veTheVsiFq9FuQMHIytEKZHw5w0oAxWj7VJo849xeAPUZQjBgtARNqLOd4IdQoZwAj
         1VlzVIQGHFAP3VKPg7M9ResVy8dTEa5uT2yjkEUYYTMS7aFgc/5d6q69TRKa7ifGxes6
         cMqKMTKFEDvw5mTB0ORVZsfs+8R3fTj1B1qZcDU5Bu4XdKoZDkExwfAXPsPOUaw0mEOx
         SdzIk4NZoImNYxmcubf7UtNXSXcP5Shkmi4/gJYQd/cTfItbbwOeT7HeOySgAKKlURgP
         8WCw==
In-Reply-To: <20181217160351.27903-1-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Dec 17, 2018 at 8:04 AM Dennis Zhou <dennis@kernel.org> wrote:
>
> The blk-iolatency controller measures the time from rq_qos_throttle() to
> rq_qos_done_bio() and attributes this time to the first bio that needs
> to create the request. This means if a bio is plug-mergeable or
> bio-mergeable, it gets to bypass the blk-iolatency controller.
>

Hi,

I have a question about merging in plug list, since plug merges are
done before rq_qos_throttle(), why would plug-mergeable bios bypass
the controller?

thanks,
liubo

> The recent series [1], to tag all bios w/ blkgs undermined how iolatency
> was determining which bios it was charging and should process in
> rq_qos_done_bio(). Because all bios are being tagged, this caused the
> atomic_t for the struct rq_wait inflight count to underflow and result
> in a stall.
>
> This patch adds a new flag BIO_TRACKED to let controllers know that a
> bio is going through the rq_qos path. blk-iolatency now checks if this
> flag is set to see if it should process the bio in rq_qos_done_bio().
>
> Overloading BLK_QUEUE_ENTERED works, but makes the flag rules confusing.
> BIO_THROTTLED was another candidate, but the flag is set for all bios
> that have gone through blk-throttle code. Overloading a flag comes with
> the burden of making sure that when either implementation changes, a
> change in setting rules for one doesn't cause a bug in the other. So
> here, we unfortunately opt for adding a new flag.
>
> [1] https://lore.kernel.org/lkml/20181205171039.73066-1-dennis@kernel.org/
>
> Fixes: 5cdf2e3fea5e ("blkcg: associate blkg when associating a device")
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> Cc: Josef Bacik <josef@toxicpanda.com>
> ---
>  block/blk-iolatency.c     | 2 +-
>  block/blk-rq-qos.h        | 5 +++++
>  include/linux/blk_types.h | 1 +
>  3 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
> index bee092727cad..fc714ef402a6 100644
> --- a/block/blk-iolatency.c
> +++ b/block/blk-iolatency.c
> @@ -593,7 +593,7 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
>         bool enabled = false;
>
>         blkg = bio->bi_blkg;
> -       if (!blkg)
> +       if (!blkg || !bio_flagged(bio, BIO_TRACKED))
>                 return;
>
>         iolat = blkg_to_lat(bio->bi_blkg);
> diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
> index fd8a0c5debd3..58f62483b537 100644
> --- a/block/blk-rq-qos.h
> +++ b/block/blk-rq-qos.h
> @@ -170,6 +170,11 @@ static inline void rq_qos_done_bio(struct request_queue *q, struct bio *bio)
>
>  static inline void rq_qos_throttle(struct request_queue *q, struct bio *bio)
>  {
> +       /*
> +        * BIO_TRACKED lets controllers know that a bio went through the
> +        * normal rq_qos path.
> +        */
> +       bio_set_flag(bio, BIO_TRACKED);
>         if (q->rq_qos)
>                 __rq_qos_throttle(q->rq_qos, bio);
>  }
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 46c005d601ac..fc99474ac968 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -228,6 +228,7 @@ struct bio {
>  #define BIO_TRACE_COMPLETION 10        /* bio_endio() should trace the final completion
>                                  * of this bio. */
>  #define BIO_QUEUE_ENTERED 11   /* can use blk_queue_enter_live() */
> +#define BIO_TRACKED 12         /* set if bio goes through the rq_qos path */
>
>  /* See BVEC_POOL_OFFSET below before adding new flags */
>
> --
> 2.17.1
>
