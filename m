From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v8 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Tue, 4 Oct 2022 20:49:51 +0200
Message-ID: <YzyAT/lfyKhOnOpy@blackbook>
References: <20221004151748.293388-1-longman@redhat.com>
 <20221004151748.293388-4-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2x28QV160etDw6kh"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664909392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8UNyI7lLYkq9NR142HxaTAJjkImjeZgGlN6hwkAxwMk=;
        b=YC+buOEk9Zc2GcPD5jOtQJWPyzrKsJH/cz+0BQYO7BGtB1JGjVdxR6XHWP8ftATaQo6OHd
        JhKwLPZDIsyhSrLJtXujRVkh75AJvF0yYrrOIUe5aqbh0nmobhYxqufLH/vGO+WlHkP25y
        +2oHfraB4VDBb7/iDgFznOCT3jB2vMU=
Content-Disposition: inline
In-Reply-To: <20221004151748.293388-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


--2x28QV160etDw6kh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Tue, Oct 04, 2022 at 11:17:48AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> To protect against destruction of blkg, a percpu reference is gotten
> when putting into the lockless list and put back when removed.

Just to conclude my previous remark about the loop, let me try
explaining it more precisely:

blkcg->lhead via blkg_iostat_set holds reference to blkcg_gq=20
   (taken in in blk_cgroup_bio_start)

blkcg_gq holds reference to its blkcg_gq->blkcg=20
   (taken in blkg_create)

The cycle has two edges, the latter is broken in __blkg_release but
that's a release callback of the involved blkcg_gq->refcnt, so it won't
be called.

The first edges is broken in blkcg_rstat_flush and that's more promising.
The current code does the final flushes -- in css_release_work_fn.
The problem is that it's the release callback of blkcg->css, i.e. it's
also referenced on the cycle, therefore this final flush won't happen
before cycle is broken.

Fortunately, any other caller of cgroup_rstat_flush comes to the rescue
-- the blkcg_rstat_flush on the stuck blkcg would decompose lhead list
and the reference cycle is broken.

In summary, I think this adds the reference cycle but its survival time
is limited to the soonest cgroup_rstat_flush call, which should not
cause practical troubles.

HTH,
Michal

--2x28QV160etDw6kh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYzyATQAKCRAkDQmsBEOq
uR6ZAQDgLur6eHNw+8NVHuBo39WYPgLu3bNOK4TNdtKfpKl3mQEAxvyDr/yKx2iZ
Duqml+a289o/PZPQLt5fTmUskNjKYAI=
=xQFZ
-----END PGP SIGNATURE-----

--2x28QV160etDw6kh--
