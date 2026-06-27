Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AA914F112
	for <cgroups@vger.kernel.org>; Sat, 27 Jun 2026 00:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782519951; cv=none; b=Nq29/tdb/nn7+VRoi237EHvbGjldmFXpOeQ6ZyOWwqGaUBdYyJbB7aFa6AyQM4lX4eby9tr1/EQI/MYv990JVTl7SyzEH2aehjRqLapodFm3bICBWr0c3/FWddsY6Goh/Cnx2tb6B0noEMGAw+EXjkH0xgwhvOTGYFbKyM3Z0FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782519951; c=relaxed/simple;
	bh=cpZeDxH/8kquhBtLjijxoMFE249+DJTDDNQeZc7MnGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RL37WusQRXR0fa9Rg+l9Vr2uZkdeo5DkQrY1Z1EjIY/2ZWelRmB9ixXGCv39ukqnfSllLoLyzJN42/HDYbAf1G3G+/UjdNZT9HMFpLslZSvb9kXyRfc8tMi59UlN6tNmOjYE2/9V5wyQ+IbRWO7RakhxiQapGZtA7/qv7o0jAxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xa2LIILx; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xa2LIILx"
Date: Fri, 26 Jun 2026 17:25:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782519938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2rtmhvJjinb8DEEiGRho1gz89/v7/dbBZ8zEBhu5q/s=;
	b=xa2LIILxyclfD441FflIQK7j1hGGLliqf33fZ7ZssQWT1pkGKSVCn9Q7fG+XFPaQrZQk5c
	2q9Ia1lSFkmC5hwixcTy2ISERcSMtSRN8gU5yTLQHImyrGqCttWs3hBZU+SM3n6qgV8j6S
	QKw5IoEzyOKykbjEbVEqv2eVD1oQBrw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Breno Leitao <leitao@debian.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcg: initialize *locked in memcg1_oom_prepare()
 stub
Message-ID: <aj8XjtMqwAQM2XNd@linux.dev>
References: <20260626-memcg-oom-uninit-locked-v1-1-a00175936b39@debian.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626-memcg-oom-uninit-locked-v1-1-a00175936b39@debian.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 26, 2026 at 05:43:02AM -0700, Breno Leitao wrote:
> mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
> and reads it back in memcg1_oom_finish():
> 
> 	bool locked, ret;
> 	...
> 	if (!memcg1_oom_prepare(memcg, &locked))
> 		return false;
> 	ret = mem_cgroup_out_of_memory(memcg, mask, order);
> 	memcg1_oom_finish(memcg, locked);
> 
> This relies on memcg1_oom_prepare() setting *locked whenever it returns
> true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
> CONFIG_MEMCG_V1=n returns true without touching *locked, so
> memcg1_oom_finish() consumes an uninitialized value.

On CONFIG_MEMCG_V1=n, memcg1_oom_finish() is an empty function and I assume
compiler will just remove it completely. Maybe on CONFIG_UBSAN=y kernel,
compiler is not removing memcg1_oom_finish90.

> On a memcg OOM this
> is reported by UBSAN:
> 
>   UBSAN: invalid-load in mm/memcontrol.c:1932:27
>   load of value 0 is not a valid value for type 'bool' (aka '_Bool')
> 
> Initialize *locked to false in the stub; with cgroup v1 compiled out
> there is no OOM lock to take.
> 
> Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>

Anyways, this is not a performance critical code path, so this is fine.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

