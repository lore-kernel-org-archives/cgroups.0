Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F78672603;
	Wed,  3 Jun 2026 19:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780513228; cv=none; b=qZAh8h3BTuNdY77Mw3kt7I11jBP35Ixxz48YRl2UtFOpWjYzfSkhLyyBPy73rFrwMBXww8+bF1iDJBghIAIrQyMmXFSbLMd0EuWswGAfnEStWMqYFM0A5lQ63e8FkvduC8G93VEIehKuUBBAjjM4kDlijdf6qERizvAV/MunzBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780513228; c=relaxed/simple;
	bh=UoXJF4gpcHzZ2PNwYCKqHvbz0z/j1jaCt5hUjQjCPsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qia+g5n2H1n4nmKLtPZgjbFiwClQyFAl+4gRs/vHTzGE9OFPwSKQUeGEX8sq6/hKI/VspZ5EGV9OwH8F6e3/bKKj8t9AUVMYiqraVT/qpCRxW8JFZT8VyBhra74wBEEs5sSSekhkaBgfrwhS4rWk73sxvJCJny0QCKdvqTOS6Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nraqdA1d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nraqdA1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CBC1F00893;
	Wed,  3 Jun 2026 19:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780513227;
	bh=5zbCaKse9V66SE5IfNpASYQVYOGSQeR/Rad19zWfoBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nraqdA1d0f2oiroPaK7Q5IGM8vdNnyflEpyhphrkbAArWnLZ5ZH5Pwg4UH+AZ3KK/
	 nG0e/TxEfVJq4BeAXswX8D0sBuBTHMBsUQPHlwLbvjGyZx06CtIyBjf9Kp8ZHX779d
	 /r/mB51xzJ6sHWmIpysxNuL+fj8ggAhYGIncqYOz7M1NKx/0sCHJPi9KxcYkEA1dJM
	 JaBBQrrd4PmwTA3UAFAdoVMcW1k4bPO/h4G9PyjPUOUTUGMqghDg+60goT0+DIS4Le
	 DnW8d8T/Yc/KvsqmFuwQY2DdwmCx1w3ERg7mnvuo6EAuOC1KccSmvdQE2eLfIwyaTD
	 FvjbTQFbS8H2w==
Date: Wed, 3 Jun 2026 19:00:23 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org, 
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com, 
	yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com, 
	kernel-team@meta.com, riel@surriel.com, haowenchao22@gmail.com
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
Message-ID: <aiB5lEMSH97R_aiP@google.com>
References: <20260528212955.1912856-1-nphamcs@gmail.com>
 <ah-A2gQ0GPgerXop@google.com>
 <CAKEwX=MWX9KkSFAoN4xEMg3b+gZUN9=yd7rirAWG5NOBf26eAg@mail.gmail.com>
 <CAKEwX=MZQJLHNNU0tUqnihdhdPdVd19KhC-HtJxfbQ_d8OezzQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=MZQJLHNNU0tUqnihdhdPdVd19KhC-HtJxfbQ_d8OezzQ@mail.gmail.com>

> > > I don't like that the code bifurcates for vswap vs. normal swap entries
> > > though. Not sure if this is an issue that can be fixed with proper
> > > abstractions to hide it, or if the design needs modifications. I was
> > > honestly really hoping we don't end up with this. I was hoping that the
> > > physical swap device no longer uses a full swap table and all, and
> > > everything goes through vswap.
> > >
> > > I hoping that if redirection isn't needed (e.g. zswap is disabled),
> > > vswap can directly encode the physical swap slot so that the reverse
> > > mapping isn't needed -- so we avoid the overhead without keeping the
> > > physical swap device using a fully-fledged swap table.
> >
> > Can you expand on "vswap can directly encode the physical swap slot"?
> > I'm not sure I follow here.
> >
> > >
> > > All that being said, perhaps I am too out of touch with the code to
> > > realize it's simply not possible.
> > >
> > > Honestly, if the main reason we can't have a single swap table for vswap
> > > is saving 8 bytes on the reverse mapping, it sounds like a weak-ish
> > > argument, even if we can't optimize the reverse mapping away. But maybe
> > > I am also out of touch with RAM prices :)
> >
> > In terms of the space overhead I do agree, FWIW :)
> >
> > I think the other concern is the indirection overhead with going
> > through the xarray for every swap operation, hence the per-CPU vswap
> > cluster lookup caching idea:
> >
> > https://lore.kernel.org/all/20260505153854.1612033-23-nphamcs@gmail.com/
> >
> > >
> > > I at least hope that, the current design is not painting us into a
> > > corner (e.g. through userspace interfaces), and we can still achieve a
> > > vswap-for-all implementation in the future (maybe that's what you have
> > > in mind already?).
> >
> > That's still my plan. Operationally speaking, I want to make this
> > completely transparent to users, with minimal to no performance
> > overhead.
> 
> I do want to add that, even without achieving this, the current design
> already enables a lot of use cases. I think it is a good compromise to
> maintain both virtual and directly mapped physical swap entries for
> now, and revisit the conversation of whether we can afford a mandatory
> vswap layer once all the optimizations have been done :)
> 
> We should strive to simplify the codebase, and it will naturally
> happen when the original overhead concern is no longer there. A
> swap-related example: a few years ago, everyone thought swap slot
> cache was needed. But then, Kairui optimized the swap allocator's lock
> contention issue away, and that swap slot cache is suddenly redundant.
> That finally allowed us to get rid of it. Similar thing happened (or
> is happening?) with the SWP_SYNCHRONOUS_IO swapcache-skipping
> heuristics.

I agree, I just want to make sure we have a line of sight (or at least
no blockers) to having a unified vswap layer in the future.
