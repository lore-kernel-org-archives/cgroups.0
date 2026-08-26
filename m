Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A533B19C2
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 08:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731473; cv=none; b=BTDhw2Wn3+yk/2YDkQhLDAHyN6u737kxyJ5f4ZaMST5tvNhnydXBHXP3NJciEHpr1CDpBGJDGFHmaByGB7+URCXz1EOf7VEgV1YaTVmaEU/gfINMt8CzkIu3jD7cac7BBe+gWnBuzDA6qXJtApsWfBjJtHpnPy7mq9bRRKus+eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731473; c=relaxed/simple;
	bh=rGxbw1h/TQdAc6lVq+5VHtXog01UUxIR3lm4oWVA6s0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=boXWcZpQIIeOAoE1ARHjqO94sWVJvNPPns3vKjTEODcEml/IElJCaNdPzDhodxlrQXRFiI8ZsrtIgUSUrjYE26dbPhSx5acv65OiM5Mjfepqa/voHleRsoRdWVpYFgAsjXsVEo45rK9oq2bjcfS/+vtarn8jegnOgPptTDk/vd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R1W5YWRi; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R1W5YWRi"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a18e24ad25so859115a12.1
        for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 01:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787731469; x=1788336269; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wB7gr+OEBdPvQV2wk9lYHYxAzB0Tgui+S11+5Xp/rXE=;
        b=R1W5YWRiA0ACyDk7AhfWjBk089Tkkd4qwCjYDfbmM5kc+tlzkUa1v1E++ANc7hwFRh
         7S+7w3NfDeWLHm/MSjdFVBOaJ+Nv4TINnG0tqhlAltscWHLvVpgfvINjTqywBaBfhyOC
         au1l9BJJ+njysAr7bGpP/V6ic330oGjNP2sZfnhvEKmDSm45meSyTt+/A+1b1eXg/7dD
         pd+9+cjDhXm4PWgdtz6NWHdft/7i3hJ+ijXW6u2h7i8xB1y2lTCNMAFmbaeQHzQcpN0V
         xG3u3bExxaZ8OteUJAlE2VWJwRiUDj68C9HjVvxkHO41KJGE2pSYEZD0QMHGbsZ4hhr3
         1NHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787731469; x=1788336269;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wB7gr+OEBdPvQV2wk9lYHYxAzB0Tgui+S11+5Xp/rXE=;
        b=ZZlKDeXDVRKUDJrkU22JJwjE/EnxCIFa1H4Gc1Ntsb4gcK73Okf1uK+2QsBrCalRhp
         rlOyfHvg/Igpuh+DjYTl6WndLldr0wfQCaeeTIpABWreJOA4zfChKqDPE2NBKg+jfRKc
         9XOqomuYPS4XSOiLrFg+1HIpMe0L0IPVacJPHuK4eWf2I+TROzB4LQUCzMSgI5JwNPlB
         pEM5SS8tr/UY7gHO+ZnwVA30R0r13AA0thtsxTGdFxCO8AYBNtleltGycRb6cWSbXwJy
         v1J7L2oEAYRlpNiFmOt7ubu2sNJX0DUAVUwfn/Ot+pMtMufNBNUXGMYAA0vFbffkG7wu
         6Hxw==
X-Forwarded-Encrypted: i=1; AHgh+RocSCPHyVQcskrTJqITNUzfNEA88anOVGb3n57sDVN7ZWnE9HfXG2XLi2Cxw7jB9tgKVThMvqPP@vger.kernel.org
X-Gm-Message-State: AFuF++lcZ4YQiMBH25yLpLeBu1OBnOpU819lYPANioBVnQhCI/otMvjC
	z54izQWLk9/j5J1H8Yzk1tbzFj/j3Y1K0lb9P6q/TDYQbYdo6bLz7i/kH0XzevfQTrs=
