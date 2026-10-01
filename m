Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4EA364943;
	Thu,  1 Oct 2026 18:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790880180; cv=none; b=WZFQtuhxQ7JvtgWeBnynUwhr11NX8eu5IzciT54HDMF3M7peilKoBUYj1SShj6IdbVKIhNG3YkMIsRRE6iQbTUhG3MZMrUmAfvDEPJa5i3aDX2lVvRphurPHxkMc9Rj68hKVDLIhoIdbO7OyxVJkfHyH/KxgjbR7ZAjIA0MdqDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790880180; c=relaxed/simple;
	bh=uwZ2rsWGvMJKClUG1hn9YbZEiJLt9Kacj4MriMozc3I=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=k0odKYMwl6kNhlCCy9jwB/D7dCFMtoSLVlKchS3EaEG7L7nmHEOgHgMrkjaCx9Z/cH/7AC1w2byY4FFPLBKO0MJq4LZTwE+2qUDOZyAJR2GdGtqQwJr/GL9P48Dgj85Hte9NdVYppXDcYD7/cVs4CZQIauG6YFQb7jW+RnRziEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sip89Hr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sip89Hr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396861F000FF;
	Thu,  1 Oct 2026 18:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790880176;
	bh=uwZ2rsWGvMJKClUG1hn9YbZEiJLt9Kacj4MriMozc3I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Sip89Hr+ljBrGcOlZuTFng6Yqymu0XsVLS6Q+f1OX0DDrRQnrOKfRUf3xbLFMK5Rr
	 MGzF7i7XGQBNseZmtpyyiB/Co3VpFaNBPSf2A74ffOjYSaMlwK3tDSZvpKMzRupD6R
	 O7Xg0CYiEN8k4Xxe1v/zA5BBufzoFWLjZrfaDx9f6akDG7TpDC3QSzRxH0HaqePBFW
	 mrBwdm3/WvWzMp44+0w5Tij93tXGXbnQFnhTGYdA2kAKzrhgE/Rj8tO8MEMa0uEMIc
	 K9C0k4xw42SyxBL5TIQKuefJfoCPrIhOgScPhNRWq6O8+nWwnBdTqR5KUA+FCO5nOa
	 bXT1IZ1Ueruuw==
Date: Thu, 01 Oct 2026 08:42:55 -1000
Message-ID: <31a871a07fccc99e953a2d633fc51edc@kernel.org>
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
In-Reply-To: <ar2kvmCPR9q31V8M@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
	<bda525506b3fb3e61da28a112f28abba@kernel.org>
	<arw4rjVkm2ob9ioL@linux.dev>
	<bc6815954b8d08e75deadd43e1a2192c@kernel.org>
	<ar2kvmCPR9q31V8M@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Shakeel.

On Wed, Sep 30, 2026 at 06:00:41PM -0700, Shakeel Butt wrote:
> mlock(), madvise(POPULATE), fadvise(WILLNEED) are the obvious ones where large
> amount of memory can be allocated before returning to userspace.

These are explicit bulk memory operations running in the calling task's own
context, so they can be special-cased. Each is a loop with points between
chunks where no locks are held, and the same over-high handler the
return-to-userspace path runs can run there. That keeps the throttling on
the task which asked for the memory and can't cause priority inversions. The
set of such paths is small and obvious, so I don't think it'd be onerous to
maintain.

> > This doesn't seem like a policy problem.
>
> What is "This" in the above statement?

The whole thing, how memory.high should be enforced when the overrun happens
inside the kernel or from a kthread.

> Here if you meant that default behavior of memory.high should work for most (if
> not all) users then we are on same page. If some user want memory.high reclaim
> to happen in a separate thread instead of return-to-userspace or synchronously,
> this proposal provides mechanism through BPF to such users to achieve their
> goals.

I think there's a common reasonable solution here, which is deciding by who
the charge is for. A task charging for itself gets return-to-userspace
enforcement plus the checks in the explicit bulk operations above. A kthread
or anything else charging on behalf of a cgroup shouldn't be throttled for
the cgroup's overrun. The overrun is attributed to the cgroup, async reclaim
is kicked, and the cgroup's own tasks absorb the throttling on their next
return to userspace. The in-charge synchronous fallback goes away. Each case
has one reasonable answer, so I don't see a policy choice to expose here.

Thanks.

--
tejun
