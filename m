Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7A33EC2E1
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 20:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784838085; cv=none; b=aqM6fUykUWpvyBDjp0bgEqhdylcWtGARE/QNPXHTtETiVz3lvoSf/Spn04Ao2Ws7loWbzGPGujEYYBUMlYPFihwvEkmsCYR7B/+j4jdGyREotur6+omVuhgHUsguH/tmPeur4SzU7ExgqqEyjyARoSbT9aXSwYaWInuz/8uDd00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784838085; c=relaxed/simple;
	bh=qhTFtcs+K9pMyshGCzhFk2k3M3wv62ULXFylkT6mSU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4RZ3FrAkATXBTht562Nh6EgnmgRpMpwIRP/Vvu6JejC5CJk4jW0dVOY0zLyCqKGnMIAtnzTugx1CFp0yIYgFBuC1GIudsyXW2TyzEGNSaHeIPFPl78R0PO8ysnPQMrvRTKqe9CI/WwdguwXtw91n4o5Hm5zEIDoKWf3KbIB9wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SsVXGtGl; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SsVXGtGl"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6aac8a94a2bso634014eaf.1
        for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 13:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784838082; x=1785442882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a7NoLvTE348K+Na68Jw9OquhlDUzGX30hZ/eyZXWDcM=;
        b=SsVXGtGl0faSCHR0qEjcqRIsQxxpspTuCvI/0teEvP5P4sNuhz13NpIHq3phS+uw57
         5cukLHMjBp9HHK+hOnJgFhvLSEv0TT1xHTbtT5PW8U5cRGlQHEDluORXeXY3Nhu47dFu
         ZVZJZMBHVqeD4ANwny8qp/d/3YMPJWyAwSkKI3odjlMIke28nL2Jm4cCOnGtinv1UAuJ
         naigI7g5gX+InF3KYovQnsMEqjuoKPynMrfzcTCdX/iV9178kJ2DKno/GDCD/40PhOmH
         8HbnvY8+jlFgElOvXjmlGDFNj3bnzeor3csU1jDBSxGGwP4l233Sz3VxVVNj/WKDMLwg
         B7yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784838082; x=1785442882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a7NoLvTE348K+Na68Jw9OquhlDUzGX30hZ/eyZXWDcM=;
        b=aLBMjjv372+7gkvKtzrQYriCLOP/FsGO0eiTAJqFIBI4KiHVqCJoWrxMLJBoGawOql
         Z8rpJAlQI86aAre+Bu8hm5/sfxjlH9U/a1Mso+R5BHv2t7T/biDYrzBlXH5hGcCxSlty
         gVQTs81g1abP1175q03RMGhaUGMkMOFY+stNsscilKqgY7xzSptv+KKdsQfySH5P1u+N
         1Xm2Ba/J8cRRi+pJiBOwpiwupjWTEkHVRBnyJOKwBxhbNyMD65iIRO+YeYC3PIPZSLsy
         FhBbZJMUsySXdrE2qXKfLpvqiUBUCuJtNSqMkfBC7t9yc99zl2jvuG9b34HAeh2dp38h
         nrtA==
X-Forwarded-Encrypted: i=1; AHgh+RrQHEscOSAnBL50Ufd5VeNPizZBklRAiYFGBMVHDT9twqX5U6GTROL3y106B8dVUs9ssuZ9bjnB@vger.kernel.org
X-Gm-Message-State: AOJu0YyRBH/rJsHtbk2dYK2FS7jW60kNK5/Vgx3ghbI/XzX2DGHbzt7J
	tKckhEqD8oOJc7qhAqt7Dyhq4BKZwFQQBViX7pNlen8H7EIrR9esbGw/
X-Gm-Gg: AR+sD13VzIYcIfXVhOl2/lroqN+B5GJPtA+Bkqs11kI6HGOE/SjUL6kt3yjvlxe0TUS
	t+ASphvvFhEyu2v5UiFwoc38vmHEGyoobvEf02xuSUApOfmYQ0SCKcKpjnpY4Dp4fZn9v8w3vK8
	hDs2vWHOs8anbl02zWQeRDXGfRZfVC7fztuOXo8OJVh3oLKlJ8pkkh1CKs1abHALQ8/jzNvxFr9
	t1JnUgMiEaiNvGoU8n77oNasfYoc2HZCLRhC7aPOfqfGDBrNvxxRiW/5v6kq26Y3RXP+XEgco+h
	X6hiGqJjwxAvgzJ7GvzNfemMQAu4P4MSBcxC++e9c+MW4JPwDC3BIygEqOjtdVrEQpu1m9jQhu2
	gceBX7usIFTcfLGbeA2uJK5H0uiyxN7iYVlC17QIUKXp2BzVoAlL/tB3tgHHZycZczC41HcdKfL
	NXQ0iOWteac4Z8Ok/VHqpvARHhXh1pCxg=
X-Received: by 2002:a05:6820:7042:b0:69e:43a2:349 with SMTP id 006d021491bc7-6aad4139c06mr1581776eaf.47.1784838081210;
        Thu, 23 Jul 2026 13:21:21 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:9::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6aa79ef5a37sm4173918eaf.13.2026.07.23.13.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:21:20 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-mm@kvack.org,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
	David Rientjes <rientjes@google.com>,
	Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/9 v2] mm/memcontrol: Make memory cgroup limits tier-aware
