From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 1/6] blk-cgroup: factor out a helper to read rwstat
 counter
Date: Thu, 6 Jun 2019 15:03:04 +0000
Message-ID: <BYAPR04MB5749DB3E6C0307980F32A80886170@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20190606102624.3847-1-hch@lst.de>
 <20190606102624.3847-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1559833387; x=1591369387;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=77O/NUdT38XGfrjDff5NjM8zU6sT8Poj32urvyyH9LQ=;
  b=B/tcjmMrHZ5gmZeQQqjDoCI7K4JXDC9CoarbYmaOBsxzSvOjf7iwL9uq
   0lZSY8Qu/Pf0UkACqzUiKRKNXU6Eg6F/nKns2sE2YDI1GaGSiVu2PVahB
   Cb5FQE9PJhOaSQ8t23SsRXrnxAwUFTJEPayQo3aTwa3PL9V8juLvj3uWn
   kC4/AfCgUr7qpEkCHUEfEe/FmpFMUstsdE52bkcOcHq6yPfHEIMixvtyA
   1itwDyQ9eHcZ7CQE2kGWHaYvHHefYXQ2jVqEa01rIUGVKKrBTTb/Uk+e8
   loOZJLjCZwhDCpUSN865Socvw1JQyWGjazU2tEZjBDJVjoK87jwNJ/ii8
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xq6dkQ6VWPE4D4SL5rvWUtzAf/9p6ITXPkC1UBHgNgU=;
 b=yhA3It6xG3t93OUc0A3zRwuR5cWTNMir7mYoH3YckjJh+9OvUP176bWe1KM+Z2O6Dxk4Sg+JWlDi5Hluz0qHnaSEw2XrELsqd71roJdphOlhQ5Ca1PT8cRTp30ZcL3+uQB/E78vHr1EfXLnCDnDZ1ma/O0vbYOFW+j4wuGCMECk=
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Looks good to me.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
On 06/06/2019 03:27 AM, Christoph Hellwig wrote:=0A=
> Trying to break up the crazy statements to something readable.=0A=
> Also switch to an unsigned counter as it can't ever turn negative.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> ---=0A=
>   block/blk-cgroup.c         | 5 ++---=0A=
>   include/linux/blk-cgroup.h | 7 +++++++=0A=
>   2 files changed, 9 insertions(+), 3 deletions(-)=0A=
>=0A=
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c=0A=
> index b97b479e4f64..6f79ace02be4 100644=0A=
> --- a/block/blk-cgroup.c=0A=
> +++ b/block/blk-cgroup.c=0A=
> @@ -750,7 +750,7 @@ struct blkg_rwstat blkg_rwstat_recursive_sum(struct b=
lkcg_gq *blkg,=0A=
>   	struct blkcg_gq *pos_blkg;=0A=
>   	struct cgroup_subsys_state *pos_css;=0A=
>   	struct blkg_rwstat sum =3D { };=0A=
> -	int i;=0A=
> +	unsigned int i;=0A=
>=0A=
>   	lockdep_assert_held(&blkg->q->queue_lock);=0A=
>=0A=
> @@ -767,8 +767,7 @@ struct blkg_rwstat blkg_rwstat_recursive_sum(struct b=
lkcg_gq *blkg,=0A=
>   			rwstat =3D (void *)pos_blkg + off;=0A=
>=0A=
>   		for (i =3D 0; i < BLKG_RWSTAT_NR; i++)=0A=
> -			atomic64_add(atomic64_read(&rwstat->aux_cnt[i]) +=0A=
> -				percpu_counter_sum_positive(&rwstat->cpu_cnt[i]),=0A=
> +			atomic64_add(blkg_rwstat_read_counter(rwstat, i),=0A=
>   				&sum.aux_cnt[i]);=0A=
>   	}=0A=
>   	rcu_read_unlock();=0A=
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h=0A=
> index 76c61318fda5..06236f56a840 100644=0A=
> --- a/include/linux/blk-cgroup.h=0A=
> +++ b/include/linux/blk-cgroup.h=0A=
> @@ -198,6 +198,13 @@ int blkcg_activate_policy(struct request_queue *q,=
=0A=
>   void blkcg_deactivate_policy(struct request_queue *q,=0A=
>   			     const struct blkcg_policy *pol);=0A=
>=0A=
> +static inline u64 blkg_rwstat_read_counter(struct blkg_rwstat *rwstat,=
=0A=
> +		unsigned int idx)=0A=
> +{=0A=
> +	return atomic64_read(&rwstat->aux_cnt[idx]) +=0A=
> +		percpu_counter_sum_positive(&rwstat->cpu_cnt[idx]);=0A=
> +}=0A=
> +=0A=
>   const char *blkg_dev_name(struct blkcg_gq *blkg);=0A=
>   void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,=0A=
>   		       u64 (*prfill)(struct seq_file *,=0A=
>=0A=
=0A=
