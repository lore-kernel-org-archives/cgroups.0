Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F6940BCB8
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 20:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790367986; cv=none; b=l5XTROzR/DTS7f4+OUKUafCUkM+393z/mkgXD6gmbvZWyDXfZXwc8tYAUppV+yglDXX8gYxuD3WIcLp1QX7vNZnG8DoFQg31+Og+dV+n4904KvglJ9Q3AYmYFQdmSBXCPErgicjT93vIrdK/+8TK+U6wb97YKLj/7S93CkTThwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790367986; c=relaxed/simple;
	bh=pLWvLgyzJJJqRJXGy0wrLLfUtbLFMrmx5MOMy9q32N4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lL4w6ZLwWjgafQ7k2bIIG1aD7GsZTZSV/LuC4uNMvTDj8DzpNPAsPhUpv1xk7mI88RA5IkdH2/uJUImgPQ+aGxfBf5n4PrqQ8HlB55q5sspbva1GxQaqKL4a0ukbUeXKj18/h+OfRDNNMZ5D1baat0nxnQzZ/YKhs7Pkhp6AWZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hszJJ5AC; arc=none smtp.client-ip=74.125.228.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hszJJ5AC"
Received: by mail-pz2-f39.google.com with SMTP id d2e1a72fcca58-880fcd3790bso322043b3a.1
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 13:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790367984; x=1790972784; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UTHOStho6nRPPrwayEo907rSZvPmwPMNwiUqVSkI8tY=;
        b=hszJJ5AC0xMm4DeciTdFlWq8eiJQ5yzUvUjWhxjHdgE8ja242jDd51bxHtAtBUN5+c
         WVPx0AzpuHYnfkh3ZTECMPcigZsWaUtuH4YozTcrjMPlzncr35PxpmmCv5pVe8c628uJ
         97Gq1Du8f8rf7SzixP7z9bU2JsavCU34KNycpVMKHRxvkydMpFqHpBuEgBxAKOFopXI5
         6g1n1qL/BkcNhxiq/YlB9axR05c8rdEPbU1Rf2o+fEGdflxO4ptA0EuD+OpDh91AeCg/
         7z4+LRPv85EULwAOar7yl3oDtYgd/9FlhaD12VsWzUE959BavgF6s3IMFznofKShx71j
         TxoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790367984; x=1790972784;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UTHOStho6nRPPrwayEo907rSZvPmwPMNwiUqVSkI8tY=;
        b=vT9+IcROyFb8Reeo2l9YGs9qQwrjuzSRcqpCKBYtpyyZtoT8By4JiHjNTveSNQBX3M
         /5zOIB4Eu4txHszWutZnpl9oRjDN15SIUcBQPQpjmM4mGEk9xcbMZoRUj8ZZgrpsOTDg
         r1S8jBi1YP4fCB3drVKgbIixRDoiu7wPh9bH6EUOZ4IcbubMCoar0rPgnMlsXy9VYfq3
         TUcyzSqqjsXdOxERp7uXW4XnlO7CyS6/5zDRbyzic6qYWalMZzvDJ7d9nhBWnAuhAfpM
         6PF3pS1LeMDk3EkXcEeI59sWIgbAZ3dsCMIby3SABSpmuPd5DOOQmHhutVEHIXrufDuY
         ReIg==
X-Forwarded-Encrypted: i=1; AKwUvBxKWg6+WNnHaEyvvbtrp9a41mRe/Oz9ctYgh8CUjLCJm2OxM8m5GicVr4J2pmITt0hoemaAp6uH@vger.kernel.org
X-Gm-Message-State: AFuF++nGQqrUZuHPfblR4DNSz1wKGzLmTnL8xwdviBo7vLB58YprFUAv
	dY1KsG4BO+vGRssJ+VFqGBlfVDnzAuuUCBUPe50CITPJ399JRVO3rfy9
