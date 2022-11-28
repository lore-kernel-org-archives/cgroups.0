From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH-block] blk-cgroup: Use css_tryget() in
 blkcg_destroy_blkgs()
Date: Mon, 28 Nov 2022 15:06:31 +0100
Message-ID: <20221128140631.GI25160@blackbody.suse.cz>
References: <20221128033057.1279383-1-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tSiBuZsJmMXpnp7T"
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669644392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4yiwoI9xze/bvvYsQ6MdgjViodw7i3sVy+Mfdib+hi0=;
        b=dM+RRQP85j6tCnpaeFC6IaoAklNnGvuffWFKJCeG/G+4EVXC4waWkZ6Qbbc3+ljra+mvqK
        Y7jNhIgPc3fN/05T7T7h1Y1lvX4s+E98o9CtW3twrDcT0FELzQ5gpg4vlgnK+8CII3vvWr
        4Cw2A8QF/ST9FcbYnmZGQCWjPfJoMrQ=
Content-Disposition: inline
In-Reply-To: <20221128033057.1279383-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Hillf Danton <hdanton@sina.com>, Yi Zhang <yi.zhang@redhat.com>


--tSiBuZsJmMXpnp7T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Sun, Nov 27, 2022 at 10:30:57PM -0500, Waiman Long <longman@redhat.com> wrote:
> That may not be true if there is no blkg associated with the blkcg. If
> css_get() fails, the subsequent css_put() call may lead to data
> corruption as was illustrated in a test system that it crashed on
> bootup when that commit was included.

Do you have a stacktrace of the underflowing css_put() in
blkcg_destroy_blkgs()?

It looks to me slightly as a mistake of the caller site that it passes
struct blkcg * without any references.

By a cursory look, could it be cgwb_release_workfn?

--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -390,11 +390,11 @@ static void cgwb_release_workfn(struct work_struct *work)
        wb_shutdown(wb);

        css_put(wb->memcg_css);
-       css_put(wb->blkcg_css);
        mutex_unlock(&wb->bdi->cgwb_release_mutex);

        /* triggers blkg destruction if no online users left */
        blkcg_unpin_online(wb->blkcg_css);
+       css_put(wb->blkcg_css);

        fprop_local_destroy_percpu(&wb->memcg_completions);

Does your crash involve this stack?

Thanks,
Michal

--tSiBuZsJmMXpnp7T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY4TAZQAKCRAkDQmsBEOq
uS+5AP97cFglT6cqH0lX6xHLHlFTnlz0R8/2eiUTZc7t+UMIAAEAx44DeExOpRjE
QcJ6UH59lXEoD6kvkW4qmcP6+AWHTAA=
=jz60
-----END PGP SIGNATURE-----

--tSiBuZsJmMXpnp7T--