Date: Thu, 23 Jul 2026 13:21:18 -0700
Message-ID: <20260723202119.3688800-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <alkB4tnJxOLyVCi2@gourry-fedora-PF4VCD3F>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 16 Jul 2026 12:55:55 -0400 Gregory Price <gourry@gourry.net> wrote:
> On Thu, Jul 16, 2026 at 03:11:30PM +0200, David Hildenbrand (Arm) wrote:
> > > 
> > > First, for the multi-numa-per-tier case, I think this is already pretty well
> > > handled by my series. Once we realize that a memcg is consuming too much memory
> > > from a tier, we trigger reclaim from that memcg via
> > > try_to_free_mem_cgroup_pages,
> > > which as far as I can tell already handles the multi-numa per memcg case.
> > > Other than restricting the scan_control's nodemask to target the nodes
> > > from that tier, I don't think there's anything else to be done.
> > 
> > I am not really sure about the "toptier" notion, in particular if your memory
> > hierarchy is not static.
> > 
> > Imagine that you have only DRAM in your system. Then you hotplug some slow CXL
> > memory. The you hotplug some HBM CXL memory.
> > 
> > The meanting of "toptier" changes, which is rather confusing to me.

Hello Gregory, hello David,

So circling back here a little bit (sorry that it took a while to get back)

> I think this is a naming problem.
> 
> Maybe we should start calling this "initiator tier" or something.
> Maybe tier is even the wrong notion here, but it's the best we have.

I think the confusion is that "toptier-ness" doesn't give the full picture
for whether a node is a promotion candidate, a promotion candidate node
needs to both be toptier (adistance < toptier_adistance) AND also have
CPUs. So a HBM node that is hotplugged can definitely be toptier
in that it has a smaller adistance than the toptier_adistance, and will
probably even have a smaller adistance than the DRAM node, but if it
doesn't have CPUs, it won't be a promotion candidate.

It gets a bit more confusing because this distinction is not a tier-wide
distinction; you can have two HBM nodes hotplugged where only one of them
is CPUless -- then we cannot make any statement on whether the tier is
a proper promotion candidate, only that one of the nodes within that
tier is a candidate.

> But I agree "toptier" naming doesn't generalize to complex systems.

The merits of calling a node a "toptier" node is therefore a little
dubious I think, it's just one part of whether a node can be promoted to.

Anyways, I think this is outside the scope of this series. I think that
for the scope of what I am working on I will try to move away from
referring to things as "toptier" nodes but rather call them 
"promotion candidate" nodes. I hope that distinction will make this
series easier to understand and read. 

> > > $ cat memory.tiered_max
> > > tier_0 20971520
> > > tier_1 31457280

One change here is that it is not really possible to have 0..N-1 indexed
tiers, since those are not stable. For instance, hotplugging a HBM
node (as David pointed out) would replace what tier_0 is. However,
one thing that remains stable is the abstract distance (adistance) the
tiers are associated with, so I'll preserve the ABI that I have right
now, so we can have something like

tier_42 20971520
tier_128 31457280

And if HBM does come up as the "highest tier" with the lowest abstract
distance we will just have

tier 16 1048576
tier_42 20971520
tier_128 31457280

And we will not have any problems with tier_0 defining DRAM and then
later switching to define HBM. It is certainly less interpretable but
I think this is the only way to have a stable set of tiers, since
adistance is pre-calculated for all possible nodes at lateinit time.

> > memcgs are currently not NUMA aware, so this could be one possible direction.
> > 
> > But is "tier" the right abstraction? I really don't know.

> Really I think we're trying to classify 3 general pools of memory
> 
> - Precious:      HBM
> - Preferred:     DRAM  (initiator preferred targets)
> - Non-Preferred: CXL   (fallback and demotion targets)
> 
> HBM nodes are already weird in terms of fallback ordering, but ignoring
> that for a moment.
> 
> Non-preferred "tiers" are slightly different than preferred "tiers".
> 
> Under normal operation (assume no mempolicy or cgroup weirdness):
> 
> 1) Direct reclaim NEVER targets non-preferred tiers (kswapd only)
> 2) Promotion NEVER targets non-preferred tiers (promotion -> toptier)
> 3) Under total system pressure (direct reclaim on top tier), we swap
>    directly from the preferred tier out to swap
> 
> So non-preferred tiers don't have the same reclaim behavior associated
> with them.  In fact i'm pretty sure we could summarize non-preferred
> tiers as being managed hyper-lazily in the current scheme.
> 
> (if there's space, have at it - otherwise you have to wait for kswapd).
> 
> In my head, I think what we mostly want is:
>   - Precious      - controlled entry,  Private node?
>   - Preferred     - semi-precious, fairness desired
>   - Non-preferred - not precious, lazy managed, no fairness
> 
> Just some food for thought.  I've been poking at making non-preferred
> tiers less lazily managed, and I'm just finding this results to massive
> regressions.

Thanks for your insights Gregory. All of what I am saying is just in
aggressive agreement with what you and David have pointed out.

I am working to make the next version generic across tiers.
Thank you both! I hope you all have a great weekend,
Joshua
