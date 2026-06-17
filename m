Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F2631326F
	for <cgroups@vger.kernel.org>; Wed, 17 Jun 2026 06:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781677482; cv=none; b=Le1RSsyrAiSYRSII7IS3g+oMfuWr+5bY0wnn4l+TXpwF/DWvIbAA+GLLOqOPjmgNBRA8856BjCo0+nsytoLjrcjjdJUB2nGuDDLhcPPJxKCMG/y/Yhtu8cNXNRL/tDAgUo2J8n3adjlrehcEK6/7v3Uvn2NHLFnJ216xO8rdLvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781677482; c=relaxed/simple;
	bh=busgHP+z6JkzV9ZUJIF4qN+1v5HWMSreQkBoN89NFSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G4KAFZmE+GXXIfLNofGBQ3OrUH/nZ7yhMJOQkurWka6TgX7mLqmN984/xalJSUnOH3AlnaCUBlI5odp/BfCTVIUSckEvz5mXFzFjiGkNBfMLOiXxWNRz9EDGln0ofJn2GFX55VgyEVHELUUlL95b/NAiOOit844t9mWwHDwHDe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 17 Jun 2026 15:24:38 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 17 Jun 2026 15:24:38 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	baohua@kernel.org, yosry@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v8 4/4] mm: swap: filter swap allocation by memcg tier
 mask
Message-ID: <ajI9pmwrSXQarXBW@yjaykim-PowerEdge-T330>
References: <20260617053447.2831896-1-youngjun.park@lge.com>
 <20260617053447.2831896-5-youngjun.park@lge.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617053447.2831896-5-youngjun.park@lge.com>

https://sashiko.dev/#/patchset/20260617053447.2831896-1-youngjun.park@lge.com?part=4

Regarding the review from Sachiko.

The AI review pointed out two things. a pre-existing issue and a valid
issue regarding swap_sync_discard().

For the pre-existing issue, I believe it is out of scope to address it
together in this patchset.

However, the second point is a valid issue. For the case where
swap_sync_discard() discards a non-selected tier, succeeds, and then
retries swap allocation. I will fix this in the next version by
checking the memcg mask within swap_sync_discard().
