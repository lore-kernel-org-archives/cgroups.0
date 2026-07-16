Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CE9434E29
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 16:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784220970; cv=none; b=CKpkwDzvUtQ6rHVS47QOSsxxH47BEn4EN8MR3JbjDuKV1kNanhBuAtbXZlt1PJsSjQyCCTJD6cRnb08CxRWQf2LxFI57zFaJhKzq5SerbtrIGdPvOKuL4B0s2NhW+ihtlHSzpiDln3xpeagBNvVwHeViVAbSHqlTih/cYUn1W14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784220970; c=relaxed/simple;
	bh=xBajAebr75Al/QmBxjkQVEzD4bWqemnrt6d62r14j/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s70RiBB/RGR6bhc/7qQiJfdZtdQsmJx0eGpwsr2wi/X/Vn6YTfvB4vZBPRnCT8PHZ8fuyxe4NP3zCwHJF3v2BiFgE54ePyHJHOUrWwkiRF/uMZtlrTIfdQx7TIDLs9qEHV2mJDm8jSVmVEiihnGEbxn/T4lOfUXkfUYvlk2HFxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=HK6Ru4XB; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="HK6Ru4XB"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e50a650a0so363935485a.1
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 09:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784220961; x=1784825761; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=08EQSxLVtNW+I2h2PWuzuRsz9aErjHxxHAiZ5/B9N7Y=;
        b=HK6Ru4XB5cWfpokzBci1nF46gk+0KG+83IFz9QMdHtLNqhxKyaIf+mCIvZNy800AF1
         hxTEPIU1n7HeNxeDCCeLK0miYZmp+nVkaazCpTP7qlIW+6Z0IWTNz72o6szbL45/pJQB
         FE2rLQBCcGrhPlVf2fc17qpt2/5odVgAUaXBSgw7e9xlsCccmZxEp+BYt8pfUI3BBl7K
         BvgI16cewhqI8/0bWqvTLlcIjZWuVwVS/bfASMy1ibYQh/gP7P+UrbXvA4DW6t2KH3Cx
         k+onft9SD4O40qRQY3mB34HNkBkcYdPXKJN1NPlNIYdGctaI5M4q8WRByuozagzMF+An
         Pbjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784220961; x=1784825761;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=08EQSxLVtNW+I2h2PWuzuRsz9aErjHxxHAiZ5/B9N7Y=;
        b=nBEVkTBb/cyCXIVhz7VZZWISvBWlUwndkZyTZ4aiIbJMueokLN2LQhhHuyrZkv1bUs
         mvOrkA7weGcMkArhF8fCFpP4St3E2XNYEwQ4h5gZa7Fzr12zQn8mJQG4ytmO9QfU0NKP
         JC2lrQfhI8C9j5aNkOZr6ibnOog7wFClrHOnoe22dIumpZUmMVNCG0dpOdEHB6jbu6Zu
         8fpRcKcDkBW5SbdJ+BOK7s7r0W6L/pMbsl//+64qs4bJW1Y/+66Nt3ArqtuO2Ytmr2pr
         5gNc5x1QTBUCFT7TDAlOdIsvUyceSzTy7iKOZAsNHVY+hEj4u6t6ZKkmrxwOTRqP37BM
         65zQ==
X-Forwarded-Encrypted: i=1; AHgh+RroKs61HlR4bWf7KDcRn4so774SxxCtnQswN1RdUeUn6c/tcupvN3S5HCQQYmnOke8di1M/G+Qw@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzrx+tq4uzENKr8va8bVRCQqZG/mkdhK6BkYpp526nbtS7m90X
	s2WCDvVkk2vmdmGVCuQnaHFZSI3ZoWqV29Sx8DNz762WY/y+My7JYMOra/1+CICFzSs=
X-Gm-Gg: AfdE7cnGxj4E9sViESUlKd9pUBBouINB//wUNaOW++PCOZJqM/dPkmNYOLrpGXAiDhO
	V9+Kj/9iFQM7KjrN0zdgZu6k2bgvX9mLKhpx87woQH/+Grg7outFzsOFppcUDcSnrCRBeVxn1hj
	9NIESqdCV5qgzqH0wTKLjmAv8QLlKNqZpHGOLBv9UTZe2/L4QtE2d9u1zbtvO8kWMUyv/aW9InD
	ljRyoto4FBCpOTwFbJ2fkMzynaqPQpz/ItQ/TFvVrXPzOb/cVPEfpSE/xBBbxqEUTnbioTuEOnN
	ApQaNREsbMjPgZvZbycbDuwBr1cwFsV5ywJjMiJfgkQYZhXhzpeSeIKPGgouY6kpk6uYshsfZBf
	SrjGB33htELInc5XijLMBU3kbwnLB4ZDGENqFHHlSlbIyR5xkEgyuEdrJ1oRAsZ/9DA9lwIgRgQ
	7WS6PQ42Cd14HPoBsDVJ5vuDsanOg2Ps9bBrL5cIu4/uZfcCf5jlWtOceobg==
