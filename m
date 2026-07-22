Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF1F348C4C
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 13:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726373; cv=none; b=iiIVzT6woGcNt4366D1Hs69kmSgAppMoKq3QET1k34+z7dWxDClBB4+qrjMtHUfAto4hbsaJEMjoOOxaoEY0S7f67i5BeguvUAFXxeD0J8zFrljS538KSGZesy62gwllQgSIX96ohLL6TojbdrT8EaM6nIQtELeLFaxprcQeOh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726373; c=relaxed/simple;
	bh=epK4LVDwm2+auSTveDZ6GGKifGGGfqh7hgaFGF+EvAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFbqZi3xChpoYWbxfKURGXe575NxSXPQ7YKYDkBFBK4+75/ulYtwis6RLq3vDXZlNpELOhLzHcEr4kBW57BKGB6Yt6o2PG2aMF3Tstw6rb9wYY/2D8r/mbX7h3V+6KnsNm6xb90yBfTVNIbTTVrpw2QfbNTWkbpG5+ElNvtzSU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=hnFAnD8B; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="hnFAnD8B"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-930f618435cso79733585a.3
        for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 06:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784726369; x=1785331169; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uPPBH/hmuBagyTMjawpVpFd8RmJZZP/xfXgbpwvebxM=;
        b=hnFAnD8B6yb746lM1dDg1iy3zz4nVeGNoA0PUX2SqMQ0ccOjs4l68Z5mAmqD/V2fey
         2m3DMIiZdnE5jVP6n5bDRNS4xg2G64CdgAZX3IjXkqcm/WdANu7ich8foaJHOlAsixzy
         TlD3GKsCrfIa3N077RdxGvBvK+73UWGGSbzo/z7y8gA1ZHwVGGpcCbQi9ThD8wkUXb2v
         6l4BvYxtquoMM33zGBqpotOPa26jM86mPxxyA8dYjnSvPvc4FmxA4Ru8mls6N1mqvMEa
         oSUGkJS7S5VPYG51sn6svBcXZCP4kBHFPj2Z1U2cNZnLN9+JGqZ8DwoO6D396ccjDJ1D
         PDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784726369; x=1785331169;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uPPBH/hmuBagyTMjawpVpFd8RmJZZP/xfXgbpwvebxM=;
        b=tA+nCFSyMgVe08Kt8iDrEFHw5BLGvD4thu4fYPQTgaPVq/+QysAGzjo9UT2626rVeG
         a7vEPmqGNduRDZBinD2UNdJ4KbBAsNwvp3/+Tj6Yem4NtJfVOGl765fFvoYbSTMMsPoy
         Od+v6qWpr+DFWxFGvkqDMsbqXBfwVDHjyUWIvQ/FaRpa82InEJCHFvqJEHXI7LrwdAth
         OBcPoKxj7ttUeFCKGxMy4IskN+bNS8vsxF8TlApOspDWsoGAdLFNKmyJZX2LHofsV3AD
         eOnmpWhWzbK2BilJg3JWb4umbCQO6E4ucbTyAyZUncRtv/1UIVj2bnQHTToyTqH3KSf6
         WzSg==
X-Forwarded-Encrypted: i=1; AHgh+Ro/Ho4XRgXXPciGyO+QgWwWWFs8en8i5n/otOX/kFWNhOOhpHmcwkzpcYm2Yh4Xx7Za1AQNnlPy@vger.kernel.org
X-Gm-Message-State: AOJu0YyU7A0IAMKdF34CIasLIQM8OIishTFBtctqwtafTCxTPsJx4AtU
	SvFJ7o9P5ToVWx8QZsedmcWpdqIEVmsxkCtVny0kqVOG6G1s1QNOb9QNvusUP1/jKz0=
X-Gm-Gg: AR+sD12DCjR6d1ytjEjdtWnEq2L+kY3Wjfu4P9Eh//r+xCy3QcPDG2hUnGu3SFCru5b
	qxCU/N0uqYSORaPPtxXd0znlpGt30VpnwBq4SsA1a5XMai7DfmgJKMY0HLHAdPNjnxD0RNOzHS1
	p9L+nDQYUsCu2t6LwMRiN8a9QDUAlW0TaNkijTBEBkKWp/DeaNxkyrQ7bTqBuFjinkN+waq8SS4
	21RhCYKvYR/iSpCTn8oAMV3KHBESuYCqmStXD9AWShKKf2QljncSSkcyVwiqMIvWoi7xixGF5LH
	Y7VdIWjn3ZGE+ZS3TDPpCWhe0mLIGlj/7ccxBJq/aLpe8Rv/Y9TBRioGv+hVel8D0YwCxQ3mKHw
	0tJ3kd11GqNCPRmjuwR0z2E305gg1qsi4e6x8OYz8OkY48AXkDbKeYTxF4XhdqCO+C4Ap0WeNNA
	bkvBw9XvrIhlPhnRg6eOxDQs9hSfPve7zP1IhB9maHSSVkKZmvMk6F2P1kfw==
