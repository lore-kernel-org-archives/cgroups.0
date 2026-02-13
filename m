Received: from sg-1-38.ptr.blmpb.com (sg-1-38.ptr.blmpb.com [118.26.132.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99061DFF0
	for <cgroups@vger.kernel.org>; Fri, 13 Feb 2026 12:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770985003; cv=none; b=GZuO00VzZYZ+RdDo7G4jC5y12WZNggHlWKRGV7WcIijObKRy+Dvlm9CIz2aatxfBnyTpXhshplSogagrdJEaNXnjCcqfC0Kgs1gwis/X4BeyPsE0i+e0Xd0EzOPwDGjjiRurQoiOesaUyQ3iE9UY3Ijiw0Xou9+OmVIMB/Ki+2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770985003; c=relaxed/simple;
	bh=8BOPUJXdT1Uq2jAk6U10qem0VUu6RTkzIwVnaOs/vls=;
	h=Date:Mime-Version:Content-Type:Cc:From:Subject:Message-Id:
	 References:In-Reply-To:To; b=CLOlt/WZ/f/XS4CZfmG07w4uMPaba0A+3eDhYO8/1HsX0rcE/sVcguVgry6mon58+M0js+4thWbsYYHIY7rW9f9USvk09rMLZUiFqAxa+qA++BDilNP731eWcfGG3hr6LTsBkqHI6U7LZ1j8Atc/nCZ1mbwZAn1+q6THXdLqM9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=wzo12CmF; arc=none smtp.client-ip=118.26.132.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="wzo12CmF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770984874;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=b95/Hc1Ad3/2DWW2NhMINHRr9RRhdcM+jCuygQAatLo=;
 b=wzo12CmFQqNNvLFH8xd0l+MbI/OH62QFCRUf1FEhyRQRqZJgTmXyl3qONM/qs0QJFaVZ1z
 Z4WiRrFGNVG+geQrXUsWnm53D6SzOX8nLRnWsWTWV6Kx/TOhhHdJ8Arnb4AxCo0EFs+FNK
 MOs9KXY41aDfgRTOEbaZKUfUhYiAhVEdvIlOUKUZWRlPlV8trGbiu3w2PisbjCyb0MIArQ
 912qSMoqzEExcT5dGKfcuR2yuPXEjtp7m8YaEyAyLMR3M+x4NlspyVw0ONY+ZbLWg6VUZc
 fl0YobQSgkfOs51DYDVJ3ptEhvDyvlWSRIB319qu9bHtcDZmITTW/+hcmOXSEQ==
Date: Fri, 13 Feb 2026 20:14:28 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+2698f15a8+0af009+vger.kernel.org+yukuai@fnnas.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fnnas.com
Cc: <lianux.mm@gmail.com>, <cgroups@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [RFC PATCH] blk-iocost: introduce 'linear-max' cost model for cloud disk
Message-Id: <890f2571-fb46-4ff2-b7ea-7cfa10bc8797@fnnas.com>
References: <20260213073829.182168-1-wjl.linux@gmail.com>
In-Reply-To: <20260213073829.182168-1-wjl.linux@gmail.com>
To: "Jialin Wang" <wjl.linux@gmail.com>, <tj@kernel.org>, 
	<josef@toxicpanda.com>, <axboe@kernel.dk>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.132]) by smtp.feishu.cn with ESMTPS; Fri, 13 Feb 2026 20:14:31 +0800
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/2/13 15:38, Jialin Wang =E5=86=99=E9=81=93:
> In public cloud environments, block devices usually enforce performance
> limits based on two independent token buckets: IOPS and BPS. The device
> is throttled when either the IOPS limit or the BPS limit is reached.
>
> To effectively manage "noisy neighbor" problems, we configure iocost
> model parameters (or vrate max) to approximately 95% of the cloud
> provider's provisioned limits. The goal is to strictly avoid hitting
> the storage backend's hard BPS/IOPS limits. By saturating the virtual
> budget before the physical limit, iocost engages throttling first.
> Unlike the indiscriminate throttling applied by cloud storage backends,
> iocost selectively penalizes low-weight cgroups or heavy-traffic
> perpetrators. Consequently, IO-latency-sensitive critical workloads
> remain entirely unaffected by the congestion. Extensive testing has
> verified that this approach yields excellent isolation results.
>
> However, the existing 'linear' cost model leads to significant
> performance loss in this specific configuration due to its additive
> nature.
>
> Using tools/cgroup/iocost_coef_gen.py, we measured the following
> performance data on a typical cloud disk:
>
> 8:16 rbps=3D173471131 rseqiops=3D3566 rrandiops=3D3566 wbps=3D173333269 w=
seqiops=3D3566 wrandiops=3D3559

Feels like a model similar to blk-throttle will work fine with your IO work=
load,
what you really want is blk-throttle absolute threshold and blk-iocost rela=
tive
throttling, correct?

