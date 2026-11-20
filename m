Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795141161;
	b=PLNYdvZk2lm8R4tk6h0TVAqnyPpFXnXD5LAzyNhx0lL3+NooQ2Pz8Iymh5vQG9EWSw21
	 fyaN52uOiIDPsLv9B9RBPFoKOlGNPxvJMd0OHpFmVNsC0AjHl05mu6j+uXf12//zaCXn+
	 1CplPsd1vCjhHv/T2aX+/mC5hNX+l9yu6w+irVmDu3hM2Rojj9ZdkZvCdJn04/2GYY/vq
	 ywlAulC/6CroXbg2bKYcWXqdvQOcRr2br1Fi3RSm9g/9QcZFHksM21dPZwvBk8SSVqDV8
	 xaOwG4w9m8F6JCcYLqwWTuY1/9c4OcNFzb1OrveAvqaDQZYOMAlPbDk7eNY70TY4H/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795141161;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=balcmbgSpngESIblTghqrlh1o6Z7H9I2czbvxRW+eu4=;
	b=IcJsDI7zomXc8FYl/HFqnyN9jmE+PbLaiodSpzky5j4zQTtcjB3ZPr52lAk6Xa7b/rg3
	 1SXbP2wuyBb46OX5NXIqrghDk6/hZUsZ1iNsXIfI7fRhd9/vcQKqDHtvPD3jalXH5vizH
	 w/KxMIEGDLTH5xRhCOLeG4g98KiAubiwS7MyccbeMNy0fEqOQSbq5wRL+OF3ICL+7WRCP
	 1dw1wJL6QFRta8t53U5LvVeD84cTtPmt3adAuwxhFwmXpizVesed3XQqSt9zVL6LmIkWJ
	 HkcTlP5fSwvJxu7a35yVbKCOkTOL7Ue4a90AFbhizoqTA8jDoixVZ6MMp4Oth99MCbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="MR/dMGwa";
	arc=none smtp.remote-ip=115.124.30.112
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B64606A325;
	Fri, 20 Nov 2026 02:19:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30B64606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=MR/dMGwa
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795141151; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=balcmbgSpngESIblTghqrlh1o6Z7H9I2czbvxRW+eu4=;
	b=MR/dMGwaCsgx+VVcAlok9BPme62AcQRT5o25JY6ClvhchH7KSo2JNXCuZ9mpO1dOj4JtPhwaMm41JHQBFEJhC2BUpqqs322lLmYazJSZHwNejaQQiklalesnMr3sFZCdBYja7NsMXl7N5mS4zNm7cGAmNhsFqITnh2D6z8pn+04=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XF5-vtZ_1795141149;
Received: from 30.178.67.37(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0XF5-vtZ_1795141149 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Nov 2026 10:19:11 +0800
Message-ID: <856407d2-db33-4c1d-a5c9-2ba7e0053ad4@linux.alibaba.com>
Date: Fri, 20 Nov 2026 10:19:09 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] block/blk-iolatency: fix always-zero cur_stat mean on
 non-SSD
To: Tao Cui <cui.tao@linux.dev>, Jens Axboe <axboe@kernel.dk>,
 Tang Yizhou <tangyeechou@gmail.com>
Cc: tj@kernel.org, josef@toxicpanda.com, linux-block@vger.kernel.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, cuitao@kylinos.cn
References: <20260904065426.1281914-1-cui.tao@linux.dev>
From: Guixin Liu <kanie@linux.alibaba.com>
In-Reply-To: <20260904065426.1281914-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/4 14:54, Tao Cui 写道:
> From: Tao Cui <cuitao@kylinos.cn>
>
> iolatency_check_latencies() accumulates the per-window latency stat
> into iolat->cur_stat via latency_stat_sum(), which for non-SSD devices
> calls blk_rq_stat_sum().  But blk_rq_stat_sum() is contracted on a raw
> per-cpu src: it folds src->batch into the new mean.  By the time the
> per-window stat reaches cur_stat it is already aggregated, with batch
> left at 0.  Each window therefore contributes zero latency to
> cur_stat->mean, which on non-SSD devices stays at 0; the
> latency_sum_ok(&cur_stat) check that gates scaling up is always true,
> so the scale-up hysteresis never engages.  SSD devices use the
> percentile path and are unaffected.
>
> Add latency_stat_merge(), which merges two already-aggregated stats by
> their reconstructed totals (mean * nr_samples) instead of src->batch,
> and use it only for the cur_stat accumulation; the earlier per-cpu sum
> keeps latency_stat_sum(), whose src is still raw.
>
> Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Ti Tao:
  Would it be better to change the fix tag to "451bb7c33197 ("blk-iolatency: keep track of previous windows stats")"?

