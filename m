Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795673008;
	b=5Vcz1fcn39JoRzFa/K/cdG6LfjX2WJKmt6p1/TTYYW0dSS5jNsh2vI+dQmmyBZpaQf7n
	 jrL4exvtLlJbzKGHX5Vu5ZkuGKRNHPxnfaIPdjh+DgkSagCW6UEkcknwNmzPPhlD9C+vw
	 vlBF9u9hGu6iUn9HnifzQo2qFbKHgmOI25b3Xb/colE9+Oj5xJp+RIh8ViCmbmCdLhRnc
	 Q489u2+VTuF22gkg2btakBPEb5lNcwpV5fTK+fbTjbfzsFHt9XRTlkMo2APBfow7SaqT3
	 QlJPrQwj72cJTuj45tsW+PaMYwbwxcAx3x5H6zWjKEpWOesvZjsAlyt30RNuyVBsR5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795673008;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=0PzfTGtQNoeXf6Gjoec1s/Tw8QgiWIeiBg+XwjQcs8o=;
	b=1KsB/mjbxnOgmnT/hGgYdU2K7++1dcUIdtDPGfV+DAy/8G0yrtMNTu+SDsrncTYMhKIE
	 pwvj1i5RMimaqKjc7pBr75nMi3KgVtDf7JRZVVobliF0bqQGHNLPy413p1GF1zVdnMQ3k
	 5NjOXCj4uUeJz3D6RMp/vbyrVf1zu/2fgWFBvT4HBGyVifTVNp6zhD4zCZjyhSA7mpK8g
	 HMB0H/rpuyetgPWwNw3/jReN/fP9t7HIR5M6FujwlssmaU1eur4X4YSQICDAgpKyQ9hQJ
	 kRYKmbA/bQ7/u4E+vwppQlOMCoQf/D/jvtUVbBDNWTpU10pA8/6Q2KatXPToT4RFZsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=orQsZTUp;
	arc=none smtp.remote-ip=91.218.175.14
Received: from mta0.migadu.com (out-14.mta0.migadu.com [91.218.175.14])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD229606A31E
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 06:03:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD229606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=orQsZTUp
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=748+ddCbsTP/XIDjke/+TROSx5c7dPfXbczUrGruMHY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795673005; v=1; x=1796277805;
 b=orQsZTUppfMHaenXYMAuC6fgaFhIJ8I2sIqlnrUlmWRJmaBgrone90Ei8FYK5hiRn9+KB0fx
 s1KYh08T/FBsUCyn5YuPbPE/4r6A5TlNSunVVHVc3mHMoxG2VB/378K8bB3DeeT9iTFBPUCaauZ
 iyZ991Wg8d1sMoBHJQBbY8wk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id c47457697a4402af;
	Thu, 26 Nov 2026 06:03:24 +0000
X-Mizu-Trace-ID: c47457697a4402af
X-Migadu-Flow: FLOW_OUT
Date: Thu, 26 Nov 2026 14:03:19 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <ryncsn@gmail.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
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
	Yuanchu Xie <yuanchu@google.com>, Gregory Price <gourry@gourry.net>,
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
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: Re: Virtual Swap Sync
Message-ID: <awfLp4H_pyefSM5v@fedora>
References: <CAKEwX=NXSwSiuY65EV5nqFocMLd6-afsiJfgy_ahB2v_MDmcng@mail.gmail.com>
 <CAKEwX=O2McF-gyqJT2a8R5q79+QABCPjULrcjC2CC0v8TnXxJw@mail.gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=O2McF-gyqJT2a8R5q79+QABCPjULrcjC2CC0v8TnXxJw@mail.gmail.com>

