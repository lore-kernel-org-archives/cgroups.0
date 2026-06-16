Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893572F1FEA
	for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 03:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781579289; cv=none; b=IiK+GcvwtX80EoBbvz6XkdaSyq+oZuVdcZrm5ASG0r8RBn4ezouA37FNNvNnvU93YTgGeoIGxbygCMX5ARS039McWJ+PwhLxWy9qTWH/Yqn4d9JrL3xCi5jeEITpbMAxemyw8P3BAWH8ct5XQRiNhQ5cGSFWxFXA6kSscnpElLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781579289; c=relaxed/simple;
	bh=EZBobUkQ5DMy/8Pix2l+oYy9kG8Wf/37Fu+HbrijHNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bwJKB/V5U+Qgg5wYsvk1vLcLdQ8GI7ovoxzPOeCu1JNPFeENkM81dvzg6E34wwSSlP2CCReFhHYV6QYafeSYlhcBoOqUwKMJK0ldA4du14TpETix7lgsa3phC/54TTRVEVDbKlx+TYeTKAp+K6qO3AjvtB3Yf5Xz+y9s59DFqMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 16 Jun 2026 12:08:04 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 16 Jun 2026 12:08:04 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Hao Jia <jiahao.kernel@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org,
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev,
	Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org,
	chengming.zhou@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org,
	kasong@tencent.com, baoquan.he@linux.dev, joshua.hahnjy@gmail.com,
	youngjun.park@lge.com
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
Message-ID: <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
References: <aictKA0XWMWbxFdN@linux.dev>
 <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330>
 <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev>
 <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev>
 <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330>

...
> - "zswap tier only": Only zswap is allowed. Fallback to other swap is
>   blocked.
> - "zswap writeback disabled": zswap is allowed, but if zswap_store()
>   fails, pages can still fall back to other swap devices.

Upon double-checking the code, my previous clarification was wrong.
You are right. Sorry for the confusion. "zswap tier only" is indeed
equivalent to "zswap writeback disabled".
(I'm not sure why I read the code that way...)

As I initially thought, it might be possible to replace the zswap writeback
control with the tiering mechanism.

If we need to keep the existing interface, we can integrate or share the
underlying logic (though the specific details need more thought anyway).

It can be summarized as follows:

- "zswap tier only" + "zswap writeback disable" -> meaningless (noop)
- "zswap tier only" + "zswap writeback enable" -> meaningless (no writabck backend exist)
- "zswap tier with other tiers" + "zswap writeback disable" -> uses only zswap
  (can be replaced by "zswap tier only". This code could be intergrated, modified or something.)
- "zswap tier with other tiers" + "zswap writeback enable" -> works as is

As mentioned in the previous email, the zswap tier on/off control comes as a
bonus (though, as you pointed out, we may need to discuss if it's actually
needed).

BR,
Youngjun
