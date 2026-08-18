Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCE93AD522
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 15:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787065723; cv=none; b=QhnwmSW8ltzFCxjIeednRgfhuAnyCqJ5rLMK0kF7VY0RlZpN24jaCBMh1gdmS8iAh0SdxxD3WgadAw0Ve7tzAVyuTs0GhRZC+Qs7E7w4m/M59YHwCw57kw22LnJIbk1bOj3mHJNPVPmiE8Q8UaSLua9EaMx/rkamjkGyaHPtQCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787065723; c=relaxed/simple;
	bh=0FsRmWGrp3IBrt0AhnQA/jZLSq4jcxcIf2nihiOFFb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BmPgna8a+KAZr/pJD6OIVChvMjs9DlR2XL2CjNm/AP+lxsknNUGsgD+dxRfFqMq5+8gRxM6cUnmrbdJT7bLv4kXQZ3iDYA+jybYbSgnjUiVZsLD8OIm+/h/xkC8f49Akgi5cTKHwn7B7Y5MkLkKRamI19Y2YmsfCiVNfj5/mwLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MtXo2V57; arc=none smtp.client-ip=91.218.175.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MtXo2V57"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0FsRmWGrp3IBrt0AhnQA/jZLSq4jcxcIf2nihiOFFb4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787065719; v=1; x=1787670519;
 b=MtXo2V57bPU+QFfVBvnqEoE5Qm1/MW2gFIUDa46SiFiPpmxo8DEEhCxLhdlSbJFHRYOUjyq4
 SPbLVqSCHkkeEmkTeISoFUz8peDQ4gar4l2GE5WFGa1bwHgH3+wkkphxC1GUYD5Ys+5i1ASERsD
 4L0VwfqGtlCrzJbNiNhMsQPU=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:59::)
	by smtp.migadu.com with ESMTPS id e04d93166a86feda;
	Tue, 18 Aug 2026 15:08:39 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 08:08:37 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Joy Chaoyue Xiong <joyxiong@yahoo.com>
Subject: Re: [PATCH] memcg: trim the per-cpu charge stock instead of draining
 it
Message-ID: <aoR1ClkKofp0l9Cs@linux.dev>
References: <20260817234651.666540-1-shakeel.butt@linux.dev>
 <aoQt2zKsQT-rvjd6@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoQt2zKsQT-rvjd6@tiehlicka>

On Tue, Aug 18, 2026 at 12:03:07PM +0200, Michal Hocko wrote:
> On Mon 17-08-26 16:46:51, Shakeel Butt wrote:
> > Joy reported that an application generating a request/response traffic
> > pattern spends 44.6% to 57.0% of CPU in the memcg charge/uncharge path
> > for a range of message sizes, against 0.27% to 0.71% outside that range.
> > Running from the root memcg, where socket memory accounting is skipped,
> > recovers the performance.
> > 
> > Tracing the charge path showed that the application generates a pattern
> > where the write syscall charges one page and the read syscall uncharges
> > two pages on the same CPU. This hits a corner case in the memcg percpu
> > stock code that thrashes the stock continuously.
> > 
> > In the memcg percpu stock code, MEMCG_CHARGE_BATCH (64) is both the high
> > watermark and the emptying target, i.e. on a request to charge one page
> > the kernel charges MEMCG_CHARGE_BATCH pages and caches
> > (MEMCG_CHARGE_BATCH - 1) of them in the percpu stock. The following
> > uncharge of 2 pages takes the cached count to (MEMCG_CHARGE_BATCH + 1),
> > and refill_stock() then empties the cache completely. With such a
> > pattern the percpu stock becomes completely ineffective.
> > 
> > Instead of a single boundary point for charges, use the technique the
> > page allocator uses for its own percpu caches, which keeps the watermark
> > and the emptying target apart: nr_pcp_free() frees between batch and
> > high - batch pages, leaving at least pcp->batch on the list. Add a high
> > watermark MEMCG_STOCK_HIGH and, once the cached count goes over it,
> > return only the pages above MEMCG_STOCK_LOW. The watermarks are
> > MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a full
> > batch. Peak cached pages per memcg grows from 64 to 96, the same
> > high-versus-batch tradeoff the page allocator makes.
> 
> The idea is sound. I would just not increase the overall stock size in
> the same patch. Fine tuning can be done independently and ideally with
> some numbers.
> Would it make sense to start with MEMCG_STOCK_HIGH := MEMCG_CHARGE_BATCH 
> and  MEMCG_CHARGE_BATCH := MEMCG_CHARGE_BATCH / 2. That would preserve
> the maximum stock size while preventing all or nothing behavior which is
> indeed suboptimal and pushing charging path to a slower path way too
> aggressively.
> 
> WDYT?

Yes, this makes sense. Let me run the experiment with that workload to make sure
the newer number works and resend the patch.

Thanks for the review.
