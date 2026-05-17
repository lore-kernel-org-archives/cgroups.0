Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884122DCF52
	for <cgroups@vger.kernel.org>; Sun, 17 May 2026 19:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779046486; cv=none; b=LqKCtGJMpA4cqs90tT8YOu6OeBSH1/Akcm7R79LWXQx3Mye8I9c/VjP8CIZEKZ1gEVWLgHBTA0bneVS3WYmXGBLFZa6OP6snB3/1T+a2JOjNjXBnorQuco5mGWA2C62Sv9PILMzemmXrvWJ+S+edXRSV2sgr89ZVrGQROuClZSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779046486; c=relaxed/simple;
	bh=fqVGrMPltQycqdJUUF3iNfkZ1nzUuT9Uk8viQYk3eI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qN/PehkVmemn0QdwhjAGMYW34QxHB+9j6tsY2Odqd2iJ7UTlaIhp4RAieVdltX99feXhrEIo8usGxMK+ma0R/EaKPoV1LOE+YaCsPh4MVbudTLr4LxJuNlvUtrpWYtSLyds381owi8ohLzulUXqXnZ+xRDnS/DP98fZ9Zw3G8Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tYSH0kMs; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tYSH0kMs"
Date: Sun, 17 May 2026 12:34:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779046482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iMAxYkiLe+6rFdPj4BXY2Sm1CnSl5lwd7zUgGll+LNI=;
	b=tYSH0kMsOtzH6hBlheNnNNf6sSMd47g5ItVVvMKyFwyPg9cXN6EyO0UYWh17vOpTHcr+F/
	Y1RkFWSkhCPB7TzPu1m7hU0AVSnbSCx6T+W6KKDwL3Mw41b7MmAgymsUyBB1jt+mEZWALF
	4ggl/OwcTDyCUNJTDbmgXOI9qz68eMQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] memcg: cache obj_stock by memcg, not by objcg pointer
Message-ID: <agd-gbYnVyaaiLH7@linux.dev>
References: <20260515171953.2224503-1-shakeel.butt@linux.dev>
 <agdnTPXhuepuu7hG@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agdnTPXhuepuu7hG@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, May 15, 2026 at 11:42:39AM -0700, Shakeel Butt wrote:
[...]
> > Will sharing the reserve between per-node sibling objcgs without updating
> > stock->cached_objcg break the page multiple invariant in
> > obj_cgroup_release()?
> > 
> > If an allocation for objcg_B consumes bytes originally funded by objcg_A,
> > and the stock is later drained, those borrowed bytes are flushed into
> > objcg_A->nr_charged_bytes.
> > 
> > When obj_cgroup_release() is invoked, nr_charged_bytes will not be an
> > exact multiple of PAGE_SIZE. Will this trigger
> > WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1)) and truncate the remainder,
> > permanently leaking the page charge from the memcg?
> 
> This is actually a very good point and need more thought.
> 

I think we can handle this simply by taking over objcg->nr_charged_bytes into
the stock.

