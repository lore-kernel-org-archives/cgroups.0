Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADFD502D5F;
	Mon, 28 Sep 2026 22:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790635160; cv=none; b=bFtArPcSJxod82WEM7ZNKQ1AVJfU3dfBMehOSjvHEZyXuo4Iqu93dngd4B+rp8FixFqtyv1te+w1QAupLmvwvOQwKgA06lRX2aLay9ktz1hwJs0rOEM3CchroL7E+LDpywKxeCqFsu0EndLP3M1x6Zz+bcZYvnxLyox4aAVtdz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790635160; c=relaxed/simple;
	bh=0DcTnoia+4xLSrCsg5TVEUmSrD1P5AixIs8yunT2mbo=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=Guzs/4CS5m2K2pWe6XFnoigxQbbLwlLrR3yHzXfVJbcEG7G8Fw5wwpNh7NxV+mLp/VJxjQQzMR6uJaGL6SmBJaOslAagNasBqzKaplNn6xG3Ck6rzjroRK7lheyXR5AqhA6xjGgUDzyTkeRussgIIxBpZUgBW72tQFbj3jIod2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nvC1M3Ic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nvC1M3Ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771F01F000FF;
	Mon, 28 Sep 2026 22:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790635158;
	bh=0DcTnoia+4xLSrCsg5TVEUmSrD1P5AixIs8yunT2mbo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nvC1M3IcvbjGKpuIeoOXjwdt4kNlIDUq7OoP/yr+feT3CCiUuC8a1GV8p+mbtQFYO
	 uou5WRLU8eKJeRWvKfNvBVnhh9l9YHewiwmKYE9hO+wemXQwqTckvZL7vavzqysKiR
	 hAXz/2Ae/xHx1xeUh2G7b4XmEAznKdHly1jHEJsIfbEXFjyldks0Gb4T5PTXtuyl7s
	 ODG0CcrT1DXPcLfxo9c49uEJwD6X4E+KApLeD6JPvydwH/xbAYjbCdpRD87SnR/UC5
	 l+Qi24UmRyohYuc7M2fxjf6gGbfQ4mFBtWVlOVSrOcNWupOfEigalg1zsY2rtg7XhH
	 Fguwz6dSvzcPw==
Date: Mon, 28 Sep 2026 12:39:17 -1000
Message-ID: <e2ede7c4172c421c0894f1962fbe8517@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	David Dai <david.dai@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>,
	Frederic Weisbecker <frederic@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Hao Lee <haolee.swjtu@gmail.com>, kernel-team@meta.com,
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
In-Reply-To: <arWLq4p488JPhuZ1@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
 <arWLq4p488JPhuZ1@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Shakeel.

On Thu, Sep 24, 2026 at 02:11:00PM -0700, Shakeel Butt wrote:
> On the modern NICs where the workloads get their own rx queues, I think the
> proposed mechanism can help to do the accurate accounting (I have to extend this
> to softirqs as it is limited to kthreads atm) very easily.

Rx steering is useful for partitioning the whole machine, but it doesn't
seem like the right tool for attributing CPU cycles to each cgroup. It's
cumbersome to set up and the granularity doesn't match. We aren't going
to be steering net rx processing per cgroup.

> If you don't mind, I think having solution for modern NICs i.e. dedicated rx
> queues, should suffice for now (unless you want the solution for old NICs as
> well). Let me know what you think.

This doesn't have to be exact or completely synchronous. I don't see why
net rx charging and reclaim CPU charging can't share the same mechanism,
where the cycles are force charged to the cgroup after the fact.

I don't think PSI needs to be involved either. Shared execution in
itself shouldn't create pressure. The forced charge changes the cgroup's
usage, and that usage then creates pressure in the cgroup. IO works the
same way.

Thanks.

--
tejun
