Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFD03D1718
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784223218; cv=none; b=FXzc+CKg06ZEpIjgE1/VUkZ8ykcyFbO0ga3RtqU6ofYSddfOgDz5j11S7WpJMsZEUgx71mT/2uvhopnO67mkyZsnxxTWPj74sf+7oQ+cJ3tY7kGIxr2A5kSaJmV6HWZ35+l2LAxxfaUg7/LwAv5BWKuv/70np/A+biuA9M/ys2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784223218; c=relaxed/simple;
	bh=ClU8vdgXTiP/YDwH1Gudk/UwpY6zg9kybMVj2KICN/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uv/QuKerrFEIPnxacVf7E9GGKca/SGXZChQrbAf0hM0ZeL0tBj5qCB0i+n8ah59Zfev3EXO/SWtIBGOeD1i/FqBhtb9NaCd6PegYINZVLbkaSjha0UJhZWe5ETv/Ki5epU6KktcqGS9lgJM5OjEu9u7TLUAoW2soJfIrt0tpYdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IwxhzAo+; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IwxhzAo+"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7ec3b429a3aso2481582a34.1
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 10:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784223216; x=1784828016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2q8FzZfR4mwloD+avLyHIbdhXjifcrgRRf6/0HEL3BI=;
        b=IwxhzAo+XMKllOaVSrvgN66QIjnur3tHY2o3/jV0GpZWDoIpwH/CBRqLqEgdNm7s5z
         /fUPXFvTNXut0OvuWQ8B/sy986sURwfJPB205R9nXmnT8do3HbecBeduoo9SP5D5gyda
         xdqLgF3McBfxXZR/OPrM8iWA4cDwB07Fh6uiOcjyen4PAelLRhcrrwkT7WX5vYV3IMsE
         ImGP9vbBs51nI+87zX4J0TiLKkDvukt+f0JBdgrJeCZeDScAhaJNfJ1D36OvQ8E/KQfT
         BzD3JCzSxlsLrv/INZe0KGvMPXNjV5K4Ow8WNweM2CS46T0HO90AsSWWddFos4J6j0Cy
         Pnwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784223216; x=1784828016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2q8FzZfR4mwloD+avLyHIbdhXjifcrgRRf6/0HEL3BI=;
        b=W+WliUOUrfG1rPVAnE414YkSixzwlVqWTe1yLtKJYbKm+EcHmo5abV3QkGJXhJhwfZ
         XtEjELd4sYro18jucJcOkyuDlBg2IqDuYwdMYpMUAkHmrtbBJL8EYwjnE0r1q10dNAiz
         Lzesl9lU/N9zrcx40nwYuhnM43vyS15CE+Fd/3zqrd7lubMALxFdsLVhn87GNLlJ9nz8
         aMtyQ1UoEWF+NpqxnOlksclRXvKcwvo3RdLOphhvvJI2dXEWAy0q9epgmgQO/oi43YxA
         rctJzCx635O3oBzbSmiYwqWGwGq9OEyvfndtF5m7r+jgbSCcl81a4h1jgMT4/274yxHg
         kE0g==
X-Forwarded-Encrypted: i=1; AHgh+Rpms/9uD9duUJjP5IRqI9umUrEhZEIYqD4fMqaN05MFTXwJ3tZ8pxq4k6CxkvCT0QaqK1ZJBPBA@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr5ShZuZWTKpaWqMj4iEtTPb0WYXomE0ScWFYV6PmnTA+f2kl7
	Fsto9gZWMOiuCC/SF7IlD+9TrSZKO35Dj96jx/6t2fAG7yOz31ftWmJb
X-Gm-Gg: AfdE7cnMnB1zojqjjrNhC1niSfcGWLBxjy64cgD41MoNwBkBrTHJ2jrDbXHpst6oRjH
	PnQjH793ypJo6lcPo/d2aCfbKni+WNVFl9iD9axT7FxCP7lcWXAGR8oxiLCnbm70HEiGzWEJ4nG
	uvIMrfkSeszezxzTkA1S9kmmhyWTzyE12nuJwkSkRWBBcjYO57/Lvl0P4DwmBl9YtV3dd+i0StD
	CR28mawiYUxN7Y9Gi3WqiImwxRdWlRQ8OuEBPCcsZymVeQ3pWX7FLvoOKBLl+nA5ZYxI+lGUaix
	dc51HAttEjsftw+5Md3P4EWv4BFYxIllt9YYnryEsSMrEGWtLpcmXojlDR0m9rQGQliP7yGTp8A
	TcP5K9lCfOEg68gYlxUghdt37kJ4LycbeDSPYH/9WxFOcjWYwEXLsX8JxJ69zHfSgbFrjlxO+Td
	uXBvaUFKTxS+mH3FkqoQkLJ8F6tQXJdxL7
