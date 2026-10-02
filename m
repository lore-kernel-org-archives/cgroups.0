Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68414F55AC;
	Fri,  2 Oct 2026 16:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790958310; cv=none; b=X/664L6odBEwQjeYrNpJzVYwo7ak9nvMGsuoVpghSCYml41SghT5txuoJljvR927/u+MCHP0Cfcjbs87Q/uP46sNBHVV3kyKFOPr1JX5GLi8Tu1AiIXFTTZPsjb1iSv7mKaa0LCC0rtHxIiXjSYQ38G7dAw71SugFWKbydswUTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790958310; c=relaxed/simple;
	bh=AZChlUywntyCPFGY9lWSy9nCKlzwb5uj6pLW1/A5pqg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fnCWf32tejM7F92OkspqGBwLol6AOMKgEYCV56u4iAd5yAkAU8qyp6pLfenDpUd/eP6SbF7FcCzW0pVaexw7j/BHfm7gHtBktYjp6V2S4hFyEBVfw8UKZEtnUBydJsa/KnvAa8aVkSovAFb2PlBslh43/el+1uVi3ClRxQxinwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a7P4HPag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a7P4HPag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4FA1F00898;
	Fri,  2 Oct 2026 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790958309;
	bh=k9QBgyctyjf1wUE5+IyBS6H1P6fbF3GcIg9RGUe3MH4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=a7P4HPag2l40BDyWAf0RSYqJLQ/nRiZl8oKP85Fm+8ZeQciaNQMy6de5OJpy4VGYr
	 XTKl6O7W0XS26UEspaVQI2vXQect500KbWu4Bw30HLL6+aX7HP/BiJa4G2pOOaRnPm
	 pph0MsVHgwOjr1yhliCEDQPeyuKaDmyoDsM6jBspi12905W8LJSIBPHfXa9FachT3X
	 3Umn16tD4BV9Rxh3R7rDxkbR8vf77K9rDbAH84SPatjsGTJH+uzzyCP6z9xq0FqyTC
	 RpXOWeNNAJceJj/8CGMl9ACsjcGVfLuF70TFiy2NVp0Gue3Z6eeuZaueKG18GGLsh8
	 tnIIXY55lrs4Q==
Date: Fri, 02 Oct 2026 06:25:08 -1000
Message-ID: <c1fdbe4f99352a102b38c7d131215d5a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
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
 bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
In-Reply-To: <ar7H__jzvWVtqSn5@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <bda525506b3fb3e61da28a112f28abba@kernel.org>
 <arw4rjVkm2ob9ioL@linux.dev>
 <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
 <ar2kvmCPR9q31V8M@linux.dev>
 <31a871a07fccc99e953a2d633fc51edc@kernel.org>
 <ar7H__jzvWVtqSn5@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Shakeel.

On Thu, Oct 01, 2026 at 03:56:47PM -0700, Shakeel Butt wrote:
> We are in agreement on (1) and (2) completely. For (3), I am fine with removing
> the sync enforcement, but for throttling points for bulk operation sites,
> I think we should only add them when there is an actual use case for that
> or someone complains about overrun from those sites.

On (3), if removing synchronous enforcement wouldn't regress anything,
that's fine, but why was it added in the first place?

> Now, setting aside the default behavior of memory.high, I want to provide
> additional flexibility to users for (3) specifically. One specific case is
> letting users opt in to async reclaim instead of the other forms of memory.high
> enforcement. Basically, users can specify that instead of having their
> application threads throttled, they would prefer async reclaim to bring their
> usage back below memory.high.

As for flexibility, we already have a gradient of enforcement around
memory.high. Is the need here to make the shape of that gradient
configurable? Can you give specific examples where this is needed?

Thanks.

-- 
tejun
