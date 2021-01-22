From: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] bfq: don't check active group if bfq.weight is not
 changed
Date: Fri, 22 Jan 2021 10:46:21 +0100
Message-ID: <44BDF727-92DA-4678-A026-A1CF53A655BF@linaro.org>
References: <b4163392-0462-ff6f-b958-1f96f33d69e6@huawei.com>
 <20210114122426.603813-1-yukuai3@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=HjgV2PK/NA+pQ8cTfpiwH9HQAhJSvB08Q16GX5X3zfA=;
        b=by/sVS1It0deAY0BLbNdRSfPNB6zDWFTbe0d/GdsR736L2aLnyAHGJLh2YDDme2PwY
         IWjGWmZfSUUJLx6x33cWmVGFnaFF8NdjEAfl3KulaX2BZ6y3QGSQcriBcwdMDhfNavwo
         YVTiU3HsaaYUWTPrisnsQVlILY7rOMNv1FfKeLhjI21QRn1vMPkF/cRjIeagRCAuOIR5
         C/JtUyOq5gyX3gWEnOupLVZXJKYP/gpyr+w68gBGVbnm7m2zVamsEGQAPJWlwPqVVUFT
         iaGgCxf3xXGQwjd3c9Msmm9RPa3aa2nRk6IwK1oDfhJnTaXBBhlqSAwf0kmmh5AvxPH7
         kghA==
In-Reply-To: <20210114122426.603813-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



> Il giorno 14 gen 2021, alle ore 13:24, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> ha =
scritto:
>=20
> Now the group scheduling in BFQ depends on the check of active group,
> but in most cases group scheduling is not used and the checking
> of active group will cause bfq_asymmetric_scenario() and its caller
> bfq_better_to_idle() to always return true, so the throughput
> will be impacted if the workload doesn't need idle (e.g. random rw)
>=20
> To fix that, adding check in bfq_io_set_weight_legacy() and
> bfq_pd_init() to check whether or not group scheduling is used
> (a non-default weight is used). If not, there is no need
> to check active group.
>=20

Hi,
I do like the goal you want to attain.  Still, I see a problem with
your proposal.  Consider two groups, say A and B.  Suppose that both
have the same, default weight.  Yet, group A generates large I/O
requests, while group B generates small requests.  With your change,
idling would not be performed.  This would cause group A to steal
bandwidth to group B, in proportion to how large its requests are
compared with those of group B.

As a possible solution, maybe we would need also a varied_rq_size
flag, similar to the varied_weights flag?

Thoughts?

Thanks for your contribution,
Paolo

> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> block/bfq-cgroup.c  | 14 ++++++++++++--
> block/bfq-iosched.c |  8 +++-----
> block/bfq-iosched.h | 19 +++++++++++++++++++
> 3 files changed, 34 insertions(+), 7 deletions(-)
>=20
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index b791e2041e49..b4ac42c4bd9f 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -505,12 +505,18 @@ static struct blkcg_policy_data =
*bfq_cpd_alloc(gfp_t gfp)
> 	return &bgd->pd;
> }
>=20
> +static inline int bfq_dft_weight(void)
> +{
> +	return cgroup_subsys_on_dfl(io_cgrp_subsys) ?
> +	       CGROUP_WEIGHT_DFL : BFQ_WEIGHT_LEGACY_DFL;
> +
> +}
> +
> static void bfq_cpd_init(struct blkcg_policy_data *cpd)
> {
> 	struct bfq_group_data *d =3D cpd_to_bfqgd(cpd);
>=20
> -	d->weight =3D cgroup_subsys_on_dfl(io_cgrp_subsys) ?
> -		CGROUP_WEIGHT_DFL : BFQ_WEIGHT_LEGACY_DFL;
> +	d->weight =3D bfq_dft_weight();
> }
>=20
> static void bfq_cpd_free(struct blkcg_policy_data *cpd)
> @@ -554,6 +560,9 @@ static void bfq_pd_init(struct blkg_policy_data =
*pd)
> 	bfqg->bfqd =3D bfqd;
> 	bfqg->active_entities =3D 0;
> 	bfqg->rq_pos_tree =3D RB_ROOT;
> +
> +	if (entity->new_weight !=3D bfq_dft_weight())
> +		bfqd_enable_active_group_check(bfqd);
> }
>=20
> static void bfq_pd_free(struct blkg_policy_data *pd)
> @@ -1013,6 +1022,7 @@ static void bfq_group_set_weight(struct =
bfq_group *bfqg, u64 weight, u64 dev_wei
> 		 */
> 		smp_wmb();
> 		bfqg->entity.prio_changed =3D 1;
> +		bfqd_enable_active_group_check(bfqg->bfqd);
> 	}
> }
>=20
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 9e4eb0fc1c16..1b695de1df95 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -699,11 +699,8 @@ static bool bfq_asymmetric_scenario(struct =
bfq_data *bfqd,
> 		(bfqd->busy_queues[0] && bfqd->busy_queues[2]) ||
> 		(bfqd->busy_queues[1] && bfqd->busy_queues[2]);
>=20
> -	return varied_queue_weights || multiple_classes_busy
> -#ifdef CONFIG_BFQ_GROUP_IOSCHED
> -	       || bfqd->num_groups_with_pending_reqs > 0
> -#endif
> -		;
> +	return varied_queue_weights || multiple_classes_busy ||
> +	       bfqd_has_active_group(bfqd);
> }
>=20
> /*
> @@ -6472,6 +6469,7 @@ static int bfq_init_queue(struct request_queue =
*q, struct elevator_type *e)
>=20
> 	bfqd->queue_weights_tree =3D RB_ROOT_CACHED;
> 	bfqd->num_groups_with_pending_reqs =3D 0;
> +	bfqd->check_active_group =3D false;
>=20
> 	INIT_LIST_HEAD(&bfqd->active_list);
> 	INIT_LIST_HEAD(&bfqd->idle_list);
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index 703895224562..216509013012 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -524,6 +524,8 @@ struct bfq_data {
>=20
> 	/* true if the device is non rotational and performs queueing */
> 	bool nonrot_with_queueing;
> +	/* true if need to check num_groups_with_pending_reqs */
> +	bool check_active_group;
>=20
> 	/*
> 	 * Maximum number of requests in driver in the last
> @@ -1066,6 +1068,17 @@ static inline void bfq_pid_to_str(int pid, char =
*str, int len)
> }
>=20
> #ifdef CONFIG_BFQ_GROUP_IOSCHED
> +static inline void bfqd_enable_active_group_check(struct bfq_data =
*bfqd)
> +{
> +	cmpxchg_relaxed(&bfqd->check_active_group, false, true);
> +}
> +
> +static inline bool bfqd_has_active_group(struct bfq_data *bfqd)
> +{
> +	return bfqd->check_active_group &&
> +	       bfqd->num_groups_with_pending_reqs > 0;
> +}
> +
> struct bfq_group *bfqq_group(struct bfq_queue *bfqq);
>=20
> #define bfq_log_bfqq(bfqd, bfqq, fmt, args...)	do {			=
\
> @@ -1085,6 +1098,12 @@ struct bfq_group *bfqq_group(struct bfq_queue =
*bfqq);
> } while (0)
>=20
> #else /* CONFIG_BFQ_GROUP_IOSCHED */
> +static inline void bfqd_enable_active_group_check(struct bfq_data =
*bfqd) {}
> +
> +static inline bool bfqd_has_active_group(struct bfq_data *bfqd)
> +{
> +	return false;
> +}
>=20
> #define bfq_log_bfqq(bfqd, bfqq, fmt, args...) do {	\
> 	char pid_str[MAX_PID_STR_LENGTH];	\
> --=20
> 2.25.4
>=20

