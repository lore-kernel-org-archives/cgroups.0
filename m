Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A104CDA0A;
	Thu, 24 Sep 2026 20:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281699; cv=none; b=iBnx2V2pu3xGmYxnK8ipQFelU2QiBn+78qtWWYcwYY/Gg5AzT4mUGhriZ6cTi2UYTkgdLCSwZY9k385J6mlPiJ22uECn2HOgKnHPuFXkke0OycJXLTP3pFU1dyxXiTUE9a0loJmaE5/Yv30lCF186F1uIJYw07F++52Pj9cdWIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281699; c=relaxed/simple;
	bh=w97EWjZesGb+3hb/Zx7HCgr5mgb4O8SmEQJDS8VlRqw=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=RzLBaRsCoQhH+NpBdz+ciYGFyJ09YjfwaHmKQIBLaLzBIReDEjORWWJ7Lzx1kmZxcDWKq6ks+7/B4sQiV4zzANns1CVdhvICKG40HUZmDl0JH1CJ8bygwBf60l1T3guWITyFUdQNE2Y2/DGJG6Px43bhv2G4MWyarrX0Ov9vJ+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cq9hMZrf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cq9hMZrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DD91F000FF;
	Thu, 24 Sep 2026 20:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790281691;
	bh=avFjG5EZmFqrwm1p4+gM+ZFckK2JwdC+scZyps23rJs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Cq9hMZrf00s1b6AqZjdi0M+xphvplpO9MfOok1IlGnSwLbZV9ayIds8xD6DUZyNhK
	 ihG3/PzW1VIcrv2SrmJGjylEQZGb5RT8Bn9ZG/E2YWntUfWR1x48dpWb6WKNhcwm78
	 Mt5krRorJPuciXv7L7H9pOUwm/5VqLS37cMpgcD43pK2jNIp4lNqXKpPLK70jy6RSw
	 J5YcktwTTPtFPkjnZrORVx2wzI/krFj7O5JKL/pCzE+5nOaTuBF6jZAO2A8/HkZq4s
	 2mlpsLV3yZqlU05yjHOS68T+DHUwV143/0ez2Sgb7ddfEgajnPjCfBBBsoXYyXv4zf
	 jyF/qq3tPWPJw==
Date: Thu, 24 Sep 2026 10:28:10 -1000
Message-ID: <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Peter Zijlstra <peterz@infradead.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 David Dai <david.dai@linux.dev>,
 JP Kobryn <jp.kobryn@linux.dev>,
 Frederic Weisbecker <frederic@kernel.org>,
 Aaron Lu <ziqianlu@bytedance.com>,
 Daniel Jordan <daniel.m.jordan@oracle.com>,
 Hao Lee <haolee.swjtu@gmail.com>,
 kernel-team@meta.com,
 cgroups@vger.kernel.org,
 bpf@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it
 is done for
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Shakeel.

On Thu, Sep 24, 2026 at 11:47:04AM -0700, Shakeel Butt wrote:
> This series lets a kernel thread say which cgroup it is working for.
> That cgroup then sees the CPU time in its cpu.stat and the stalls in
> its memory.pressure, and the CPU time comes out of its cpu.max quota.
> The first user is the memcg reclaim that runs from high_work.

This doesn't translate to net rx, which is another major source of
displaced CPU usage. Switching membership on each packet isn't going to
work there. Attribution can't happen that way. We'd much rather count
per-cgroup received packets and prorate the CPU consumption. If at all
possible, I think it'd be better to adopt an approach which can cover
both use cases.

>  - The debt is capped at one period's quota, so one long piece of
>    work cannot starve the cgroup for long. Time over the cap still
>    shows up in cpu.stat. Writing cpu.max or cpu.max.burst clears the
>    debt.

I don't like the debt capping. Having debt doesn't have to mean that
the cgroup doesn't get any bandwidth at all. The cgroup just needs to
be slowed down enough that the generation of new work is throttled and
the whole thing doesn't go out of control. IO control already does
this: when IO debt is accumulated, userspace is heavily throttled, but
not completely stalled, until the whole cgroup's consumption comes
under control. I don't see why the debts would need to be forgiven
unconditionally. The cgroup can keep paying them while running at a
minimal rate to avoid triggering stall failures, and if the situation
doesn't resolve quickly, that will most likely trigger pressure based
kills in any reasonable setup anyway.

Thanks.

--
tejun
