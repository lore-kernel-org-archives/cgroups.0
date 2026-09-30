Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E644D492E57;
	Wed, 30 Sep 2026 23:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790811336; cv=none; b=JamcBPX36J+VMFfB2U7qdAs1Ej0qkNvJldII98Ozb3Mg8clrElo3Eov/aZ9b69ghuaGxWIQmzp3lmCXlKpNwnhGcLZrifbernjY3n8rqOwmdo3pB1yuiJw0QnTVCsLhPYwgKzh3ZYVJ1wZx4h/ct6Il2Jlkq6xYG56YzbwX4uh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790811336; c=relaxed/simple;
	bh=9wZLP+oTbknfbp3RkP0l6m3e4bL5ylavJVKS1T8of90=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=NlzEQWs2xG8LlRFHE8eKiRUqIzOKCrvsmGvfNZf9meDBQpRaOYLPZBQDjg+TEuNRMnOlz1s1JfjUPFcAqlbaSTdUlpwOpiv+7S/83tFBttUsjlfxqdvEB9xlBcDu07xEW6KMIe5AUmIHXA29j3LKJX7h1T1Obvd5/jNmTqA/PTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BK5TJkB5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BK5TJkB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEC01F000FF;
	Wed, 30 Sep 2026 23:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790811334;
	bh=9wZLP+oTbknfbp3RkP0l6m3e4bL5ylavJVKS1T8of90=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BK5TJkB5IGftgeaJG2HDjs70RD5rQUlw/q8Zy3kOYU7qzv2veRbSVTI40FpoNTzwh
	 dPjjOpLvz1br9YDpP8ERDUHMbsRdHkkb817QzqOnIYUb0JThqETFLTlRiLliZjQeCc
	 JGS99kjehaBbgpznAfRDksfYKJqK99oipg4DMesZmkBoZiv35Nrm2bnnea1HjpDW9T
	 oUZgcv2IqGpYWW54uJZvq/6i6bvVqVbDiqs+dIszJpjGAeATbqknggpIeu+2BNi/g2
	 Qy1AKBdzJVu+nSqbDz8ijZ2Sq2NaDb/CaSLe1GpucNf3ZylyWxKhzQbx8ldUwrzQEo
	 0KuKBok25v6RQ==
Date: Wed, 30 Sep 2026 13:35:33 -1000
Message-ID: <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>, Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	bpf@vger.kernel.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
In-Reply-To: <arw4rjVkm2ob9ioL@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
	<bda525506b3fb3e61da28a112f28abba@kernel.org>
	<arw4rjVkm2ob9ioL@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Shakeel.

On Wed, Sep 30, 2026 at 06:28:21AM -0700, Shakeel Butt wrote:
> I am fine with changing the default behavior. Actually, I have been
> contemplating whether I should propose a revert of commit c9afe31ec443e
> ("memcg: synchronously enforce memory.high for large overcharges") because
> it has introduced more problems than it has solved, but that is a separate
> topic. The initial commit already mentioned that MEMCG_CHARGE_BATCH was used
> arbitrarily, so replacing it with something big might be acceptable. I want
> to keep that decision separate.

Which kernel paths allocate enough for this to matter? Can you give specific
examples where the in-kernel synchronous enforcement helps?

> Returning to the actual proposal, my plan was to start small with a narrow,
> specific use case. However, my long-term plan is to provide a mechanism to
> change the default behavior for custom use cases. For example, for
> memory.high, I will provide a way for users to specify what behavior they
> want, i.e., whether or not they want more synchronous throttling.

This doesn't seem like a policy problem. It feels like a problem that should
be and can reasonably be solved for everybody, so I'm not sure whether BPF is
the right call for this specific purpose.

Thanks.

--
tejun
