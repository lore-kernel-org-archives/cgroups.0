Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB689383993;
	Sat,  3 Oct 2026 07:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791011866; cv=none; b=iMMpVjW4ncJbwyn3mGgSvM7Pfa6OwLdGG2/tsfngV1hO36+rAXCxhJv4mxFW2MOBPPujBBtuCQPqJ/q4NqrGGHPbHUajIIyJwe7y+34jEUSysbB9T/VqKYseRfJBqWaZL7vjNq1jiYdQTt7OgAp7DG5YkatTcskwesNiBLnsiGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791011866; c=relaxed/simple;
	bh=uC2I99DW/NnzxAhEKwfL4GTgHwkUY8v9YbVXzYcZW10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aw5BqZJWnV2IlsivLzGsClvAk8xQb/T9xkcW5m2HK1x+D4EwE/nuHMAZUazmvpYWIxa0nD6noW2Gdn+xxw5kx7X5Fl79fbgysZKs1dMt83Cx7f4x4FdoEtPZRi9PHDtgNwtnqS1h7rbxnITGgYuro/T+4t44v/p9hTdM0Rplzuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtEu4rI0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtEu4rI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC831F0089B;
	Sat,  3 Oct 2026 07:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791011864;
	bh=8k358hsoqUyrsPcls8xTBIMgHNITWIlqEj23dCu7cFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LtEu4rI0c+XEIKBMRx0jCl5i0gmrucNi3fExE3MyFznY+EvjMautRUqrp0lPxavkS
	 9K+9gF+wD5qgkViIi2rLRLs8kWBnWcdqrVmph5m6HnnMW5lmsyPB5WN7PAVoQdYq57
	 2w3yvspvkW432MV8LCtBiTfKXO3kneXRxXOzQ1IHz5AP5dcjNz1Gn3FIZvqnHXXZ/r
	 Po6gYOi0zoPPBk4XD/b96TXiACv/YBUmhiwPrm4z9HG2NRU1z1K9xoLKMetCMnq8qM
	 JCRyGNI/sMiPan+bOPRIMBmIrDnFWpgNP+jyFUTTJVoJTy1dm96RZ4lTnMrRM66/n9
	 Q0cETzqLBBgpQ==
Date: Fri, 2 Oct 2026 21:17:43 -1000
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	bpf@vger.kernel.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
Message-ID: <asCsF6hXwOcJ3jXt@slm.duckdns.org>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <bda525506b3fb3e61da28a112f28abba@kernel.org>
 <arw4rjVkm2ob9ioL@linux.dev>
 <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
 <ar2kvmCPR9q31V8M@linux.dev>
 <31a871a07fccc99e953a2d633fc51edc@kernel.org>
 <ar7H__jzvWVtqSn5@linux.dev>
 <c1fdbe4f99352a102b38c7d131215d5a@kernel.org>
 <ar_fuYs_-qS46dVk@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar_fuYs_-qS46dVk@linux.dev>

Hello,

On Fri, Oct 02, 2026 at 03:19:38PM -0700, Shakeel Butt wrote:
> > On (3), if removing synchronous enforcement wouldn't regress anything,
> > that's fine, but why was it added in the first place?
> > 
> 
> I added the sync enforcement to replace a Google internal feature which, on
> memcg OOM, allows node controller couple of seconds to either increase the max
> limit or let the memcg die. With sync enforcement, memory.high helped in simple
> benchmarks. However later testing on some realistic Google workloads, I found
> out that several thousand threads are very normal of typical Google workload and
> memory.high sync enforcement is not effective on applications with large amount
> of threads. In addition, there were workloads which on noticing blocked threads,
> keep forking more threads. At the end implementing that feature using
> memory.high didn't pan out.

Yeah, if there's no known active usecases, might as well start by dropping
it and see whether anyone complains.

> > As for flexibility, we already have a gradient of enforcement around
> > memory.high. Is the need here to make the shape of that gradient
> > configurable? Can you give specific examples where this is needed?
> 
> The concrete example I have is the kswapd like async reclaimers (plural) per
> memcg. Kswapd is woken up on free pages falling below low watermark and then
> when free pages fall below min watermark, allocators get throttled (enter direct
> reclaim). I want to apply similar concept to memcg (but with right cpu
> accounting and more concurrency). 

I see. Yeah, ISTR talking about async reclaim for memory.high. I don't know
much about mm but that makes sense to me and I'm not against allowing
customization of memory.high behavior via BPF; however, most use cases can
likely be served with a reasonably designed dumb interface and that likely
is a better place to start.

Thanks.

-- 
tejun
