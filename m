From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH -next v6 3/3] block, bfq: do not idle if only one group is
 activated
Date: Sat, 28 May 2022 10:30:34 +0200
Message-ID: <27B0AE8B-C134-4BA1-B84F-39C659CB2B10@linaro.org>
References: <20220523131818.2798712-1-yukuai3@huawei.com>
 <20220523131818.2798712-4-yukuai3@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=T+Hu8XQTes5+zOjXdhH2PIcfNeRm97dI8R0g/lN+Yd8=;
        b=cMsKLp9xx6caXX4fhNUQ1GIDgeMWcvOHB+BQYZV7KhH/sIQHowtAJJduwzZeMn/ayn
         NEyO4PCwKkMmopMy3OFYPJNGueAYgpi2TmgwoPuj7gr2ImFZupuKBykH5Y0wahgVwpwC
         UmEXmyzWlGNdEHsP7SHKUDULFII5IHCW2u3onGKGbELBlPMnDfEMv2O4iKAFVh66XNyC
         6qUWZxzmeOFsQ2R1foQjeTlNZPR7YXsFJ3WfkLJ7m9blxV0nng9m8EykO4xde1SnExTZ
         juWKXm2I6HADHKXH0h/Fy0Rt5PA6d7CYbUtH2rOgnt0gFj3U+hJiV1J5T9NCzPzWPn9W
         kK7w==
In-Reply-To: <20220523131818.2798712-4-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3@huawei.com>
Cc: Jan Kara <jack@suse.cz>, tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com



> Il giorno 23 mag 2022, alle ore 15:18, Yu Kuai <yukuai3@huawei.com> ha =
scritto:
>=20
> Now that root group is counted into 'num_groups_with_busy_queues',
> 'num_groups_with_busy_queues > 0' is always true in
> bfq_asymmetric_scenario(). Thus change the condition to '> 1'.
>=20
> On the other hand, this change can enable concurrent sync io if only
> one group is activated.

This is ok.  Yet, if the mistakes I found in the other two patches are
actual errors, I wonder how these changes made it to pass your tests.

Thanks,
Paolo

>=20
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
> block/bfq-iosched.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 609b4e894684..142e1ca4600f 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -812,7 +812,7 @@ bfq_pos_tree_add_move(struct bfq_data *bfqd, =
struct bfq_queue *bfqq)
>  * much easier to maintain the needed state:
>  * 1) all active queues have the same weight,
>  * 2) all active queues belong to the same I/O-priority class,
> - * 3) there are no active groups.
> + * 3) there are one active group at most.
>  * In particular, the last condition is always true if hierarchical
>  * support or the cgroups interface are not enabled, thus no state
>  * needs to be maintained in this case.
> @@ -844,7 +844,7 @@ static bool bfq_asymmetric_scenario(struct =
bfq_data *bfqd,
>=20
> 	return varied_queue_weights || multiple_classes_busy
> #ifdef CONFIG_BFQ_GROUP_IOSCHED
> -	       || bfqd->num_groups_with_busy_queues > 0
> +	       || bfqd->num_groups_with_busy_queues > 1
> #endif
> 		;
> }
> --=20
> 2.31.1
>=20

