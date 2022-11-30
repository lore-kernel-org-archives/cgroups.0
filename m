From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH-block v2] bdi, blk-cgroup: Fix potential UAF of blkcg
Date: Wed, 30 Nov 2022 16:16:39 +0100
Message-ID: <20221130151639.GE27838@blackbody.suse.cz>
References: <20221129203400.1456100-1-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T6xhMxlHU34Bk0ad"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669821401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ATM8wuEZO4F8LmfuabnM5oV4K3RnnbDMeyDmwCZSpdY=;
        b=j6xq7JSq+Wr3SnG8eqNE+ECS5hPr743xQ5eo4n+UP7l3stds48QDvKwIiUHdHLnjAe5FLh
        i3ipUvJUniXllps7G5UVsQKq8e4auYqUEEFMQ/03zLcVsv9A4c4d2v2B6rezUF+XYnSfwU
        8/nlKl2px4rsGu4yjPnAuTS9c0Ex8fE=
Content-Disposition: inline
In-Reply-To: <20221129203400.1456100-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


--T6xhMxlHU34Bk0ad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2022 at 03:34:00PM -0500, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> The reproducing system can no longer produce a warning with this patch.
> All the runnable block/0* tests including block/027 were run successfully
> without failure.

Thanks for the test!

> @@ -1088,7 +1088,15 @@ static void blkcg_destroy_blkgs(struct blkcg *blkc=
g)
> =20
>  	might_sleep();
> =20
> -	css_get(&blkcg->css);
> +	/*
> +	 * blkcg_destroy_blkgs() shouldn't be called with all the blkcg
> +	 * references gone and rcu_read_lock not held.
> +	 */
> +	if (!css_tryget(&blkcg->css)) {
> +		WARN_ON_ONCE(!rcu_read_lock_held());
> +		return;
> +	}

As I followed the previous discussion, the principle is that obtaining a
reference or being inside an RCU read section is sufficient.

Consequently, I'd expect the two situations handled equally but here the
no-ref but RCU bails out. (Which is OK because blkg_list must be empty?)

However, the might_sleep() in (non-sleepable) RCU reader section combo
makes me wary anyway (not with the early return but tools would likely
complain).

All in all, can't the contract of blkcg_destroy_blkgs() declare that
a caller must pass blkcg with a valid reference? (The body of
blkcg_destroy_blkgs then wouldn't need to get neither put the inner
reference).

HTH,
Michal

--T6xhMxlHU34Bk0ad
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY4dzxgAKCRAkDQmsBEOq
ua6MAQCYfYVZAsH1NgOid00l0b52FcccC2/s0ITlu8jm7ZQs6wEAhKRvdwKu6lsC
VQgfYht9U8f+lQdK562Fh/ONyn6DzQw=
=M1ug
-----END PGP SIGNATURE-----

--T6xhMxlHU34Bk0ad--
