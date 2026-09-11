Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F0739B960
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 13:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789132005; cv=none; b=ubfcmBhVWivzMuCUFFhfnCqVrp837i1gbQInFuvHt/VI4OVNhcOwNuXLpjpiUkHxOfmcK2wxq5RO1t5mSVpPizVbHiUwewdcmdyIVv4PE3kBdmY2hFLH+2h4auvd1g6j/C7SzfaPhrepyhtquBZciwKAWcowyW5N8EJBk0QlfEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789132005; c=relaxed/simple;
	bh=bMQKUDCnWYRVzV2bP3s9Nv8XrLCTHDAUkzNZebbjfT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4LQ2lNwfEoxC43mxL/AHVRyylPG99c0gFDi0W9le9ETurrXkQp/WbKv7HEKiRumy9VHDJ3ZpnRf7ieaZuTjJSFhfE5Kp0eV8zz14orH995Lg/lVkJxT6hy89TVdAvA3PNTxMVqIaO1CcVRYMv49NtIOhcFzR5fx6LyroKrKMHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MRadHebc; arc=none smtp.client-ip=91.218.175.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MRadHebc"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bMQKUDCnWYRVzV2bP3s9Nv8XrLCTHDAUkzNZebbjfT8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789132000; v=1; x=1789736800;
 b=MRadHebcmh3cs6A29n2tnkWSPAMX36pHRZE+eKWGFqLn5+S85uSpf3Sm7W2pWd1pgyiYWjYj
 6IbWu+dq+NllnP70BtrDF9iP/jMZbbirNc6PZihvaD8wBJzoFPH29mxbrF+nTkvkNC5ITbjBp2k
 UTKFEN+iNzg8vVehykncC0gU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 9a318d970a08cc45;
	Fri, 11 Sep 2026 13:06:40 +0000
X-Mizu-Trace-ID: 9a318d970a08cc45
X-Migadu-Flow: FLOW_OUT
Date: Fri, 11 Sep 2026 21:06:29 +0800
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
Message-ID: <aqP81aqNbwAbs2P0@fedora>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLZ5TVDAqEbIeMN@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqLZ5TVDAqEbIeMN@linux.dev>

On 09/10/26 at 09:39am, Shakeel Butt wrote:
> On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > Hi Nhat,
> > 
> > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > .....snip...
> 
> [...]
> 
> > With VM_SPARSE, xswap's cluster access is exactly the plain-array line the
> > rest of swap already uses:
> > 
> >     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> > 
> > no branch, no RCU discipline, no tear-down state machine, and no NULL
> > return. So VM_SPARSE doesn't add complexity to close a gap; it lets the
> > cluster layer stay as simple as it already is, which is precisely the
> > part later work (writeback, rmap lookup, memcg charging, THP) has to sit
> > on.
> > 
> > I'm not going to claim xswap wins on throughput. I measured it:
> > on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are all
> > within ~2-3% of each other, effectively identical. 
> 
> So the claim is VM_SPARSE is simpler than xarray based approach. I feel like
> we are discussing implementation details before deciding the design and
> architecture. So, instead of VM_SPARSE vs xarray, let's discuss and decide the
> need for dynamic growth. Why we want dynamic growth upfront or can it be added
> later? Once we decide that then it will be very easy to pick an implementation
> that would take us there.

Hi Shakeel,

Thank you for joining the discussion and for taking the time to comment.

Agreed on requirement first - but this one was already decided, and not by me. In
the July ghost swapfile thread Nhat rejected exactly the shape of "grow only, can
be added later":

    "Except for my virtual swap design, which does support dynamic growth AND
     shrinking of capacity on demand ;) If it cannot grow (and furthermore, if it
     requires userspace operation to trigger swapfile growth), why do we need this
     at all? Might as well create a new swapfile with swapon?"

To me what it converged on was "dynamic growth and shrink, no writeback yet".
So automatic growth *and* shrink is the requirement, and the simpler alternative
was already on the table.

And I keep mentioning it in the cover-letter of each version of my posting. I
only did the foundtation via lazy vmalloc. And Nhat will do the core
part including writabck, rmap lookup, memcg accounting, zero page fill,
etc.

What is still genuinely open, and I would like us to settle, is how large the
device's address space should be, because the metadata scales with it:

    address space = machine memory (128G)  ->  65536 clusters  ->  ~4MB table
    address space = worst case, like (8PB)->  ~4M clusters    ->  ~256MB table

Once that is fixed, choosing the lazy representation is a normal implementation
question - and it is the same question Johannes is asking from the other side.

As you can see, xswap make swap_cluster_info[] kept as is. Accessing it
is simple and easy, and the xswap code is not intrusive into normal swap
code, and won't add complexity to normal swap. Even though Nhat doesn't
admit it, saying if writeback is done on top of xswap, the code is messy
too. In fact, it's not. I have done a draft writeback part, I will post
for checking, there won't be a lot of struct swap_cluster_info_dynamic , 
swap_is_vswap() flying around.

Thanks
Baoquan
