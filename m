Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408DE4749F6
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 21:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790371809; cv=none; b=aOL2nYoFoU1FDe/8rC/rQQ8KrPs2+m4Jk9+saqlOcE9M6zwBuKkipERqN6lebuZLJZcLiMo7vewqNQz0LY+5iyu9tRBLRLxh6jwmHDg36CyUhU/8N3FBQnlH0n+qfCY+AZotKRN2lPRv7lv9/YkC8LlEg/W2jJc75t4zXBVZAzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790371809; c=relaxed/simple;
	bh=eA4174cKq/Ck05VI+T1fEjjdA/+Uu8zjbMJZxNAHtIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HEtIWsy+hC7lRuntynkWUY5Mci33UovRatjapq9F63DTrJ+RvettqxsJZH/lXeFU//EZEwoKSP236oZ5CbNvBWrZkgLVpHIhAGri9a1bqQ/hE2kVeTXlkFzlluuBPRMJD/wrzHmW9zeFaePV7LkhmCR36OttHPa/YXmYTYHbB6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=nQk2sJ5b; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="nQk2sJ5b"
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939ca12ab70so167517385a.1
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 14:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790371806; x=1790976606; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+fKh18UTHHYV9BhDkG+zBfHvGvhTQUS2inp00ECGTG0=;
        b=nQk2sJ5bPlLX8VUJuqsAiebBT3BPcWejagFmlqFLjV6H2PprHbEIQT+V87hzxveQ6g
         hzAPHbhBqB6XdXPFBMAbOD1GNI2YqJ8g0HWdZTmH20lAIDrYcjPKjJiAD8TSns8Uj3u/
         6sPobtWKyjjJxu5cxZ5rlrwnw/AJDxEy0RYAcmZWhO30ju1WdkwrglXA4PegeCtWhJcW
         jaeqI+4dbBcD/qFE0tUpKUB6Rvg77eYQc3xDF8xCzjStSSvmS+ZEbe9SJxL7FPkllTBP
         vhSdPfkgqW44giTIhj8XHEV6Pp3rm6Oud+Wm0thN1H3PhERklUhpdf5HFmmmQIJ5evNI
         tyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790371806; x=1790976606;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+fKh18UTHHYV9BhDkG+zBfHvGvhTQUS2inp00ECGTG0=;
        b=sXblpHPFVuoQKIJrn1jG7aG6izyqREZqOLnLBeN8UEotYqRa432vWABbCmzup4dkOj
         1x2KKTYAeO5PFckTvPAqlPqThJG3p6oTaRpvkgG7QZURWH9fagGypD+PpahCX+VEvu8g
         bzEBaS04f77ZH32sPW42p165LWawDQuvOt10lO9SfWAec9vnhcl6EH9KYawH2q8/RCXb
         bcjhEe7NyoSbwbt8O0KLoRMqfcth+nSwLD8KpHxin64RwKazLknooeNmmLjMYbS1OnCv
         u+UYgRbMfixv+YypP/Mv8O5BSmY50PBXh1e53temSPGkIv1M1POFrQEbMiDbFjG7ifp9
         RznA==
X-Forwarded-Encrypted: i=1; AKwUvBxtO00pBW0NNREXkonOVRI/njgLR51+W73c/MzoirdWVqmFly9Of7AXu8nRBLDvea8ZLHPMtVSW@vger.kernel.org
X-Gm-Message-State: AFuF++lG60Rgt20trqSBjV5FCcEj8sqZM9N53DpISrZqMyMNiTYUrdcC
	ceM726ZHp6UI0HEkaWGZxDZfO/PUPi71kXaXuYB9ulzk8IPDQJdQDF+ogy/42Jxk4tg=
