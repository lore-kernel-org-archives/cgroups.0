Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3862A4A3D51
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 16:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789145160; cv=none; b=Z4gvPm1g0D3J2hTnZr+gYLRbfJc7KyNUyAF6GjfH/6rQbFa4cdIGRsKrE3FBUY1EfI69DSBNnJflVWmWQ6BWcbtAuqTpK23LW7+9UDDq1sIIVfNSCSp6bFcbNwtqbgiVko4fGpjDQAsFu3GvZh3hwU1o1tzIw75xX+5+335v2aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789145160; c=relaxed/simple;
	bh=iVjHC+6s8+AGQU6RRqV42Jq80JuEkr3tyj+AhFd+fe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFBzGmjr+JeFcxwrFXzo+sGLvJy+3jykAX3CpD38rankRhB7Wd1Ala65bHloGuDx5fSyzkhSIXme54wgr9eB7n0qAjNrbSSLf3Ht5rp2HjcJPrOCzmzzYYEJ+uIZ578zJ+35AhOXz4hjQwnISehc9ojoODuaJWsdrjCh4EDLBi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ipDHnnk0; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ipDHnnk0"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iVjHC+6s8+AGQU6RRqV42Jq80JuEkr3tyj+AhFd+fe8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789145154; v=1; x=1789749954;
 b=ipDHnnk0VRcBMvNduGCJFtepe3w0LLG7UlPAnox8ngTrZ9q3T/Jx/ZAHhc91zmP5+amXtTqE
 MSKCAEGVXd/NiDt2TGf7VdtUGdg8+2r6OeKhE8eL/1l73NeYvyENpGlEm0UyC8GhkHuvZUIx5dg
 owyA2XgfG8+8zFdx89iEDbVo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6c76367668246014;
	Fri, 11 Sep 2026 16:45:54 +0000
X-Mizu-Trace-ID: 6c76367668246014
X-Migadu-Flow: FLOW_OUT
Date: Fri, 11 Sep 2026 09:45:52 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel team <kernel-team@meta.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <aqQrPLPXHXiuKup0@linux.dev>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLZ5TVDAqEbIeMN@linux.dev>
 <aqP81aqNbwAbs2P0@fedora>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqP81aqNbwAbs2P0@fedora>

On Fri, Sep 11, 2026 at 09:06:29PM +0800, Baoquan He wrote:
> On 09/10/26 at 09:39am, Shakeel Butt wrote:
> > On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > > Hi Nhat,
> > > 
> > > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > > .....snip...
> > 
> > [...]
> > 
> > > With VM_SPARSE, xswap's cluster access is exactly the plain-array line the
> > > rest of swap already uses:
> > > 
> > >     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> > > 
> > > no branch, no RCU discipline, no tear-down state machine, and no NULL
> > > return. So VM_SPARSE doesn't add complexity to close a gap; it lets the
> > > cluster layer stay as simple as it already is, which is precisely the
> > > part later work (writeback, rmap lookup, memcg charging, THP) has to sit
> > > on.
> > > 
> > > I'm not going to claim xswap wins on throughput. I measured it:
> > > on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are all
> > > within ~2-3% of each other, effectively identical. 
> > 
> > So the claim is VM_SPARSE is simpler than xarray based approach. I feel like
> > we are discussing implementation details before deciding the design and
> > architecture. So, instead of VM_SPARSE vs xarray, let's discuss and decide the
> > need for dynamic growth. Why we want dynamic growth upfront or can it be added
> > later? Once we decide that then it will be very easy to pick an implementation
> > that would take us there.
> 
> Hi Shakeel,
> 
> Thank you for joining the discussion and for taking the time to comment.

Hi Baoquan,

I am mainly trying to facilitate the discussion but your use of LLM is causing
more confusion. LLM use is fine but please at least re-read before sending that
the sentences flow and makes sense.

> 
> Agreed on requirement first - but this one was already decided, and not by me. In
> the July ghost swapfile thread Nhat rejected exactly the shape of "grow only, can
> be added later":
> 
>     "Except for my virtual swap design, which does support dynamic growth AND
>      shrinking of capacity on demand ;) If it cannot grow (and furthermore, if it
>      requires userspace operation to trigger swapfile growth), why do we need this
>      at all? Might as well create a new swapfile with swapon?"
> 
> To me what it converged on was "dynamic growth and shrink, no writeback yet".

I am not getting how out of context above paragraph shows the conclusion about
dynamic growth/shrink and *no writeback*.

> So automatic growth *and* shrink is the requirement, and the simpler alternative
> was already on the table.
> 
> And I keep mentioning it in the cover-letter of each version of my posting. I
> only did the foundtation via lazy vmalloc. And Nhat will do the core
> part including writabck, rmap lookup, memcg accounting, zero page fill,
> etc.

I don't see any evidense of this decision. Actually this whole email thread
shows that there is no such decision.

> 
> What is still genuinely open, and I would like us to settle, is how large the
> device's address space should be, because the metadata scales with it:

With dynamic growth/shrink, is this really a blocker?

Anyways, I will let Nhat and others discuss the technical details (unless I am
asked for it). My main reason to join the conversation is to converge the
discussion to a decision and resolution.