X-Received: by 2002:a05:6820:4ccb:b0:6a3:a54a:367 with SMTP id 006d021491bc7-6a3c6007e30mr8115803eaf.14.1784223215792;
        Thu, 16 Jul 2026 10:33:35 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4f::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-455b767413dsm12696507fac.3.2026.07.16.10.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 10:33:35 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org,
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
Date: Thu, 16 Jul 2026 10:33:32 -0700
Message-ID: <20260716173333.1413857-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a8a0e540-414b-4174-a9f9-2c501fb46130@kernel.org>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sorry, re-sending because linux-mm didn't get added to the reply when I
sent it out.

> Sorry for the late reply :) Yes, hopefully talk to you in person next time!

Hello David, no worries! Thank you for taking the time to consider this
series again.

> >> Assume you have a bigger hierarchy (HBP, DRAM, CXL), or assume you have multiple
> >> NUMA nodes with a hierarchy each.
> >>
> >> Your proposal doesn't really seem to be very versatile, or am I wrong?
> > 
> > Let me address these comments separately!
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

While I do agree with the idea that tiers in general are not stable, I think
that for the most part the "toptier" node is generally stable through hotplugging
nodes. In your example above, the DRAM will always be the toptier node, right?
In any case, I think if we are to support 3+ tiers I have to change the
semantics to distinguish between higher and lower tiers instead to be
generic anyways, so I will change the wording to reflect this!

> > Next for the 3+ tier case, I think this is a lot more scalable than it seems
> > at first. This series depends on another RFC that I sent out [1],
> > which pushes the concept of "stock" from memcg to page_counter, which means
> > that it is more scalable to just add more page counters to each memcg.
> > This means that each tier would just need another page_counter to track its
> > memory usage, and we trigger selective reclaim on the tier that is being
> > targeted via the scan control nodemask we introduce in this series.
> > 
> > At my talk in LSFMMBPF, Usama noted that the user-visible API should probably
> > remain the same, no matter what. The way I have currently established the
> > memcg files aren't really scalable, so Usama suggested turning the
> > "memory.toptier_XXX" sysfs files to "memory.tiered_XXX", which would include
> > a newline-separated / space-separated list of per-tier limits. Something like:
> > 
> > $ cat memory.tiered_max
> > tier_0 20971520
> > tier_1 31457280
> > ...
> 
> memcgs are currently not NUMA aware, so this could be one possible direction.
> 
> But is "tier" the right abstraction? I really don't know.

From my Pov after working on this for a while, I think tiering is the grouping
that makes the most sense. It is my understanding that memory present in
different nodes, but belonging to the same memcg are fungible; memory from 
one node isn't more or less scarce than the other node.

However, if the system has multiple tiers then the memory is no longer
fungible, and memcgs will be competing for the same scarce resource. So I think
it makes sense to limit how much a memcg can make.

> Are tier numbers really what we want? I don't know.

If this doesn't make sense, I can change this to just tiers 0-3 (MAX_NR_TIERS
is currently hardcoded to 4 across all architectures).

> We'd really need some feedback from memcg folks.

That would really be awesome : -)

> > So we have a way to make both the user-facing side stable, and the internals
> > also more scalable.
> > 
> > With that said, I've opted to leave the internals to 2 tiers for now -- I think
> > it is not too late to add the generalization series when we start seeing
> > 3+ tier systems out there in the wild. My goal was to introduce tieredness,
> > and we can work towards generalization in a future work.
> > 
> > On that note, it seems like in general mm is aware of 3+ tiers, but most of the
> > existing work revolves around distinguishing between toptier/everything else.
> > I got this impression from reading mm/memory-tiers.c -- but please feel free
> > to correct me if you feel like I have the wrong idea here : -)
> 
> I assume you're right, but it's something different if we end up providing a
> proper memcg API towards the users.
> 
> > So perhaps the generalization work would benefit from first introducing more
> > general tier awareness (not just toptier vs. rest) in memory-tiers.c.
> > 
> > What do you think? Does this approach of introducing toptier restriction for
> > now, and then generalizing in future work make sense to you?
> 
> I'd suspect that we'd want to support multiple tiers from day one -- especially
> get the interfaces right.

So I think the interface that I have at the moment (in the v3) is stable across
any number of memory tiers. My idea was to land something with a stable API
and then as future work support 3+ tiers. But if it makes more sense to land
the scalable tiered memcg work as the first iteration then I can work on that
too.

I've been working on v3 for a while, I will send it up sometime soon so that
I can start the discussion on this again. I really want to discuss with memcg
maintianers and migration maintainers to get some confirmation on whether
the series's direction looks good and whether they are happy with my
vision for the series.

And then in v4, I will add the scalable tiers.

How does that sound? : -) Again, thank you for coming back to this.
It means a lot!
Joshua
