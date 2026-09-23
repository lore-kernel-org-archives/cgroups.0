Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2269B52E07E
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 13:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790171765; cv=none; b=hfUcxOoXLlD1Qz4uQawgKSg9U8KojUrykKgfXfsE6r5Zsb/dWJHnDqw9TewU7Wvv7/JnANeIgVAFXn30Zm7VSRri2BMypqBHQer7mbofEbS40iasXE7V2tbjV7+N04h+w/tVkFlJoCjnqT95+EzaGWj2oUZ5ZwkV62avSmJBWR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790171765; c=relaxed/simple;
	bh=51BxNxE6qUpfl1S4HbyYFu+F0ILsO4eP8vqT4GlKj60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lzx3FswQ53flxVvF0ocY7rC0qcbxG/NgBZ/tEibInZmpuYQLhZM/6HBd4DAQeSvlfGUTPnzAmvWA78ZeSb/ww0wruZti89v5isBWmfX9CCa0xioZpG7yVE4LC4DRpGjaYh4TPtxsbMHawPOU09IPgQoY48MCwZw+ZB8rY5+cc7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=uWCboD6L; arc=none smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="uWCboD6L"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-9105d241693so8007096d6.0
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 06:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790171761; x=1790776561; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fXC2nmOyFn84bCUp7WE6WyZCEN3lbi386wtQ70wZOAo=;
        b=uWCboD6LCoqNfUNRjAbXiGxDjAtAqkKVq6cpWz0auhXfGRKEBn9D00a3xvxpRpe7XD
         GEMCOFoGMcy5Ux/Rg80hHOLVsW2ZWMeza+EWtvJGnbObxgAmn7FOSY3QuBmepQvjy7cf
         bW/G7f/McEWpfr3tB/Cdd3enCDbX58PHLkRLZnpIOPLHwH7vqqPvgdiP2cL1iJUJPfuv
         VZ3vhQ+hGzcYGOTKvO5NL3xyNmr6pbEwtsrEUuTSKfb+3PdKyuWsbbZ3dstaOtMaVd6r
         OczyDR27xBOourn4w2xbNXWNeK+5nOVW+18MypLsgBUpO3w4izDWtu5z2wvQ9TiqDu1H
         qztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790171761; x=1790776561;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fXC2nmOyFn84bCUp7WE6WyZCEN3lbi386wtQ70wZOAo=;
        b=UQV4lyALgOcwql1YoVOoMiDWEJf9RY1TCtiABrpqJh66LQYQFpwUaEz4dZXd8kdTxT
         lsYFhQRcZnKOTHJnFMhopnCJOHiKsDQ+1fiTYBzzHOsn+pyFM0J9sX4daz8J8rnCvs13
         ut55QWynqh/nuous6YSX9zm7SRh/IZ1CZDyjw9H9HmekcwSpOWYmnScz2/6TNmFbwIcz
         5+XnzA561oCQ2fwIB7GvOUUPIsk4LJh22fCw5QNu9a4KfaCdJDaMkgpVrzznq42SV/nD
         3zY8wfEGofNXCLVCkIPJ+v162i7waR2HfwAX+W9h6F0fs3qFkhvdSALhzAtPGXuQPdb9
         tUoQ==
X-Forwarded-Encrypted: i=1; AKwUvByxbZydfn22r5VXgvCFp5R4zvMBqmgkfm/w/sZtcfP3N/qXEULteYz8nh0QGUuW+V0RavbpB+m9@vger.kernel.org
X-Gm-Message-State: AFuF++kEgkKz+dY810KRWgNu1OWe6nkF4tlhCGSDG3F8tApaQ2DGB9BS
	+HVcg9HJMfFUPow0+bdmXBwFTOMTa337pFnxU2lB3LoYbe+Iw8vJah8OWByBGZEMDTk=
X-Gm-Gg: AYBFou2NMHfOfSP3oTQ7hidqRYiRLoyt099O2sYDHKSntrJmf8+DgaJQb0VWSdqc5Yu
	427nSmJ3zybtnq6/vpvWB5wAokD1jGx9XV7bIZrOqTSAXVxrbr3PdEK4Iud6T5UJ2GXldumLkEu
	SAnl9qdkFPRVRZwNIPjabA5A2x0UM3SDdL++Iv2Q6vVFTzx2MwFKz4xlEmlpVTcbHtFB8HPxlYO
	Kf7OQ398hNR9Pp0iBTfmIiRQZU4cwW+pHo2hbi2j7c/TtiwrJ0CIPRv9c20EUmlPsbTyV/rV+gF
	NtN3kvK0q4KVJIICuROx1H+0rySq42GRjjaCENwAdgZFUYmxzHe5DeMv1Pe4y4MI1HeMzBrcQ0h
	hgKhoKyYF3rsxwBIcdhHLxO7Ji60uTlKi6lKc802HcaEtCcpyKqSOXA4UzvsRUkfY3Syd0w/oO9
	Fnux3C5MX0HfJcaPWGPHGA+xQ/xlPTXgHOF/btWKiI1PIkPXMQUKGppfkGUmEUwNzsHsKznXPRY
	3r4IUvG
X-Received: by 2002:a05:6214:4a84:b0:910:63b6:fc60 with SMTP id 6a1803df08f44-9140c2bb7e1mr41090286d6.11.1790171759269;
        Wed, 23 Sep 2026 06:55:59 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9140c4640c9sm20563416d6.40.2026.09.23.06.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 06:55:57 -0700 (PDT)
