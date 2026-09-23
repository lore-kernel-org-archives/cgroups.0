Received: from mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577C1357D18
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 16:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790181048; cv=none; b=f0w+MKUudHJfaD8r9Ew5MAXRKGbxnlKIgKve18b1Ke5dt7gfb5gA/6jL5NDTiHum/V7B52z9yIM8DfUGhnhJzM5MkbwnfV3yz0ceRNA50CIXtkFP923XOJ1KxAHTwVn6c0AwjV6EdvLvDBafIe1ifkMKxriwS0qjybK8tYaJIaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790181048; c=relaxed/simple;
	bh=syhg4Xh/gTAUQZORWpezw8Y96tkhKRENMCokWTcj1JM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JocCe7Jw6NjuGYZxghfsb+XwmsYuY7Y8GbGFhct7OT7hv9V1Pj1a2svVqHY9lruelKlb/NqwN+bYFDP0PFIxoZxokWMVy47gaaiNanUCIx+T9n2fiYRKG5QNCxjQkGnqtnvNOnXon2aH2M+MrOFT9qcUUu7oyj9/np5hVaH6hDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e56fLXSO; arc=none smtp.client-ip=91.218.175.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e56fLXSO"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=syhg4Xh/gTAUQZORWpezw8Y96tkhKRENMCokWTcj1JM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790181043; v=1; x=1790785843;
 b=e56fLXSO0dNEodGCADCluJC7/pc7/Ch7AsscjvuEp0s8yNT9ctnnFUcVNBfkKs/yvhXeZ4rj
 oz+3SQnRv8I5zVPOixGqdMw7XDGU5t/zS1zlBWxqgk6IIDCS/AD/+IMr0lslwGcVvh6sM812+Cw
 wCAYqfllMyxTL7UQSjRjjpjs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a4693e8db12b2407;
	Wed, 23 Sep 2026 16:30:14 +0000
X-Mizu-Trace-ID: a4693e8db12b2407
X-Migadu-Flow: FLOW_OUT
Date: Wed, 23 Sep 2026 09:30:12 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
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
Message-ID: <arP8vXdJAL6ZJ1Os@linux.dev>
References: <aqQrPLPXHXiuKup0@linux.dev>
 <aqjcFb6MFNiA6n4V@fedora>
 <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>

On Tue, Sep 22, 2026 at 09:44:37PM -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 7:54 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Sun, Sep 20, 2026 at 5:13 PM Chris Li <chrisl@kernel.org> wrote:
> > >
> > > That is not what I have in mind. The example I have in mind is that
> > > zswap is charged to swap counters. Changing that behavior will break
> > > our current deployment and that of many other. Kairui give some
> > > example as well. That behavior should not change.
> >
> > We already have a knob to select vswap. Users can turn it off
> > initially, and/or update their software to handle the transition
> > based on this knob.
> >
> > Otherwise, you'd never be able to introduce any behavior into the
> > kernel. Hugetlb accounting/charging is a new behavior, and there were
> > softwares written before that assumed hugetlb usage is not charged. If
> > it's not a good argument to block the implementation of hugetlb
> > accounting then, it's not a good argument now.
> 
> My original intent is that 200% of RAM for zswap is too much.
> 
> It seems you are talking about a different topic: the vswap charging issue.
> There is a golden rule that we should follow: don't break existing
> users. At least with the same persistence, this rule should apply
> universally.
> In the swap tiers discussion, the UAPI was such a big deal that we
> couldn't implement new UAPI. On the other hand here we argue for
> liberally changing user-space visible behavior.

Johannes has already answered this very clearly but let me talk about your other
claim.

> 
> BTW, I already shared that changing swap counter charging will break
> our and others' existing deployments.

What do you mean here by "break our deployment"? We are talking about
memory.swap usage and limits here. Google is still on v1 and using memsw
usage and limit and I don't see how vswap is breaking memsw?

Are you making these false claims just to derail the conversation?
