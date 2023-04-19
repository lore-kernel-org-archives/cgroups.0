From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH mm-unstable RFC 1/5] writeback: move wb_over_bg_thresh()
 call outside lock section
Date: Wed, 19 Apr 2023 13:38:11 +0200
Message-ID: <7woe6ljcarqsr6uep7uns7bc3hm6xqog6ufk4rhwfo4vxixczw@tdjkdhx2euok>
References: <20230403220337.443510-1-yosryahmed@google.com>
 <20230403220337.443510-2-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="um3hlfownhi7iyh5"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1681904293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CawZP8F8+xYMOVFHt2q5TqVfXamwgFnKSbMRqGDkkis=;
        b=GL5fAGiWO2P5IiS5km6lqEZciICNE40kwVeLHDhHCVOZVt8jDUYanFIa1YaVUirxyzdxNF
        AemECDuu3TqA6SneZwBNJ3xttSlMUd3KMgmbg2ZfxFhIB73Azy1a5wAUPUd/zTbVMBZYbe
        ROOnf24qNyDC+lbl2/LAR9jU4dAfhI8=
Content-Disposition: inline
In-Reply-To: <20230403220337.443510-2-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org


--um3hlfownhi7iyh5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2023 at 10:03:33PM +0000, Yosry Ahmed <yosryahmed-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
> wb_over_bg_thresh() calls mem_cgroup_wb_stats() which invokes an rstat
> flush, which can be expensive on large systems. Currently,
> wb_writeback() calls wb_over_bg_thresh() within a lock section, so we
> have to make the rstat flush atomically. On systems with a lot of
> cpus/cgroups, this can cause us to disable irqs for a long time,
> potentially causing problems.
>=20
> Move the call to wb_over_bg_thresh() outside the lock section in
> preparation to make the rstat flush in mem_cgroup_wb_stats() non-atomic.
> The list_empty(&wb->work_list) should be okay outside the lock section
> of wb->list_lock as it is protected by a separate lock (wb->work_lock),
> and wb_over_bg_thresh() doesn't seem like it is modifying any of the b_*
> lists the wb->list_lock is protecting. Also, the loop seems to be
> already releasing and reacquring the lock, so this refactoring looks
> safe.
>=20
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/fs-writeback.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 195dc23e0d831..012357bc8daa3 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2021,7 +2021,6 @@ static long wb_writeback(struct bdi_writeback *wb,
>  	struct blk_plug plug;
> =20
>  	blk_start_plug(&plug);
> -	spin_lock(&wb->list_lock);
>  	for (;;) {
>  		/*
>  		 * Stop writeback when nr_pages has been consumed
> @@ -2046,6 +2045,9 @@ static long wb_writeback(struct bdi_writeback *wb,
>  		if (work->for_background && !wb_over_bg_thresh(wb))
>  			break;
> =20
> +
> +		spin_lock(&wb->list_lock);
> +
>  		/*
>  		 * Kupdate and background works are special and we want to
>  		 * include all inodes that need writing. Livelock avoidance is
> @@ -2075,13 +2077,19 @@ static long wb_writeback(struct bdi_writeback *wb,
>  		 * mean the overall work is done. So we keep looping as long
>  		 * as made some progress on cleaning pages or inodes.
>  		 */
> -		if (progress)
> +		if (progress) {
> +			spin_unlock(&wb->list_lock);
>  			continue;
> +		}
> +

This would release wb->list_lock temporarily with progress but that's
already not held continuously due to writeback_sb_inodes().
Holding the lock could even be shortened by taking it later after
trace_writeback_start().

Altogether, the change looks OK,
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>


--um3hlfownhi7iyh5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZD/SoAAKCRAkDQmsBEOq
ud9HAQDjyg6QsqLgZUGry6hNbONC5QVd0E2+HvxdLRrVBbVMTwD/dXaHa+QsVZiZ
ADTParKHoShcH9b0N7u/scBSdpKHhgM=
=xwT4
-----END PGP SIGNATURE-----

--um3hlfownhi7iyh5--
