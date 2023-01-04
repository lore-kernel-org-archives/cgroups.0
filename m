From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Wed, 4 Jan 2023 12:11:58 -1000
Message-ID: <Y7X5rsnYCAAYRGQd@slm.duckdns.org>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pKNXM54CWmj3ArGU8axmSVIl3xxiHyUVTW8v6DzGRHA=;
        b=XeyuieaOtOOzRKGFjqn1IrRy3FbUpNBsXgm5p31jD6s62WfLwgMNey9QWnbRAniiTI
         ffWLGD3JyLqTrn3kDeC6Ye79OjQ9b6aI1KxXAOg5mJ3cnwHIaz/XNdSIgPHgKy092C/9
         z/dU/KUeru7A2hoGC84bFrOi1V8+5haTDs+DANlEuNy538SPL7H6GGtJAlBRJoSfsWdV
         Q5EHgRKCpgfbJ0J0+VAKOYZIV9+y4JrXs1V78W16MvAFzweAYYPwAeOe3Zszj6osT6jl
         1qtpRy83+l5cPjnq5rwOlsAona6qhEYXLVJlPd/jFHHWHQMNjHm+7F8OCm59Q09zUY3F
         CrIg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221226130505.7186-1-hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hello,

On Mon, Dec 26, 2022 at 09:05:05PM +0800, Jinke Han wrote:
>  static void throtl_pending_timer_fn(struct timer_list *t);
> +static inline struct bio *throtl_qnode_bio_list_pop(struct throtl_qnode *qn);

Just define it before the first usage? Also, I think it'd be fine to let the
compiler decide whether to inline.

> +#define BLK_THROTL_SYNC(bio) (bio->bi_opf & (REQ_SYNC | REQ_META | REQ_PRIO))

Nitpick but the above is used only in one place. Does it help to define it
as a macro?

> +/**
> + * throtl_qnode_bio_peek - peek a bio for a qn
> + * @qn: the qnode to peek from
> + *
> + * For read qn, just peek bio from the SYNC queue and return.
> + * For write qn, we first ask the next_to_disp for bio and will pop a bio
> + * to fill it if it's NULL. The next_to_disp is used to pin the bio for
> + * next to dispatch. It is necessary. In the dispatching  process, a peeked
> + * bio may can't be dispatched due to lack of budget and has to wait, the
> + * dispatching process may give up and the spin lock of the request queue
> + * will be released. New bio may be queued in as the spin lock were released.
> + * When it's time to dispatch the waiting bio, another bio may be selected to
> + * check the limit and may be dispatched. If the dispatched bio is smaller
> + * than the waiting bio, the bandwidth may be hard to satisfied as we may
> + * trim the slice after each dispatch.
> + * So pinning the next_to_disp to make sure that the waiting bio and the
> + * dispatched one later always the same one in case that the spin lock of
> + * queue was released and re-holded.

Can you please format it better and proof-read it. I can mostly understand
what it's saying but it can be improved quite a bit. Can you elaborate the
starvation scenario further? What about the [a]sync queue split makes this
more likely?

> +/**
> + * throtl_qnode_bio_pop: pop a bio from sync/async queue
> + * @qn: the qnode to pop a bio from
> + *
> + * For write io qn, the target queue to pop was determined by the disp_sync_cnt.
> + * Try to pop bio from target queue, fetch the bio and return it when it is not
> + * empty. If the target queue empty, pop bio from another queue instead.

How about:

        For reads, always pop from the ASYNC queue. For writes, target SYNC
        or ASYNC queue based on disp_sync_cnt. If empty, try the other
        queue.

> +static inline struct bio *throtl_qnode_bio_list_pop(struct throtl_qnode *qn)
> +{
> +	struct bio *bio;
> +	int from = SYNC;
> +
> +	if (qn->disp_sync_cnt == THROTL_SYNC_FACTOR)
> +		from = ASYNC;

?: often is less readable but I wonder whether it'd be more readable here:

        from = qn->disp_sync_cnt == THROTL_SYNC_FACTOR ? ASYNC : SYNC;

> +
> +	bio = bio_list_pop(&qn->bios[from]);
> +	if (!bio) {
> +		from = 1 - from;
> +		bio = bio_list_pop(&qn->bios[from]);
> +	}
> +
> +	if ((qn->disp_sync_cnt < THROTL_SYNC_FACTOR) &&
> +		(from == SYNC))

Why the line break? Also, this may be more personal preference but I'm not
sure the parentheses are helping much here.

> +		qn->disp_sync_cnt++;
> +	else
> +		qn->disp_sync_cnt = 0;
> +
> +	return bio;
> +}

Thanks.

-- 
tejun
