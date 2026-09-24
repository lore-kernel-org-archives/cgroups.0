Received: from mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EF33624C5
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 05:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229117; cv=none; b=Qot2Jg8fLvtCPzKzjXXOz5MPOA8bc4dvhIpmGTdq4/FOp5+wKg9flkxQgX21Q0zZ+ebk8b/5v6YZ2Dk3IuoxGkigTOTgaxsP75pg0wPQUXEntZa2U08fzLNiajG8AsCVAzsc4BlqWJUIq8zg9wZeHnQQAGfOUP7XBp8jvjae9HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229117; c=relaxed/simple;
	bh=Qh8p1Wq/6FENjB4kTXNkMpLip9RVFvwk/eduC06xJC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9Qxhoo+vUj1XOKYlccnVDszMsnJfFdLwqjrlVZhJs28VdGP6cJDWWW6QEdNiM2TeEvnDQilbAYwhutxqw7HvMYwwQOFn+0yYEgRdnnRz4lyaeSgEAKw1fTDYUfL85HqnTNi2SIlDlpBJ/s2T6uuJ8Qk3Tjz6W+rAGXQACi13PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sP1vWwUl; arc=none smtp.client-ip=91.218.175.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sP1vWwUl"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Qh8p1Wq/6FENjB4kTXNkMpLip9RVFvwk/eduC06xJC4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790229113; v=1; x=1790833913;
 b=sP1vWwUltxM/z61RttITi1TTXJcaD5qmwVoAGCwAH6bUAhg+1oKaDYiP+Cx3RM9SgwVFvEmq
 TIATMENnAhTTqe9J34sC+epd7JmzmW6vzuTUnL8Eu+Bxz0qFhMcgSZOSoVAMBvJ5EL8Rr7seKSy
 nQtHO6IQ+KYN4R0qxzdZW+sc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id f5f74063f00ab3a9;
	Thu, 24 Sep 2026 05:51:52 +0000
X-Mizu-Trace-ID: f5f74063f00ab3a9
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 13:51:50 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Klara Modin <klarasmodin@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
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
Message-ID: <arS6dvzAI5XLHuG-@MiWiFi-R3L-srv>
References: <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
 <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
 <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
 <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>

On 09/23/26 at 02:52pm, Klara Modin wrote:
> Hi,
> 
> On 2026-09-22 21:10:53 -1000, Chris Li wrote:
> > On Tue, Sep 22, 2026 at 5:53 AM Rik van Riel <riel@surriel.com> wrote:
> > >
> > > On Tue, 2026-09-22 at 05:43 -1000, Chris Li wrote:
> > > > On Tue, Sep 22, 2026 at 5:20 AM Gregory Price <gourry@gourry.net>
> > > > wrote:
> > > > >
> > > > > On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > > > > > Right now it has 64GB of memory.
> > > > > >
> > > > > > That is exactly my point. You are running 1/8 = 12.5% system ram.
> > > > > >
> > > > >
> > > > > Chris you are missing the point
> > > > >
> > > > > Zswap:           8812236 kB
> > > > > Zswapped:       24927876 kB
> > > >
> > > > I am well aware of the point. The 7%-10% data I provided is before
> > > > compression. After compression, the real saving is about 1.5% - 2%.
> > > >
> > > Here I'm at 28% without any issues, with room for
> > > more.
> > 
> > 28% is one thing, 100% is a difference beast completely. If you
> > haven't tried it, don't assume 100% will behave the same as 28%. There
> > is a point where too much zswap makes the system unusable. It is hard
> > to pinpoint the exact upper boundary. However, figuring out the upper
> > bound larger than that exact boundary is not hard at all. I haven't
> > seen any one can use 100% system RAM sized memory swap out to zswap.
> > If you have a data point showing what that system with 100% swap to
> > zswap looks like, please share it.
> > 
> 
> Chiming in as more of a user perspective.
> 
> On my 4 GiB BPI-F3, I can reach more than 10:1 compression ratio on
> zswap during some parts when building GCC 17 snapshots. E.g:
> 
> MemTotal:        3966864 kB
> SwapCached:        31872 kB
> SwapTotal:      16777212 kB
> SwapFree:       16638128 kB
> Zswap:            280140 kB
> Zswapped:        2859840 kB
> AnonPages:       2927376 kB
> AnonHugePages:   1409024 kB
> 
> While this is 72 % rather than the 100 % you asked for, I think this
> shows that what size a potential limit on the uncompressed size of zswap
> is suitable heavily depends on the workload.
> 
> I have been using vswap consistently on all my machines since about
> August, and I have also tried one or two versions of xswap (but the
> current lack of writeback makes it inconvenient for me). I really

Thanks for testing xswap and reporting issue on xswap rfc v3.

xswap has writeback now. I only built foundation for xswap, while
writeback part was left to other people for collaboration. Finally
I added it.

[RFC PATCH 00/17] mm, swap: xswap writeback to a physical backend
https://lore.kernel.org/all/20260920072043.430390-1-hebaoquan@kylinos.cn/T/#u


> appreciate the work being put in to decouple zswap from needing a
> physical swap device to work.
> 
> > >
> > > > You are not listening. The boundary was set due to feedback from the
> > > > application SLO. Those are real deployments not imaginary usage.
> > > > Please respect the user.
> > > >
> > > Different users need different things.
> > >
> > > The kernel needs to be able to accommodate all of them.
> > >
> > > The kernel default should accommodate the people who
> > > are least capable of configuring their systems.
> > >
> > > Hyperscalers can set their own defaults across their
> > > fleets. They know how to adjust settings.
> > 
> > They can use a safe value, e.g., 100% of RAM. Let the people who know
> > exactly what they want to swap configure the boundary they want.
> 
> My personal preference would be for a default uncapped (or very high,
> and I don't think 100 % of RAM is high) limit on the uncompressed data
> which is backed by zswap, since that would mean one less knob to tune.
> 
> > 
> > Chris
> 
> Regards,
> Klara Modin
