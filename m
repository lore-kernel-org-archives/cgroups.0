Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98FB49620;
	Sat, 19 Sep 2026 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789829993; cv=none; b=NMQkumBmntsAINkYvwto3PZ6Tj7GP5PAvSgMUmhI6cBuUepBi3OOtY9LPBOQNMeimlJEdWlh4z/GouPFPXmg5djzVE4f6/zzMuDxQQroUQQtxDMFyjFLMU6YtGt0jGwJCK6SoeVB6CJDTEb3xxtgkMxqTI/HeJdnIfAmnXG7BRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789829993; c=relaxed/simple;
	bh=b/5TyoQZRO0ss3L7pu5A+OLk7BdID+zAINyTKYHt3Ro=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=MgjbhgxqZo/764fiJVXYCyx1bASfCAAeIT3I3A5B2mZkyYpTt7PO9nAmW1UOwuch6hY5+23WGMxoLoQcVlhX2TSWrYMypM6nef118TvvFcII3B1uXGKqHsbTiKdMY2Ib9nUhhe75wy6O5xzHz+rKh/Ow0IEkq63GBDOVdqyaOEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOrpF/Zi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOrpF/Zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349381F000FF;
	Sat, 19 Sep 2026 14:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789829992;
	bh=G6UrRUnwPk27soo9sZRN/gCGVOcIjOkGOc/TAsrOnY0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IOrpF/ZigHHog3C08bzBhLbtwm1SJhgCNCIl3mir+4sI4sNg+SaaDVWwczkKfwvFI
	 6IXfXoLGwPVIctpTQY3DRWeq79VldceApGlMbPlL0KRXdUmvLWCfjpxNYKNCFdPMY7
	 oB3valLF7zlr0ZVoauMcku/0WaHtLEBBlQv7+UIKpWAr+er03hCXQntwIRKiNhJkUj
	 vwvQpQnELUmPF7Xs9cagvwlssCMzaBe1/w59K6fmpIP+zVLYF02bvQFiEVFErRHQzI
	 jPyIcURzoy6arA28k4apN6yM+amt4VIo/9y0mIQGKlfGop9vwGCF84oGKLw8x45XSW
	 y2OH2e6Gy5KTA==
Date: Sat, 19 Sep 2026 04:59:51 -1000
Message-ID: <9575357186118be214d6377dd80a21e8@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: Josef Bacik <josef@toxicpanda.com>,
	josef@toxicopanda.com,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/4] blk-iocost: charge flushes as pageless random
 writes
In-Reply-To: <20260916085304.1080271-2-cui.tao@linux.dev>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
	<20260916085304.1080271-2-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Tao.

On Wed, Sep 16, 2026 at 04:53:01PM +0800, Tao Cui wrote:
> Charge the flush component of any REQ_PREFLUSH bio on top of its data
> cost, priced as a pageless random write (LCOEF_WRANDIO), which provides
> an approximation of the device time consumed by a flush.  For profiles
> where WRANDIO clamps to zero (ssd_dfl / ssd_fast), use a one-page floor
> (LCOEF_WPAGE).

Pricing a flush as a random write, or as a page where that comes out to
zero, is as arbitrary as pricing it at zero, and it changes what existing
setups get charged. 013adcbef165 ("blk-iocost: skip empty flush bio in
iocost") zeroed them because the flush machinery coalesces flushes and the
write coefficients don't say anything about what a flush costs.

Can you instead add the flushiops parameter you mentioned in the v1 thread
to the linear model? A flush costs VTIME_PER_SEC / flushiops, and zero when
the parameter isn't set, including in the builtin profiles, so nothing
changes until it's configured or the profiles are regenerated with a flush
measurement.

The same charge should cover REQ_FUA the way the flush machinery does: one
flush for PREFLUSH, and one for FUA on a device without FUA support, which
is when a post-flush gets issued.

Please also drop the Fixes tag on this patch. With the parameter, this is
an extension rather than a fix.

Thanks.

-- 
tejun
