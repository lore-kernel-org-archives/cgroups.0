From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 5/6] bfq-iosched: move bfq_stat_recursive_sum into the
 only caller
Date: Fri, 7 Jun 2019 08:07:48 +0200
Message-ID: <3F21E6DF-2688-46A8-8A41-320BCBA86D05@linaro.org>
References: <20190606102624.3847-1-hch@lst.de>
 <20190606102624.3847-6-hch@lst.de>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Type: multipart/signed;
        boundary="Apple-Mail=_5E4D2C27-0D0A-4856-A512-45033AE94569";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=6xJ4Zi0fEzF1tamGyEeDu2gwAQnQnxhNg41rFECCkME=;
        b=j1kxod//g55v+aH9PBXXXCXwL4CPf5Z5ng1IQ85XBMkKZwUXVz5JzjKRrl3YV3MYHh
         5QEo9EtbKVWSFhvsQtEQ2knHJfp8/9EMq86MrSnhNT4HwGUG3qGK8yv1go7PKxIHtv8Z
         x5i7xnmgrN1ki+HZ7iA7v1Wph8U7c+hVnMbbx8KOCpC3fYGHojp59mY5/Aplw/ZA3Zxv
         85hT6g0MPadKGjRjBGVtxFU2sZ1brlAS8opEUswBxGegwMLqGXA3xzu3FJkTNxuzsfBT
         /Krk/5igaBPzGDw04EUyRZzCFNUIa8lEdQE8fzUlhyt1uPb2dsF2j9eWvylzbOPusXGo
         ShGg==
In-Reply-To: <20190606102624.3847-6-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


--Apple-Mail=_5E4D2C27-0D0A-4856-A512-45033AE94569
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> Il giorno 6 giu 2019, alle ore 12:26, Christoph Hellwig <hch@lst.de> =
ha scritto:
>=20
> This function was moved from core block code and is way to generic.
> Fold it into the only caller and simplify it based on the actually
> passed arguments.
>=20

Acked-by: Paolo Valente <paolo.valente@linaro.org>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> block/bfq-cgroup.c | 62 ++++++++++++++--------------------------------
> 1 file changed, 19 insertions(+), 43 deletions(-)
>=20
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index a691dca7e966..d84302445e30 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -80,47 +80,6 @@ static inline void bfq_stat_add_aux(struct bfq_stat =
*to,
> 		     &to->aux_cnt);
> }
>=20
> -/**
> - * bfq_stat_recursive_sum - collect hierarchical bfq_stat
> - * @blkg: blkg of interest
> - * @pol: blkcg_policy which contains the bfq_stat
> - * @off: offset to the bfq_stat in blkg_policy_data or @blkg
> - *
> - * Collect the bfq_stat specified by @blkg, @pol and @off and all its
> - * online descendants and their aux counts.  The caller must be =
holding the
> - * queue lock for online tests.
> - *
> - * If @pol is NULL, bfq_stat is at @off bytes into @blkg; otherwise, =
it is
> - * at @off bytes into @blkg's blkg_policy_data of the policy.
> - */
> -static u64 bfq_stat_recursive_sum(struct blkcg_gq *blkg,
> -			    struct blkcg_policy *pol, int off)
> -{
> -	struct blkcg_gq *pos_blkg;
> -	struct cgroup_subsys_state *pos_css;
> -	u64 sum =3D 0;
> -
> -	lockdep_assert_held(&blkg->q->queue_lock);
> -
> -	rcu_read_lock();
> -	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
> -		struct bfq_stat *stat;
> -
> -		if (!pos_blkg->online)
> -			continue;
> -
> -		if (pol)
> -			stat =3D (void *)blkg_to_pd(pos_blkg, pol) + =
off;
> -		else
> -			stat =3D (void *)blkg + off;
> -
> -		sum +=3D bfq_stat_read(stat) + =
atomic64_read(&stat->aux_cnt);
> -	}
> -	rcu_read_unlock();
> -
> -	return sum;
> -}
> -
> /**
>  * blkg_prfill_stat - prfill callback for bfq_stat
>  * @sf: seq_file to print to
> @@ -1045,8 +1004,25 @@ static int bfqg_print_rwstat(struct seq_file =
*sf, void *v)
> static u64 bfqg_prfill_stat_recursive(struct seq_file *sf,
> 				      struct blkg_policy_data *pd, int =
off)
> {
> -	u64 sum =3D bfq_stat_recursive_sum(pd_to_blkg(pd),
> -					  &blkcg_policy_bfq, off);
> +	struct blkcg_gq *blkg =3D pd_to_blkg(pd);
> +	struct blkcg_gq *pos_blkg;
> +	struct cgroup_subsys_state *pos_css;
> +	u64 sum =3D 0;
> +
> +	lockdep_assert_held(&blkg->q->queue_lock);
> +
> +	rcu_read_lock();
> +	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
> +		struct bfq_stat *stat;
> +
> +		if (!pos_blkg->online)
> +			continue;
> +
> +		stat =3D (void *)blkg_to_pd(pos_blkg, &blkcg_policy_bfq) =
+ off;
> +		sum +=3D bfq_stat_read(stat) + =
atomic64_read(&stat->aux_cnt);
> +	}
> +	rcu_read_unlock();
> +
> 	return __blkg_prfill_u64(sf, pd, sum);
> }
>=20
> --
> 2.20.1
>=20


--Apple-Mail=_5E4D2C27-0D0A-4856-A512-45033AE94569
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEpYoduex+OneZyvO8OAkCLQGo9oMFAlz5/zQACgkQOAkCLQGo
9oMJ1g//Uq6rihqfY8N/SIZ5zFCHuk8eizqXtFV4p1MKbm84R2YUTOZWifce95vW
5R5XVD7mRQ2h4hzwDW1r7aE+reoCCAlCIGqXITUpT/e2PpUvRmY+6Wcs6Vwcd9vR
GfZjKIGqydgbxRfdBho352yUN+/QYJxR+XSkwVLzNQVKKuuzbGQFh3kafY/mjE1b
m1WoyOmUgjve+ui4TGyU5M3Mn3aRCSzoYWzIj1QyOqjgaFp9FFkFKGv46fu2C2zP
SGYbSvn+WuLxBhh+Wh8A0gDREuV7MyPyOVCZMA8VN7fCBykrCT6d6TKjTmc20WuY
7mT6MNFF0mom6dIX2spjTL0rnAdgKkRInwaI5RJm1fQXVVPZTm4hArKfK0Yl/68D
BM1kqYh2T8OLEiTQLCL5IRX844El11g/btmlNLlhBPeUeNkERe6CucSX0++UllA6
TREKdlmE1Jy/8uZKgCEgJpAOB8mCnU+MxrpXSGrY+V/iBtZt12R5M8nXLmWgiJ1p
xXPyvE5JMYg6xgAMTBO9mnBsTALF11WRQl9PVWdmOxWUFiZhRgzdp3zgpoaFAFjW
YAOxsLp2LY7iz7TT9KGoE/uN6rArHIVYnMTuzWfCv547wnwQXlYXaJBSSqKxEoj/
5P52zzCamgtxlKahQHQ/JJQcvRloGKFgZNm2N5igas9duc07e+o=
=25My
-----END PGP SIGNATURE-----

--Apple-Mail=_5E4D2C27-0D0A-4856-A512-45033AE94569--
