Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941EB25F984
	for <cgroups@vger.kernel.org>; Mon,  9 Feb 2026 17:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770659643; cv=none; b=LQbzd4mN6UsMmwv+IZXDFFq7DcIv8Vg/TwMdozSg94+yXhR+WwpHLMGdDy/8YgjVNJ15U+/OcRxP4FPDcONWk9kTfeeRjKProdG1/f1VeVPy8if7RieHvlymgoQCH1bcQfepF2ukQEw0CK+ulbTW6FY3UiYLq9ooGhPgo3DI+H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770659643; c=relaxed/simple;
	bh=XwsQI2wrzypanRpiCI+SLmTog/38ulD0ioVvQJJc8Fw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzIyh4+WkERTa5nVJt5pvKbW3aSMUinxWaQn9H16QQiXBOklIeA36d5W/Fduk//1Z8AvIY2wPxhgZGv1+RrxiywlZbKKsLAhcn6WqyS+eRDo6imuPTnJRGhRpgkfdm/hGtAt3M7iN65Fa/0uZ0/7Z7JUoix3NXPyWf+l/wVPXtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bz37dgu2; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bz37dgu2"
Date: Mon, 9 Feb 2026 09:53:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770659640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hABd2jvZOVnjl2wLz3t/00/fhLlc+2ElVVVlmwti45w=;
	b=bz37dgu2WOZ0fHE5mdro7INsfOtdYjgaUiDKeNyEC4e7oAuZBp7HwpM/vqGoMbZR19Nhs4
	xvFUvEU4thB78JQ6srTO+YyJeFZgYJH2RhwSwcXClEVmMV4pS7x8qQm79Va3JpARHVk93q
	RADaYAIS/vvBNLqaXG+ZM73RAquaGJc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 30/31] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
Message-ID: <aYoezZdqL_AofUgP@linux.dev>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <9e332cc8436b6092dd6ef9c2d5f69072bb38eaf6.1770279888.git.zhengqi.arch@bytedance.com>
 <aYe1R2MMcXbPVYUW@linux.dev>
 <2a0e4ae2-457b-4d16-a7b9-7372fd665337@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a0e4ae2-457b-4d16-a7b9-7372fd665337@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 09, 2026 at 11:49:43AM +0800, Qi Zheng wrote:
> 
> 
> On 2/8/26 6:25 AM, Shakeel Butt wrote:
> > On Thu, Feb 05, 2026 at 05:01:49PM +0800, Qi Zheng wrote:
> > > From: Muchun Song <songmuchun@bytedance.com>
> > > 
> > > Now that everything is set up, switch folio->memcg_data pointers to
> > > objcgs, update the accessors, and execute reparenting on cgroup death.
> > > 
> > > Finally, folio->memcg_data of LRU folios and kmem folios will always
> > > point to an object cgroup pointer. The folio->memcg_data of slab
> > > folios will point to an vector of object cgroups.
> > > 
> > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > >   /*
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index e7d4e4ff411b6..0e0efaa511d3d 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -247,11 +247,25 @@ static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
> > >   static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
> > >   {
> > > +	int nid, nest = 0;
> > > +
> > >   	spin_lock_irq(&objcg_lock);
> > > +	for_each_node(nid) {
> > > +		spin_lock_nested(&mem_cgroup_lruvec(memcg,
> > > +				 NODE_DATA(nid))->lru_lock, nest++);
> > > +		spin_lock_nested(&mem_cgroup_lruvec(parent,
> > > +				 NODE_DATA(nid))->lru_lock, nest++);
> > 
> > Is there a reason to acquire locks for all the node together? Why not do
> > the for_each_node(nid) in memcg_reparent_objcgs() and then reparent the
> > LRUs for each node one by one and taking and releasing lock
> > individually. Though the lock for the offlining memcg might not be
> 
> To do this, we first need to convert objcg from per-memcg to per-memcg
> per-node. In this way, we can hold the lru lock and objcg lock for
> each node to reparent the folio and the corresponding objcg together.

Oh we want reparenting of both objcg and folio atomic. Let's add a
comment here with the explanation.

