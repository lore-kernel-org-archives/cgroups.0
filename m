Received: from mta1.migadu.com (out-140.mta1.migadu.com [95.215.58.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6C83CFF51
	for <cgroups@vger.kernel.org>; Fri,  9 Oct 2026 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791567659; cv=none; b=JzeZILukjQB0qDchgfGDFI56nNDBT3XmHaMPVD46vOZJGYBcxUre/lqre+hv9tJqnEquCSdYy3W8F3HVKREGdD4nQA2Lc6hFY8zkKE7nOidF8GeyIGbQzy6eHf6eyC/cB05nXcHWXv3MnFzQAh1sqmtloDz3Wsw/5/nk8Hynf+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791567659; c=relaxed/simple;
	bh=NCJUfRqteXNa9rV0Ul+4wMwjj6UjxOxMpqC4BSP0B7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kfHW8Ai4A/KcMTubAdtmmEXHwyzAw2GYB0GL9EMyt9yq70Sn8SLkjDq5ii44laf6hn+8bMt3t/ThzOnnXVRWty9qn9jHe8/B9C7laDRGZsxyfXi80MLEbac8OwFFLJiAL9IYX54dsOuQMXKmn6Ea7MB/BkQ0vTTdk2dBYjAvgEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xaMle+yZ; arc=none smtp.client-ip=95.215.58.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xaMle+yZ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NCJUfRqteXNa9rV0Ul+4wMwjj6UjxOxMpqC4BSP0B7U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791567656; v=1; x=1792172456;
 b=xaMle+yZrk3JCIMZFC+5PNJ+fLbORE4xEONXDNweZB6hqTcZ4IpWDRHgVd1XgK2YiU5Js6mN
 HwHBPL/MEdTlpCl6YQ4zvkK5gI6H6Se7GuEIMmuIfjRINhsloxOLN0kJwz5BIWjpCWxM8B6qwz3
 qWjXrDITG2MLB0SBjAUySLIo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 63215eb558c466a3;
	Fri, 09 Oct 2026 17:40:54 +0000
X-Mizu-Trace-ID: 63215eb558c466a3
X-Migadu-Flow: FLOW_OUT
Date: Fri, 9 Oct 2026 10:40:53 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
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
Message-ID: <askmzoB_Bcn1BfCN@linux.dev>
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>

On Mon, Oct 05, 2026 at 01:06:28PM +0200, David Hildenbrand (Arm) wrote:
> On 9/22/26 15:38, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 8:56 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >>
> >> On Fri, Sep 18, 2026 at 11:50 PM Chris Li <chrisl@kernel.org> wrote:
> >>> No that time slot is too late for Asia developers. I don't think we
> >>> should use that time slot for swap alignment.
> >>>
> >>> We should find a time slot more friendly to Asia.
> >>
> >> Any time slot would have that kind of problem. We're spread out across
> >> the globe.
> >>
> >> Let's just use a standardized time slot we have for MM alignment sessions.
> > 
> > There are more swap maintainers in Asia than in the US + Europe, at
> > least based on the maintainer file. Please be more inclusive. If the
> > alignment is done without key stakeholders, it miss the point.
> > 
> > Sigh, we can't even align on a time slot.
> > 
> > In that case, let's keep discussing on the mailing list. At least it
> > is accessible to every one.
> 
> Looking at the mailing list, that approach doesn't seem to work.
> 
> Finding a time slot that makes US, Europe and Asia happy is ... tricky.
> 
> 1 AM is certainly unpleasant.
> 
> US vs. Asia is also tricky, but doable.
> 
> China 8AM vs. US West Coast 5PM?
> 
> China 9AM vs. US West Coast 6PM?
> 
> (Europe is 2AM vs. 3AM, who besides me from Europe would join?)
> 

Thanks David for pushing this.

Kairui, Chris & Baoquan, please respond which time slot is better for you?
