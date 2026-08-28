Received: from mta0.migadu.com (out-154.mta0.migadu.com [91.218.175.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3020830675F
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 00:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787878094; cv=none; b=YQ2aT+yIBrcLF2XU3eOnmjdOoQ3Q9dopcmzO8xMBSqWiB4V4i2023n0iRBUH7KfpHqNZoozU6rJ9BO7n5wuW0r8UjgyJVaiIIQ7ksEj/JjZZsOcoTtTCPZ9ZKm06yNJ1KfImt7VQ/4p2PQpCL9XI64UbjrTuWPjXEWTEPy06+ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787878094; c=relaxed/simple;
	bh=Kv7SegtkprBpdAtnxRcZRecFg6c76sWZc/YX/HSXqi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYxP1IvLfFOQc74yxOEHZBmr+JfFoHejjjbetNqDktOidZzZf2XygOmkPH3xHc9kxj2y+ERr/w6+s4/Oyj7ug1hi3pRrbSfXqHDH0ZGaMSrhwkf+/x2vXIbBuRXGXJFiS4+Uvueb2Lo2Mbs0y2JDtWlHyJqz3rTWs73Z/Alup/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NpBuPJnC; arc=none smtp.client-ip=91.218.175.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NpBuPJnC"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Kv7SegtkprBpdAtnxRcZRecFg6c76sWZc/YX/HSXqi4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787878089; v=1; x=1788482889;
 b=NpBuPJnCKiroB8N/qNlsW9K8B4fEy1GEaSAhNJFXUQtJ4qDWZH9q7NoyChCwc2lhDZHB3ssP
 0NDcvSxPOtucqEE14JWtuO65iisYR0ggFPCqjtyPie1ZqDmn5EfW/Ng4iPi8f7+vzfU/YdVYpKJ
 3SyCAzgqCG8cbm9wEU4h5RTc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4f6263115d5ea613;
	Fri, 28 Aug 2026 00:47:59 +0000
X-Mizu-Trace-ID: 4f6263115d5ea613
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 08:47:54 +0800
From: Hao Li <hao.li@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: treat disabled memcg as kmem accounting
 disabled
Message-ID: <apDZV9nKW69ZbIj1@fedora>
References: <20260827091813.22327-1-hao.li@linux.dev>
 <apAnveXHmeQlKJnU@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apAnveXHmeQlKJnU@tiehlicka>

On Thu, Aug 27, 2026 at 02:04:13PM +0200, Michal Hocko wrote:
> On Thu 27-08-26 17:17:50, Hao Li wrote:
> > mem_cgroup_kmem_disabled() currently only checks whether the
> > "cgroup.memory=nokmem" option is specified. However, kmem accounting is
> > also unavailable when memcg itself is disabled.
> > 
> > Check both conditions to ensure the function accurately reflects the
> > kmem accounting state.
> 
> It would be really great if you could describe how we could end up with
> the inconsistent memcg enabled but kmem enabled and what kind of effect
> does this have.

Yes, thanks for point out this.

> 
> AFAICS the inconsistency is possible and it would lead some wastage but
> no functional problems but the changelog should be more descriptive.

Exactly! The most direct benefit is that when memcg is disabled,
new_kmalloc_cache() will not need to create a separate `KMALLOC_CGROUP` slub
cache, but can simply alias it to `KMALLOC_NORMAL`. This avoids wastage.

If this sounds reasonable, I would be happy to explain it in more detail
in v2.

> 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> >  mm/memcontrol.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1ebceade4021..b28f6165c354 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -132,7 +132,7 @@ static DEFINE_SPINLOCK(objcg_lock);
> >  
> >  bool mem_cgroup_kmem_disabled(void)
> >  {
> > -	return cgroup_memory_nokmem;
> > +	return cgroup_memory_nokmem || mem_cgroup_disabled();
> >  }
> >  
> >  static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
> > -- 
> > 2.54.0
> 
> -- 
> Michal Hocko
> SUSE Labs

-- 
Thanks,
Hao
