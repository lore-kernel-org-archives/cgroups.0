Received: from mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7644756C3
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 09:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790156396; cv=none; b=HUZu8CV/eB8uZMHYC8oCUMwgZ1XYNy79IHo6eFfu5n5rmghdtWHazEwDZJYHMGukQQzggqIG5RcFx7jRqZtVsaeAuuTy7iHh4FMfWtjamdybq13KzlFBAGPor9YMUDyGgWZEvmJyx3TDS+t2I0q6obLUJTKKqp4ogj46I8IEQhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790156396; c=relaxed/simple;
	bh=MzOAhLKmbJiSI4FocgslvkepFbs+VNzpkEibZW2q3/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q56JgMmu/ltAr02G8GADlBZtt3qxckTyj+2+P+A6zPsFC7F9uRflDh8m7hB9zJEP9gVK83Wh5w6OhdKm4GEPAfQzJaomD07pB+EaLlZC7Cf5OOvBrZ8xJs4s/Ci3eM2N77i7H1hmjONLnsicnsK5npKmswr0lVtn8ERv8/UsZII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OcD3OH9r; arc=none smtp.client-ip=91.218.175.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OcD3OH9r"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MzOAhLKmbJiSI4FocgslvkepFbs+VNzpkEibZW2q3/8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790156392; v=1; x=1790761192;
 b=OcD3OH9r5GDLa1RAtiQXePDtbn32B679l5paNIzso95xSS7zE5uSQ49AcjrQCyAadzN7S+NY
 5+ZPJKTWZyRM2K1EV1GqeNtE6PTFzZG9NDvmsDPrGpVLhuL2mb2qoHmXNHGpMnc5FAzJ4Nk5aRG
 SqaDdHpDF56hmsHUtnCUyLlQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 637d28ad337e819f;
	Wed, 23 Sep 2026 09:39:51 +0000
X-Mizu-Trace-ID: 637d28ad337e819f
X-Migadu-Flow: FLOW_OUT
Date: Wed, 23 Sep 2026 17:39:44 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Gregory Price <gourry@gourry.net>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <ryncsn@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
	Michal Hocko <mhocko@kernel.org>,
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
	Rik van Riel <riel@surriel.com>,
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
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arOeYHEf9aO7AU5X@MiWiFi-R3L-srv>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
 <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
 <arFe215hUcjLhvmS@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arFe215hUcjLhvmS@gourry-fedora-PF4VCD3F>

On 09/21/26 at 01:02pm, Gregory Price wrote:
> On Mon, Sep 21, 2026 at 06:32:56AM -1000, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 3:27 AM Gregory Price <gourry@gourry.net> wrote:
> > >
> > > This would preserve the existing memory.swap semantics while allowing
> > > both backing resources to be constrained independently.
> > 
> > It sounds like you want memory.tiers have limit enforced.
> > 
> > I suppose it is possible. Again I want to see how people would
> > actually use this feature.
> > 
> 
> Possible, but arguably not needed. the swap and zswap counters already
> work for this existing interaction.
> 
> As I pointed to in my response to Rik, in every reasonable use of
> pswap+zswap the global swap counter is pointless.
> 
> So then pswap=swap and we're left with zswap and swap.
> 
> And I'm not convinced your reading of the swap counter as a limit on the
> *logical* memory allowed to be swapped out is actually accurate.
> 
>   memory.swap.current
>         The total amount of swap currently being used by the cgroup
>         and its descendants.
> 
>   memory.swap.max
>         Swap usage hard limit.  If a cgroup's swap usage reaches this
>         limit, anonymous memory of the cgroup will not be swapped out.
> 
> There is no documentation I can find that has ever documented these
> counters as "the amount of memory requiring a fault".  If you put a
> compression system in front of physical swap - the counters as-described
> would still be accurate, while your reading would be broken.
> 
> "swap" here is highly implied to mean "storage" as opposed to memory,
> which is why "zswap" defines its limits in terms of memory.
> 
>   memory.zswap.current
>         The total amount of memory consumed by the zswap compression
>         backend.
> 
>   memory.zswap.max
>         Zswap usage hard limit. If a cgroup's zswap pool reaches this
>         limit, it will refuse to take any more stores before existing
>         entries fault back in or are written out to disk.
> 
> If you're presently using swap.max to mean the "logical amount of memory
> allowed to be swapped" - then your usage does not meet the definition of
> the knob.  You need to justify that your use case cannot be expressed
> via memory.min/low controls:
> 
>   memory.min
>         Hard memory protection.  If the memory usage of a cgroup
>         is within its effective min boundary, the cgroup's memory
>         won't be reclaimed under any conditions. If there is no
>         unprotected reclaimable memory available, OOM killer
>         is invoked. Above the effective min boundary (or
>         effective low boundary if it is higher), pages are reclaimed
>         proportionally to the overage, reducing reclaim pressure for
>         smaller overages.
> 
> That's an SLO interface.  memory.swap is a provisioning interface.
> 
> As it stands, I'm left viewing zswap's counter inclusion in swap as more
> of a bug than a feature - they account for different things (memory vs
> storage usage).

It's hard to say. When 37e84351198b ("mm: memcontrol: charge swap to
cgroup2") introduced memory.swap.*, it was clearly defined as charging
"the actual number of swap entries used by a cgroup". Please see the
commit log. With that, zswap still reserved a swap slot even when the
data never reached disk. And not to mention zram, it's backend is RAM,
but not physical disk.                                          
                                                                                                      
Now some deployments do use memory.swap.* as an SLO signal, and that is                             
real use cases as Chris and Kairui told. So I don't think this is about
who is right and who is wrong.
                                                                                                      
To keep the existing deployment working and at the same time give the
physical slot its own knob, I think the solution is to add a memory.pswap.*
counter as you suggested. And that is not something we think of from a
brain storm, it comes from real deployments which already depend on the
current memory.swap.* behavior.

Thanks
Baoquan
