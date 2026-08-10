Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388F243B484;
	Mon, 10 Aug 2026 18:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786387732; cv=none; b=CcICsoMv1HKitDhmEj63gmMLFqVvl1gGl+/uWihNOdokEam4VnMdcNU3L7f6DOPNi86s7vJhaWBSopS2RVKolbg2s5eMG91c6Rlqb68KddIyOhJ65DAIf5+yWKBrEpTa1k28Oi179bwJKCTx1cvVLEP8Fo4fx4pdlNBSmtcZ5JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786387732; c=relaxed/simple;
	bh=uBRmXQFLgdKK/MTBwM8X9x67hc98yk3UROqZjFzGsMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvGZUobFhgoW0E+yHK2hBEA27y4PtxWkVV+KgypeAjQZfsjTwnr+mhsIptiKbeAzain9yYUfCWzNoxxSdLvbeGiMAAFr1KwDJZCF7xIlHPSvXHDMylshDmsGeaKYuc00lhm3E1OqxCFbMY6Z2aHjN/ddK6HVB5cLd+PxpPmkJIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D8V3hYeK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D8V3hYeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22301F000E9;
	Mon, 10 Aug 2026 18:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786387731;
	bh=uQfmLOJQ19ya/6r87qxWkDXGteQRiFiLQqu8zDkt3Kw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D8V3hYeKd7VzxAe/3BbHrv9qxwione39dXoSpNTc7iOYZXDFSrAbsp3PjpkFsqzBj
	 j06sa14+cC8dlKxS4obOVwXMxHrvOIjVGeISPTz2N7HVaJvNqQkYrkjv5sB8YgDhnE
	 lxI9MhFGnsfJjvz8ooNso05mbEPNk/yUDjHuhg1bifyT33O+ucpZbp9+rmcBL93vf4
	 S1883+B7YZVEyl81l6EfbF0PlYuyyMZFf5crVTK4T1GnMfkyfOtsMZbk2Qj2LZD1Tq
	 bQmLZ2Ddo4HafpXeIRV0mOJ0v1fCQY9pdFcz1MnYzggUdIbAddJMemjTogqQfypYVu
	 fKC6tQHMLdRyQ==
Date: Mon, 10 Aug 2026 08:48:49 -1000
From: Tejun Heo <tj@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
	kernel-team@meta.com
Subject: Re: [PATCH 1/3] blk-iolatency: clear delay state when freeing policy
 data
Message-ID: <anodES1Ht7shMCTr@slm.duckdns.org>
References: <20260806183742.946953-1-usama.arif@linux.dev>
 <20260806183742.946953-2-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806183742.946953-2-usama.arif@linux.dev>

On Thu, Aug 06, 2026 at 11:37:18AM -0700, Usama Arif wrote:
>  static void iolatency_pd_free(struct blkg_policy_data *pd)
>  {
> +	struct blkcg_gq *blkg = pd_to_blkg(pd);
> +
> +	/*
> +	 * Groups throttled as collateral have min_lat_nsec == 0, so
> +	 * iolatency_pd_offline() leaves their delay set.  Drop it here, where
> +	 * no in-flight bio can re-arm it via check_scale_change().
> +	 */
> +	if (blkg)

When can blkg be NULL here?

Thanks.

-- 
tejun
