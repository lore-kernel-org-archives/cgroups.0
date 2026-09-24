Received: from mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461F64334AA
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 07:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236426; cv=none; b=qelrO3ePOdZnORg6AXmd1o8T47+JMompvq0P1YHS1r/8am4ITRTpyVEU7WK4ry7J+Oe7hZohBzPfPaNIfTUEX4BgugEHAmqAhFBa5SWt7fd/LiEIFb+KmufuNzMVegV0EjbbXbRjoEhIl8tByr9KpfENgvoZPZbiGR4vpFMzS9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236426; c=relaxed/simple;
	bh=tmFKVXcIZq7e/z6sePm5F4/lrwU40o91QzXOAC74BWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AVacVI44wVklAqmXeqiufLRtIecfXwbicPCCYP8iiQRzGzPjDsuOumsMBjijDdxQn0t2IPg/DMLzCKaTVM6uQ4SQooLjypMCxj26nnVm2rIIK3EtpKaDQO/j/HgIG7hGn+hhxvMGYK/TcO1dtuiP6LHm9d0ebcySDp2d+Vn5u2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MuDzBozR; arc=none smtp.client-ip=95.215.58.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MuDzBozR"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tmFKVXcIZq7e/z6sePm5F4/lrwU40o91QzXOAC74BWg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790236422; v=1; x=1790841222;
 b=MuDzBozRitngDeYt7LdGDXXgd0dNYPast5NxG3UNIJbOj6z4nn7SDbGpvBsoyk009+YFxZ4U
 J99oOpwwlSnJchoEo2mmdMpJFARKLqMF/TpA7DI1wzNDVq0iNV97Gul4Hk4UpwVcSsuQuKh34gr
 j481XSTM6CZnZM1FCQxXFv9I=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 8c9537f07561259a;
	Thu, 24 Sep 2026 07:53:41 +0000
X-Mizu-Trace-ID: 8c9537f07561259a
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 15:53:33 +0800
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
Message-ID: <arTW_QJmL5PFev-X@fedora>
References: <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
 <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
 <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
 <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
 <arS6dvzAI5XLHuG-@MiWiFi-R3L-srv>
 <arTNdz2P4ZZZfruh@parmesan.int.kasm.eu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arTNdz2P4ZZZfruh@parmesan.int.kasm.eu>

On 09/24/26 at 09:20am, Klara Modin wrote:
> On 2026-09-24 13:51:50 +0800, Baoquan He wrote:
> > On 09/23/26 at 02:52pm, Klara Modin wrote:
> > > Hi,
> > > 
> ...
> > > 
> > > Chiming in as more of a user perspective.
> > > 
> > > On my 4 GiB BPI-F3, I can reach more than 10:1 compression ratio on
> > > zswap during some parts when building GCC 17 snapshots. E.g:
> > > 
> > > MemTotal:        3966864 kB
> > > SwapCached:        31872 kB
> > > SwapTotal:      16777212 kB
> > > SwapFree:       16638128 kB
> > > Zswap:            280140 kB
> > > Zswapped:        2859840 kB
> > > AnonPages:       2927376 kB
> > > AnonHugePages:   1409024 kB
> > > 
> > > While this is 72 % rather than the 100 % you asked for, I think this
> > > shows that what size a potential limit on the uncompressed size of zswap
> > > is suitable heavily depends on the workload.
> > > 
> > > I have been using vswap consistently on all my machines since about
> > > August, and I have also tried one or two versions of xswap (but the
> > > current lack of writeback makes it inconvenient for me). I really
> > 
> > Thanks for testing xswap and reporting issue on xswap rfc v3.
> > 
> > xswap has writeback now. I only built foundation for xswap, while
> > writeback part was left to other people for collaboration. Finally
> > I added it.
> > 
> > [RFC PATCH 00/17] mm, swap: xswap writeback to a physical backend
> > https://lore.kernel.org/all/20260920072043.430390-1-hebaoquan@kylinos.cn/T/#u
> > 
> 
> Thanks, I'll give it another try when I have time.

Sure, no hurry. Thanks a lot!