>
> Dividing BPS by IOPS (173471131 / 3566) yields approximately 48607
> bytes. When running fio with bs=3D48607, we observed a 50% drop in
> throughput compared to running without iocost enabled.
>
> The reason is that the current 'linear' model calculates cost as:
>
>    Cost =3D BaseCost + (Pages * PerPageCost)
>
> Expanding the internal variables relative to IOPS and BPS, this is
> effectively:
>
>    Cost =3D VTIME_PER_SEC * ((1 / IOPS - 4096 / BPS) + size / BPS)
>
> When the I/O size is such that the IOPS cost component roughly equals
> the BPS cost component (as in the bs=3D48607 case above), the linear
> model sums them up. Since cloud disks throttle based on *either* IOPS
> *or* BPS (whichever is exhausted first), summing them effectively
> doubles the calculated cost. This causes iocost to drain virtual time
> twice as fast as necessary, throttling the device to 50% utilization.
>
> To solve this, this patch introduces a new 'linear-max' cost model.
> Instead of adding the components, it takes the maximum:
>
>    Cost =3D VTIME_PER_SEC * max(1 / IOPS, size / BPS)
>
> Which translates to:
>
>    Cost =3D max(BaseCost + PerPageCost, Pages * PerPageCost)
>
> This formula correctly models the dual-bucket behavior of cloud disks.
> It ensures that for any block size, the calculated cost aligns with the
> actual bottleneck (IOPS or BPS). This allows the system to reach close
> to the provisioned BPS/IOPS limits without premature throttling, while
> still maintaining the latency protection benefits of iocost.
>
> Signed-off-by: Jialin Wang <wjl.linux@gmail.com>
> ---
>   block/blk-iocost.c | 21 ++++++++++++++++++---
>   1 file changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index ef543d163d46..ead478d8e5bc 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -445,6 +445,7 @@ struct ioc {
>   	int				autop_idx;
>   	bool				user_qos_params:1;
>   	bool				user_cost_model:1;
> +	bool				cost_model_linear_max:1;
>   };
>  =20
>   struct iocg_pcpu_stat {
> @@ -2565,7 +2566,12 @@ static void calc_vtime_cost_builtin(struct bio *bi=
o, struct ioc_gq *iocg,
>   			cost +=3D coef_seqio;
>   		}
>   	}
> -	cost +=3D pages * coef_page;
> +
> +	if (ioc->cost_model_linear_max)
> +		cost =3D max(cost + coef_page, pages * coef_page);
> +	else
> +		cost +=3D pages * coef_page;
> +
>   out:
>   	*costp =3D cost;
>   }
> @@ -3368,10 +3374,11 @@ static u64 ioc_cost_model_prfill(struct seq_file =
*sf,
>   		return 0;
>  =20
>   	spin_lock(&ioc->lock);
> -	seq_printf(sf, "%s ctrl=3D%s model=3Dlinear "
> +	seq_printf(sf, "%s ctrl=3D%s model=3D%s "
>   		   "rbps=3D%llu rseqiops=3D%llu rrandiops=3D%llu "
>   		   "wbps=3D%llu wseqiops=3D%llu wrandiops=3D%llu\n",
>   		   dname, ioc->user_cost_model ? "user" : "auto",
> +		   ioc->cost_model_linear_max ? "linear-max" : "linear",
>   		   u[I_LCOEF_RBPS], u[I_LCOEF_RSEQIOPS], u[I_LCOEF_RRANDIOPS],
>   		   u[I_LCOEF_WBPS], u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS]);
>   	spin_unlock(&ioc->lock);
> @@ -3412,6 +3419,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_o=
pen_file *of, char *input,
>   	struct ioc *ioc;
>   	u64 u[NR_I_LCOEFS];
>   	bool user;
> +	bool linear_max;
>   	char *body, *p;
>   	int ret;
>  =20
> @@ -3442,6 +3450,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_o=
pen_file *of, char *input,
>   	spin_lock_irq(&ioc->lock);
>   	memcpy(u, ioc->params.i_lcoefs, sizeof(u));
>   	user =3D ioc->user_cost_model;
> +	linear_max =3D ioc->cost_model_linear_max;
>  =20
>   	while ((p =3D strsep(&body, " \t\n"))) {
>   		substring_t args[MAX_OPT_ARGS];
> @@ -3464,7 +3473,11 @@ static ssize_t ioc_cost_model_write(struct kernfs_=
open_file *of, char *input,
>   			continue;
>   		case COST_MODEL:
>   			match_strlcpy(buf, &args[0], sizeof(buf));
> -			if (strcmp(buf, "linear"))
> +			if (!strcmp(buf, "linear"))
> +				linear_max =3D false;
> +			else if (!strcmp(buf, "linear-max"))
> +				linear_max =3D true;
> +			else
>   				goto einval;
>   			continue;
>   		}
> @@ -3481,8 +3494,10 @@ static ssize_t ioc_cost_model_write(struct kernfs_=
open_file *of, char *input,
>   	if (user) {
>   		memcpy(ioc->params.i_lcoefs, u, sizeof(u));
>   		ioc->user_cost_model =3D true;
> +		ioc->cost_model_linear_max =3D linear_max;
>   	} else {
>   		ioc->user_cost_model =3D false;
> +		ioc->cost_model_linear_max =3D false;
>   	}
>   	ioc_refresh_params(ioc, true);
>   	spin_unlock_irq(&ioc->lock);

--=20
Thansk,
Kuai
