Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20AC29BDAA
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 15:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783957851; cv=none; b=trkkQI9eIQvmwIcNrUJcr/27SG5DPsvZ71slgDkAkW1bccIhzaj59j/wzd7EM0HciPdCNlbj2fhfZu5JPSUjwFs/WquMV8lGynh3C+E7hClVJ53a4Ai0Q7SlNZhfqVhUszxK2oB6Uq7AppJpJphTMBUSIwc87f8mZp/M36IJBgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783957851; c=relaxed/simple;
	bh=lrTE/jBqsGUQGv5y+i6RrpN7GtTt/dRfzjiCSeWXts4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gxbF98Ld/NUuv3qnoijzl9uAHkmLaBDSboXew+ZDJ1fS7BHVCZ0xPqFB7cMFdW/j88qqmWxA8oOyyXck61NVCQG2g6oYhU90UcHgJi39ElxKjhG5SQTJLhvm9B3vQ5FQbQzHf5h5Yl/San62vldAxxsAxwyH74wSiPwX+O2G7Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.52 with ESMTP; 14 Jul 2026 00:20:45 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 14 Jul 2026 00:20:45 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 14 Jul 2026 00:20:45 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, yosry@kernel.org,
	joshua.hahnjy@gmail.com, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 2/6] mm: swap: associate swap devices with tiers
Message-ID: <alUCTVQSVH/gPbjo@yjaykim-PowerEdge-T330>
References: <20260713025644.170839-3-youngjun.park@lge.com>
 <20260713142856.102257-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713142856.102257-1-usama.arif@linux.dev>

On Mon, Jul 13, 2026 at 07:28:53AM -0700, Usama Arif wrote:

> >  #endif /* _SWAP_TIER_H */
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index ff567ad893a4..f3cff586cf30 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3041,6 +3041,8 @@ static void _enable_swap_info(struct swap_info_struct *si)
> >  
> >  	/* Add back to available list */
> >  	add_to_avail_list(si, true);
> > +
> > +	swap_tiers_assign_dev(si);
> 
> Could we move the assignment before the device is added to the active and
> available lists?
> 
> After patch 4, swap allocation checks si->tier_mask while holding only
> swap_avail_lock. But here the new device is added to swap_avail_head
> before swap_tiers_assign_dev() initializes its mask.
> 
> That creates a small window where reclaim can see this swap_info_struct
> with a stale tier_mask. swap_info_struct instances are reused across
> swapoff/swapon, so the stale mask can come from the previous device that
> occupied this slot. A memcg allowed to use the old tier could then
> temporarily allocate from the newly enabled device even if that device
> belongs to a different tier.

Hello Usama. 
Thanks for the review!

Good catch! You're right.
the device becomes visible to swap_alloc_slow() the moment add_to_avail_list() drops swap_avail_lock, 
before the mask is assigned. 

Will move the assignment before the list insertions in v11.

Youngjun
