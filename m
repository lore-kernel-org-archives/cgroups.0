Received: from mta0.migadu.com (out-165.mta0.migadu.com [91.218.175.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641C8475340
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058385; cv=none; b=a2mUtvSm4Eq4CXAB5e2JQYwIM8yJG+h6M1C4peaP92DhJsX3zmtXISC7B9FX2tZrsoT49srcP0l+pRMegb1UU/SYOFrKKJiQwA4VGgsSdOjBIKG4eK2YnETs5gPuYlMOTjhhopqqYflBZhbZCdTbxNOeBtKOOUTLHUoPgpjKWSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058385; c=relaxed/simple;
	bh=yz1ck6uqcqcd9T+oUOlPk0GNk4jIwW+HM3Fvm0oIvuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZCUcgaaSAUDRTHU8J/JEpmFN9p/q+Mbdm6ob38yn5HaPuX8i2U+HP2m8Ry97feu1DiQH7KolA2f6unM4kPSOefCGaAOXmMb+MbNkGka+372eD7evBGQO+yjaTQZxoPF7VQZ5xE4c4mDDwGe+kF12wn4JEfiddq353P7j/wL3Cvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WyPsKyit; arc=none smtp.client-ip=91.218.175.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WyPsKyit"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yz1ck6uqcqcd9T+oUOlPk0GNk4jIwW+HM3Fvm0oIvuw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789058379; v=1; x=1789663179;
 b=WyPsKyitMDXYuExL/dowTmU+dY0ZsHlqfB4c28hdxZNRHS+QQeq4xBgUi/97wXtgcjVrRmQe
 ndOlr64PQ437/4KGSF14E6J0/UT9qEmM3XCOUQb+mQdU2RfPGCpyuXamf3O1uAA+fCdr+tK7AhT
 8HBU/P7lnJUkTuvVXqCV1LQw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f698ba6bac255394;
	Thu, 10 Sep 2026 16:39:39 +0000
X-Mizu-Trace-ID: f698ba6bac255394
X-Migadu-Flow: FLOW_OUT
Date: Thu, 10 Sep 2026 09:39:37 -0700
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
Message-ID: <aqLZ5TVDAqEbIeMN@linux.dev>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqJXx2vtbKaRLt3x@fedora>

On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> Hi Nhat,
> 
> On 09/04/26 at 02:14pm, Nhat Pham wrote:
> .....snip...

[...]

> With VM_SPARSE, xswap's cluster access is exactly the plain-array line the
> rest of swap already uses:
> 
>     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> 
> no branch, no RCU discipline, no tear-down state machine, and no NULL
> return. So VM_SPARSE doesn't add complexity to close a gap; it lets the
> cluster layer stay as simple as it already is, which is precisely the
> part later work (writeback, rmap lookup, memcg charging, THP) has to sit
> on.
> 
> I'm not going to claim xswap wins on throughput. I measured it:
> on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are all
> within ~2-3% of each other, effectively identical. 

So the claim is VM_SPARSE is simpler than xarray based approach. I feel like
we are discussing implementation details before deciding the design and
architecture. So, instead of VM_SPARSE vs xarray, let's discuss and decide the
need for dynamic growth. Why we want dynamic growth upfront or can it be added
later? Once we decide that then it will be very easy to pick an implementation
that would take us there.

