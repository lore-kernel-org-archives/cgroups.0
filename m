Received: from mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328154854F1
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 13:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790255734; cv=none; b=pY04GCjTSHkdBzLUHtpROqWYyrIW/3B7Xk/2sQYcLzLgLvPQ79y204RU7tShjNoRCBnSC0/i0ZH39yT35bvQkRjY6whyEL/yXu3ridbW2ksZfNNeRk4GcIG20/FiX7EOO62+zpBabCqyQKAswM0PHorSVZo7eCU6wWsLK8M7nCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790255734; c=relaxed/simple;
	bh=VAqY47MliHFwSb5df7rFV+UkhNv2LqwPUXS4WaUskXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGIcS1iu2H3LRkMVh/oyuosOwvOXsa0OXaNanlHzOq+DfDMldpX+JRdTQmKF4EwOy8eS5JZeiZ2/IeMViaMIkUpEM0gL3EvcqDW5TOJb6XRVl3O6oZguHRUgyRyrjTAD6RnakyIeDvvCAh//ixnUUmLQsBOb/+Qgv9bmnuPpTJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q/MlswJ3; arc=none smtp.client-ip=91.218.175.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q/MlswJ3"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VAqY47MliHFwSb5df7rFV+UkhNv2LqwPUXS4WaUskXI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790255729; v=1; x=1790860529;
 b=Q/MlswJ3E6lYNWfz6+0G+LQQKNGmbkg5FUehv60tWlpTYbOYWDIwchm6Yk4J9WVp/YAg3HuS
 0fe20OgOBNCZOSuyK3sRZmDfWduxSuMICexS9RzuUcBZ+91TRQR+dsC7LAA6vB5nQeh5ICd9ggo
 DdUH8zOXr2l3JGrbDNMHTNCM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 15fed9b4dac8ae4f;
	Thu, 24 Sep 2026 13:15:21 +0000
X-Mizu-Trace-ID: 15fed9b4dac8ae4f
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 06:15:07 -0700
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
Message-ID: <20260924125040.GA25882@shakeel.butt@linux.dev>
References: <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arP8vXdJAL6ZJ1Os@linux.dev>
 <CACePvbV8zprLuiWMdYAOLRy=TwRx9WjSahCWySf53o0d_myJ8A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbV8zprLuiWMdYAOLRy=TwRx9WjSahCWySf53o0d_myJ8A@mail.gmail.com>

On Thu, Sep 24, 2026 at 01:27:41AM -1000, Chris Li wrote:
> On Wed, Sep 23, 2026 at 6:30 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> 
> > > BTW, I already shared that changing swap counter charging will break
> > > our and others' existing deployments.
> >
> > What do you mean here by "break our deployment"? We are talking about
> > memory.swap usage and limits here. Google is still on v1 and using memsw
> > usage and limit and I don't see how vswap is breaking memsw?
> 
> Your information is no longer accurate. I got this from our internal
> AI: "While Google's internal production fleet has historically relied
> on cgroup v1, there is an active migration to cgroup v2 to align with
> the upstream Linux community. Meanwhile, in Google Cloud (especially
> Google Kubernetes Engine - GKE), cgroup v2 is already widely deployed
> and is the default for newer node pools."

So, using AI to provide more vague statements. Let me help in providing
more clear statements:

1. Google shared borg is still on v1.
2. Google cloud (GCE) is still on v1.
3. GKE running on VMs is on v2.

Another very vague statement is "active migration". This migration plan
has been active since 2018 [1].

[1] https://lpc.events/event/2/contributions/204/attachments/143/378/LPC2018-cgroup-v2.pdf

> 
> About the V1 to V2 migration, it uses the memory.current and
> memory.swap.* counter to simulate the memsw counter for providing the
> metrics singal.

What does metrics signal mean here? From [2] it seems like there is
intention to propose addition of memsw to v2 and from my last
conversation with Sweet Tea, he was interested in exploring BPF to
provide memsw semantics.

[2] https://lore.kernel.org/all/7a5619a6d27119fcf566e43563a72396@dorminy.me/

> 
> > Are you making these false claims just to derail the conversation?
> 
> You should apologize for your accusation.

I am actually more convinced that you just want to derail the
conversation by providing AI generated vague statements. However I
accept that there are parts in Google like GKE which are on v2. The good
thing is that vswap is opt-in, so GKE can just not use it.

