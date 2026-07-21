Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D7F399892
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 02:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784601394; cv=none; b=HWdB9+4JalkM4TwU5h30wNDsJMKTKPnUp5Z0ERpBPl+q/H3KgJkC++5OUfqA8zVmkL99zcGRUmFXIBiNrSoZEGPMLnmIhdFvyO4+f74TbQAmDtTT/L0Bmf7PiQ1YFMUpokoylpyU5ielVrIh9lDPgcqA8Qd+7Q5NeBtw0wdBlSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784601394; c=relaxed/simple;
	bh=Bcjr36qrjeZHprXpCoFh09aHa4pmC9UiEgqz8uIuQIo=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YFQMa31SwTpNV7NTdQAbg/PTb8RQLrIuI1LtgGHR7dO1chCUOkHLsOnRTu/hnxPh/jxd8uYzZJI/EWvvGz9I0enXBCKXFPFK3rmMTZWDcbkJE3g/V2ZOXX0BsgVmr2HbzAFkUsupySF5YmPXJ80PDHkY7bXAwT0jwUzlynvJO9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CY648WXk; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CY648WXk"
Message-ID: <49b87018-952e-4ec1-8c23-833c2cd88f3a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784601380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=467IXcSrQPHtgxAsAnztPpkNUe8fIE7pYnj4OHkNsPU=;
	b=CY648WXk+9vKwceZJHsEunWBv/fzxPZHGrpCsKsCm9uBO+al8efDiGzwEatlYRfxGQiguq
	lnXN6VPZE2AUPzeYXPza0LTj4yXiSFK5mz6sskH0AMmdu67UCYQpcFDSnef6OUlpdcr5N+
	0G3YFTs6DS3lHAHyxE/Da+KAd/4NKxM=
Date: Tue, 21 Jul 2026 10:36:14 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Tejun Heo <tj@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Omar Sandoval <osandov@fb.com>,
 Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] block/blk-stat: fix mean loss when re-summing aggregated
 stats
To: Tang Yizhou <tangyeechou@gmail.com>, Jens Axboe <axboe@kernel.dk>
References: <20260720133813.45150-1-cui.tao@linux.dev>
 <296cbf18-86da-4c1b-832d-a27a78881dd8@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <296cbf18-86da-4c1b-832d-a27a78881dd8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/21 01:05, Tang Yizhou 写道:
> On 20/7/26 9:38 pm, Tao Cui wrote:
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> blk_rq_stat_sum() folds src into dst but only advances dst->mean and
>> dst->nr_samples, leaving dst->batch untouched.  The mean is computed
>> from src->batch (the raw per-cpu sum), so a stat that has already been
>> through one sum carries batch=0; if that aggregated stat is then used
>> as the src of another sum, its samples add nothing to the new mean.
>>
>> iolatency hits exactly that: iolatency_check_latencies() first sums the
>> per-cpu stats into a local stat, then sums that local stat into
>> iolat->cur_stat.  After the first sum the local stat has batch=0, so
>> every later window drives cur_stat->mean toward zero.  On non-SSD
> 
> Good catch, this is indeed a real issue.
> 
>> devices it stays at 0, making the latency_sum_ok(&cur_stat) check that
>> gates scaling up always true -- the scale-up hysteresis is effectively
>> defeated.  SSD devices use the percentile path and are unaffected.
>>
>> Keep dst->batch in sync across sums so an aggregated stat can be reused
>> as a src.  blk_rq_stat.batch is internal to blk_rq_stat_init/_add/_sum
>> (no other reader in the tree), so the wbt and blk-mq consumers, which
>> only read ->mean/->min/->nr_samples, behave as before.
>>
>> Fixes: 34dbad5d26e2 ("blk-stat: convert to callback-based statistics reporting")
>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>>
>> ---
>>  block/blk-stat.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/block/blk-stat.c b/block/blk-stat.c
>> index de126e1ea5ac..4d4781350083 100644
>> --- a/block/blk-stat.c
>> +++ b/block/blk-stat.c
>> @@ -36,6 +36,7 @@ void blk_rq_stat_sum(struct blk_rq_stat *dst, struct blk_rq_stat *src)
>>  	dst->mean = div_u64(src->batch + dst->mean * dst->nr_samples,
>>  				dst->nr_samples + src->nr_samples);
>>  
>> +	dst->batch += src->batch;
> 
> This change doesn't actually fix the issue. As you already found, the local
> stat's batch is 0. Also, according to the comment of blk_rq_stat_sum(), @src is
> a per-CPU stat, so there is no issue in blk_stat_timer_fn(). Your change would
> actually make this case look strange.
> 
You're right. blk_rq_stat_sum() is contracted on a raw per-cpu src,
which blk_stat_timer_fn() honors; the actual misuse is iolatency
feeding an already-aggregated stat at blk-iolatency.c. I'll drop
the blk-stat.c change and fix it on the iolatency side — merging
cur_stat with the per-window stat by their reconstructed totals, since
both already carry a valid mean. Will send a v2.

Thanks,
Tao

