Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06053BE162
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 18:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787769360; cv=none; b=gQqMgQgOXCRITNHQvnOWLIi5Bhi+m+C8IO7UWz/wxkac4A4ymp80HUgJO7h7iZh5CyTRpAecawaDYqDXuGZ5UKzfKQ14JegLHnrkYzipZeuwdUhxHTITEGsHrx9n3feZhW3IMYHbrjJ2EZI4MAxJu3XO+30qti73fwzYN+KLN7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787769360; c=relaxed/simple;
	bh=ZyrhrAm7j38NGOmipO+o+kjkSYfh0FE7Hm9WXO5o6LA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4ulXfMJboCM//GSZSkGqsdeGW1X3qBig2deoz7Knm+WkYgiB+8DcV8N918b2DlXstU82oRj01oc3PeTvxnbJaUcRcgzH5tS4Xs2aL2b/I1XK0xW2mfmPRC14+OZiKkqbRc7dfnI6YyUdxDbFpHOYBVT+BnT4yCM/3f+mwz/TlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hhDrfRDY; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hhDrfRDY"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZyrhrAm7j38NGOmipO+o+kjkSYfh0FE7Hm9WXO5o6LA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787769346; v=1; x=1788374146;
 b=hhDrfRDYhKkfpSwP9PNCv6Uakdp4iyxNRK9IYGEw6fc0T9fBe+6KkcbdIto8F+rvWFfzIL2a
 LzucZZv8LnyK9Ou0J+wMdvcIkyok/GhLLfVtAgBN6AhAg53uFvt6UiJsUkgSqWFSwHMACzX9dPr
 txGaB6Xr/bs9Cb9Y0gytDlJI=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:b::)
	by smtp.migadu.com with ESMTPS id eb79b8ec4e60aea3;
	Wed, 26 Aug 2026 18:35:45 +0000
X-Mizu-Trace-ID: eb79b8ec4e60aea3
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 11:35:44 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: remove unused memcg parameter in
 calculate_high_delay()
Message-ID: <ao8x787ZgJvUvhbr@linux.dev>
References: <20260825120153.1405-1-hongfu.li@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825120153.1405-1-hongfu.li@linux.dev>

On Tue, Aug 25, 2026 at 08:01:53PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The memcg argument of calculate_high_delay() is never referenced in
> its function body. The delay calculation only depends on nr_pages
> and max_overage, and both callers have already obtained max_overage
> from the same memcg.
> 
> Drop this unused parameter and update the two call sites inside
> __mem_cgroup_handle_over_high().
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

