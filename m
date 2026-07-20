Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05490442FBC
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 17:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567144; cv=none; b=Pi/QCR3myVMqOMYXi1el24VqUJwQCfsLdJn7KdyO8TQJvrTfdD+AKlDrV3sCKdzWMcMcuZlmnKK/lcgEly1eNePhwIXaNz1wKNxA1RJCPgNZ1yTVp7Ic8pmjJkY2OBzKzLmVTwN7ZWXaqN3dW+1O49i2vLNGUBgh04aus3Z7xnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567144; c=relaxed/simple;
	bh=EPHXgE92OZtwrusVZTpJimPa6PHp1mjxA6Q2dzygXUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DUmZjBJ6c06aHANt+kTOk1w+wECMC3DNesp5/jU054ud36WEu1c1K+Z9r5x9HOC5lrE/9oc4OZ1uZC+p7EL2nJ+jT3i7QkZrrJP6aWUfYli+J0Jkq7qBDUsj5ru7Y3jbuF0FP/hUHElR+6d5i/NbtwS1Eexb/50JgbQz3OYqobE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FO5m1tKv; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FO5m1tKv"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-80c5cb9a888so87528547b3.3
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 10:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784567138; x=1785171938; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GqlMGabo3ObXGmn0thsIH4WBoZJD0hx7su/ezzAUMj8=;
        b=FO5m1tKvKY/aP9evleF+whRzKapro7xwpXTfGXXNFizkcZTJJYzjp7TrdtyJpzms44
         wEGW2ZSDLx2S2MiuDVvCk8mnjw/9LYB7guNFDmTc98T6KeIw5Zkd/f66x21agGOP8vry
         PovdbWeDQP3x+5VmgeCTa6UGAq4ANHuXSzvk6csHEpJNYDqFVYt6l9G+cAfj8RDzIunb
         Su7DWx3/CycylC+5AaLNtrwMDvbYMDdFmLddLDVLrsVdtcwiczCMsbgYdwLtlx4XtWdi
         3GILtvxicmAALWa0xztdyfuSXYXS0w/qc0ANr5jAvgXxedXmG7ptBY0fwtDISIKwezA1
         y9qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567138; x=1785171938;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GqlMGabo3ObXGmn0thsIH4WBoZJD0hx7su/ezzAUMj8=;
        b=kCAaWhHAFbQdD+iUS+y4bdr57373XFqCWa2ETMjJe9XaxzGlCm9Q8k0uCN8lx9HK1e
         Gr18o4PtN5apduzb5XdXQPKAqnzPoIRZcqzUtGgARSeaCmzyVnvTlYlhvZLRERZhpEAm
         hqA9AFwmZh25FFcBDO82un1MLeYEO6+oETPFVpuEyThRFw9vT9+rB/idL7xLSwAvdITl
         1Y0/Si/ufYkgargMs8yEee8V4YYK/2giWYZXwrXJJ3qFbOVHS7stkdBDAOey7+sSEX+W
         5v3G/yOjRpMmHPbrU/8WqT7D+10WrqiwSgsqGLvh9WxuIDUZEtp/8iYho+i86vrVHSKE
         8yrg==
X-Forwarded-Encrypted: i=1; AHgh+RqyyOCFpxU1EQLuvGRjFg69mUZP2p4PA37E8X0O9s5EY4mgLhRw8aUNEENXdGJ4RO1NkQl15FxP@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4t1RDBO5e/8vVy+Mwlac2uEDHy0L2lU1N+c301+B30ANs/zLt
	uQsodHD2tlc869cLKF0kYoEp4Ti2oBpIog7Tl6gbzTDUuBaigZ7eoj7h
