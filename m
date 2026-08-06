Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EADF364942
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 20:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046646; cv=none; b=Yl4eP3S+iCT3KP5Lo5cYiP7dfS9kIH+1f4y/w6k7ynBl9kYK6hilWc5QlRWT9B9gsSUWzdezMfZt5WZqoTdZjOuozH+Amm2ap/hA6T81/2U1BH5QrZowHJ9cMXIcY5MDoRDiNTKGizcj259GEOKGmUlfa1r7gt4fCQaB6ljXaqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046646; c=relaxed/simple;
	bh=WHCiSnc0ONIs1uA0+0anTixoo55lB3Fa2WbuoEhoxos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GP12LnVST2/WsdQ1PmOdEo4n7JnFDt+UZBtamBILnHjNAshoE9ha016Ubt4Hhgksg5afpG8ZNeD0BSxaEfejpOd2uuD7oVs8znc1fCM4XIX3g02C1q10uWQc6wARRrw2HGLb8iHOP43HrdePOk0bnxXCpy1NA6Pq0nKWfvGs6gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wDDwWbNA; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wDDwWbNA"
Date: Thu, 6 Aug 2026 13:03:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786046616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UPKg8QMwwWLCGGZZI8KkM6QbnBXtsMGOQLkRtcQ339w=;
	b=wDDwWbNAa/jORPyFOSxyRdpfHizF+0Hq9u+chRZy2pz09OrGkjgSLKIAC5yIJDqC7rJapQ
	muXt42AKEYpyLrxuoz86VHcRPezv78Dki35zG4NGfMzirTy28sWPUQlOct1iy3f4YH8YlN
	ZFkho8hYtKdGRRqu2a43OkGgNktuh/s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Karl Erik Hofseth <karl.e.hofseth@opoint.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] memcg: keep folio's objcg same as its node
Message-ID: <anToOuVZ-xF6onE6@linux.dev>
References: <20260806165813.2526415-1-shakeel.butt@linux.dev>
 <anTPPr5hVV4aQLRD@cmpxchg.org>
 <anTfChWlK998-7sY@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anTfChWlK998-7sY@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 06, 2026 at 03:22:50PM -0400, Johannes Weiner wrote:
> Hm, it's still not quite right.
> 
> When there is a root mismatch, we cannot fall back to committing the
> old objcg. That would reintroduce Karl's issue. Not as broadly as
> before, but can still happen if the memcg tree died up to the root.
> 
> So we have to commit to the new objcg, always.
> 
> What obj_cgroup_is_root() then comes down to is whether uncharge will
> balance the page counters or not.
> 
> mem_cgroup_replace_folio() gets a new charge for the new page. We can
> just conditionalize that right away on whether the new objcg will
> actually uncharge.
> 
> mem_cgroup_migrate() currently trades the charge, but that won't work
> if the new objcg is root and won't uncharge. So we have to settle it
> right then and there.
> 
> This?

Thanks a lot Johannes, this looks much better. I will incorporate this and run
through the reproducer before sending out the v3.

