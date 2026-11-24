Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.59
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795542903;
	b=GgIUiY+sIigMeByhrKqJROecsiZsXWJZpec8Jvwm25pFk3UkwqQIKMYkN8YuyfPws9Uh
	 dQfk+8dBlzvGyNq0YPDHGLPSzqfrWsZF960kJdkxWDr6yH3ORIgr2LoL6hE37WJ8aPX9z
	 hlSys3KTBCreYnJeRlT9VG785Sh93P6IW2RsXQlyhZnr6+IMjobSoc2P383UdatO9AhLN
	 Ddvo2ocEAaOAGnfprgDdPNTwFpj1Uun+qGNYOTbR83yhO2QTesNmLkZV3bdoHz5EBsQcS
	 +7AyyS7Moqbyz+Md/XfmE0p1JfWDgTOA3JysKCLRSn0ENjH4Xwa6g4KwiNqx53l6Muw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795542903;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=I2yxDbU7lOpiFweogZtcA4pKGDUYWG7cArF22khEzuE=;
	b=cBIjI6R5PgeqkJlJ5vHjKC9SnXns6FJBOvdxKqiCp8LHqG4+Un8ISgb25M9q13U4d5IZ
	 6Q+o8xo2unZV76RlabxqatmUy2EdRVU4wo0NM+qPqCqCF7T9Jk/GCSSS9FdOiDJMh9vcm
	 nmSJNQ7dTwZltCqzFSz3hEgzYcS5UJY/pSiOQHgjnzpyYIMRulnE25ryG+tlkje1IchsK
	 fLRIsDzoA85iUilwfn6hYs92apBDLdD1Mjx1UNzHQ7s3TVJ/66eMcr1LNB6Ce2ZXWyvVf
	 nXu4shbFp8O1PXkP78zqdhtUoIo0g1njNW1jDdnrjrg64qJ5O/blIqnGjMfX8rKGMXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=K4qBbnj0;
	arc=none smtp.remote-ip=91.218.175.59
Received: from mta0.migadu.com (out-59.mta0.migadu.com [91.218.175.59])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39016606A323
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 17:55:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39016606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=K4qBbnj0
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=WAB79C+6SpcJcXgk0rqpViA2L6QwhWPx0WDOvroYZdg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795542900; v=1; x=1796147700;
 b=K4qBbnj0YFn062jLpuAS6VoHfSwuSIIpz8YBKCjTCKImMV5ZwpQWPt8XDwLSkO7QdQC1UmKl
 hjsrkT1kI5tfcAjvd7Pll7mnLKqpb409L9UiyNFUavsgm7dSknAZaEKtMzfUj47ztHwybjfETir
 cxpqdrHG6XgiDmH0HOjHfb8s=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1aed601a24a53ad1;
	Tue, 24 Nov 2026 17:54:59 +0000
X-Mizu-Trace-ID: 1aed601a24a53ad1
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 09:54:58 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
Message-ID: <awXO66mRuz_BRWs9@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
 <awVSrbJn00wmh1nn@tiehlicka>
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
In-Reply-To: <awVSrbJn00wmh1nn@tiehlicka>

On Tue, Nov 24, 2026 at 10:02:37AM +0100, Michal Hocko wrote:
> On Mon 23-11-26 16:04:39, Shakeel Butt wrote:
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
> 
> Considering these error paths they should be pretty impossible in
> practice (and without fault injection), right?
> 

Yes, this one is found by code inspection while I was debugging the memcg ID
leaks happening in the Meta fleet. One of the biggest source I found is the
orphaned swap cache of offlined memcg. I am still working on the fix for that.

> > Erase the ID in mem_cgroup_css_free() if the memcg never came online,
> > which is when (memcg->css.flags & CSS_RELEASED) will be false: it is
> > only set when an fully onlined memcg is released.
> > 
> > Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks.

