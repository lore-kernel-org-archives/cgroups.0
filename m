From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH RFC 8/9] block, bfq: move forward
 __bfq_weights_tree_remove()
Date: Fri, 10 Dec 2021 11:00:37 +0100
Message-ID: <FA78962A-DC03-4A1F-9B79-D085A4908E5E@linaro.org>
References: <20211127101132.486806-1-yukuai3@huawei.com>
 <20211127101132.486806-9-yukuai3@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=O70batPj3wvi7RLrp3X+l52GyfZpEV965rgDfVwXWZY=;
        b=nwrUIMOWOU4Q7yQqvPcI8A0eut+VItBwApaqSOQ+7tajte458rjWZjpOj5X8gek9ym
         KNcvP0d6nah96lj4Uo1XXJAsRAD6FzdqerX+6KvqepB1GzUCjMY9dej0p2bfBRyGAEBs
         eBajnOnM4yEoi8h6ZvLXUKd+Xh/IbjlK0HQWNWQhKlEhvTzRrFEXk6XjpJWncNA8OCvz
         Jbc1y4sSDIcnlWVkWnwbGTRTqs2qmO5MvBtYlazwt2qViCfH5npWoN6A+0sQMCWMOP8v
         0QTwsn6HfD4mneH4/49vSCl6EbDPRQAU3b33Fi0bzV0uuBfpTAZ4EJqHFWWZDkio675n
         o4fQ==
In-Reply-To: <20211127101132.486806-9-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, yi.zhang@huawei.com



> Il giorno 27 nov 2021, alle ore 11:11, Yu Kuai <yukuai3@huawei.com> ha =
scritto:
>=20
> Prepare to decrease 'num_groups_with_pending_reqs' earlier.
>=20
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
> block/bfq-iosched.c | 13 +++++--------
> 1 file changed, 5 insertions(+), 8 deletions(-)
>=20
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index e3c31db4bffb..4239b3996e23 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -882,6 +882,10 @@ void bfq_weights_tree_remove(struct bfq_data =
*bfqd,
> {
> 	struct bfq_entity *entity =3D bfqq->entity.parent;
>=20
> +	bfqq->ref++;
> +	__bfq_weights_tree_remove(bfqd, bfqq,
> +				  &bfqd->queue_weights_tree);
> +
> 	for_each_entity(entity) {
> 		struct bfq_sched_data *sd =3D entity->my_sched_data;
>=20
> @@ -916,14 +920,7 @@ void bfq_weights_tree_remove(struct bfq_data =
*bfqd,
> 		}
> 	}
>=20
> -	/*
> -	 * Next function is invoked last, because it causes bfqq to be
> -	 * freed if the following holds: bfqq is not in service and
> -	 * has no dispatched request. DO NOT use bfqq after the next
> -	 * function invocation.
> -	 */
> -	__bfq_weights_tree_remove(bfqd, bfqq,
> -				  &bfqd->queue_weights_tree);
> +	bfq_put_queue(bfqq);
> }
>=20

why it is not dangerous any longer to invoke __bfq_weights_tree_remove =
earlier, and the comment can be removed?

Paolo

> /*
> --=20
> 2.31.1
>=20

