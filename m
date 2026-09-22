Received: from mta0.migadu.com (out-108.mta0.migadu.com [91.218.175.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5CF545DB9
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 14:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790088204; cv=none; b=gqp8EPvh/apAAlvv0ZtkXHR9F2LBuelw/hLA2t5Oj9VZUwxS4LBQfFZLtw0x+i4fDCgW7tA77akJ81eMR/j8Eem7kgEFW/bq7+qkDE+Wc5FCY82CEkH1Qf0Gu72IrP9r/R9Il1Cv+o8r71Emoy4dd8ZNO3qnCj3BtKjG9Tqby3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790088204; c=relaxed/simple;
	bh=1XVpomz+LNVUGmpQ0CnnMZuywBPQ1iz7wasngwgLM7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxPZVbsWaqcaKgxVKQpZxAdXtlfGzia4rJ76yYvx3jXiMekK+lAdd+00bN1cf4aUvbU6qW3JRk8CP/r/ruGu7NeNwH87nENCXossiI9RlRbb1EOVYdLkSfA/D7i5x6mRO8NteoHgOu2UDJfoLycO12Sr3ZuQ2DuyOJU1a/JruBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jbh2KfAU; arc=none smtp.client-ip=91.218.175.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jbh2KfAU"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1XVpomz+LNVUGmpQ0CnnMZuywBPQ1iz7wasngwgLM7M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790088199; v=1; x=1790692999;
 b=Jbh2KfAU3CXTaa23kHQngeum45/Mw+8mcTxDluoAlJHP6valLhIKF+dQNdM84rqhSC8wBqsv
 1W4LL5RYJuJS9bSngMj2LWTzTkM7ZOeVHFhOm9E9QfFNa0RwO6WsXwTphVsjqvrtsFiF31Wcb9k
 fokZ9KTR9UEPuq2LH4xX/MAc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8d71456352f15a08;
	Tue, 22 Sep 2026 14:43:19 +0000
X-Mizu-Trace-ID: 8d71456352f15a08
X-Migadu-Flow: FLOW_OUT
Date: Tue, 22 Sep 2026 07:43:12 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
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
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arKRdaNEaKvFOtMg@linux.dev>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>

On Tue, Sep 22, 2026 at 03:38:38AM -1000, Chris Li wrote:
> On Mon, Sep 21, 2026 at 8:56 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Fri, Sep 18, 2026 at 11:50 PM Chris Li <chrisl@kernel.org> wrote:
> > > No that time slot is too late for Asia developers. I don't think we
> > > should use that time slot for swap alignment.
> > >
> > > We should find a time slot more friendly to Asia.
> >
> > Any time slot would have that kind of problem. We're spread out across
> > the globe.
> >
> > Let's just use a standardized time slot we have for MM alignment sessions.
> 
> There are more swap maintainers in Asia than in the US + Europe, at
> least based on the maintainer file. Please be more inclusive. If the
> alignment is done without key stakeholders, it miss the point.
> 
> Sigh, we can't even align on a time slot.
> 
> In that case, let's keep discussing on the mailing list. At least it
> is accessible to every one.

People can speak for themselves and suggest other time slots. You do not speak
for anyone but yourself here. At this point this is derailing the conversation.