X-Gm-Gg: AR+sD13yfIOQ+Tw+/5rp/NL0NU2po3iIyVs2w8kEGDcLXPbpkTzGC4EOgBvTD3S4WIq
	sPMNDCidTyaBz3sSOjDmxDGY/JD5/imjdOT20sExlVmv3Ue1tusJYqf6TeihuyD4Ywwn1jexMjy
	QTtVkyAR//z0MHA9AN1WuYTvkh3r8arSa/sMa2fiH3pdM0yyNx5GCrDy6V3gq34eJYT37DL0Mx8
	qKlyfQElCHkYIjpImt773s3NU1cch43C20QjGDWcEQXsfiNkx40193AGZWA+DTUBLCJPorIO0V2
	tmQM9IzVF94hcRuCe18dlZpfEg7UgAoEGpZHPGI4XKVvUYzhD6WXiu+qmnPxY6UHaAA6ruktTR8
	5XWTlJJmCYEyuyTtmmBU5f4bq5mPf17HWt2qLHtlY9anoGW44tUOCfnX3jc73DFEKzCThfcxhCO
	5IN9P2+7GpT3QcBlqc5IJO
X-Received: by 2002:a05:690c:4b0a:b0:80c:5ce9:8f1a with SMTP id 00721157ae682-81ef27f1ccbmr48967227b3.34.1784567137799;
        Mon, 20 Jul 2026 10:05:37 -0700 (PDT)
Received: from [192.168.0.23] ([210.10.76.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81ef4034901sm53073037b3.12.2026.07.20.10.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 10:05:37 -0700 (PDT)
Message-ID: <296cbf18-86da-4c1b-832d-a27a78881dd8@gmail.com>
Date: Tue, 21 Jul 2026 01:05:31 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block/blk-stat: fix mean loss when re-summing aggregated
 stats
To: Tao Cui <cui.tao@linux.dev>, Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Omar Sandoval <osandov@fb.com>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
References: <20260720133813.45150-1-cui.tao@linux.dev>
Content-Language: en-US
From: Tang Yizhou <tangyeechou@gmail.com>
In-Reply-To: <20260720133813.45150-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/7/26 9:38 pm, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> blk_rq_stat_sum() folds src into dst but only advances dst->mean and
> dst->nr_samples, leaving dst->batch untouched.  The mean is computed
> from src->batch (the raw per-cpu sum), so a stat that has already been
> through one sum carries batch=0; if that aggregated stat is then used
> as the src of another sum, its samples add nothing to the new mean.
> 
> iolatency hits exactly that: iolatency_check_latencies() first sums the
> per-cpu stats into a local stat, then sums that local stat into
> iolat->cur_stat.  After the first sum the local stat has batch=0, so
> every later window drives cur_stat->mean toward zero.  On non-SSD

Good catch, this is indeed a real issue.

> devices it stays at 0, making the latency_sum_ok(&cur_stat) check that
> gates scaling up always true -- the scale-up hysteresis is effectively
> defeated.  SSD devices use the percentile path and are unaffected.
> 
> Keep dst->batch in sync across sums so an aggregated stat can be reused
> as a src.  blk_rq_stat.batch is internal to blk_rq_stat_init/_add/_sum
> (no other reader in the tree), so the wbt and blk-mq consumers, which
> only read ->mean/->min/->nr_samples, behave as before.
> 
> Fixes: 34dbad5d26e2 ("blk-stat: convert to callback-based statistics reporting")
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> 
> ---
>  block/blk-stat.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/block/blk-stat.c b/block/blk-stat.c
> index de126e1ea5ac..4d4781350083 100644
> --- a/block/blk-stat.c
> +++ b/block/blk-stat.c
> @@ -36,6 +36,7 @@ void blk_rq_stat_sum(struct blk_rq_stat *dst, struct blk_rq_stat *src)
>  	dst->mean = div_u64(src->batch + dst->mean * dst->nr_samples,
>  				dst->nr_samples + src->nr_samples);
>  
> +	dst->batch += src->batch;

This change doesn't actually fix the issue. As you already found, the local
stat's batch is 0. Also, according to the comment of blk_rq_stat_sum(), @src is
a per-CPU stat, so there is no issue in blk_stat_timer_fn(). Your change would
actually make this case look strange.

-- 
Best Regards,
Yi

>  	dst->nr_samples += src->nr_samples;
>  }
>  
> --
> 2.43.0
> 