Date: Wed, 23 Sep 2026 09:55:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arPaalt234UG2qHV@cmpxchg.org>
References: <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F>
 <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
 <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com>
 <arK7gLYD0GJwzKFq@cmpxchg.org>
 <CACePvbW9=HTg69J1JTAUROZui4vD00g4=xbFk8QfL5Xdrg6pAQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbW9=HTg69J1JTAUROZui4vD00g4=xbFk8QfL5Xdrg6pAQ@mail.gmail.com>

On Tue, Sep 22, 2026 at 09:32:17PM -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 7:31 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Tue, Sep 22, 2026 at 01:14:31PM -0400, Rik van Riel wrote:
> > > On Mon, 2026-09-21 at 06:11 -1000, Chris Li wrote:
> > > > On Mon, Sep 21, 2026 at 2:53 AM Gregory Price <gourry@gourry.net>
> > > > > That should tell you that your model of reasoning about this issue
> > > > > is
> > > > > ill-suited to address the problem.
> > > >
> > > > That is what I'm suspecting. Nobody in a sane mind would want to
> > > > zswap
> > > > 100% of the RAM and maintain reasonable SLO.
> > > >
> > > It could make a lot of sense to have some default
> > > limit upstream, that says the zswap pool is not
> > > allowed to take more than half of memory, because
> > > at that point the compressed content will be
> > > crowding other things out of memory.
> > >
> > > That seems like the kind of limit that is large
> > > enough that very few people will run into it,
> > > while also being small enough to prevent actual
> > > corner case trouble.
> >
> > Just to be sure we're all on the same page:
> >
> > Zswap *backing memory*, the space needed for compressed data, is not
> > the problem. It actually has a limit that defaults to 20% of
> > memory. And there is memory.zswap.max for users to define everybody's
> > fair share of that limited backing storage.
> 
> Just curious, how is the 20% determined?

If you look at the git tree, you'll find it came in with the original
commit that introduced zswap. There was no explanation.

> May I apply the same argument used in this thread: since you haven't
> surveyed all users in the world so you can't determine that 20% is a
> good value. Let's make that 200% for safety.

Yes, thank you:

" the practical usecase for limiting zswap memory to begin with is
  quite unclear to me. Zswap is not a limited resource. It's just
  memory. And you already had the memory for the uncompressed copy. So
  it's a bit strange to me to say "you have compressed your memory
  enough, so now you get sent to disk (or we declare OOM)". What would
  be a reason to limit it? "

- https://lore.kernel.org/linux-mm/20240925192006.GB876370@cmpxchg.org/

This is my whole point. Swap/compression is a low level layer in the
reclaim stack. You're asking it to make a page smaller and it does it.

- It's *reclaim* that determines who and how much gets swapped.

- Cgroups provide configurable memory.low and memory.min residency
  enforcement based on volume.

- MGLRU has the min_ttl setting to configure residency based on
  hotness.

- Many real world environments use some form of pressure-based OOM
  killing to determine when too many pages have become non-resident
  and the workload meets some subjective threshold of "suffering".

There is a whole stack of clever algorithms and configurable QoL
policies that make judgements about residency.

The compression layer has one job: compress the pages I feed you. It's
purely mechanical. It does not need an opinion on which pages are hot,
how much compression is "too much". It's a glaring layering violation.

The reason we keep talking past each other is that you think I'm
arguing for a larger limit. I am not. I'm saying the mechanical
compression layer has no business editorializing what the policy
layers above it have determined.

> > The point of conflict is the pre-compressed side. How many swap
> > entries can vswap hand out. Hard limiting this is the point of
> > conflict. Any given swap entry can refer to several things: a page
> > full of zeroes that has no backing space; a compressed page in zswap
> > that consumes some amount of backing space; a page that was written
> > back from zswap and now consumes physical swapfile space.
> >
> > All mapped by the same address space.
> >
> > I don't see why you would limit this at all. I don't see how you would
> > pick a sane default. And if you limit it and workloads run into it,
> > there are no cgroup controls to manage fair access.
> 
> I am not using a limit to enforce the workload. I am just using the
> limit with a safe margin to set the vmalloc max size for xswap.

And this would carry a lot of weight if we HAD to go with vmalloc.

But there is an alternative proposal based on xarray that does not
have that limitation at all. Neither Nhat nor Boaquan seem to have
been able to find any performance issues with it.

It's YOUR claim that we need to go the vmalloc route. That means it's
YOUR burden to (1) propse an implementation limit that everybody
agrees is safe and (2) why the usability risk of having a limited
implementation is even justified (e.g. performance numbers).

You clearly haven't done either.

> This is similar to the 20% for the compressed pool. I do believe the
> app will suffer if too much of its memory is swapped out. e.g. 100%
> of system RAM.
> 
> > (Despite what has been said in this thread, memory.swap.max is for
> > those entries that compete over physical swapfile space. It must not
> > and can not control vswap space used for all sorts of backends.)
> 
> Doesn't memory.swap.max limit existing zswap? Then that is a
> user-visible behavior change to make zswap don't go through the swap
> counter. That is a change we need to avoid.

No. This has been explained to you repeatedly.

It's for managing fair access to a physical swapfile space because
that's a constrained resource.

After vswap, zswap does not use physical swapfile space anymore. But
other things will, and it's important it keeps working for them.

This "user-visible behavior change" is the whole dang point.

And it's opt-in, so nobody "breaks" through kernel upgrades.

I'm sorry if your setup is abusing this knob for enforcing some sort
of residency. This isn't what it was designed for, and it is clearly
not a generalizable model - most workloads have page cache.

You're in fact asking for it to STOP being usable for managing
physical swapfile space. You're asking to break the broader container
and memory management model as designed so you can continue supporting
what is essentially a case of creative abuse.

This is unreasonable.
