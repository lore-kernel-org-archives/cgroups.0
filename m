Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54D0499F3E
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 12:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165520; cv=none; b=M+3PJTJ1xxB1uDinsvBhWkHrCDE0dUtGgCzglLOw57BeA//0DzLL7LJsvbFKzODHUu6AF26KAew2DHJASSR5F2oZEXEHDPn27RU4zO4CXOjhCYIs3N+GSkmCjOhS6sP+9/Kp8OszRjKktDQf7StfD0LcRa34dNJ3H1+CAo2/N3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165520; c=relaxed/simple;
	bh=P2mtw9GVAY2T2gTvi8dxKOiJYKSqx3tp1Lhkfn6w1rA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8U/1eUofG008Fk59ngTigvXj0NGeXAPjFT2R2nF24IotjcmMokQo8IeYkrjcFb0Orw//Mn34FnLPniIHgxselnfyiTl70vfBDvtAYXzZV1tvWz8ir9d7dachC+xComyYNdyXjwJsk705If8olyV0DnR46Lngb8isTrUX0IYm+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=c1rkrzIy; arc=none smtp.client-ip=74.125.230.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="c1rkrzIy"
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb766bfd3so6667371cf.0
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 05:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790165516; x=1790770316; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IPMTUmIFbMagr41QpNmtzeOVUfCnU5evjD/bYrUNYz4=;
        b=c1rkrzIySQbU93CNbfS377LzIrTwyFhZZ/kb9CP0v8160GnMg28+csQfrAZPOt1MUC
         wBWLygo1DVVMN1ua6QjIXtqJt8i+ynjqDbq7W5IRXKhzJR4OGbQiV+qyN2pASYbTx8Ul
         yqdoP41p3wOP5Gx9mEqxNW3Nd2IIvoGZM3iPsukNyD60S/8IU4ty8O+7JL2/WbQn+oo5
         rzIh2qiyA1XS4u3oDPe8x1UEFpXrJWomEIKihyhAT+qafgGAgy/ZBj858T/Y6k+7BhNE
         w6ZC2wnBisdHB4Kn4E054g9jm4lJldY/vl81N/mlO/70GenAKpKx8ZmOUkvx2E74IIMJ
         VV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790165516; x=1790770316;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IPMTUmIFbMagr41QpNmtzeOVUfCnU5evjD/bYrUNYz4=;
        b=10836qffaGAvGhcVg7pdKjF0TkkrdyBWwiKUu1aAVjOCUIVtwQs8z8r6/TfvekWzg2
         tA1JrthewEV/Db0MrSBN1RJjFod9fTYkViKsfFoN6cRo+Ehl49zTPpL32DdmKGtFvpV9
         pFonyCoNwU87OSGGGXP40kj9Yxnlu9ov45CB4X/7lkwhYMES/WGI2gnoTaPjvoraGHvc
         MK5FRS9i+P0UmxR7eQRFvgPmrtBs3ahe9jEltN/7L4r0N4xOm9/hFDhoZS4ihgaO/l/X
         BwE1i0jF9rOXJBO5J9QrJj0YP8Ty4n5WLWWcfY7aE2c3C3pxuc3HrmSMmXtG8sYxsP76
         wH6w==
X-Forwarded-Encrypted: i=1; AKwUvBxWy5yPDKAxdglCnGX5ZWmIL1hfSiM9GYA9ySFN14RxUXwz7B8WcrzYnVGSPzOiijvGH1hfXWzy@vger.kernel.org
X-Gm-Message-State: AFuF++maGM5cChlrM951kEXR4KkPieXF7oWHm1d+LajG3HczvYgON1HM
	8lE+N3PqaNvXRdEuyGoYU6Sy394vN2E2EjGTS3oOUFNdAi68EK6grS3+UcGwUGNVeuY=
X-Gm-Gg: AYBFou2Ym3OcJlwzH3UpNT+HnYvA3iGpMFCFojUqBGGUXAKgt0qzMJthSSheT6RSw4G
	0fU92M4QWML5GzXcGf8Z0ousOZFDfigImZ5OUnUrWAEEeCsgK2EuyxSEDgESAKLYcS6xSwYzI9U
	7j+h3sgSKz7CknURRbZjOdC4sQhHa+Rb3kEgSK3CVGGh2MN1oAiTdc0Of5oDhFQB2wayH8Y69KX
	ZZ4IM5KuXwzVovjJw9L2xJEdleZVwbe5kvb2Z8WSU5NheTgIFdOmPh0nICVqYaosoWoVp8oCOQQ
	hygkkblC1mkF90cEEBm8paWlHvIeb9AyQK1kfk4GuwqQgzc6fhm2TOcTHbVXshQnQ34fZ5H9vaL
	kak0WIc5TdXPEGy10Af+O4xL50ZN8UJhM+D5bYPvcIrzL9o2+ZSllVE5JrpqAVh+69h16/URL5r
	hY+Xq5rFbz28QbpmMGm36dGsLgqfLcafi5a6iQzRj9PeXCs0QmEp36C8S5YIdtj4CaPPLp3OTnE
	iXzQ9x92TYs80YC9XwzyFtWoIzcK/p5CZ048bZ8FbIFkqm3wHa7AP+QgkSgGheXWw==
X-Received: by 2002:ac8:5cd1:0:b0:531:a6d:dafd with SMTP id d75a77b69052e-532eabb3c23mr38720741cf.7.1790165516357;
        Wed, 23 Sep 2026 05:11:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eaec166bsm18721651cf.4.2026.09.23.05.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:11:55 -0700 (PDT)
