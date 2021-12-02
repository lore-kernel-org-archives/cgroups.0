From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 2/2] block: cancel all throttled bios in del_gendisk()
Date: Thu, 2 Dec 2021 15:48:18 +0100
Message-ID: <20211202144818.GB16798@blackbody.suse.cz>
References: <20211202130440.1943847-1-yukuai3@huawei.com>
 <20211202130440.1943847-3-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638456499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uwqW9ELU+jGK+NuQi1+7a6QT/l3WZTEzYW+bZJoKIeE=;
        b=f9ZXzJf5LFpiT2X6TuRjVMvl6xAFciKyA0CiIMnb+s4fe5nZbXqN/KrOEQUzdnXC5p6jaN
        prcl+l0b/5mXSDm+s9ldnuXK2ukzBA08x4tNnsAFX21tb0bpdVwoVBBZzg1HekS75f2Tkr
        vIZVI5E9e57ZVzlPy9MutotpTmVQJ/k=
Content-Disposition: inline
In-Reply-To: <20211202130440.1943847-3-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Kuai.

On Thu, Dec 02, 2021 at 09:04:40PM +0800, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> For example, if user thread is throttled with low bps while it's
> issuing large io, and the device is deleted. The user thread will
> wait for a long time for io to return.

Do I understand correctly the "long time" here is
outstanding_IO_size/throttled_bandwidth? Or are you getting at some
other cause/longer time?

> +void blk_throtl_cancel_bios(struct request_queue *q)
> +{
> +	struct throtl_data *td = q->td;
> +	struct bio_list bio_list_on_stack;
> +	struct blkcg_gq *blkg;
> +	struct cgroup_subsys_state *pos_css;
> +	struct bio *bio;
> +	int rw;
> +
> +	bio_list_init(&bio_list_on_stack);
> +
> +	/*
> +	 * hold queue_lock to prevent concurrent with dispatching
> +	 * throttled bios by timer.
> +	 */
> +	spin_lock_irq(&q->queue_lock);

You've replaced the rcu_read_lock() with the queue lock but...

> +
> +	/*
> +	 * Drain each tg while doing post-order walk on the blkg tree, so
> +	 * that all bios are propagated to td->service_queue.  It'd be
> +	 * better to walk service_queue tree directly but blkg walk is
> +	 * easier.
> +	 */
> +	blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg)
> +		tg_drain_bios(&blkg_to_tg(blkg)->service_queue);

...you also need the rcu_read_lock() here since you may encounter a
(descendant) blkcg that's removed concurrently.

(I may miss some consequences of doing this under the queue_lock so if
the concurrent removal is ruled out, please make a comment about it.)


Regards,
Michal

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTiq06H1IhXbF2mqzsiXqxkP0JkRwUCYajcogAKCRAiXqxkP0Jk
R7cGAQCsIq9mNSSTJzsqhyqoxiLByxVHzsfKjVpMEXCOTKOJoQD8CF2+/060Ii8J
cTwQpo66d266frtmJFTvhKDWHeInGww=
=H8f7
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
