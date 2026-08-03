Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E3433937F;
	Mon,  3 Aug 2026 16:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785775649; cv=none; b=tJ7mtykIXbadT1agaktetrty2bLuRMCNgH94Midg4sMkgkhSg00zEdZIQc2gbTz5NAZLeLuMVESR1ej2pvzYIsmu49MBU7P08nJ/iBrkNtCHaeW0NHdM2bxOjeM4PTTCsOaQWGMI4mHggapa7i769f+GNMQoB6CGPeocTfcclrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785775649; c=relaxed/simple;
	bh=XaVgAirKIyKl8+QLIHE8n5rKN2g/v4X+DJNO+ye/eIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qE9rFzCJiyuypqZmgsdacV1ZEt+nly7F3a8VCnD650H/QE7ls4a5KGu090Hvy9fPR8Vft9eIOnXL3Xin1CiUAeYd4boTiORVOPCxLTIOuFR3q8KX4TMtGfj74oDjeIsPLpl+i1rJpAbX//gSMHp3HMNjaLjvP/dHqeLJFbJIIpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E05zH6BF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E05zH6BF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273611F000E9;
	Mon,  3 Aug 2026 16:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785775648;
	bh=jfuUCDNY0N9WBoJMJ3KO7FB3Ftw45T6HsMOdvvVFVj4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E05zH6BF3SpEQuAI3Ii1PsAuT+DRR4mPjY/3wMn28rf1OC4+9cRxcQ5feC6e+K8+B
	 9C9vZ3IxITIPD7qq8Atn1Of+D2xh53WGF9vE50QN/cDyRjwv+90MFmCaYpC5Lp+cEU
	 c/j9PblPJIznLBA5hfve+Drx0k2RvC5OUynSjwAtjyT3Lhr9c3m2s84kqCilhp2geF
	 HhMO+P+BOy/ld64kj4X2T2VvICfO/LGWPwnuG3uET7wrjZtsL9PUoumFucjikYn92r
	 YvEXU0P5Bw/Qen51JS9ufE8Bc3mDzIyVBjD1N6n6jTc8YU9/LSV7Qoure+hZqMqSGY
	 ksCdZg2BlTfXA==
Date: Mon, 3 Aug 2026 06:47:27 -1000
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: axboe@kernel.dk, josef@toxicpanda.com, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v2] block/blk-iocost: read ioc_pd_stat params inside
 ioc->lock
Message-ID: <anDGH6An5b_HI8pj@slm.duckdns.org>
References: <20260803132201.135355-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803132201.135355-1-cui.tao@linux.dev>

On Mon, Aug 03, 2026 at 09:22:01PM +0800, Tao Cui wrote:
> @@ -3092,9 +3092,12 @@ static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
>  {
>  	struct ioc_gq *iocg = pd_to_iocg(pd);
>  	struct ioc *ioc = iocg->ioc;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ioc->lock, flags);
>  
>  	if (!ioc->enabled)
> -		return;
> +		goto out;
>  
>  	if (iocg->level == 0) {
>  		unsigned vp10k = DIV64_U64_ROUND_CLOSEST(
> @@ -3110,6 +3113,8 @@ static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
>  			iocg->last_stat.wait_us,
>  			iocg->last_stat.indebt_us,
>  			iocg->last_stat.indelay_us);
> +out:
> +	spin_unlock_irqrestore(&ioc->lock, flags);
>  }

There's nothing in this function that requires synchronized reads. Might as
well just annotate them with data_race(). Otherwise, this can lead to a lot
of lock operations when there are a lot of cgroups and high frequency stat
reads.

Thanks.

-- 
tejun