Date: Wed, 23 Sep 2026 08:11:53 -0400
From: Gregory Price <gourry@gourry.net>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <ryncsn@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arOtPQN5irtjXKh0@gourry-fedora-PF4VCD3F>
References: <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
 <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
 <arFe215hUcjLhvmS@gourry-fedora-PF4VCD3F>
 <arOeYHEf9aO7AU5X@MiWiFi-R3L-srv>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arOeYHEf9aO7AU5X@MiWiFi-R3L-srv>

On Wed, Sep 23, 2026 at 05:39:44PM +0800, Baoquan He wrote:
> > 
> > That's an SLO interface.  memory.swap is a provisioning interface.
> > 
> > As it stands, I'm left viewing zswap's counter inclusion in swap as more
> > of a bug than a feature - they account for different things (memory vs
> > storage usage).
> 
> It's hard to say. When 37e84351198b ("mm: memcontrol: charge swap to
> cgroup2") introduced memory.swap.*, it was clearly defined as charging
> "the actual number of swap entries used by a cgroup". Please see the
> commit log. With that, zswap still reserved a swap slot even when the
> data never reached disk. And not to mention zram, it's backend is RAM,
> but not physical disk.
>

If you read the entire series, you will find this documentation update
to go along with that commit:

https://lore.kernel.org/linux-mm/dbb4bf6bc071997982855c8f7d403c22cea60ffb.1450352792.git.vdavydov@virtuozzo.com/

  For trusted jobs, on the other hand, a combined counter is not an
  intuitive userspace interface, and it flies in the face of the idea
  that cgroup controllers should account and limit specific physical
  resources.  Swap space is a resource like all others in the system,
  and that's why unified hierarchy allows distributing it separately.

So the counter was also intended to be a limit on swap space - not a
limit on the amount of virtual memory allowed to be swapped (via any
backend).

Johannes originally proposed this for the documentation:

https://lore.kernel.org/linux-mm/20151211194254.GF3773@cmpxchg.org/

  memory.swap.current

       The amount memory of this subtree that has been swapped to
       disk.

  memory.swap.max

       The maximum amount of memory this subtree is allowed to swap
       to disk.


It is clear from the outset that memory.swap was intended as a resource
consumption control (how many swap entries may be used), not as a
virtual memory consumption limit (how much memory can be swapped).

all the v1 discussions you will find these counters talked about
consistently in terms of "consumption":

https://lore.kernel.org/linux-mm/20151214153037.GB4339@dhcp22.suse.cz/

  I guess this was the reason why this approach hasn't been chosen before
  but I think we can come up with a way to stop the run away consumption
  even when the swap is accounted separately.

https://lore.kernel.org/linux-mm/20151215145011.GA20355@cmpxchg.org/

  Allowing the parent to exceed swap with separate counters makes even
  less sense, because every page swapped out frees up a page of memory
  that the child can reuse. For every swap page that exceeds the limit,
  the child gets a free memory page! The child doesn't even have to
  cause swapin, it can just steal whatever the parent tried to free up,
  and meanwhile its combined memory & swap footprint explodes.

https://lore.kernel.org/linux-mm/20151215202235.GB15672@cmpxchg.org/

  As far as the high limit goes, its job is to contain cache growth and
  throttle applications during somewhat higher-than-expected consumption
  peaks; not to contain "large unreclaimable high limit excess" from
  buggy or malicious applications, that's what the hard limit is for.

https://lore.kernel.org/linux-mm/5670E147.8060203@jp.fujitsu.com/

  The point is, at least for their customer, the swap is "resource",
  which should be under control. With their use case, memory usage
  and swap usage has the same meaning.


Now, with vswap - zswap becomes detached entirely from disk swap.

There's no (physical) swap slot being "reserved" by the zswap slot
usage and the slot is now just another chunk of memory. It is correct,
according to the definitions, to stop counting it in memory.swap.

Without detatching zswap from swap, this would be blatant breakage.

But, putting aside correctness, lets discuss usage of memory.swap as
an SLO signal, and whether this use case has merit.

> Now some deployments do use memory.swap.* as an SLO signal, and that is
> real use cases as Chris and Kairui told. So I don't think this is about
> who is right and who is wrong.
>
> To keep the existing deployment working and at the same time give the
> physical slot its own knob, I think the solution is to add a memory.pswap.*
> counter as you suggested. And that is not something we think of from a
> brain storm, it comes from real deployments which already depend on the
> current memory.swap.* behavior.
> 

Then let Chris make and defend a proposal for memory.pswap.* and
justify the redefinition of memory.swap to mean the total virtual
memory space eligible to be swapped.

If memory.swap has existed with dual meaning for long enough that users
depend on it to mean something other than the historical and documented
meaning - we should have this discussion.

That doesn't mean we should simply accept the redefinition, but the
proposal has some merit considering some ambiguity dating back 10 years.


I would like to know more about his use case and why it cannot be
accomplished by memory.low/min. I can see there being limitations to
those interfaces that need to be addressed, and maybe such a change to
the definition is warranted and a new interface needs to grow out of it.

This would also allow vswap=on or =off to work regardless of deployment.


Chris has done none of this - he has offered no solution or constructive
discussion. At best what Chris is doing is finding creative ways to say
"No" without engaging good faith discourse.

You'll notice Chris did not engage in the discussion around the
proposal which intended to solve his concerns

https://lore.kernel.org/linux-mm/CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com/

He asked no questions, he brought up a completely unrelated idea,
demanded justification for the unrelated idea, and then entirely
disengaged. He continues to demand workload numbers completely
detached from the discussion at hand, and makes dictations about what
an "appropriate amount" of compressed memory is.

He's more interested in fillibustering than finding a way forward,
and this behavior is quite innapropriate.

~Gregory
