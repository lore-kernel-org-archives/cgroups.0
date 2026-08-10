Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565673793BF;
	Mon, 10 Aug 2026 18:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786387860; cv=none; b=VgkgRzId1TCQWGhafqq/q676OahlJtX5YoLh7x7C3BKRap7aC/7ynEImKGL1HskB2cubvQXK/t+5l7YoBUWQMYXQ6C0A6nHz4M/TkMEs1qaRKJNiOgm6KBb+mVcUrhYTmRmExm6f6u3CvQrSpbwieIsyO7/j5rssTQgbR6DeTyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786387860; c=relaxed/simple;
	bh=3Zw9wU81RyPWTeoFC8OUN+I81RWlM6c+ubyCdDUkMfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvRyCHOqRWdFU8dlhf8AcXNe9FWcz6aivo7xqLYjsyLJ5/g+pwxRrswsaD2UrdJv1EucfunxE0/ovSYBx1BUD0yneHhHAzrKJvJ4DY97g1HaDQ8PhZz/AsgY3dE6ilNJho5R5Bu3oqjb+k/FQNZJpSRrKMerI9ANiosTofE/rZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dnqOppQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dnqOppQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFBF1F000E9;
	Mon, 10 Aug 2026 18:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786387858;
	bh=dXxGU1gfavW+fBsQ0TYTzr6e/Ch8i6VLsSGQhqNBGnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dnqOppQLC0TaQirgoHK+54j67C7VZzZtahfD04fXz16BUr94ts7h5Gh38+ubUZCKE
	 jA4Arn4rgTnq7I/791ibpAsQZDD9R2UFz2ol6muYvC5fmOei4/b4Lxu3qGP/8WoCq4
	 GfdVVqixln81RSjiS58NPbAzmi5hsNC5Adwy6+Uve+MpVIW5vEiKey1OsiTZuQU6pq
	 B4dru1rajCfoTnUL7XJBcBfKkc+Rk5DZUqocvIZBnVAg/0nU+TYc28HlbgEgfRJY1R
	 xProwYtFQkV9YUp84Re88SW2L/IJfImK9RKSh4MhgSrzURHPE8/ZUntcGpGoPKKNI0
	 J+iHD22gJqnvg==
Date: Mon, 10 Aug 2026 08:50:58 -1000
From: Tejun Heo <tj@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
	kernel-team@meta.com
Subject: Re: [PATCH 2/3] blk-iocost: clear delay state when freeing policy
 data
Message-ID: <anodkhEpanZPbwxu@slm.duckdns.org>
References: <20260806183742.946953-1-usama.arif@linux.dev>
 <20260806183742.946953-3-usama.arif@linux.dev>
 <0326caea-07e7-43bf-8fe9-f2b97186e2ad@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0326caea-07e7-43bf-8fe9-f2b97186e2ad@linux.dev>

> Does this unconditional call to blkcg_clear_delay() overwrite state managed
> by other policies?
> 
> Since use_delay is shared among block cgroup policies, if iocost never
> actually applied a delay, this might forcefully zero out the delay state
> managed by other active policies like blk-iolatency. 
> 
> Would it be safer to check if iocost had actually set a delay before clearing
> it here?

Yeah, this is fine. The two mechanisms aren't usually used together and even
when they step on each other, use_delay being cleared spuriously is
transient and nothing really breaks.

Thanks.

-- 
tejun
