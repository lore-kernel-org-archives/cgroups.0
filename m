Received: from mta1.migadu.com (out-2.mta1.migadu.com [95.215.58.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31534DA528
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 20:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790282558; cv=none; b=t7Etn2W34uOBAr92ug1CiONbw7+atz1NJGu39B30nRaU6q44/QToInODS5ZXysCghPGDP4uEoTUZ2XsNzpxesD22M1ooWh6PRC3J//U3FWu6vFb7jkT8kpFtlkUkOmmWpkNgUWlEcgIvn/LB3qSlYgYd0zqSxTnJdLCZM8GwuCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790282558; c=relaxed/simple;
	bh=nnArrsZ9H8yG5uIeRkg0y81lA15dy/yoQgT4igabXhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=chfz+FuCkwA0k07l53dmz+vEzzmvq7NhOFcY68HLe8xMKKL9k9dN60oss5Ifb5mFa0aLlnVDjEEUzUGWKvNJGVPhnRYz1RJhKKI3cCQhNBXmEKk8kRXCYbNJmBhYPgysFlSJcNOWB+RBjC3GgIBsvaWYNzWWVz71WvbdTOG5Rpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=movhOMzi; arc=none smtp.client-ip=95.215.58.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="movhOMzi"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nnArrsZ9H8yG5uIeRkg0y81lA15dy/yoQgT4igabXhs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790282547; v=1; x=1790887347;
 b=movhOMziQtRSeKkzCtOdTDgLn/vpuXyK3ONg4P+AqvP9xRlLcvwoVH9I7sTEjNelr4oKA0T0
 CMQdTkWulpOzBLIKErJjheg6krYOy5tP0AhfgpKjLrwDUpoWsRduXhpPGkriFs1QtDMs2SledM4
 3KOQyAivloZDBVXZgA8qgW2A=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e2e7b493161569e3;
	Thu, 24 Sep 2026 20:42:26 +0000
X-Mizu-Trace-ID: e2e7b493161569e3
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 13:42:24 -0700
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
Message-ID: <arWJBBOdvLsOSdCt@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <CALOAHbA4EgGw_uWfbXD0Q87exP7ek=z9ENuU_ARgb+DgBgy1kQ@mail.gmail.com>
 <arPyspcEFNkqfNyr@linux.dev>
 <CALOAHbDKRw9cPN_GxOYbp9u50cvr7PzPyoGPsSwoPDPAwBCGbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDKRw9cPN_GxOYbp9u50cvr7PzPyoGPsSwoPDPAwBCGbA@mail.gmail.com>

On Thu, Sep 24, 2026 at 06:01:27PM +0800, Yafang Shao wrote:
> On Wed, Sep 23, 2026 at 11:47 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > Hi Yafang,
> >
> > On Wed, Sep 23, 2026 at 09:07:40PM +0800, Yafang Shao wrote:
> > > On Tue, Sep 22, 2026 at 3:30 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > >
> > > Hello Shakeel,
> > >
> > > On the open question of how deferred debt eventually gets paid: would
> > > it make sense for the policy to also notify userspace (e.g. via
> > > ringbuf) when it defers,
> >
> > I think the notification through bpf programs is already possible and a bpf
> > program deciding to bypass memory.high can already do notification via ringbuf.
> >
> > > and have a userspace reclaimer do the reclaim
> > > through memory.reclaim?
> > >
> > > I understand one of the concerns for the async worker is CPU
> > > accounting. If the concern is that the kworker's CPU usage is not
> > > charged to the target cgroup, the userspace reclaimer could instead be
> > > spawned with clone3(CLONE_INTO_CGROUP) so it runs inside the target
> > > cgroup, and both its CPU and memory usage get charged there.
> > >
> > > One caveat: intermediate cgroups with the no-internal-process
> > > constraint cannot take processes, so this would only work for leaf
> > > cgroups.
> > >
> > > What do you think?
> >
> > I think all of this is possible without additional code and with this series.
> > With AI, should be very easy to prototype it. Please take a stab and I will look
> > into it as well (time permitting).
> 
> An LLM helped me quickly implement a userspace async memcg reclaimer
> based on your series, and it seems to work quite well.

That's awesome. Please do take a look at the code and provide feedback and if
you don't mind, a tested-by tag would be awesome.

> 
> >
> > Thanks for taking a look and also please let me know what other ways you think
> > memcg can be customized through BPF in a beneficial way.
> 
> Sure. On our production servers we have been running a set of BPF
> programs to tailor kernel behavior for different workloads — all of
> them global programs so far — and I believe they are all good
> candidates for per-cgroup BPF policies now that cgroup-attached
> struct_ops is available. They have been really helpful in our
> Kubernetes production environment. I have sent some of them upstream,
> such as:
> 
>   - BPF-THP
>     https://lwn.net/Articles/1039689/
>   - BPF-auto-NUMA
>     https://lwn.net/Articles/1054030/
> 
> Perhaps we can revisit both of them and turn them into per-cgroup
> policies — what do you think?

Yes seems interesting and I remember other folks (I think Rik) were interested
in these ideas as well.

> 
> We are also running some custom BPF programs that have not been sent
> upstream yet, such as:
> 
>   - BPF-async-reclaimer
>     We don't care about the CPU accounting of the kworker, so we just
> wake up a kworker to do the async reclaiming.

I understand but I think for general solution we do need accounting for this and
I have rfc out for this.

>   - BPF-fault-around
> 
> Both are really beneficial to our workloads, and both are global programs today.
> 
> We are planning a few more customizations to resolve painful
> production issues, such as:
> 
>   - The long-standing inode::lock contention caused by dentries [0].
>     We have not started implementing it yet, but we might introduce a
> memcg->dentry_limit or a memcg->vfs_cache_pressure as BPF policies..
>   - cgroup-level readahead.
> 
> So, to answer your question directly: for memcg itself, the beneficial
> customizations for us are the reclaim policy (the async reclaimer
> above), the dentry/vfs cache pressure knobs, and fault-around; the
> rest are per-cgroup MM policies that would need the
> struct_ops-to-cgroup mechanism generalized beyond memcg — which is why
> I hope these use cases can help make the design more generic.
> 

Thanks a lot for this information, I will think more on these.

> [0] https://lore.kernel.org/linux-fsdevel/20240511200240.6354-2-torvalds@linux-foundation.org/
> 
> -- 
> Regards
> Yafang
