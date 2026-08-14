Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226363515D2;
	Fri, 14 Aug 2026 17:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786726929; cv=none; b=sW4/G8Orz2E53WUEyp7qBUL72lb4daD4hn4QWXllxUdu1rw3yOpD2dmoYJLGhjn0JzytaW3EF83WLoZHwHsx4ptGkomBtzvlzX5bshOoEkcBYD0Y5Px1s+7kqtz/TgyT2TPnoA308B4bvD/fxX1gvRyMeLxCryjZCWbOWJKFmHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786726929; c=relaxed/simple;
	bh=LC2xHaArLnHXvXk7dcIdnND+SlR/r89jqjEtJyTyfN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M7E+oGUXSCCl2Kx9tjYfklmG6B5Nysu5LJyUsuFc6mG7S50803VXlmIzXc3h8hpJtZQ8m+TLPnJCZVSagQ8vB9emHg2fRPyguKwmdTWfzo9mAxMlnVDWQAyZ7euM35N7aC42yBi7CkiS0usY2+vod8EpX01klO+PvuKvogLe2r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bMHIoMz1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bMHIoMz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCCF1F000E9;
	Fri, 14 Aug 2026 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786726927;
	bh=/kbSNyp17h1AJoDh7TL2L1+WBAOkVbYZ8iTm+X5pEyo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bMHIoMz1WWgkMyhJ6HnuhQLkFbMuzlK1Irets4jrEt5JolBjxhGvt4ypm7GVbUuI6
	 0WieuTdhhho7unjwiG+s4GxUvu9GaM9nhd42oxfNZ23hvUP+oLSliedViOLcFhCGwg
	 ltFDHazCEKyjEA3NyEvVsxofUgCOBEii+vc9XpxG+qIvr4XpiE0tRkmCFAesomLXuu
	 7nr9knyCqQ04EFcoSMicMOKaI/mGbs/VpkhTvhrx+VB2iW3jQNGPCLxHDHAN2fZ/eK
	 pn+9GoRufgwHiLXjqVkT7aItfk5umiBN8yASxZ+zO+BwWvo1yygMg+ZrHhy1r8lKE6
	 T7S1y5NPeLSLQ==
Date: Fri, 14 Aug 2026 07:02:06 -1000
From: Tejun Heo <tj@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
	kernel-team@meta.com
Subject: Re: [PATCH v2 0/3] block: skip the blkcg walk in
 blk_cgroup_congested() when nothing is throttled
Message-ID: <an9KDqdb9oUGwn7V@slm.duckdns.org>
References: <20260814165712.510132-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814165712.510132-1-usama.arif@linux.dev>

On Fri, Aug 14, 2026 at 09:56:36AM -0700, Usama Arif wrote:
> blk_cgroup_congested() walks the current task's blkcg ancestor chain on every
> readahead decision and, once swap is in use, on every anonymous and shmem
> folio allocation.  The answer is almost always "no", but finding that out
> costs two loads per level on two cold cache lines, plus an out-of-line
> kthread_blkcg() and an RCU read-side pair.  On a fleet profile of hosts
> running containers with 5-10 level hierarchies it costs about as much as all
> of mutex_lock(), 99.4% of it under __folio_throttle_swaprate().
> 
> Patch 3 gates the walk on a global count of blkcgs with a non-zero
> congestion_count, so the common case is a load and a predicted branch.
> 
> That only works if the count is correctly maintained, currently two teardown
> paths can leave a blkcg permanently marked congested.  Today that only hurts
> tasks in the affected cgroup, but it hurts them for the life of the cgroup -
> readahead cut to a single page, async readahead skipped, and a throttle
> scheduled on every anonymous folio allocation.  With a global gate it would
> cost every other task on the machine the walk as well.  Patches 1 and 2 fix
> those two paths and stand on their own as bugfixes; patch 3 depends on them.

For the series,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
