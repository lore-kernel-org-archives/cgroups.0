Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD8C36D510
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 15:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784908203; cv=none; b=sjIGccJ4K09uN9p0VMldKvI+7r3RI8f+gCjM31gb+g6J4DDx55anyjvZoV65wOQhjTpGWjF9/AiLzhdrExHJmmYzCwYJc3/o1Kh0utxEChOalhsOW1mgOwrX1UWOVFnuCPVigm8pBk5PDDJ6V2nrIOjIxrGwWz0K4t3mzka9A5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784908203; c=relaxed/simple;
	bh=Vu3RHRBkSxdfa6eq8UYpi+TZBknKkXYRRsM2C2QDvjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KjPg8gQUzjsbN0LZJpgg3Kk3AxU44XVn62CJVenkzzWC0X8oSfzpS8aD09tRdsYmxGaLp8M6Fom9p/i7AJKRa4HuLe9FERZYbM0fuVmc2hS/0Z7FG4F7dqm346kcP7OvIczBTrmTv5k0TjkFzavxt4pc9LVTi/TOYXGofUuP+58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AcwSQ5V3; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AcwSQ5V3"
Date: Fri, 24 Jul 2026 08:49:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784908198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=puy/lbx3gV07h+EH3SaehUGzAFW3ZFFm8DNCtKB+s9w=;
	b=AcwSQ5V3zO6db9OMqK62FzP9yQd9LWe6bfPiHIs4UBEzxfBSCHJN+F/plzJnvEcRBg8JUT
	x0t79OSyv5oH13OHSGeUgCwIc5/CZDR7rRTK+jOjkds4tezzCK8HSQt1wXX5RdpZN2LztE
	HNArZlMc1DUXpwLcli7YQbn6xcKl1QQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	kasong@tencent.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <amOJW_RmU0_4LL2J@linux.dev>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-3-usama.arif@linux.dev>
 <amK-ApfqfwkPheC5@linux.dev>
 <32a85420-caac-477e-b371-8628ed28c428@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32a85420-caac-477e-b371-8628ed28c428@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 24, 2026 at 02:29:23PM +0100, Usama Arif wrote:
> 
> > 
> > The patch looks good but I have one question. We already have concept of
> > pgrotated through /proc/vmstat which represents number of pages we have moved to
> > the tail of inactive LRU to make them next reclaim candidates. This patch is
> > exposing pgrotate_[anon|file] to userspace. Here these metrics represents either
> > the number of pages we scanned but didn't reclaim plus number of pages given one
> > more trip in the active LRU.
> > 
> > Older and newer pgrotate metrics kind of represent something different. It may
> > cause confusion. Now before suggesting to change the name, let me ask do we
> > really need to expose these to the userspace? How exactly users can use these
> > new metrics? I think you can use them here without exposing to userspace. So,
> > does it makes sense to delay userspace exposure later when we have a more solid
> > usecase for that unless you have it already.
> > 
> 
> I do think the userspace counters have diagnostic value. They can be another metric
> to show how much anon/file reclaim work is spent on pages that are not immediately
> reclaimed, including pages retained on actie LRU. It could help explain if there
> is elevated reclaim CPU usage.
> 
> But tbf, I don't have a concrete usecase, and I wouldn't put up a patch to expose
> them to userspace if it werent for this patch itself.
> 
> I definitely dont want to create another hidden lruvec rstat infrastructure for this,
> it would be too much code churn. If the stats really shouldn't be exposed to userspace,
> would something like below be acceptable?
> 

Yes, the code seems reasonable to me.

