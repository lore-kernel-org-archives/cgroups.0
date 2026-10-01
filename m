Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771E04CCDC4
	for <cgroups@vger.kernel.org>; Thu,  1 Oct 2026 22:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790895413; cv=none; b=ghK0I9f7h1zU9HKGYmxMLRZKzXmnCil5kM0HJSIi1RN8EdLPJeYXEdR7sFx9G/Ofj7F/HcUOWtgnEIu8VcVy80id8Q5b+t5cImfSHAvv0yc5JB7f39zlvy3a7tGu6vAecXId5LeVvVF7t/rYpP7IcubrM0tSQnuVxAu+6ZrJd+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790895413; c=relaxed/simple;
	bh=LLQ8+pbOCynS3JlGqiF6iafheWllDG7Lb60tw6hvgjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tt6P8ePioHS1eRCKn/tXfxKfZin7euBTf45qyoBj8qHFDwRCvzQQZ5zmeobxiW0km5P84BJPp6kQY40IWNuZim1ScYkpp0K5ljpIxg4ugi+YW/RzS1HO3HrdRZADZMPd0IGBQGq5WfOkq0HryAe6J8n363WevAo0uqdTTHdj5fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q+o+jMDv; arc=none smtp.client-ip=91.218.175.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q+o+jMDv"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LLQ8+pbOCynS3JlGqiF6iafheWllDG7Lb60tw6hvgjk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790895409; v=1; x=1791500209;
 b=Q+o+jMDvVuzAdIo4XoXemkI+/mUNSF9KZFVLHjdwWllFqZOlVWQatEYuzA6inN1yO0CD7yFQ
 r0vmbDroiJX1NJDW+aWz4IRALSORsfUD7lql/HsSth/5OZpdGCQZ7rWFhLgtQQZd/7sCcB0HbnD
 KvHR68Su707/lmHt1C/sFLB4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e4abc687ef968c60;
	Thu, 01 Oct 2026 22:56:49 +0000
X-Mizu-Trace-ID: e4abc687ef968c60
X-Migadu-Flow: FLOW_OUT
Date: Thu, 1 Oct 2026 15:56:47 -0700
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
Message-ID: <ar7H__jzvWVtqSn5@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <bda525506b3fb3e61da28a112f28abba@kernel.org>
 <arw4rjVkm2ob9ioL@linux.dev>
 <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
 <ar2kvmCPR9q31V8M@linux.dev>
 <31a871a07fccc99e953a2d633fc51edc@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31a871a07fccc99e953a2d633fc51edc@kernel.org>

On Thu, Oct 01, 2026 at 08:42:55AM -1000, Tejun Heo wrote:
> Hello, Shakeel.
> 
[...]
> 
> > Here if you meant that default behavior of memory.high should work for most (if
> > not all) users then we are on same page. If some user want memory.high reclaim
> > to happen in a separate thread instead of return-to-userspace or synchronously,
> > this proposal provides mechanism through BPF to such users to achieve their
> > goals.
> 
> I think there's a common reasonable solution here, which is deciding by who
> the charge is for. A task charging for itself gets return-to-userspace
> enforcement plus the checks in the explicit bulk operations above. A kthread
> or anything else charging on behalf of a cgroup shouldn't be throttled for
> the cgroup's overrun. The overrun is attributed to the cgroup, async reclaim
> is kicked, and the cgroup's own tasks absorb the throttling on their next
> return to userspace. The in-charge synchronous fallback goes away. Each case
> has one reasonable answer, so I don't see a policy choice to expose here.
> 

Let me list the cases explicitly to see where we agree and where we disagree:

1. For the !in_task() charge path, today we trigger async reclaim and we will
   continue to do the same in the future.

2. For a kthread (or remote charging), today we throttle it similarly to user
   threads, but we want it to be handled similarly to the !in_task() case, i.e.
   trigger async reclaim. Regarding your statement "the cgroup's own tasks
   absorb the throttling on their next return to userspace", I assume you meant
   that when some other user thread of that memcg goes through the charge path,
   it will eventually do memory.high enforcement on return to userspace.

3. For a task, today we enforce memory.high on return to userspace, and if too
   much charge is accumulated in a single kernel entry, we enforce the high
   limit synchronously. You are suggesting that we remove the sync enforcement
   and add a couple of throttling points at known bulk allocation sites.

Please correct me if I misunderstood.

We are in agreement on (1) and (2) completely. For (3), I am fine with removing
the sync enforcement, but for throttling points for bulk operation sites,
I think we should only add them when there is an actual use case for that
or someone complains about overrun from those sites.

Now, setting aside the default behavior of memory.high, I want to provide
additional flexibility to users for (3) specifically. One specific case is
letting users opt in to async reclaim instead of the other forms of memory.high
enforcement. Basically, users can specify that instead of having their
application threads throttled, they would prefer async reclaim to bring their
usage back below memory.high. Whether we provide this functionality through
BPF or through something else, I am open to options.

thanks,
Shakeel


