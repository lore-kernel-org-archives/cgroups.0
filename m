Received: from mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AE4380FEC
	for <cgroups@vger.kernel.org>; Thu,  1 Oct 2026 01:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790816454; cv=none; b=Dx7jRUR1drX8cIHQBMCeVFCWZQuUPIQCtqwqfojUaMpUkYwMO31W6Ant/WclRlZw305tX2PdgWBNAclps4eJ6JvaDJ6ZjflzETAPSL7GeLi6FnHNwNbIr3jcGVzqN+UJTR5xnSB5dvYchkK8ifwWWofuwU9Y+HSrZZEbilp+hA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790816454; c=relaxed/simple;
	bh=HaQPNgehEuldW2UhCdxSN+8tT39bgGHcvLRMMFKomVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KFy4XO4Gx8BHkGjdYECk78tIqko/AtnVuwy5X8lvC5Mn++xiXIl8u2qgn5q7/ygnzVOPyGzcX2LjIkaDDE7jFTbVq7ZgwhdqcSO/xR7qsRkuat/Cvj4pvlfe10RmXnasR1dtv/K1CobgsCF9BrXDDnQdgZN92Q7YxzmCB2yYfPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xShgBlgK; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xShgBlgK"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HaQPNgehEuldW2UhCdxSN+8tT39bgGHcvLRMMFKomVs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790816448; v=1; x=1791421248;
 b=xShgBlgKu6+XLjyZu3n6X1OOEztZFWuRNKQvyZnrkQrQuVf523VESG6Y0ZmhL7b+U/UHGC09
 /vkcndQ/mWan2KqAGYQepSqZF9slE0h9A7W/y3XoFfdT7mNPbRZrKiu9SDvtEviqZJhibdHCnlp
 Rn6DPhQrny1gA/ouQF0fbcO0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9f96ffee7864c01d;
	Thu, 01 Oct 2026 01:00:47 +0000
X-Mizu-Trace-ID: 9f96ffee7864c01d
X-Migadu-Flow: FLOW_OUT
Date: Wed, 30 Sep 2026 18:00:41 -0700
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
Message-ID: <ar2kvmCPR9q31V8M@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <bda525506b3fb3e61da28a112f28abba@kernel.org>
 <arw4rjVkm2ob9ioL@linux.dev>
 <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc6815954b8d08e75deadd43e1a2192c@kernel.org>

On Wed, Sep 30, 2026 at 01:35:33PM -1000, Tejun Heo wrote:
> Hello, Shakeel.
> 
> On Wed, Sep 30, 2026 at 06:28:21AM -0700, Shakeel Butt wrote:
> > I am fine with changing the default behavior. Actually, I have been
> > contemplating whether I should propose a revert of commit c9afe31ec443e
> > ("memcg: synchronously enforce memory.high for large overcharges") because
> > it has introduced more problems than it has solved, but that is a separate
> > topic. The initial commit already mentioned that MEMCG_CHARGE_BATCH was used
> > arbitrarily, so replacing it with something big might be acceptable. I want
> > to keep that decision separate.
> 
> Which kernel paths allocate enough for this to matter? Can you give specific
> examples where the in-kernel synchronous enforcement helps?

mlock(), madvise(POPULATE), fadvise(WILLNEED) are the obvious ones where large
amount of memory can be allocated before returning to userspace. Now regarding
the in-kernel sync high enforcement for these cases helps or not, I think it
depends on what the user is trying to achieve with memory.high. One scenario I
can think of is an overcommitted system where admin dynamically adjusts
memory.high limits of colocated workloads based on their working set size. The
memory spikes will be smoothen by memory.high otherwise colocated workload can
be negatively impact. In this example, ineffective memory.high will not be able
to avoid global pressure which can impact colocated workloads.

BTW the above scenario is just an example and not something I am proposing.
Actually I think memory overcommit in the presense sync throttling can
potentially cause more isolation issues.

> 
> > Returning to the actual proposal, my plan was to start small with a narrow,
> > specific use case. However, my long-term plan is to provide a mechanism to
> > change the default behavior for custom use cases. For example, for
> > memory.high, I will provide a way for users to specify what behavior they
> > want, i.e., whether or not they want more synchronous throttling.
> 
> This doesn't seem like a policy problem.

What is "This" in the above statement?

> It feels like a problem that should
> be and can reasonably be solved for everybody, so I'm not sure whether BPF is
> the right call for this specific purpose.

Here if you meant that default behavior of memory.high should work for most (if
not all) users then we are on same page. If some user want memory.high reclaim
to happen in a separate thread instead of return-to-userspace or synchronously,
this proposal provides mechanism through BPF to such users to achieve their
goals.

