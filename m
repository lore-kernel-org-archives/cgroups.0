Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152DC1A681B
	for <cgroups@vger.kernel.org>; Mon,  2 Mar 2026 22:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772490071; cv=none; b=qhkRulaugk0U1WVRkZMPp7i924zsekk1KxcTICMOruwTREdHltfGErlDV0DZi+3QFdkJtiAw3NHZY0ciJw3VIOaRe7qeihdwYn6byhRW6q81kN6NSDXWm0Ch7F+8Xku95xHLwQvKAwOY92lGmfkWsvkphSQJdwmlJVD0/tyFumY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772490071; c=relaxed/simple;
	bh=cM6Sf+nPkriTMX6iDjxwpKHyStgmQ8eaMordpwlaLOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L621mEYEceBCnGI8ujIz2LFQ702gW3MszIMHUXs84tZZkd3UdOT7AWboOZp3NtzkjfBv13/rk9nhh5lIAT9FZ3AR4AzbodSGcx3iCm3L6KJtWszScIuAHuZubeu8FYeNsSE6pa+L1IAyDA6Eabyx9axxCTztK/5hLYgm9tK+I4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I5qBYBhf; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I5qBYBhf"
Date: Mon, 2 Mar 2026 14:20:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772490067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kxrIqC4lTYaQ10ka6NqFm5OmD9rPDMHzGSGdgraOMEg=;
	b=I5qBYBhfBL7RM+n9tcitpC63AArsIB0Echd/QGCuxpghhgcyLn1x1g524QDKNs9PGJjFc5
	mzS9QY7M33beBsSO00PAS0Jqf6y3ftwMbTuC3N1bAR3SCC4h2C3+fu1e/dMB+2CyU8yss6
	HB0nClNoAyr4j8xbicwiok+mySUNHhI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mm: memcg: separate slab stat accounting from objcg
 charge cache
Message-ID: <aaYNDbFZ2AHM7gKt@linux.dev>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-6-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-6-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 02, 2026 at 02:50:18PM -0500, Johannes Weiner wrote:
> Cgroup slab metrics are cached per-cpu the same way as the sub-page
> charge cache. However, the intertwined code to manage those dependent
> caches right now is quite difficult to follow.
> 
> Specifically, cached slab stat updates occur in consume() if there was
> enough charge cache to satisfy the new object. If that fails, whole
> pages are reserved, and slab stats are updated when the remainder of
> those pages, after subtracting the size of the new slab object, are
> put into the charge cache. This already juggles a delicate mix of the
> object size, the page charge size, and the remainder to put into the
> byte cache. Doing slab accounting in this path as well is fragile, and
> has recently caused a bug where the input parameters between the two
> caches were mixed up.
> 
> Refactor the consume() and refill() paths into unlocked and locked
> variants that only do charge caching. Then let the slab path manage
> its own lock section and open-code charging and accounting.
> 
> This makes the slab stat cache subordinate to the charge cache:
> __refill_obj_stock() is called first to prepare it;
> __account_obj_stock() follows to hitch a ride.
> 
> This results in a minor behavioral change: previously, a mismatching
> percpu stock would always be drained for the purpose of setting up
> slab account caching, even if there was no byte remainder to put into
> the charge cache. Now, the stock is left alone, and slab accounting
> takes the uncached path if there is a mismatch. This is exceedingly
> rare, and it was probably never worth draining the whole stock just to
> cache the slab stat update.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks, this looks much better.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