On 11/22/26 at 08:31am, Nhat Pham wrote:
> On Thu, Nov 5, 2026 at 2:06 PM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > Hi folks,
> >
> 
> Hi folks - thanks everyone for attending. :)
> 
> I summarized the points we discussed below - please let me know if I
> missed anything or misunderstood a point.
> 
> * Control interface: Google is interested in a knob to cease zswapping
> (which already exists and will still work in vswap world). Kairui has
> a use case for remapping all swapped-out pages.
> 
> Vswap currently bypassed when zswap is off; per-cgroup selection could
> be added as concrete use case arises (for e.g migration/compaction).
> 
> David objected that a virtual swap abstraction should not carry a
> swapoff interface per se. Folks also asked whether making vswap a
> mandatory layer would make the implementation cleaner (Nhat will
> explore this direction and follow up on this).
> 
> * Virtual space sizing: We discussed using vm.overcommit_ratio and
> vm.overcommit_memory to limit the host's logical memory footprint. The
> exact sizing formula is still unclear - Nhat will follow up with
> Kairui on whether it is acceptable.
> 
> (Kairui, if possible, can you respond here for your exact use case? Do
> you want to limit physical memory usage, or virtual? My understanding
> is you want to gate physical + swap, which would be closer to the
> latter).
> 
> * Priority and multiple swapfiles: should not be added for now.
>   No good use case for swap priority was identified.
>   Multiple swapfiles were used in the past to work around swapfile
> lock contention, but it is unclear whether they are still needed with
> Kairui's new cluster-based allocator. If contention remains a problem,
> we should fix it in the kernel before putting that burden on
> userspace.
> 
> * Proposed phase split and charging (from Nhat):
> 
>   - Phase 1 - initial foundation:
>     - Decoupled zswap: Let zswap operate without reserving disk swap
> for every virtual entry.
>     - Physical backing and writeback: Keep disk swap available as a
> backend, including when zswap cannot store a page or an entry needs
> writeback.
>     - Charging: Retain memsw charging for virtual entries; keep
> virtual-slot usage out of memory.swap.max. Actual physical swap usage
> keeps its resource charging.
>     - Usage counter: Expose vswap usage so users can monitor
> virtual-space consumption separately from physical swap usage.
> Essentially this gives you a method to estimate the logical footprint
> (memory.current - swapcached + vswap).
> 
>   - Subsequent phase(s) - further support and controls:
>     - VM_SPARSE: Add VM_SPARSE as an optimization after the
> first-phase foundation.
>     - Runtime controls (added as use cases arise):
>       - Host-wide runtime disablement knob (and remapping of swapped out data).
>       - Per-cgroup vswap control (for e.g, if some cgroups want
> migrations/physical swapfile compaction).
> 
>   - Orthogonal use cases and concerns:
>     - Cgroup-level logical memory limits in cgroupv2 (memsw?) - swap
> developers will follow up with memcg maintainers.
>     - Static sizing: Define the host-sizing formula and decide whether
> another interface is needed.
>     - Swap tiering for cgroups: Explore backend selection when a
> concrete workload needs it.

Youngjun's swap tier comes from concrete use case of his company, it's
been v11, he presented this in LSF and LPC. 

[RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with per-cgroup selection
https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.com/T/#u

This is xswap road map I shared with you when we discussed about working
together. I also mentioned swap tier in road map because Swap tier is a
very important feature we swap developers plan to add. 

https://lore.kernel.org/all/al8ohWshSSZ64AtT@MiWiFi-R3L-srv/

I thought you had read them.

I don't know why I couldn't join meeting last time, I tried at 8:05am at
my side, kept waiting for people to approve me until 8:30am I was
added. Not sure if you guys also talked about this.

Thanks
Baoquan

> 
> Folks, please comment on the summary and proposal.
> 
> Let us keep the communication line open and coordinate on the next
> steps. I will schedule something again.
> 
> Also taking a step back - once we reach a consensus on vswap, maybe we
> can repurpose this series of meeting for general swap alignment? There
> are other swap/compressed swap developments right now (looking at the
> orthogonal use cases list above for e.g), so maybe we can do this once
> or twice a month. My experience in the past year or so has shown that
> we clearly need better alignment :)
> 
> I will reach out to set up another round of meeting. I'm hoping we can
> do it one more time in December, but I understand that holiday season
> is coming :)
> 
> For folks in the U.S, I wish you all a merry and festive Thanksgiving.