X-Gm-Gg: AR+sD12qe0cFr0/gDdB7AjU0peSfJ7LXPWCHWoQq8plGhbc53VjVffvnhlCrRcNI+xH
	PrM/DnJ2xQUU6tENpbtdq/c0qcaaALFX4nLFqt4quOUvB7KZ1TmOaaHkXqOX1Qxib34Y/noHILp
	3p2WEUyHvv0IN7wxfCLu/LGv4LTr+nQptE2SEqdK3VTXWcr3iJIieSwppRzKV3rPS1z0D+2aum1
	/+WdevP/jWh7AQqi0OQV0zorDd1sz+8gmSw5HkgIlsWHuIQFc5ABgI4OL7Z7EppTE8tACv2Vt4t
	SduBaUo4MHalLnKRg3izMcy6UUSYVdxwHz5x0ItHdjyK259mHxU1Owmt/k/VidNHT9MWApAGXCJ
	bQKg6v3M9g6fuWpmyh4QbtAV6lV9kRvXdaIzu+u7TE9VbJfYPkqn0K6XlPLRoW7PzP5XtfQvYRQ
	1JdRahsycAk76bnN9e9vf+CsjMxiT8+T0tqtniVZhVqdCmSGXWLA6S+XB/ah65npHOLe5QyfQ=
X-Received: by 2002:a17:906:f58b:b0:c21:450d:cd88 with SMTP id a640c23a62f3a-c250bbcc64amr476059866b.6.1787731469299;
        Wed, 26 Aug 2026 01:04:29 -0700 (PDT)
Received: from localhost (109-81-80-32.rct.o2.cz. [109.81.80.32])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a88ab65sm356259366b.37.2026.08.26.01.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 01:04:28 -0700 (PDT)
Date: Wed, 26 Aug 2026 10:04:27 +0200
From: Michal Hocko <mhocko@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao6eC2SUIGVz3Qct@tiehlicka>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao2t6HP-Zt5KDg30@tiehlicka>
 <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao3quaSze8YjPjxZ@tiehlicka>
 <ao3tFg4JLNlbylTR@echanude-thinkpadx1carbongen13.rmtusma.csb>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao3tFg4JLNlbylTR@echanude-thinkpadx1carbongen13.rmtusma.csb>

On Tue 25-08-26 16:58:51, Eric Chanudet wrote:
> On Tue, Aug 25, 2026 at 09:19:21PM +0200, Michal Hocko wrote:
> > On Tue 25-08-26 14:33:48, Eric Chanudet wrote:
> > > On Tue, Aug 25, 2026 at 04:59:52PM +0200, Michal Hocko wrote:
> > > > On Tue 25-08-26 10:47:53, Eric Chanudet wrote:
> > > > > On Mon, Aug 24, 2026 at 10:58:18AM +0200, Michal Hocko wrote:
> > > > > > On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> > > > > > > CMA allocations are currently unaccounted for by cgroup memory
> > > > > > > controllers. As system resources, they should fall under memcg, but CMA
> > > > > > > areas partition the available space for different purposes and memcg
> > > > > > > doesn't have a good representation for that.
> > > > > > 
> > > > > > Which CMA usecases are covered by this work? It would be also great to
> > > > > > spend more time describing usecases.
> > > > > 
> > > > > We would like to offer some usage guaranties to userspace processes
> > > > > ending up doing allocations in CMA.
> > > > > 
> > > > > For example, a shared CMA area is described in device-tree for an ARM64
> > > > > platforms. Userspace components could then, for example, allocate from
> > > > > it through the dmabuf heap, or a device or framework-specific ioctl for
> > > > > that matter, to use the buffer with sensors. The dtb may have other CMA
> > > > > areas described additionally that may or may not be used by that
> > > > > component. In this context, we would like the ability to limit one of
> > > > > the userspace component to over-allocate and choke the other(s).
> > > > 
> > > > How exactly is this supposed to work? How is the CMA access controled
> > > > and opted in for accounting. What happens when memcg limits are hit. And
> > > > many more details, please.
> > > > 
> > > 
> > > The administrator opts in by mounting cgroupfs with
> > > memory_cma_accounting. At which point the cma allocator will charge CMA
> > > allocations against memcg and manages a per area counter depending on
> > > what area the allocation was made into.
> > 
> > So each CMA area will have its own counter and limits?
> 
> Yes, in order to enforce a limit per CMA area this series add a page
> counter for each area. Areas are fixed and discovered early so the
> counters are added to struct mem_cgroup and initialized when the cgroup
> is created.
> 
> An admin would then use the cgroupfs entries to assign an area limit to
> a given cgroup, something like the following, using the reserved area
> for example:
>   mount -o remount,memory_cma_accounting /sys/fs/cgroup
>   echo +memory > /sys/fs/cgroup/cgroup.subtree_control
>   mkdir /sys/fs/cgroup/mycg
>   echo 16M > /sys/fs/cgroup/mycg/memory.cma.reserved.max
>   echo 64M > /sys/fs/cgroup/mycg/memory.max