Best Regards,
Guixin Liu
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>
> ---
> Changes in v3:
> - Rebase onto current linux-next head (no code change).
> - Verified with a two-kernel QEMU run (virtio-blk forced rotational,
>   cgroup v2 io.latency target set below the achievable latency so the
>   scale path runs every window): on the unpatched kernel cur_stat->mean
>   stayed 0 across all windows while the per-window mean was 120-250us;
>   with this patch cur_stat->mean tracked the per-window mean.
>
> Changes in v2:
> - Move the fix from blk-stat.c (blk_rq_stat_sum) into blk-iolatency.c,
>   per Tang Yizhou's review: blk_rq_stat_sum() is contracted on a raw
>   per-cpu src, so the aggregated-stat merge belongs in the iolatency
>   caller, not the shared helper.
>
> v1: https://lore.kernel.org/all/20260720133813.45150-1-cui.tao@linux.dev/
> v2: https://lore.kernel.org/all/20260721030312.85655-1-cui.tao@linux.dev/
> ---
>  block/blk-iolatency.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
> index 2caa79a008ad..853608a4f187 100644
> --- a/block/blk-iolatency.c
> +++ b/block/blk-iolatency.c
> @@ -216,6 +216,31 @@ static inline void latency_stat_sum(struct iolatency_grp *iolat,
>  		blk_rq_stat_sum(&sum->rqs, &stat->rqs);
>  }
>  
> +/*
> + * Merge an already-aggregated @stat into @sum by reconstructed totals
> + * (mean * nr_samples); blk_rq_stat_sum() reads src->batch, which is 0
> + * here. The overflow check also rejects the 0 samples case.
> + */
> +static inline void latency_stat_merge(struct iolatency_grp *iolat,
> +				      struct latency_stat *sum,
> +				      struct latency_stat *stat)
> +{
> +	if (iolat->ssd) {
> +		sum->ps.total += stat->ps.total;
> +		sum->ps.missed += stat->ps.missed;
> +	} else {
> +		if (sum->rqs.nr_samples + stat->rqs.nr_samples <=
> +		    sum->rqs.nr_samples)
> +			return;
> +		sum->rqs.mean = div_u64(sum->rqs.mean * sum->rqs.nr_samples +
> +					stat->rqs.mean * stat->rqs.nr_samples,
> +					sum->rqs.nr_samples + stat->rqs.nr_samples);
> +		sum->rqs.min = min(sum->rqs.min, stat->rqs.min);
> +		sum->rqs.max = max(sum->rqs.max, stat->rqs.max);
> +		sum->rqs.nr_samples += stat->rqs.nr_samples;
> +	}
> +}
> +
>  static inline void latency_stat_record_time(struct iolatency_grp *iolat,
>  					    u64 req_time)
>  {
> @@ -547,7 +572,7 @@ static void iolatency_check_latencies(struct iolatency_grp *iolat, u64 now)
>  	/* Somebody beat us to the punch, just bail. */
>  	spin_lock_irqsave(&lat_info->lock, flags);
>  
> -	latency_stat_sum(iolat, &iolat->cur_stat, &stat);
> +	latency_stat_merge(iolat, &iolat->cur_stat, &stat);
>  	lat_info->nr_samples -= iolat->nr_samples;
>  	lat_info->nr_samples += latency_stat_samples(iolat, &iolat->cur_stat);
>  	iolat->nr_samples = latency_stat_samples(iolat, &iolat->cur_stat);