X-Gm-Gg: AYBFou23kgJf1V+2W6HQsNCoQb3ncyX25piycWoXEutTwGzV70cRMYDMQ/PfyTCKSFS
	p18HBBU+0/W1qiZ3HV3PZVFVIj7E2YceL1L2w1NvlIBHGWMNqdeGVs2NmznXbgFG0DBV2ujoUvb
	prXaeqwwqu7E0eXBwOVM+dPGwF83DwRl4ffCPXSYERaH9uMWFBaFF/m3IbSIgaJfUTq7CcfQUAj
	W2djpiqG1IqHql0l1zh6xpvZFBj9wGe3lpD8rv1msxyg2nJ9wtvVCL+LjY/xFP7L9OwwIN3+fHL
	fjHv6C2OM7QEyt8BVfb8ZJ9MXKM3UcEwO0cqOANo4Bm9L4yYIe3xfSbFQd/Yz3EfNUnmq2kVJil
	mXg7ZY9cd7sV/6ukqC60iSQcxUzUcaYsP40ViiwWdlcpDi4nKuMZSjTmj9ffaCTMxjBivqDk+vQ
	rulBtHHu2FmoMHPQYRVqYYEXkHRLVvEAEZ2BhCeuOayc4xPISykJD7LnxemZyQy+2PKj0Dv+cIc
	O9TggGEe7k4eaXJAAD6jTJA+Lg+deaCbnm16iSJlIkJiqJ/nTm/EaqcCl5qCFyV5A==
X-Received: by 2002:a05:620a:4109:b0:93b:f083:b269 with SMTP id af79cd13be357-93c4757fbe9mr592227985a.64.1790371805867;
        Fri, 25 Sep 2026 14:30:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c448f544asm272458885a.18.2026.09.25.14.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 14:30:05 -0700 (PDT)
Date: Fri, 25 Sep 2026 17:30:03 -0400
From: Gregory Price <gourry@gourry.net>
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbgZ1OGndQAsXJc@gourry-fedora-PF4VCD3F>
References: <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <araKDOz5bce52oyg@gourry-fedora-PF4VCD3F>
 <arbJ1LTzc7H4GL27@KASONG-MC4>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arbJ1LTzc7H4GL27@KASONG-MC4>

On Sat, Sep 26, 2026 at 04:44:07AM +0800, Kairui Song wrote:
> On Fri, Sep 25, 2026 at 12:11:55PM +0800, Gregory Price wrote:
> > 2) something has to pay the price of virtualization - period.
> > 
> >    No matter how we cut this issue, something in the stack is going
> >    to implement a method of virtualizing a swap entry.  Whether that's
> >    a virtualization layer that virtualizes every backend, or some kind
> >    of franken-swap device that lets a non-physical swap backend look
> >    like a physical swap back end without charging physical swap.
> > 
> >    If the history of virtualization has taught us anything it's that
> >    the overhead of a virtualization layer is *almost* never so extreme
> >    that it isn't worth the utility of the layer
> >    ( unless you virtualize the wrong things :] )
> 
> Hmmm... I mean there are tons and tons of projects trying to get
> rid of the overhead of virtualization, if you are referring to
> virtialization as a broad topic..
> 
> With careful design we can miminize the overhead for sure, and
> that's exactly why we need to do the design carefully :D
>

Oh absolutely, overhead is enemy number #1 - but we still deploy page
tables and virtual machines because the utility is just that high.

I suspect the level of virtualization we're talking about here, which
amounts to a single token representing many possible backends, is an
incredibly small overhead if designed correctly.

> > 
> > I struggle to think of a scenario that cannot be described
> > compositionally this way - and that is without adding any kind of
> > "tier" logic.
> 
> That sounds interesting, but I think this is already a mini
> version of swap tiering :D
>

Sort of.  The key difference is that the actual resource being consumed
has vastly differently levels of availability and at least an order of
magnitude (if not 2-3) difference in latency.  So while the tails can be
very bad, the P50s are generally not that severe.

We do this same thing in memory tiering - we treat socket-hosted memory
as the same tier, simply because it's not worth differentiating.

But we still prefer locality within that tier.  So i could imagine
memory-backed swap tiers having locality that is separately grouped
from storage-backed swap tiers.

zsmalloc actually encodes a mild version of this - preferring to
compress onto the node the folio is being swapped out from 

https://lore.kernel.org/linux-mm/20250402204416.3435994-1-nphamcs@gmail.com/

So in fact zsmalloc already has a tiering concept built-in.

> And not sure if the implementation will looks odd, e.g. like if you
> adjust that midway, you get different slot of different compression
> rates.?
> 

It is not an intuitive set of knobs, but then i also don't think it's
particularly complicated math.  But yes, there are some odd looking
configs.