OK, thanks for the clarification. This confirms my initial suspicion but
it is better to have it clearly articulated. I can see several problems
with this approach. First and formost I do not think dealing with all
cmas this way is manageable. This can become a mess very quickly if we
have one limit per cma and too coarse if there is a single one. I also
have my doubts about space allocation control through a simple limit for
something that is effectively a reserved physical space.

I might be proven wrong but unless cma serves objects of a uniform
size then this will simply not work in practice. Hitting ENOSPC without
hitting limits and thus impractical for shared space management.

[...]

> > > It looked consistent to use memcg since movable pages from regular
> > > allocations may end up in available CMA regions until a CMA allocation
> > > needs the space and has them moved. So in an extreme case, hogging the
> > > CMA space of a large enough area could trigger system memory pressure.
> > 
> > I really do not understand what you mean here. 
> 
> Non-CMA allocations can end up in CMA physical regions when necessary
> (ALLOC_CMA flag).

Correct. But those are a subject of migration so any such placement
should not be blocking real CMA allocations.

> Since both CMA allocations and other system
> allocations are represented the same way, with differences only in
> properties, and they can live in the same regions, it sounds reasonable
> to account for both under the same counter.

From the memcg POV we do account physically consumed memory. So yes,
it makes no difference where the memory comes from. We only care about
the overall capacity you can constrain or protect. Generally speaking it
makes sense to charge heavy memory consumers directly triggerable from
the userspace.

That is all memcg can provide you with. Specific requirements for
specific types of memory is a different story. We currently cannot
control per-numa node for example. There is an ongoing work to make
memcg memory tier aware. 

> > > > > memcg
> > > > > looked like a good fit to achieve this, albeit handling the areas, so a
> > > > > cgroup has a quota in a given CMA resource.
> > > > 
> > > > Please expand more on why do you think this fits into the memcg model.
> > > > AFAIU we are talking about a unreclaimable memory and reservations of
> > > > CMA areas.
> > > 
> > > Since memcg already accounts for some unreclaimable memory (kmem,
> > > hugetlb),
> > 
> > hugetlb pages have their own controller
> > 
> > > or induces failure if no reclamation is possible, I did not
> > > see CMA allocations being unreclaimable to be a blocker to track what is
> > > otherwise system memory.
> > 
> > yes, we can have unreclaimable memory charged to memcg, that is not a
> > real problem. We have all sorts of memory consumers that need to be
> > capped charged to the memcg. If dmabufs are another ones then fine, just
> > charge allocated pages from the cma area. It is the "make all cma users
> > memcg aware and have per cma limits" that I am really struggling with.
> 
> CMA is system memory independently from its usage though, and in cases
> with shared CMA areas multiple users can allocate from them. Yet the
> kernel cannot enforce usage limits.

Correct. Those are effectively a shared memory pools without any
control. I do not think memcg is a good method to enfore any usage
limits for that though for reasons mentioned above. Memcg is effective
at capping the overall memory consumption of a workload. Not really
great when it comes to a specific memory pool control.

> > You cannot really assume usecase, requirements, lifetime etc. for an
> > arbitrary cma area. I do not think this is a viable way forward. Focus
> > on your real usecase, which seems to be dmabufs.
> 
> While dmabufs are indeed my main use case, they are quite generic and
> may not always have system memory backing them (device memory). Working
> at the CMA allocator alleviated these disparities.
> 
> > Explain what do you want to achieve and then we can think whether memcg
> > is the right model for that usecase
> 
> Hopefully I expressed this in a better way by now. In short, enforce
> usage limits for concurrent CMA users using shared CMA resources.

Thanks. Yes this is more clear now. And it resembles hugetlb situation
more than memcg. You simply need a memory pool specific access and usage
control. Dispersing that to a global memcg limit seems rather coarse and 
I would say impractical. So it really calls for a per pool control with
an understanding of how the specific pool really works.
-- 
Michal Hocko
SUSE Labs
