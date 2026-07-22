Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743562288D5
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 06:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784701164; cv=none; b=VBisKohNILttj1RbB43d2sGCHQ5qelSXBW3LXpGBgQ0TdavjVvGZGKffa6oLnp+dU5tsl0tPWtMSuwfvGgXz/ITvEGQgKJTBPif2U5jl2nma5YkPYfHVaIEssN09Duf4YF5lJiL0Hq/LXdGvwOs+YPKUoMqCCMLWebfnDkwSuCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784701164; c=relaxed/simple;
	bh=GGiX++7YAUJeyvCrXZm01phSETb13inLegYM7jjxggU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3z0Qd0rIDDxOZNJiwgAsgr1PhFY83Cu9gq8v45qnbZ2tTFmvMlYIfuMIz1C6DhpFzmNpDDjSNoQ9UvR1fal4N2aTB2+exrr9AT+yd0ys894FbCRl2ySq5q6MsrRIfwoMvBbYg08P2RlDGgMfmhRQsITpb6KsZiS6pQZlPtxfw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oiJXS3Rv; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oiJXS3Rv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784701150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sBd1yNpCs6DEPDiy6QcCkhl56XpCygWXGY0ZmzMftW8=;
	b=oiJXS3RvBmLpkZ70nE/CNG3Ili7NzzGOWR5nSd9eF7xCldoEix/xiKw9+pfYK9hOcCjz3X
	O4ccwmjZPXzo0kzzBonMYDy5a3aLhVhFyCz+onuvBBKWrbERF2RPPXYSfndNWIAHNquZ+t
	WLcVpTGTZYjXE56y+jkUHpkmCw4XzSY=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	hongfu.li@linux.dev,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Subject: Re: [PATCH] mm/memcg: check kzalloc_node() return in memcg1_init()
Date: Wed, 22 Jul 2026 14:18:26 +0800
Message-ID: <20260722061826.43420-1-hongfu.li@linux.dev>
In-Reply-To: <20260721171351.ec213c13afab38b89c14f849@linux-foundation.org>
References: <20260721171351.ec213c13afab38b89c14f849@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

> >  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
> > +		if (!rtpn)
> > +			continue;
> >  
> >  		rtpn->rb_root = RB_ROOT;
> >  		rtpn->rb_rightmost = NULL;
> 
> Thanks.  We assume that mamory allocations cannot fail within __init
> code.  Because if they do, the kernel has some ghastly problem and it
> cannot possibly run.

Understood, thanks for the clarification. I'll drop this patch.

Best regards,
Hongfu
