Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531C12264D6
	for <cgroups@vger.kernel.org>; Wed, 27 May 2026 01:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779847129; cv=none; b=F4YyFLN6QSnr8f2kGd+EAYpDUEBGRaSR/hOngnchKbaGyM9doP3xhisANXPgZL7ucm1gz3gcdwUCTAyIjxOaKeJ35moos0VSPHe7qPVoPjZal2ZGM5oku0ecDPxzDSDBVo2yk4AzBRYIxz4fwvY/del5D1/x+IAJxd7IZ0zP2mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779847129; c=relaxed/simple;
	bh=rvZQKXzMWC4ZFvqBSIhmhDjtz0cKjWC+p2g5wptY304=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ErRL8n3HvZ8L9ot1k3/5NrCJPunXWpbfFbCnKDYdhXKXhZJikCtqAwOw5xRhjW/3QAbuQVMGHzM5/RDje30SL/3TmPNqfBVfgyqDDOfjt1qtv27XSJcIv4NmWDzPztqjhx7A5Bre4CKE5jfAvgBLM6Mqu7IhUrk4i7HNmcVc7Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 27 May 2026 10:58:42 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 27 May 2026 10:58:42 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 3/4] mm: memcontrol: add interfaces for swap tier
 selection
Message-ID: <ahZP0hj1/O9U1pTm@yjaykim-PowerEdge-T330>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-4-youngjun.park@lge.com>
 <ahW9UQH93jBT_VaD@MiWiFi-R3L-srv>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahW9UQH93jBT_VaD@MiWiFi-R3L-srv>

On Tue, May 26, 2026 at 11:33:37PM +0800, Baoquan He wrote:
> On 04/21/26 at 02:53pm, Youngjun Park wrote:
> ...snip...
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index c3d98ab41f1f..0f67572e5e3e 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -68,6 +68,7 @@
> >  #include <net/ip.h>
> >  #include "slab.h"
> >  #include "memcontrol-v1.h"
> > +#include "swap_tier.h"
> >  
> >  #include <linux/uaccess.h>
> >  
> > @@ -4130,6 +4131,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
> >  	refcount_set(&memcg->id.ref, 1);
> >  	css_get(css);
> >  
> > +	swap_tiers_memcg_inherit_mask(memcg);
> > +
> >  	/*
> >  	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
> >  	 *
> > @@ -5667,6 +5670,88 @@ static int swap_events_show(struct seq_file *m, void *v)
> >  	return 0;
> >  }
> >  
> > +static int swap_tier_show(struct seq_file *m, void *v)
> > +{
> > +	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
> > +
> > +	swap_tiers_mask_show(m, READ_ONCE(memcg->tier_mask));
> > +	return 0;
> > +}
> > +
> > +static ssize_t swap_tier_write(struct kernfs_open_file *of,
> > +				char *buf, size_t nbytes, loff_t off)
> > +{
> > +	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
> > +	char *pos, *token;
> > +	int ret = 0;
> > +	int original_mask = 0;
> > +
> > +	pos = strstrip(buf);
> > +
> > +	spin_lock(&swap_tier_lock);
> > +	if (!*pos) {
> > +		WRITE_ONCE(memcg->tier_mask, TIER_ALL_MASK);
> > +		goto sync;
> > +	}
> > +
> > +	original_mask = memcg->tier_mask;
> > +
> > +	while ((token = strsep(&pos, " \t\n")) != NULL) {
> > +		int mask;
> > +
> > +		if (!*token)
> > +			continue;
> > +
> > +		if (token[0] != '-' && token[0] != '+') {
> > +			ret = -EINVAL;
> > +			goto err;
> > +		}
> > +
> > +		mask = swap_tiers_mask_lookup(token+1);
> > +		if (!mask) {
> > +			ret = -EINVAL;
> > +			goto err;
> > +		}
> > +
> > +		/*
> > +		 * if child already set, cannot add that tiers for hierarch mismatching.
> > +		 * parent compatible, child must respect parent selected swap device.
> > +		 */
> 
> This paragraph of code comment sounds a little unnatural. We are writing
> it into memcg, the child memcg is handled in
> swap_tiers_memcg_sync_mask(), isn't it? I don't get the 2nd sentence.
> Could you help explain?

Thanks for the review.

I think this sentence is not appropriate.
Maybe I forgot to remove this line after modifying the code many times.

This sentence is not correct.

I explain one by one for clarification.

"if child already set, cannot add that tiers for hierarch mismatching."

mask can be changed (can change the tier_mask). 
But the effective one (effective_mask) is recomputed with parent's effective_mask.

"parent compatible, child must respect parent selected swap device"

effective_mask must be restricted, which means child effective_mask
must be subset of parent's effective_mask.