X-Received: by 2002:a05:620a:460f:b0:92e:8734:b721 with SMTP id af79cd13be357-930b3ee6fa3mr2273972385a.29.1784726369355;
        Wed, 22 Jul 2026 06:19:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f6a6c1efsm160195685a.38.2026.07.22.06.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 06:19:28 -0700 (PDT)
Date: Wed, 22 Jul 2026 09:19:23 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 05/36] mm: add ZONELIST_PRIVATE(_NOFALLBACK) for
 N_MEMORY_PRIVATE nodes.
Message-ID: <amDAjb7PpWDnIQcF@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-6-gourry@gourry.net>
 <amC-b5SIkxUCKQ7H@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amC-b5SIkxUCKQ7H@MWDK4CY14F>

On Wed, Jul 22, 2026 at 09:00:51PM +0800, Richard Cheng wrote:
> On Mon, Jul 20, 2026 at 03:33:59PM +0800, Gregory Price wrote:
> >  static void build_zonelists(pg_data_t *pgdat)
> >  {
> >  	static int node_order[MAX_NUMNODES];
> > +	nodemask_t tier_nodes;
> >  	int local_node = pgdat->node_id;
> >  	int node, nr_nodes = 0;
> >  
> >  	memset(node_order, 0, sizeof(node_order));
> >  
> > +	/*
> > +	 * Zonelists: FALLBACK, NOFALLBACK, PRIVATE
> > +	 *
> > +	 * FALLBACK:   Allocation order for all nodes.  Private nodes have lists
> > +	 *             but never appear as an entry in any list. Allocations
> > +	 *             targeting a private node w/ FALLBACK land on N_MEMORY.
> > +	 *
> > +	 * NOFALLBACK: A list for each node containing only itself.
> > +	 *             Allocations targeting a private node w/ NOFALLBACK
> > +	 *             will always fail (their NOFALLBACK is empty)
> > +	 *
> > +	 * PRIVATE:    (N_MEMORY | N_MEMORY_PRIVATE) - allows access to
> > +	 *             private nodes, and falls back to normal memory unless
> > +	 *             __GFP_THISNODE otherwise constrains it.
> > +	 */
> > +
> >  	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK,
> >  			    true, node_order, &nr_nodes);
> >  	build_thisnode_zonelists(pgdat);
> > @@ -5912,6 +5957,10 @@ static void build_zonelists(pg_data_t *pgdat)
> >  	for (node = 0; node < nr_nodes; node++)
> >  		pr_cont("%d ", node_order[node]);
> >  	pr_cont("\n");
> > +
> > +	nodes_or(tier_nodes, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
> 
> Hi Gregory,
> 
> A question about this part, if my understanding is right,
> ZONELIST_PRIVATE contains all private nodes, should we use some explicit target
> nodemask here to make sure only the targeting owner's private node can be touched?
> 
> Otherwise it might fall back into a different owner's private node.
> 
> --Richard
> 

Zonelists and the constructors here is a bit difficult to understand,
and I see I actually did a poor job of explaining what's going on in
the comments here.  I will fix that up in v6.

Lets say we have the following nodes:
   N_MEMORY :  0 1
   N_MEMORY_PRIVATE : 2 3

The following zonelists would exist:

ZONELIST_FALLBACK[0]   = {0,1}
ZONELIST_FALLBACK[1]   = {1,0}
ZONELIST_FALLBACK[2]   = {0,1}
ZONELIST_FALLBACK[3]   = {0,1}
ZONELIST_NOFALLBACK[0] = {0}
ZONELIST_NOFALLBACK[1] = {1}
ZONELIST_NOFALLBACK[2] = {}
ZONELIST_NOFALLBACK[3] = {}
ZONELIST_PRIVATE[0]    = {0,1}
ZONELIST_PRIVATE[1]    = {1,0}
ZONELIST_PRIVATE[2]    = {2,0,1}  <- no fallback to 3
ZONELIST_PRIVATE[3]    = {3,0,1}  <- no fallback to 2
ZONELIST_PRIVATE_NOFALLBACK[0] = {0}
ZONELIST_PRIVATE_NOFALLBACK[1] = {1}
ZONELIST_PRIVATE_NOFALLBACK[2] = {2} <- __GFP_THISNODE
ZONELIST_PRIVATE_NOFALLBACK[3] = {3} <- __GFP_THISNODE

In the current design, we actually can never fallback to another private
node, and instead if you wanted to - for example - interleave across
said nodes you'd have to do so manually.

I think it's reasonable to later extend zonelist construction to support
such a think like:

ZONELIST_PRIVATE[2] = {2,0,1,3}

Later if such a need arises, but I would say wait for the use case.

~Gregory
