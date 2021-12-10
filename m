From: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 3/9] block, bfq: handle the case when
 for_each_entity() access root group
Date: Fri, 10 Dec 2021 11:06:10 +0100
Message-ID: <4C1444A3-8268-4F4E-99D0-76704E69C43E@linaro.org>
References: <20211127101132.486806-1-yukuai3@huawei.com>
 <20211127101132.486806-4-yukuai3@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=lC142Yo8coIpvvVUqN6aAJckxOOmW7Kkcqr32G1U5wQ=;
        b=YirHdbJ/8fHvaGzvPOOudtZaOKZcTRdBFtDjdO1hmXL9O4K9D87KqrQ1Ap9pd9QlFP
         H3sUgfmdP2N4yKurHlVRbhkt5gZOg0lM+e19Y3svTo/dvTfX6H36xgUyHme2dxly4Gvk
         w9bgVjEmNv8Mue0+0e7ZiZ+SKI2vPfHq5MEvSsb5A40po863heD6Duoq/Kqg6IfY0dHf
         2cp8hDtCRBl3YghjzvvpvYcnS7RNI1WHooBWkC2uBCFd13WNSyUdCmraD0T24rJ8kFZu
         5EphrR/MLO6IE/aRHdF4mGAWtPr68E27D/1JFsdrU40aCsr1fUkN1JQAvI/qkCNE97Ll
         PECg==
In-Reply-To: <20211127101132.486806-4-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



> Il giorno 27 nov 2021, alle ore 11:11, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> ha =
scritto:
>=20
> Prevent null-ptr-deref after counting root group into
> 'num_groups_with_pending_reqs'.
>=20
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> block/bfq-iosched.c |  2 +-
> block/bfq-wf2q.c    | 17 +++++++++++++----
> 2 files changed, 14 insertions(+), 5 deletions(-)
>=20
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 3262d062e21f..47722f931ee3 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -864,7 +864,7 @@ void bfq_weights_tree_remove(struct bfq_data =
*bfqd,
> 	for_each_entity(entity) {
> 		struct bfq_sched_data *sd =3D entity->my_sched_data;
>=20
> -		if (sd->next_in_service || sd->in_service_entity) {
> +		if (sd && (sd->next_in_service || =
sd->in_service_entity)) {

Explain with some comment this additional check.

Paolo

> 			/*
> 			 * entity is still active, because either
> 			 * next_in_service or in_service_entity is not
> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index 67e32481e455..6693765ff3a0 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -965,6 +965,13 @@ static void __bfq_activate_entity(struct =
bfq_entity *entity,
> 	bool backshifted =3D false;
> 	unsigned long long min_vstart;
>=20
> +	if (is_root_entity(entity))
> +#ifdef CONFIG_BFQ_GROUP_IOSCHED
> +		goto update;
> +#else
> +		return;
> +#endif
> +
> 	/* See comments on bfq_fqq_update_budg_for_activation */
> 	if (non_blocking_wait_rq && bfq_gt(st->vtime, entity->finish)) {
> 		backshifted =3D true;
> @@ -999,7 +1006,10 @@ static void __bfq_activate_entity(struct =
bfq_entity *entity,
> 		entity->on_st_or_in_serv =3D true;
> 	}
>=20
> +	bfq_update_fin_time_enqueue(entity, st, backshifted);
> +
> #ifdef CONFIG_BFQ_GROUP_IOSCHED
> +update:
> 	if (!bfq_entity_to_bfqq(entity)) { /* bfq_group */
> 		struct bfq_group *bfqg =3D
> 			container_of(entity, struct bfq_group, entity);
> @@ -1011,8 +1021,6 @@ static void __bfq_activate_entity(struct =
bfq_entity *entity,
> 		}
> 	}
> #endif
> -
> -	bfq_update_fin_time_enqueue(entity, st, backshifted);
> }
>=20
> /**
> @@ -1102,7 +1110,8 @@ static void __bfq_activate_requeue_entity(struct =
bfq_entity *entity,
> {
> 	struct bfq_service_tree *st =3D bfq_entity_service_tree(entity);
>=20
> -	if (sd->in_service_entity =3D=3D entity || entity->tree =3D=3D =
&st->active)
> +	if (sd && (sd->in_service_entity =3D=3D entity ||
> +		   entity->tree =3D=3D &st->active))
> 		 /*
> 		  * in service or already queued on the active tree,
> 		  * requeue or reposition
> @@ -1140,7 +1149,7 @@ static void bfq_activate_requeue_entity(struct =
bfq_entity *entity,
> 		sd =3D entity->sched_data;
> 		__bfq_activate_requeue_entity(entity, sd, =
non_blocking_wait_rq);
>=20
> -		if (!bfq_update_next_in_service(sd, entity, expiration) =
&&
> +		if (sd && !bfq_update_next_in_service(sd, entity, =
expiration) &&
> 		    !requeue)
> 			break;
> 	}
> --=20
> 2.31.1
>=20

