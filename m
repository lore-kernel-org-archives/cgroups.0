Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BC743E08D
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 06:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454707; cv=none; b=f8UbJIdX/3ofNjFBPsI14fdVO/Zo9iHMvGGMa0NIKbIAFi212gaVD9DDstUujlAdiB62MLdp82WAHZ3+apsgg44IWZj8R3q8+NCWic88w3SpdMNAfp/yzerRo3slHJAalQZ3u11eEUSftPngPkdeM4V2nodi/QPqUyn9v1IX6m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454707; c=relaxed/simple;
	bh=VMJgWKEeLbEF+5uGy7m1N0gpmXanMrHiGWE7G/bgYUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVTkQoB3/h64lvhwtBvPWJ3KypMB9XapFzrJjIu1BqyCPo6XwvBTeJdU6ri/vStiYBTqgFCT5L+gdDKyQWigFBEYoPHkd9X8LR/PEtGys4AETz50kFp2mZ7ZrqCeFaojqatk8X90Pd4O9f07/alZGSN4nNVMBURJk+NF8V5olTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T/Xdn2g2; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T/Xdn2g2"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VMJgWKEeLbEF+5uGy7m1N0gpmXanMrHiGWE7G/bgYUw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789454702; v=1; x=1790059502;
 b=T/Xdn2g2FUWeWKEVMnmA2X9N+5Wj8X5145Ho2+/kn5q16FacMLgJhDnHlupzglpeCZ2/Nbyh
 l1VmCndUDhsK7G8/j9WWJ+9oKzLzgCiDa1OtT8YTSmfje9hclk42/RU8I00bhSHQYn2bZkct+9b
 jb/PfoeO6b+O679kV6gEOe1U=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 79b6f2ba6867b9a0;
	Tue, 15 Sep 2026 06:45:00 +0000
X-Mizu-Trace-ID: 79b6f2ba6867b9a0
X-Migadu-Flow: FLOW_OUT
Date: Tue, 15 Sep 2026 14:44:48 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
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
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
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
Message-ID: <aqjpYHbZ14A8xRtK@fedora>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLZ5TVDAqEbIeMN@linux.dev>
 <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev>
 <aqjcFb6MFNiA6n4V@fedora>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqjcFb6MFNiA6n4V@fedora>

On 09/15/26 at 01:48pm, Baoquan He wrote:
> On 09/11/26 at 09:45am, Shakeel Butt wrote:
> > On Fri, Sep 11, 2026 at 09:06:29PM +0800, Baoquan He wrote:
> > > On 09/10/26 at 09:39am, Shakeel Butt wrote:
> > > > On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > > > > Hi Nhat,
> > > > > 
> > > > > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > > > > .....snip...
> > > > 
> > > > [...]
> > > > 
> > > > > With VM_SPARSE, xswap's cluster access is exactly the plain-array line the
> > > > > rest of swap already uses:
> > > > > 
> > > > >     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> > > > > 
> > > > > no branch, no RCU discipline, no tear-down state machine, and no NULL
> > > > > return. So VM_SPARSE doesn't add complexity to close a gap; it lets the
> > > > > cluster layer stay as simple as it already is, which is precisely the
> > > > > part later work (writeback, rmap lookup, memcg charging, THP) has to sit
> > > > > on.
> > > > > 
> > > > > I'm not going to claim xswap wins on throughput. I measured it:
> > > > > on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are all
> > > > > within ~2-3% of each other, effectively identical. 
> > > > 
> > > > So the claim is VM_SPARSE is simpler than xarray based approach. I feel like
> > > > we are discussing implementation details before deciding the design and
> > > > architecture. So, instead of VM_SPARSE vs xarray, let's discuss and decide the
> > > > need for dynamic growth. Why we want dynamic growth upfront or can it be added
> > > > later? Once we decide that then it will be very easy to pick an implementation
> > > > that would take us there.
> > > 
> > > Hi Shakeel,
> > > 
> > > Thank you for joining the discussion and for taking the time to comment.
> > 
> > Hi Baoquan,
> > 
> > I am mainly trying to facilitate the discussion but your use of LLM is causing
> > more confusion. LLM use is fine but please at least re-read before sending that
> > the sentences flow and makes sense.
> 
> Sorry, my bad. I used LLM to find Nhat's words. But I did check it by
> myself. I wrote most of them by myself. While at it ath the moment, my
> logic could be unclear.
> 
> As said, how swap_cluster_info[] is built is the foundation. Whatever
> you do, you have to make swap_cluster_info[] ready, then you can do
> writeback, rmap lookup, thp support, etc, on top of it.
> swap_cluster_info[] is the basement, then you continue building 2nd
> floor, 3rd floor, till a high building is done with things added. Nobody
> wants to claim he just need the high building, while no basement.
> 
> Now, the foundation has been built with the lazy vmalloc, it can grow on
> demand. It keeps swap_cluster_info accessing as swap_cluster_info[],
> a basic array semantics. And since we our target is to support a very
> large swap device with an extendable logical space, grow on demand and
> shrink becomes important. Now it is there.

By the way, with my understanding, only grow is enough for xswap. You
can reserve a huge space for it, while in fact you could only really use
it within a small space. Then it's fine, grow the swap_cluster_info[] to
the place it ever used, and it mostly will be used again. E.g on a small
system with 10G RAM, we set si->max as 2x10=20G. In fact it could only
reach 2G swap space. That's fine. 2G is the place we need, keep it. The
left 18G is untouched and surely no swap_cluster_info[] built for it.
Anyway, Nhat strongly suggested shrink is necessary. I am wondering if
there's really use case.

> 
> That's my understanding, not sure if there's anything I can't get so
> that writeback need be made first.
> 
> [I type each of above by hand.]
> > 
> > > 
> > > Agreed on requirement first - but this one was already decided, and not by me. In
> > > the July ghost swapfile thread Nhat rejected exactly the shape of "grow only, can
> > > be added later":
> > > 
> > >     "Except for my virtual swap design, which does support dynamic growth AND
> > >      shrinking of capacity on demand ;) If it cannot grow (and furthermore, if it
> > >      requires userspace operation to trigger swapfile growth), why do we need this
> > >      at all? Might as well create a new swapfile with swapon?"
> > > 
> > > To me what it converged on was "dynamic growth and shrink, no writeback yet".
> > 
> > I am not getting how out of context above paragraph shows the conclusion about
> > dynamic growth/shrink and *no writeback*.
> > 
> > > So automatic growth *and* shrink is the requirement, and the simpler alternative
> > > was already on the table.
> > > 
> > > And I keep mentioning it in the cover-letter of each version of my posting. I
> > > only did the foundtation via lazy vmalloc. And Nhat will do the core
> > > part including writabck, rmap lookup, memcg accounting, zero page fill,
> > > etc.
> > 
> > I don't see any evidense of this decision. Actually this whole email thread
> > shows that there is no such decision.
> > 
> > > 
> > > What is still genuinely open, and I would like us to settle, is how large the
> > > device's address space should be, because the metadata scales with it:
> > 
> > With dynamic growth/shrink, is this really a blocker?
> > 
> > Anyways, I will let Nhat and others discuss the technical details (unless I am
> > asked for it). My main reason to join the conversation is to converge the
> > discussion to a decision and resolution.
