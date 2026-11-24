Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.102
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795482581;
	b=V7iwWaSm0040YNYVySUqhfbTDwVUvEZImhRDA5ftWwaKb3fb6fKiUBorY80+MDii+iHS
	 egB4I1pO/Fe1S+TyeLSxB27COOQR+zrfbD1QAT3Iwwocxue3ZRbmbtcyE+03MRvznL/2I
	 Jv0vyL7rjDtF1iTKoPphQbG+2aBlIWgGzGfHkV3mAREORcqtginRH1mvsSSCmYA5veSkN
	 tt7jdT/AKAJmL9NxJxq8KATBJwno0YRse4jObSttuEskXJCC8b607qNOkPqaV3qcpIH1E
	 9ej3ujjZO1yUMK2tZJVymqOkLjgvg/lMR9M7vFcRs64aqYKn4oSfwrpPgJSzxruSWrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795482581;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=owYjzpuYFLjOeIilxJig3Hw1JAaAisOBDLN+NbRQADQ=;
	b=stR9uNSMe9Db+8+ADi3P1z9q6O8BFgAjqc4unRFDna/cng+ojN+NdGe4prDjnnTz/Plb
	 kY7dLvRDUuaYpj/w/VOwWTvNT5q9/dYy3dMzX9sYMiXCx6OtrPopoqYT91OeElZ7TzK0A
	 G/Cd3/nv6EEP/A3g49N2Yzagaon3cff0b1fKc8bVrmfkTTyFp4wXgqaesgHf+3BowUACg
	 /yVGw45jbDU/eROAvqevWbpKfjUDpSdcDJ5uoELcd+CHeTHmUuEZHimmOdJlb90+vd+uQ
	 quwh2XkvwvciXJsxZ9iR3HiBn2rghnXzlZSw4iP/8Z4/HwXiGD8PYTBTxUOgQQnRRmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=S2r1a0RJ;
	arc=none smtp.remote-ip=91.218.175.102
Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAF7606A321
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 01:09:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDAF7606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=S2r1a0RJ
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=CJ0tRkMlINyNJPnyBo44a+7BaS66at2HH38E/JU9IL4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795482577; v=1; x=1796087377;
 b=S2r1a0RJ8HfsGmCU8xVEMaN/l1w7EzrTsyYZhzykVt+eZoeGHrF20tJBlESLprJv994S3TCi
 u6k19lV8qiyNZXX7QLAOZEf+ki49TUG1GWRto04z5HWQ0qSfIIARV1AnX+rSH1037vNqMW3BBHk
 YPNRJE+Li71ydAa0RW2kLhZo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dc929d9c275ff9e4;
	Tue, 24 Nov 2026 01:09:37 +0000
X-Mizu-Trace-ID: dc929d9c275ff9e4
X-Migadu-Flow: FLOW_OUT
Date: Mon, 23 Nov 2026 17:09:35 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Koutny <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
Message-ID: <awTh5c6t7SczKRDG@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
 <20261123165451.8c30df036f95995316e15047@linux-foundation.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123165451.8c30df036f95995316e15047@linux-foundation.org>

On Mon, Nov 23, 2026 at 04:54:51PM -0800, Andrew Morton wrote:
> On Mon, 23 Nov 2026 16:04:39 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > mem_cgroup_alloc() reserves the private ID of a memcg when its css is
> > allocated. The ID is erased when the last reference to it is put, and
> > that reference is first taken in mem_cgroup_css_online(). The failure
> > paths of mem_cgroup_alloc() and mem_cgroup_css_online() erase the ID
> > themselves.
> > 
> > But css_create() can also fail after css_alloc() and before
> > online_css(): in percpu_ref_init(), cgroup_idr_alloc() or
> > css_rstat_init(). The memcg is then freed through mem_cgroup_css_free()
> > without ever coming online, and nothing erases its ID. The reserved
> > entry stays in mem_cgroup_private_ids for good, and each such failure
> > takes one of the 65,535 IDs away. With failslab failing radix tree node
> > allocations during mkdir, 1,500 mkdirs leaked 6 IDs this way.
> > 
> > Erase the ID in mem_cgroup_css_free() if the memcg never came online,
> > which is when (memcg->css.flags & CSS_RELEASED) will be false: it is
> > only set when an fully onlined memcg is released.
> >
> > Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
> > Cc: stable@vger.kernel.org
> 
> hm.  These allocations are all small and they're GFP_KERNEL so
> cc:stable seems a stretch?   But whatever - stable people have bigger problems
> than this ;)
> 

Sorry, I should have explain better the user visible impact. The memory leak
is not really a big issues, the memcg ID leak is greater issue. We have upper
limit of 65535 IDs for memcgs and if we keep leaking the IDs, we can start
seeing memcg creation failures.

> > --- a/include/linux/cgroup.h
> > +++ b/include/linux/cgroup.h
> > @@ -449,6 +449,11 @@ static inline bool css_is_online(struct cgroup_subsys_state *css)
> >  	return css->flags & CSS_ONLINE;
> >  }
> >  
> > +static inline bool css_is_released(struct cgroup_subsys_state *css)
> > +{
> > +	return css->flags & CSS_RELEASED;
> > +}
> 
> todo: switch css_next_child() to use this new helper.

Ack.
