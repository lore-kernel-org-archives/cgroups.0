Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED535208D9;
	Thu, 17 Sep 2026 16:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662711; cv=none; b=hlXvjQku5qisPHmbU6lXTw1iwzpO6ouPHev4PPvvpuvKVtmKLEv5r5O603EIJPehU60YXaBmMP3kMzRoyDhIHSHTn23bqj7RbNJVyGpFZToiLKeyUYzfsMnab/fIMlqkdzeXy9oEyHCtI4ZNr4bGlbrw53wPehYfV1JWe9/PAFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662711; c=relaxed/simple;
	bh=0To77VH1BvxXlwP0fOQpNPmA0GzBaW2FlPdaU1r/PME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6BOPAu0OpLto3n4uEA1BLqDupLU2pwd5Cr+YzfTTJE2jioe58hifs24xWROqhi+IsY4mQkHTIbHvKtMpV2kyVoDpNsSbLaSZRXaM0xgR4VD/0keuYAmLAsygABtBSSzirRXQoC99/BcCY0uQ6YQcmfMAh/qKkfFrx9bP10B6Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h7YRASXZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h7YRASXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DD61F00893;
	Thu, 17 Sep 2026 16:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662710;
	bh=MNrVdq8SN12rH480qe2VVLnJrb/VvlyGe2h6LGmcApU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h7YRASXZKPWHByFdQ1iXCJGWVds9T3xZm/7V9v0s90TxkmTKJSWZIMT9GoXtDlmxX
	 yNQxcyaBVrLRJQtvdh9tPfDllW+Y7XLcPajjU/lr6cK7p9KLWXI7VF2xJeW3BMgNhF
	 tiMSwtBCHzq0Vi/7CLQUBxtFdYxkjbGGJwWzjKp/n6ibIAibyjNvFzwVXKz0BAuusl
	 yx1Yb0IfMxUOvbTipfUDz5+S2aj7TO0FUIfwROOfn0l11btj2eRKALOyhOf8PjCjQ6
	 JcSFGGpTYtlSu3BJbja9ngadPercgSux+EyCkxr5m6Jd/OjJ8kP5NFp+ABtX6qLVYF
	 cihLtODG88ZDA==
Date: Thu, 17 Sep 2026 06:31:49 -1000
From: Tejun Heo <tj@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev,
	riel@surriel.com
Subject: Re: [PATCH] blk-cgroup: skip rstat flush for cgroups without blkgs
Message-ID: <aqwV9cjg7Yj2OtBG@slm.duckdns.org>
References: <20260917161020.4139163-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917161020.4139163-1-usama.arif@linux.dev>

On Thu, Sep 17, 2026 at 09:10:20AM -0700, Usama Arif wrote:
> Non-root io.stat reads flush the blkcg rstat subtree before walking
> ->blkg_list. This takes the subsystem rstat lock and checks for pending
> updates on every possible CPU, even when there is no per-device state to
> print.
> 
> Blkg creation is hierarchical. A descendant blkg implies an ancestor
> blkg on the same device, so an empty ->blkg_list means the subtree cannot
> contribute any output. Return early in that case.
> 
> A concurrent first blkg may be deferred to the next read. This is
> consistent with the existing non-atomic flush and list walk.
> 
> This is not rare: 340 of 969 io.stat files were empty on a 316-CPU host.
> In a 16-vCPU lockdep-enabled guest, the median

Can you please test on a kernel w/ lockdep disabled? It doesn't make much
sense to compare performance numbers with lockdep enabled.

> open/read/close time over 35 batches of 20,000 reads changed as follows:
> 
>                          before     after
>   empty io.stat          49.1 us   41.0 us
>   populated io.stat      49.9 us   50.2 us
> 
> This is a 16.6% reduction for empty reads. Populated reads were unchanged
> within measurement noise.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

That said, I don't see any downsides:

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
