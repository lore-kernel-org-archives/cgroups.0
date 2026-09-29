Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752DF386C17;
	Tue, 29 Sep 2026 00:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790642546; cv=none; b=aVzkweuNHp4TxN8m94YBvEe1sKCggZXViIKNUb8SZyAoowEmiNy14yl4lEKXgERWkTmi5k9xTUMAMHYzd0YsokoN8oq3ht5if2KoZYNeLphQy/Y9lPX1FGGl4CVw2KVgZ5GILij4gV225MBuykPRGholcxpqdKHvpv3XDyMDTRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790642546; c=relaxed/simple;
	bh=S9xPAU/9/TKIf6DgBdZhMLcz2QhAmyPlTKG+BECZji4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fAlIb+OLD+J5YyE9Hh2Ays6uTENJt6fZXiqcVBlBmqODDVnymA+9wJwtIDDtfY1vCkKfF3CBWFu20xowHJ8vMOTcwx+YVh+beC32iwU5FhTl6QIQ9a3h1hpL6v1m38N4X2DrBXDD8RtQ7kCvFG7XwAzFFE6eGvHntNtEekIfDaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZnlEW6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZnlEW6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BBE1F00898;
	Tue, 29 Sep 2026 00:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790642544;
	bh=ZSkuFme1leGMg1COAGhFiRyunbh28v3KGifLjAR+V7s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bZnlEW6hDCC0qhf2Df3A+4KYxgsloJMp2cghtj4Zl4YDXBep7rfOBipzv4z/XKb7g
	 1ZsUmkk7wWzsFoYxnIdxoHkL9uSQvqBTmYQnBbdBdh5Lax9NSzd5vN3kFy4yBcicem
	 EYFiDPL2XacWkURHY+7kYGSk29PFwKQWecyhTuXjpn8hLPUypZRgGqLaQ1I7l7sohz
	 yX5TK4ooH4WaqAQ8J7sh6BPPtKATbM7ay/4ouCS/azCpCIAL7ZBoUiz2I6uPRZDxoq
	 mKxO3z/pcrkp4bIFAyH0IKHEIpjsW+g7JquhYF+pu+t0EHAhNWLttTKkeIBQQmas4Z
	 IZehZPghSATbA==
Date: Mon, 28 Sep 2026 14:42:23 -1000
Message-ID: <4af70c48e8c7d1eac1425d368be92dcb@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v7 3/4] blk-iocost: add iocost_ioc_tick tracepoint
 for per-period device summary
In-Reply-To: <20260924054549.2271705-4-cui.tao@linux.dev>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
 <20260924054549.2271705-4-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Tao.

On Thu, 24 Sep 2026 13:45:48 +0800, Tao Cui wrote:

> +	trace_iocost_ioc_tick(ioc, nr_active, usage_us_sum,
> +			      ioc->period_us, ioc->vtime_base_rate,
> +			      ioc->busy_level, ioc->running,
> +			      now.now - ioc->period_at);

These are still passed in. Can you pass only ioc, &now, nr_active and
usage_us_sum and read the rest from ioc in TP_fast_assign() like the
other iocost events do?

Thanks.

--
tejun
