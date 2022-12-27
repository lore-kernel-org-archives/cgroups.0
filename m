From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH RFC] block, bfq: switch 'bfqg->ref' to use atomic refcount
 apis
Date: Tue, 27 Dec 2022 14:09:40 +0800
Message-ID: <ba5e74a6-b3de-844d-16b8-84eb429c7058@huaweicloud.com>
References: <20221227031541.2595647-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20221227031541.2595647-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Yu Kuai <yukuai1@huaweicloud.com>, jack@suse.cz, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi, Jan!

=D4=DA 2022/12/27 11:15, Yu Kuai =D0=B4=B5=C0:
> From: Yu Kuai <yukuai3@huawei.com>
>=20
> The updating of 'bfqg->ref' should be protected by 'bfqd->lock', however,
> during code review, we found that bfq_pd_free() update 'bfqg->ref'
> without holding the lock, which is problematic:
>=20
> 1) bfq_pd_free() triggered by removing cgroup is called asynchronously;
> 2) bfqq will grab bfqg reference, and exit bfqq will drop the reference,
> which can concurrenty with 1).
>=20
> Unfortunately, 'bfqd->lock' can't be held here because 'bfqd' might alrea=
dy
> be freed in bfq_pd_free(). Fix the problem by using atomic refcount apis.
>=20
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   block/bfq-cgroup.c  | 8 +++-----
>   block/bfq-iosched.h | 2 +-
>   2 files changed, 4 insertions(+), 6 deletions(-)
>=20
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 1b2829e99dad..aa9c4f02e3a3 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -316,14 +316,12 @@ struct bfq_group *bfqq_group(struct bfq_queue *bfqq)
>  =20
>   static void bfqg_get(struct bfq_group *bfqg)
>   {
> -	bfqg->ref++;
> +	refcount_inc(&bfqg->ref);
>   }
>  =20
>   static void bfqg_put(struct bfq_group *bfqg)
>   {
> -	bfqg->ref--;
> -
> -	if (bfqg->ref =3D=3D 0)
> +	if (refcount_dec_and_test(bfqg->ref))
Sorry that here should be '&bfqg->ref'.

Anyway, I'll wait for you, and send a new version if you think this
patch make sense.

Thanks,
Kuai

>   		kfree(bfqg);
>   }
>  =20
> @@ -530,7 +528,7 @@ static struct blkg_policy_data *bfq_pd_alloc(gfp_t gf=
p, struct request_queue *q,
>   	}
>  =20
>   	/* see comments in bfq_bic_update_cgroup for why refcounting */
> -	bfqg_get(bfqg);
> +	refcount_set(&bfqg->ref, 1);
>   	return &bfqg->pd;
>   }
>  =20
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index 41aa151ccc22..466e4865ace6 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -928,7 +928,7 @@ struct bfq_group {
>   	char blkg_path[128];
>  =20
>   	/* reference counter (see comments in bfq_bic_update_cgroup) */
> -	int ref;
> +	refcount_t ref;
>   	/* Is bfq_group still online? */
>   	bool online;
>  =20
>=20

