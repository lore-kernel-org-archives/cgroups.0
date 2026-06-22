Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6FE2D0C89
	for <cgroups@vger.kernel.org>; Mon, 22 Jun 2026 05:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782106399; cv=none; b=MHikr3TNv0bniIQmSE7agiMZrNmxJ0SGI29NuVqUL2Mx+FGGIiuRF7H80GRIkZ0UlmGSspAjQXd8LeqvD29l4p2Zi+DnD/scqm1MPmesuXoTy5swoO08Xuj4FdgJe9tXe3gcDIeRvxVOQExKQ7vTmw34IV2Md7Hy2IlIyaocNug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782106399; c=relaxed/simple;
	bh=dvuVZU3b3GFeoDmdsdia2z0DnArkjvhWJGfEkeEP+Lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qjixwd53LhXPFLmSKvK9On3+J6169KppeV/dK4nLB1nPQtxDMSWY99weV+stO6U04y7iGn+Rcs8L+4UwXsK5s4zib3QyH1wHp51NYG9HGBHK0pK/Rplgc97ao7os+3I80DBQJiwG7Ng3uj0wtX5qk4b+9JogqPjRtSFVgREXtAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.52 with ESMTP; 22 Jun 2026 14:03:13 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.154)
	by 156.147.1.121 with ESMTP; 22 Jun 2026 14:03:13 +0900
X-Original-SENDERIP: 10.177.112.154
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 22 Jun 2026 14:03:13 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Youngjun Park <her0gyugyu@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	baoquan.he@linux.dev, baohua@kernel.org, yosry@kernel.org,
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com,
	mkoutny@suse.com, baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier
 selection
Message-ID: <ajjCEWN6IwNJLv4j@yjaykim-PowerEdge-T330>
References: <20260620181635.299364-1-youngjun.park@lge.com>
 <20260620181635.299364-4-youngjun.park@lge.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260620181635.299364-4-youngjun.park@lge.com>

https://sashiko.dev/#/patchset/20260620181635.299364-1-youngjun.park@lge.com?part=3

Regarding the Sashiko review comment, I don't think this needs to be
fixed. It is acceptable for the effective_mask to be stale on a zombie
memcg.

The zombie memcg LRU is already reparented by the following patchset.
https://lore.kernel.org/all/cover.1772711148.git.zhengqi.arch@bytedance.com/

the effective_mask is only needed on the swap path. Since
swap I/O rarely (if ever) happens on a zombie memcg, leaving the stale
mask should not cause issues.

(As I mentioned above, there is no need to fix as I think.
But somehow if we needed to fix this, there would be two alternatives.

1. Fix it at offline time by setting it to SWAP_TIER_ALL_MASK. However,
   this approach would break the parent tier relationship.
2. Change the memcg iteration routine to use css_for_each_descendant_pre
   to explicitly handle the zombie memcg case. This approach would
   safely preserve the parent tier relationship.
)
