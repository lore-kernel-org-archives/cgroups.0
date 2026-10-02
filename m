Received: from mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AF047013D
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 22:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790979590; cv=none; b=ltv9xcBwBx9mDFkWohba9r2oVtC/IYpOeDIV96Amw5lkobFuatWddgmgGKfX2pbfyr66i3WxkWUIFC1XHw1Nfia+uBK1/0dTL/bVsKLKV7x/X3ayM3+qJiZsoghJPQ+J/RoYuBawm2go3BzPsjP/yyLadNtjsr0Xh32Mi/VmI98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790979590; c=relaxed/simple;
	bh=LIeypzTLxZFUaXt5ugGV2tt9HvkLhl45i2GZQQOzRtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nevp9DLgn18It4ID3aKr3YPmUOJjZQ/6IY9R+l58Afelfc322Qx8DSnIggTCPH2AOQXltkf8OC/sFC/0tq9jG8CNG5iCWcy+RZeQltRa8XLHO31FPRSJ2OoldDo2ephgkx6xaqLD454l2ZyVjKuqS9ZUP6PpiArkVzlRcWJUZEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BhepoCzX; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BhepoCzX"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LIeypzTLxZFUaXt5ugGV2tt9HvkLhl45i2GZQQOzRtA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790979584; v=1; x=1791584384;
 b=BhepoCzXqCV6+2aFXT/5CmOqdAoSYoHbqDxEnkF4m0Xvdqb6AWvH8+ChwpvQPvS343Ccuu3o
 J42qH3XqO24w3NmnS8ix4Pe+F7ROpe3BO3JCMsVAwMHUneXcpT9E/0xfeCr/FHmKGgh1yIX2Baa
 kARXwtyunWysy7L0cbgpXQKM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2a1b46a32a9d1e0a;
	Fri, 02 Oct 2026 22:19:43 +0000
X-Mizu-Trace-ID: 2a1b46a32a9d1e0a
X-Migadu-Flow: FLOW_OUT
Date: Fri, 2 Oct 2026 15:19:38 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
Message-ID: <ar_fuYs_-qS46dVk@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <bda525506b3fb3e61da28a112f28abba@kernel.org>
 <arw4rjVkm2ob9ioL@linux.dev>
 <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
 <ar2kvmCPR9q31V8M@linux.dev>
 <31a871a07fccc99e953a2d633fc51edc@kernel.org>
 <ar7H__jzvWVtqSn5@linux.dev>
 <c1fdbe4f99352a102b38c7d131215d5a@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1fdbe4f99352a102b38c7d131215d5a@kernel.org>

On Fri, Oct 02, 2026 at 06:25:08AM -1000, Tejun Heo wrote:
> Hello, Shakeel.
> 
> On Thu, Oct 01, 2026 at 03:56:47PM -0700, Shakeel Butt wrote:
> > We are in agreement on (1) and (2) completely. For (3), I am fine with removing
> > the sync enforcement, but for throttling points for bulk operation sites,
> > I think we should only add them when there is an actual use case for that
> > or someone complains about overrun from those sites.
> 
> On (3), if removing synchronous enforcement wouldn't regress anything,
> that's fine, but why was it added in the first place?
> 

I added the sync enforcement to replace a Google internal feature which, on
memcg OOM, allows node controller couple of seconds to either increase the max
limit or let the memcg die. With sync enforcement, memory.high helped in simple
benchmarks. However later testing on some realistic Google workloads, I found
out that several thousand threads are very normal of typical Google workload and
memory.high sync enforcement is not effective on applications with large amount
of threads. In addition, there were workloads which on noticing blocked threads,
keep forking more threads. At the end implementing that feature using
memory.high didn't pan out.

> > Now, setting aside the default behavior of memory.high, I want to provide
> > additional flexibility to users for (3) specifically. One specific case is
> > letting users opt in to async reclaim instead of the other forms of memory.high
> > enforcement. Basically, users can specify that instead of having their
> > application threads throttled, they would prefer async reclaim to bring their
> > usage back below memory.high.
> 
> As for flexibility, we already have a gradient of enforcement around
> memory.high. Is the need here to make the shape of that gradient
> configurable? Can you give specific examples where this is needed?
> 

The concrete example I have is the kswapd like async reclaimers (plural) per
memcg. Kswapd is woken up on free pages falling below low watermark and then
when free pages fall below min watermark, allocators get throttled (enter direct
reclaim). I want to apply similar concept to memcg (but with right cpu
accounting and more concurrency). 