X-Gm-Gg: AYBFou0p+X2ewq1blH7ychP5MGFP/Qtewdo0UmlEv1pdE6gAK5ITEYkoYzQiXBNqNiN
	dlRiJFUe99WO+FtQmESZARvub1RNYi7xnhI332Txhg59n4GdGJpa9T59Xi4rGuUHSuSe5/YyTHV
	GyGs/n8KCnXbXPb3i6n36XMSbC/O4kpBaAvZo08KoWSVZk0DqUme3RhA1mE0WBxPCwMgpC8d6Mh
	8OmySo8tTxVW1d4sMjS7fAcZv95K/PUvsuVSkcFKL3SjBJhE8UQd5y91y7e5ObrRGluVcgDBTcZ
	kYhHfZw2iinJJkrWLKEnGWyC7/IhFwL88lcaIwRc5hASc/mZCAAMZXOqBolZFx4w5dgRuSmpLMS
	cwMT3g0aiH4jM75jt0kTbUaQS1TL9hYj/R9D1myrFJMlmi0jliKbAY2xGdvJQ1JGiNTRTXGhVA0
	GDBrXQnly71Iht9wXbBdVBziIcAZyEfOfH/hOSvC9wTRkyFCB2gbioNP2wpi1U9QqsOw8og4yoo
	pFkmk6BbeDvfpSRzuXVKlqYc9TBW/0Cb1uc3jo=
X-Received: by 2002:a05:6a21:8286:b0:3dd:a006:7b32 with SMTP id adf61e73a8af0-3de0e8943e1mr7946963637.49.1790367983822;
        Fri, 25 Sep 2026 13:26:23 -0700 (PDT)
Received: from KASONG-MC4 ([1.203.116.237])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc790c80e62sm1265849a12.28.2026.09.25.13.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 13:26:23 -0700 (PDT)
Date: Sat, 26 Sep 2026 04:26:13 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbTTKE6nYWlNCLd@KASONG-MC4>
References: <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <CAKEwX=PXRB35bUL1=O4Bgx9A7aD4izZZ3dcEcCuMBBhBrMv7fg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=PXRB35bUL1=O4Bgx9A7aD4izZZ3dcEcCuMBBhBrMv7fg@mail.gmail.com>

On Fri, Sep 25, 2026 at 09:54:25AM +0800, Nhat Pham wrote:
> On Fri, Sep 25, 2026 at 6:15 AM Kairui Song <ryncsn@gmail.com> wrote:
> >
> > On Tue, Sep 22, 2026 at 09:44:37PM +0100, Chris Li wrote:
> > > It seems you are talking about a different topic: the vswap charging issue.
> > > There is a golden rule that we should follow: don't break existing
> > > users. At least with the same persistence, this rule should apply
> > > universally.
> > > In the swap tiers discussion, the UAPI was such a big deal that we
> > > couldn't implement new UAPI. On the other hand here we argue for
> > > liberally changing user-space visible behavior.
> > >
> > > BTW, I already shared that changing swap counter charging will break
> > > our and others' existing deployments.
> >
> > Hi all
> 
> Hi Kairui,
> 
> Thank you for your thoughtful response! Lots of food for thought for me :)

Hi Nhat, thanks for the reply!

> >
> > Just for reference. Maybe a seperate counter, tiering, is a better idea
> > than changing the swap counter?
> 
> I think memory.swap.* is never meant to be used as the "offloaded
> footprint". It is incidentally correct, because of architectural
> limitations: zswap/swap cache/zero page usage leads to real
> consumption of real resources (physical swapfile).

It's not that "incidentally" I think? TGhe defination from the function
level seems pretty clear, folio_alloc_swap -> charge. A logical
limitation.

> 
> But I understand your concerns regarding the missing observability of
> the "logical" footprint (i.e the "offloaded size"), and how that would
> hamper legitimate use cases.
> 
> How about a vswap counter that tracks the vswap usage? That would
> provide the "logical" view. Userspace can then monitor and act based
> on it.
> 
> I think that should cover both of the situations that you (and
> Johannes in [1]) pointed out:
> 
> (1): With memory.current and this vswap counter, you can kill any
> workloads that violate the level of overcommitting that you set out.
> 
> (2): For us, we can use memory.swap.* counter to provide isolation to
> the physical swap space, which is a real, static resource that can be
> hogged.
> 
> There will unfortunately be changes in userspace programs/scripts that
> is required. It's unavoidable. We're adding a new behavior. It's the

Right, but usually I think adding new things are generically considered
better than breaking existing things, unless the existing things are
either just metric, or really broken. But memory.swap seems has a pretty
clean definition and implementation, and usage?
