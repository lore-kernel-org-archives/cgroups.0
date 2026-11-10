Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794341442;
	b=SBEvMpYbvuh4dgmPxLnvz0leCNySqUBRNRWRq+uFZAYhHYmsPZEvXdtUkPn4cj56yOne
	 pQlwFGUamsp1G9iDZy3bqokLakPepKR/oBd17RLGdG5MwwtlaoT3G6JGAqj7dipqkRyPA
	 JcNKAgPJ9soXLWuY3d1nljkG27XCqkvo+qEcCxuyms/SkZZwNV4tsFfv7uuaPDyX0iStO
	 8MapeMGDvfd0Otmep1ZoeBRCFETkByURnL2gSZm+MVVdVFq6erpAiPbmGg2UDABQFhSnR
	 HmN+Aug6/vMdae4mbxRcF7pxQom+VdGqKeSoKmzbFrGgzWNbxr7b5qvTaIZxQRFlNvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794341442;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=gtnmaNHVD8u8S/tZT9pV39PfX4uefS+LpmURAAKxvqo=;
	b=eZnAVg5yV4gyc42aPHL38EC8pkN+0ocK9xCa6tHNZ47Vs3xt71gvXnhTk/wnUYgSYIq3
	 c1zQPeucmA2aEy0Mf1mlTwxB5WifrkbCO7/K38oynMGihmKD2qWfhyBXp6TQAqH9tBjDi
	 1zL42WlyET7Zzhnw40KcswvIL0/BvhQzPZlRflyaMftRE87w4K9AAAOxR+IPT0vI5owPP
	 4MfK6Nj2bK8WMK+hUjb520uzPb3zqRO2l1Fwxxo8iIZLNsaZPUj73CzZ9Z+50UAp85R9z
	 68hK537cj8WMzmV0QiuwjvwNourUmPsTx11+gLEXuH6Gl4yK5Wqj93IrTVD1F6H51xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bomzhE/7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749D5606A31C;
	Tue, 10 Nov 2026 20:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bomzhE/7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDFE1F0089F;
	Tue, 10 Nov 2026 20:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794341442;
	bh=gtnmaNHVD8u8S/tZT9pV39PfX4uefS+LpmURAAKxvqo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bomzhE/7LLjWceOrHhdKeF98fMwj0iURvnSUMpEqCuyHCQ4lKt3up5gPkPMvdRZQc
	 o1pz5fYeec5xnKmyMNWHEF8cnXzq6C4QpZYd7AdiVDQeSGyAU1s/YMFFVE57wJvnJz
	 suGdaHg5favfWCQNT+8g+kYBzLdFNz3qwA1xvxDIeR7oPT5fkGeqy3Q9j1xB4a53q0
	 dC1jQqMPyFOjvgsaN7wfvyLNtxwb4Yh4xzOTWmMJZwG5owDQD8BHILbb1ot33J9g3T
	 56luJBSWQNHslCk6qXm/N68VpegtoDvUxXBiONhQtkxwiBW7as+/WTIZvNjbUTC+Ng
	 THeb7M2Zd9gEQ==
Date: Tue, 10 Nov 2026 10:10:41 -1000
Message-ID: <3bdd435fd868ed7ca7ea9061e5966b7b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Fernand Sieber <sieberf@amazon.com>
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, bsegall@google.com, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, hannes@cmpxchg.org, mkoutny@suse.com,
 void@manifault.com, arighi@nvidia.com, changwoo@igalia.com,
 skhan@linuxfoundation.org, corbet@lwn.net, rdunlap@infradead.org,
 cgroups@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
 nh-open-source@amazon.com, hborghor@amazon.de, fmubeen@amazon.de,
 dwmw@amazon.co.uk, karataev@amazon.com
Subject: Re: [PATCH v2 0/4] sched/fair: cpu.max.runtime and idle refill for CPU credits
In-Reply-To: <cover.1794303670.git.sieberf@amazon.com>
References: <cover.1794303670.git.sieberf@amazon.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Fernand.

On Tue, Nov 10, 2026 at 01:08:47PM +0200, Fernand Sieber wrote:
> This series adds cpu.max.runtime, a cgroup v2 file to read and set the
> runtime the CFS bandwidth controller has for a cgroup, lets
> cpu.max.burst exceed the quota, and makes an idle group keep earning
> quota up to quota + burst. Patch 3 passes the writes on to BPF
> schedulers, and patch 4 lets them charge their tasks to the same
> runtime.

I think this patchset is too maximalist. As described, the use case is
specific to selling burstable CPU budget. Nobody else has asked for
this. There may be other use cases which haven't been stated yet but the
description doesn't surface any, so as it stands this is pretty niche.

On top of that, the series integrates into both fair and sched_ext and
then makes the two work together so that the handoff is seamless. That's
too much for something which doesn't have a strong use case or an
established generic need. As with scx_bpf_cgroup_report_throttled(),
patch 4 modifies fair's internal state from sched_ext, which I don't
think is a good idea as the cgroup piping is split at the interface
level:

  https://lore.kernel.org/all/ahdFAZVnb3DTv8Jo@slm.duckdns.org/

Seamlessly switching tasks between the classes in partial mode has a lot
of other integration problems beyond this one and at least I'm not
aiming to achieve it. It'd cost a lot more than it'd be useful.

The sched_ext part can just be a feature of your own BPF scheduler,
which you seem to be using already. There, the credit level is just
state in your BPF maps which your userspace can read and set, so the
maximalist version can wait until the need is proven. If you want a
handover between your scheduler and fair, that can be done from
userspace.

If a burstable budget is something useful to add to fair, can you do
that first and separately? It should be able to stand on its own.

Thanks.

--
tejun
