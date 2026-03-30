Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B7D2E7F39;
	Mon, 30 Mar 2026 19:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774898390; cv=none; b=IjuUM1o9okIj7YVhrQZxOl1kdEn51GEaSZAxou0cgwQ+AsHlVBxxkol5+QlQtz8D89cflfPNB/Z/3Kv9IgA/7rfBDCfBDdaaW0SGJ29FCqK2y/79wJXHEfFHteL+QYf150h56ID1RcuiVyJDcv/9WQZ115j0MPIYLezZM84cGxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774898390; c=relaxed/simple;
	bh=NLN4B0QKOWxfBXyIB5tDGLs8NtO4h2lpKdqF1WtP6F8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dUL5R0X+05sAhYWh40YUGIwrv7IjVBMYN2wOo1QEpYMggrAhekTFOXPzIuUhcGbiDkRHaqdiV6MtZzu0f3jFxMyZtgrkqWQFva5XpE/SH8+Leo4Rbi0s56VG/ErfryIPn1uJfXjQE4CzcZRE93uM9FXHvPAvehs+tg01kVmgaak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZZDNDHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZZDNDHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEEDC2BC9E;
	Mon, 30 Mar 2026 19:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774898390;
	bh=NLN4B0QKOWxfBXyIB5tDGLs8NtO4h2lpKdqF1WtP6F8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dZZDNDHnZ5ePqOrSilfXtXOnOTTHHqy924nmjDI9vnBB+AnNTbHz/NoIoguDOmI0/
	 SHG1aI1Fkj0IhaFIcLYbp4GEP1qJ85w7VO8sZVm+fyuXShiVCOVKfxMX6kUmJyG5iW
	 5FsiC9uvTJBZoNTqEDrWnm5eFC1DSvMt7L6mUww2MehgGz8BwlbSzOV3sB96Sg7wZJ
	 /kblLz+sQyXhAXd/6NjympkUBvLCJV6yeELRuRVliwWVRL+bXsWzSwt2CDPlnhs7Tm
	 Ed6bEUYS4WfPtBVZzQcI4MfUARoj5l1Zp5u5ySWy9+814L8C084vqQS2T6SfmzQfXT
	 /+ML101RUQxTQ==
Date: Mon, 30 Mar 2026 09:19:49 -1000
From: Tejun Heo <tj@kernel.org>
To: Jialin Wang <wjl.linux@gmail.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] blk-iocost: fix busy_level reset when no IOs complete
Message-ID: <acrM1flqKQlcONbL@slm.duckdns.org>
References: <20260329154112.526679-1-wjl.linux@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329154112.526679-1-wjl.linux@gmail.com>

Hello,

On Sun, Mar 29, 2026 at 03:41:12PM +0000, Jialin Wang wrote:
...
> Before:
>   CGROUP   IOPS   MB/s    Avg(ms)  Max(ms)  P90(ms)  P99      P99.9    P99.99
> 
>   cgA-1m   167    167.02  748.65   1641.43  960.50   1551.89  1635.78  1635.78
>   cgB-4k   5      0.02    190.57   806.84   742.39   809.50   809.50   809.50
> 
>   cgA-1m   166    166.36  751.38   1744.31  994.05   1451.23  1736.44  1736.44
>   cgB-32k  4      0.14    225.71   1057.25  759.17   1061.16  1061.16  1061.16
> 
>   cgA-1m   166    165.91  751.48   1610.94  1010.83  1417.67  1602.22  1619.00
>   cgB-256k 5      1.26    198.50   1046.30  742.39   1044.38  1044.38  1044.38
> 
> After:
>   CGROUP   IOPS   MB/s    Avg(ms)  Max(ms)  P90(ms)  P99      P99.9    P99.99
> 
>   cgA-1m   159    158.59  769.06   828.52   809.50   817.89   826.28   826.28
>   cgB-4k   200    0.78    2.01     26.11    2.87     6.26     12.39    26.08
> 
>   cgA-1m   147    146.84  832.05   985.80   943.72   960.50   985.66   985.66
>   cgB-32k  200    6.25    2.82     71.05    3.42     15.40    50.07    70.78
> 
>   cgA-1m   114    114.47  1044.98  1294.48  1199.57  1283.46  1300.23  1300.23
>   cgB-256k 200    50.00   4.01     34.49    5.08     15.66    30.54    34.34

Are the latency numbers end-to-end or on-device? If former, can you provide
on-device numbers? What period duration are you using?

> @@ -2397,9 +2400,29 @@ static void ioc_timer_fn(struct timer_list *timer)
>  	 * and should increase vtime rate.
>  	 */
>  	prev_busy_level = ioc->busy_level;
> -	if (rq_wait_pct > RQ_WAIT_BUSY_PCT ||
> -	    missed_ppm[READ] > ppm_rthr ||
> -	    missed_ppm[WRITE] > ppm_wthr) {
> +	if (!nr_done) {
> +		if (nr_lagging)

Please use {} even when it's just comments that makes the bodies multi-line.

> +			/*
> +			 * When there are lagging IOs but no completions, we
> +			 * don't know if the IO latency will meet the QoS
> +			 * targets. The disk might be saturated or not. We
> +			 * should not reset busy_level to 0 (which would
> +			 * prevent vrate from scaling up or down), but rather
> +			 * try to keep it unchanged. To avoid drastic vrate
> +			 * oscillations, we clamp it between -4 and 4.
> +			 */
> +			ioc->busy_level = clamp(ioc->busy_level, -4, 4);

Is this from some observed behavior or just out of intuition? The
justification seems a bit flimsy. Why -4 and 4?

> +		else if (nr_shortages)
> +			/*
> +			 * The vrate might be too low to issue any IOs. We
> +			 * should allow vrate to increase but not decrease.
> +			 */
> +			ioc->busy_level = min(ioc->busy_level, 0);

So, this is no completion, no lagging and shortages case. In the existing
code, this would alos get busy_level-- to get things moving. Wouldn't this
path need that too? Or rather, would it make more sense to handle !nr_done
&& nr_lagging case and leave the other cases as-are?

Thanks.

-- 
tejun
