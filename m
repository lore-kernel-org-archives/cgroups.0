Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC4C1F1534
	for <cgroups@vger.kernel.org>; Wed, 18 Mar 2026 23:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773876518; cv=none; b=Wg/WRMXAGk4lNyP4SdWs7Kqb6Q9ZC9kHprX0F+H2BFvLzhI1sDC6EkiCmdFrOTv7yKu+zztGfqdUgVX7oy8cUStHqq4oyMztQtWySQq/zVwUEmUuURWUJEX/rqOcN3OUlOhiafvRNy6rS4CoXCYpBhg5dqyW6FGrVjcpvc54Qoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773876518; c=relaxed/simple;
	bh=q3Ko5dheHE0hL5WdgqpM8oRno6jJk0HmjxA69twDnHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mUCdLTFwqOS/sAYO0P5rgOgKldypTqn6GTzMwjHRQdMQLFO6VtXfThDB/F7QZloe7LrefQ9Cp+EKEGo0qdXDrY/rIblRZIbOg4/VrDfsKWxyqHi1/uw464FsZvHwTPtCTxIZGmvL3QvxiEzmJELVNSzhwxwJdkPPP9uRuQsOE7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tOXpz2X+; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tOXpz2X+"
Date: Wed, 18 Mar 2026 16:28:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773876505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Js6oHi8egyhsbSgRpIpQSUvyw4AU4dc1dagQu73NTIg=;
	b=tOXpz2X+yd20tixpcBzWD7GN28MkeuHwjquOwHJs8Jjm8LdIB/MIZuZFGQoUkREgGLLjcm
	JMXPJ5WtjGAQ7fXBpDPUtfSWUyRxjsSanh8CtuxHpZP4+95zv2yL4NMWgjOl/wy8nwMb0s
	8fLFKx0rj1eSQOHY9kJkK7oUkpzDL6Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Bing Jiao <bingjiao@google.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, cgroups@vger.kernel.org, chrisl@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, joshua.hahnjy@gmail.com, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, 
	muchun.song@linux.dev, nphamcs@gmail.com, rientjes@google.com, roman.gushchin@linux.dev, 
	shikemeng@huaweicloud.com, weixugc@google.com, yosry@kernel.org, youngjun.park@lge.com, 
	yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v3] mm/memcontrol: fix reclaim_options leak in
 try_charge_memcg()
Message-ID: <abs03hzUF4rx-RdI@linux.dev>
References: <20260318215629.2849052-1-bingjiao@google.com>
 <20260318221957.2979346-1-bingjiao@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318221957.2979346-1-bingjiao@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 18, 2026 at 10:19:46PM +0000, Bing Jiao wrote:
> In try_charge_memcg(), the 'reclaim_options' variable is initialized
> once at the start of the function. However, the function contains a
> retry loop. If reclaim_options were modified during an iteration
> (e.g., by encountering a memsw limit), the modified state would
> persist into subsequent retries.
> 
> This leads to incorrect reclaim behavior. Specifically,
> MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit
> is reached. After reclaimation attemps, a subsequent retry may
> successfully charge memcg->memsw but fail on the memcg->memory charge.
> In this case, swapping should be permitted, but the carried-over state
> prevents it.
> 
> Fix by moving the initialization of 'reclaim_options' inside the
> retry loop, ensuring a clean state for every reclaim attempt.
> 
> Fixes: 6539cc053869 ("mm: memcontrol: fold mem_cgroup_do_charge()")
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> Reviewed-by: Yosry Ahmed <yosry@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
