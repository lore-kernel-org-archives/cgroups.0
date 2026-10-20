Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792515314;
	b=TDkOkQ63iq9CDFQ2P9YAC+wWsD0uDOIr0ilpjDnbNKEWKb2enPfMmQ5MeM8OhDTrUJ/R
	 3tZFYW1/uqSZJEIDL4Y7CAsJVeD2tF7cWdAxd63bSahk+Yy7fMGVkCiE7DBdBYVd2FOtt
	 TrzXJHJdbSUyln56oI8oICepe9G89Rr4wJCovSJBtUDYEUhMqS44ktkFz2UGzFzJEt3g7
	 DYjnwA3JH2fUMdHW3F12MuJHUojTfL0czf+ixfwXA5G6nzRqhVxnraHYbW1w0xhPvGrW7
	 PxnsU9YnBz3LtRaavX0M40PJd6O9cQ5AbduD5aulKusec2AIBw1O+JSFnaq7j/B6OKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792515314;
	h=Received:Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References;
	bh=74faLD1IaSIP2Z+00B1XcX8OSASYEQH3UHt+KZjsp+Q=;
	b=gYvmBFk897+Ts/8ZlKoigIGif+xIBaebmpz23hrk/AjmMqMIT0Jc4ZPgd1MVJK6onAHu
	 pKwQ/qNMnz1oOldHw73aJsnWTPmNgt5Y5bpRbHgn2Zdwj9hgPoY2Zg/wtZfrr7PrlzyRR
	 IN0xY/McqPCM+rTzK73zLsW2c7roU8XSXtzzlMYjIgpMKXi9tEaqvpFxRngY4kSMeKodS
	 dBlQwK8ndm/zdwIU5etXORHvoWQ3psftnhukNzEA7ixz4JzK/Gk2YkqyrSY+9c5j/kA+A
	 aogT51Pkb8h/++NpK4R1CJmgM95l+sbYQg3nZpSfktuqk2wnXmROXcS0tnD6w0Zat8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53AF606A336;
	Tue, 20 Oct 2026 16:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0231F000C9;
	Tue, 20 Oct 2026 16:55:13 +0000 (UTC)
Date: Tue, 20 Oct 2026 06:54:42 -1000
Message-ID: <7bcbfa61a8c69e6ffd81e97652d981b0@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 bpf-next 0/5] BPF-based per-cgroup NUMA balancing mode selection
In-Reply-To: <20261019064157.29885-1-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

Hello, Yafang.

On Mon, Oct 19, 2026 at 02:41:52PM +0800, Yafang Shao wrote:
> An opt-out wins and binds the subtree: a DISABLED request anywhere in
> the chain opts the cgroup's tasks out entirely. Otherwise the requested
> bits OR together and the kernel reads them independently, the way
> kernel.numa_balancing reads them, so a combined NORMAL|TIERING engages
> both modes. A DISABLED request only speaks for the cgroup's tasks,
> never for its memory, which follows the remaining requests of its
> ancestors.

Can you explain the reasoning behind the basic design decisions?

- The folio paths resolve through folio_memcg() while the task paths use
  the task's cgroup. Why isn't the whole thing tied to memcg?

- Why do the task and folio paths combine the chain differently? DISABLED
  binds the subtree for tasks but is skipped for folios.

- Some of the folio paths already have the faulting task.
  should_numa_migrate_memory() takes @p, and the do_numa_page() and
  migrate_misplaced_folio() checks run in the faulting task's context.
  Why not use the task there?

Stepping back, the basic design decisions don't seem to have been
thought through, and the descriptions restate them at length without
explaining them. I'm not the best person to judge how useful the
feature is in practice, but getting this version into acceptable shape
is likely a lot more work than having someone who knows how to do it
just write it. I don't think it makes sense to drag this out and force
it into shape over many review rounds.

Thanks.

--
tejun