> That data is very helpful info! But it could be very hardware dependent,
> especially with certain mitigations and hardwares, the faulting
> process may slowdown by a lot. This is the right picture for most
> cases, and for another example on one of our certain instance of VM, I
> observed this (high pressure, batch fault):
> 
>                     component                      µs/page
> page fault handling (directly calibrated)          ~1.92
> swap machinery (slot, swap cache, rmap, zram, etc) ~1.04
> lzo decompression                                  ~0.32
> 
> Kind of crazy that decompression only take a very minor part
> of it.  While storage based SWAP goes through SPDK so it changes
> dramatically according to the host, setup or spec.
>
> BTW CRAM looks really nice from the data of yours :) !
>

Funny enough this is exactly the data needed to argue that CRAM should
not be a swap backend - you're offloading the cheapest part of the
process.

The actual win comes from allowing the compressed memory to stay mapped
while Read-only, which means you don't have faults.  I'll call this
"ghost-pressure" - the data is in-memory, but you have to take a fault
because it's software-compressed.  Letting it remain mapped R/O solves
the entire fault/swap machinery piece.

We cannot safely map R/W however, as you could have catestrophic loss of
compression ratio.  (I digress, but hopefully we can chat more at LPC)

> > That shows up as stalls and PSI pretty quickly and can be dealt with
> > by monitoring - but I can see the desire to just have them OOM.
> 
> Right, monitoring is less effective from somehting that is directly
> in the kernel.
> 

Well.... I think this is probably an organizational philosophy.

We are pretty solidly effective with PSI + proactive reclaim keeping
our machines chugging along nicely.  I think this is where a lot of
confusion is coming from - because the PSI data is very effective.

> > > The second one is a policy change,
> > 
> > Disagree.
> > 
> > If zswap does not charge a physical slot, then it is correct to stop
> > charging the counter based on the historic definition - it just was
> 
> Hmm, but the historical defination is the logical entry, no?
>

I think this is the entire debate, right?

Historically I think it's clear that it is a physical slot, from the
time it was proposed it was talked about in terms of consumption, and
Johannes' original definition even said "physical" (for some reason
this did not make it into the docs).

The zswap-charging-swap was a function of zswap reserving a writeback
slot - which means it *was* consuming a physical slot and it was being
accounted accordingly.

If zswap no longer reserves a writeback slot by default, it's not being
consumed, and so not charging it is correct.

But if you read the docs as swap being a logical counter as opposed to a
physical counter, without the context of zswap reserving writeback, then
I can understand how we got here.

The question is how do we move foward.  Continuing to charge swap breaks
us, but not charging swap breaks you.  At the end of the day, someone is
changing the counter they're using (or methodology).

> > I would push back on tiering - this seems like more complexity than the
> > requirement warrants.  We may find memory-backed and storage-backed swap
> > want different solutions in the "tiering" worlds.
> 
> Hmm, I mean in general swap are page fault (swap entry) based, that makes
> them similiar and that's the common point?
>

As above, I think even in memory-tiering we have this separation of
reasoning about different logical tiers of memory (VRAM, DRAM, CXL) but
among those tiers we do not differentiation except maybe based on
locality of accessor (socket0 prefers cxl on its own CXL complex over
cxl on socket1's complex to avoid the extra NUMA hop).

I can see there being a differentiation here as well (memory backed vs
storage backed).

> > 
> > e.g. it may never make sense to give zswap/zram/xswap a lower priority
> > than a physical swap layer, and you may never really want to compose
> > them with one another, so why does it need to be considered?
> 
> Making ZRAM have a lower priority could make sense... Well I haven't
> actually see it being used that way, but first there are users of
> multiple ZRAMs indeed, and e.g. if you put offline batch tasks on the
> same machine with high priority tasks, and the offline batch task only
> want to finish their work, however slow is fine, and the user want to
> have lower impact on CPU usage from them, with a limited storage space.
> Well I have to say this looks odd and just a theory, but we have see
> too many bizzard usage of the Linux kernel, there are even people
> using deprecated GPU's VRAM as SWAP for CPU's RAM, and hey they
> still make sense, you can easily found popular community projects
> based on that.

This is what I mean by I would push back on a tiering solution.  We
haven't even figured this out for memory alone - let alone a component
that composes both memory and storage.

What's the chance we get it right?  I think unlikely.

~Gregory
