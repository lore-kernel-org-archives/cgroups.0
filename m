From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH] block, bfq: fix uaf for bfqq in bic_set_bfqq()
Date: Tue, 21 Feb 2023 15:04:08 +0800
Message-ID: <ca9fefd4-7109-042c-3b25-9eb795141145@huaweicloud.com>
References: <20230113094410.2907223-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20230113094410.2907223-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: jack@suse.cz, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, paolo.valente@linaro.org, shinichiro.kawasaki@wdc.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

Hi, Jens

=D4=DA 2023/01/13 17:44, Yu Kuai =D0=B4=B5=C0:
> After commit 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'"=
),
> bic->bfqq will be accessed in bic_set_bfqq(), however, in some context
> bic->bfqq will be freed first, and bic_set_bfqq() is called with the freed
> bic->bfqq.
>=20
> Fix the problem by always freeing bfqq after bic_set_bfqq().
>=20
> Fixes: 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'")
> Reported-and-tested-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   block/bfq-cgroup.c  | 2 +-
>   block/bfq-iosched.c | 4 +++-
>   2 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index a6e8da5f5cfd..feb13ac25557 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -749,8 +749,8 @@ static void bfq_sync_bfqq_move(struct bfq_data *bfqd,
>   		 * old cgroup.
>   		 */
>   		bfq_put_cooperator(sync_bfqq);
> -		bfq_release_process_ref(bfqd, sync_bfqq);
>   		bic_set_bfqq(bic, NULL, true, act_idx);
> +		bfq_release_process_ref(bfqd, sync_bfqq);
>   	}
>   }
> =20

It seems this change is missed in GIT PULL for-6.3. I'll send a seperate
patch to fix this...

Thanks,
Kuai

