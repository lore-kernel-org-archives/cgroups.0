Received: from mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C0A3E49CB
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 15:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790178435; cv=none; b=fvE69ZGqWZ7sIHw7YPyqi0ad2Tya92a4/biO/oOhnHXDjz1Z03OGR2nRl096dPVz2k1H7MCWyY2vKDO3IbJUrA5m1aamlOornCpp4AYGhilBpOGhj4jArkI7Z+iOVtQQVGdtI005rl+eVJqJLJI2wagnHLwT9ikkeWk82bTwxGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790178435; c=relaxed/simple;
	bh=HNkEwA1ANe2Cy1ef5VkR+k5aNsAR9SDnOLDe/iDUfoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVnxBn+OZiqA/o/XG4ILjfrxUAGeEsTWspvDP2LTmTicS39IAgm1ppa08lDB9sXBs2Yi8nS7qjcTWXcwe6aVgVnWUGoVNoehs+vhMb0Pw9nj6Pnswzw1QKt0toWGArD+vZMrC/D4tTSq8s9nN6v6s80z5g254d0UIxyd78RwuLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QVRAKpPw; arc=none smtp.client-ip=95.215.58.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QVRAKpPw"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HNkEwA1ANe2Cy1ef5VkR+k5aNsAR9SDnOLDe/iDUfoE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790178429; v=1; x=1790783229;
 b=QVRAKpPw9pB0VhEAsCwtrOwBZGF/JCoRGpiqsVVzoZ9QhWK5hxGAfABKcxhmvptQ/1Cs5WpG
 nI9r8I+aFU9x8Xd/aSJiFQdkp9dEUuCuBiL+5rxGXqFvr7q4vnyGhfbVPDK2ItoRnwM1oqIX8Bh
 kWAZfFcfgjma5hXGG0Q1mLkY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d5fec120cfd73ec7;
	Wed, 23 Sep 2026 15:47:08 +0000
X-Mizu-Trace-ID: d5fec120cfd73ec7
X-Migadu-Flow: FLOW_OUT
Date: Wed, 23 Sep 2026 08:47:07 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
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
Message-ID: <arPyspcEFNkqfNyr@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <CALOAHbA4EgGw_uWfbXD0Q87exP7ek=z9ENuU_ARgb+DgBgy1kQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbA4EgGw_uWfbXD0Q87exP7ek=z9ENuU_ARgb+DgBgy1kQ@mail.gmail.com>

Hi Yafang,

On Wed, Sep 23, 2026 at 09:07:40PM +0800, Yafang Shao wrote:
> On Tue, Sep 22, 2026 at 3:30 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
[...]
> >
> > Known open questions
> > ====================
> >
> > The semantics of memory.high for remote chargers or kernel threads is a
> > grey area and this series does not aim to resolve that.
> >
> > Another open question is whether a bound on debt deferral is needed. At
> > the moment, we think that rather than putting a limit on deferral for
> > memory.high, it will be better to handle that through an async worker like
> > memcg->high_work.  We aim to introduce that later, along with the right CPU
> > accounting for that async work.
> 
> Hello Shakeel,
> 
> On the open question of how deferred debt eventually gets paid: would
> it make sense for the policy to also notify userspace (e.g. via
> ringbuf) when it defers,

I think the notification through bpf programs is already possible and a bpf
program deciding to bypass memory.high can already do notification via ringbuf.

> and have a userspace reclaimer do the reclaim
> through memory.reclaim?
> 
> I understand one of the concerns for the async worker is CPU
> accounting. If the concern is that the kworker's CPU usage is not
> charged to the target cgroup, the userspace reclaimer could instead be
> spawned with clone3(CLONE_INTO_CGROUP) so it runs inside the target
> cgroup, and both its CPU and memory usage get charged there.
> 
> One caveat: intermediate cgroups with the no-internal-process
> constraint cannot take processes, so this would only work for leaf
> cgroups.
> 
> What do you think?

I think all of this is possible without additional code and with this series.
With AI, should be very easy to prototype it. Please take a stab and I will look
into it as well (time permitting).

Thanks for taking a look and also please let me know what other ways you think
memcg can be customized through BPF in a beneficial way.