X-Received: by 2002:a05:620a:262a:b0:92e:6b16:6a09 with SMTP id af79cd13be357-93086be1fefmr1190451185a.49.1784220960589;
        Thu, 16 Jul 2026 09:56:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930759c63fbsm956033285a.22.2026.07.16.09.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 09:55:59 -0700 (PDT)
Date: Thu, 16 Jul 2026 12:55:55 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Koutny <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Kaiyang Zhao <kaiyang2@cs.cmu.edu>, 
	David Rientjes <rientjes@google.com>, Yiannis Nikolakopoulos <yiannis@zptcorp.com>, 
	"Rao, Bharata Bhasker" <bharata@amd.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/9 v2] mm/memcontrol: Make memory cgroup limits
 tier-aware
Message-ID: <alkB4tnJxOLyVCi2@gourry-fedora-PF4VCD3F>
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
 <3ff8b23a-479d-46e8-b820-a23697587f01@kernel.org>
 <CAN+CAwPK4cW6k6LazZsbuvewswOwzM8VJgPvcg0jef7FwfF1qg@mail.gmail.com>
 <a8a0e540-414b-4174-a9f9-2c501fb46130@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8a0e540-414b-4174-a9f9-2c501fb46130@kernel.org>

On Thu, Jul 16, 2026 at 03:11:30PM +0200, David Hildenbrand (Arm) wrote:
> > 
> > First, for the multi-numa-per-tier case, I think this is already pretty well
> > handled by my series. Once we realize that a memcg is consuming too much memory
> > from a tier, we trigger reclaim from that memcg via
> > try_to_free_mem_cgroup_pages,
> > which as far as I can tell already handles the multi-numa per memcg case.
> > Other than restricting the scan_control's nodemask to target the nodes
> > from that tier, I don't think there's anything else to be done.
> 
> I am not really sure about the "toptier" notion, in particular if your memory
> hierarchy is not static.
> 
> Imagine that you have only DRAM in your system. Then you hotplug some slow CXL
> memory. The you hotplug some HBM CXL memory.
> 
> The meanting of "toptier" changes, which is rather confusing to me.
> 

I think this is a naming problem.

Maybe we should start calling this "initiator tier" or something.
Maybe tier is even the wrong notion here, but it's the best we have.

But I agree "toptier" naming doesn't generalize to complex systems.

> > 
> > $ cat memory.tiered_max
> > tier_0 20971520
> > tier_1 31457280
> > ...
> 
> memcgs are currently not NUMA aware, so this could be one possible direction.
> 
> But is "tier" the right abstraction? I really don't know.
>

Really I think we're trying to classify 3 general pools of memory

- Precious:      HBM
- Preferred:     DRAM  (initiator preferred targets)
- Non-Preferred: CXL   (fallback and demotion targets)

HBM nodes are already weird in terms of fallback ordering, but ignoring
that for a moment.

Non-preferred "tiers" are slightly different than preferred "tiers".

Under normal operation (assume no mempolicy or cgroup weirdness):

1) Direct reclaim NEVER targets non-preferred tiers (kswapd only)
2) Promotion NEVER targets non-preferred tiers (promotion -> toptier)
3) Under total system pressure (direct reclaim on top tier), we swap
   directly from the preferred tier out to swap

So non-preferred tiers don't have the same reclaim behavior associated
with them.  In fact i'm pretty sure we could summarize non-preferred
tiers as being managed hyper-lazily in the current scheme.

(if there's space, have at it - otherwise you have to wait for kswapd).

In my head, I think what we mostly want is:
  - Precious      - controlled entry,  Private node?
  - Preferred     - semi-precious, fairness desired
  - Non-preferred - not precious, lazy managed, no fairness

Just some food for thought.  I've been poking at making non-preferred
tiers less lazily managed, and I'm just finding this results to massive
regressions.

~Gregory
