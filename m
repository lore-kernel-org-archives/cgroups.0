Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F07A2D838E;
	Mon, 18 May 2026 18:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779130059; cv=none; b=elBD4zUBL4lHnytpEm8ANQhSYEE/e+RumUhns9QXWHps0htxwQsG3fJOGp4rlQAqQQwXqrQ6pxdyTTjiy3Rzl2rR4TyeNnFRSyqBYTy2JC8vsBRbCRYRkmPDKYqwUlOwnmcesvDkzKG+MeFkG2VrEeJJmWBwR7SdGt40MooGboc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779130059; c=relaxed/simple;
	bh=IDtTXbi2RclwufkSPhq8mKscmX1cOLE4IeCK1wQiD50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bV31OOehRtA/V4NyveaoIk05Yi7YHEYiMTIQnWth6NuQJrD6KqbxPKFZWPgd4WPr4sU5Mpp1ZDCTUrPzWvKTBjL3sf9P6zwyPPy2kSKrYktSa/5OoTt0m+E0c6aA0isVYmrlVhPtlxCqZSiSJidSQLv5xagn8ovxXbPHNFMj8qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHPJ66tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHPJ66tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A70DC2BCB7;
	Mon, 18 May 2026 18:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779130059;
	bh=IDtTXbi2RclwufkSPhq8mKscmX1cOLE4IeCK1wQiD50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BHPJ66tbdjRz4IsR76vvt+e/Pf9xIPVBhGTGCO+tDNgECDI+EUtNWyOq2OBg5w4YR
	 Sguly9NIgwvCSzPtE0jPY0xKwjbqsDPwCMnnfnjIY3D+03wND7L3ZN2V7OQyy6nNRD
	 NcntCqfFGU4SLrzqiJNW7f5SbgxpkVRfGaKx820Pwial4KwIZiaWREgCAEZ+X5+zoa
	 JewX/UCBDEugaB5vHOiX7EZe8LXCpH/3VJzV85gLyxpJRk35Oqeqv/YZxM88rgyqYu
	 hRHEvFCYdIGqrBMB9sK739pe5yuftBW0EqXmnCKv1dlpbCMCTtiVDpeEvSdFGJDRSQ
	 hHv3uJaK1A+3A==
Date: Mon, 18 May 2026 08:47:37 -1000
From: Tejun Heo <tj@kernel.org>
To: Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Cc: luca abeni <luca.abeni@santannapisa.it>,
	Peter Zijlstra <peterz@infradead.org>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
	cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v5 20/29] sched/deadline: Allow deeper hierarchies of
 RT cgroups
Message-ID: <agteySwOHszMVMp8@slm.duckdns.org>
References: <20260430213835.62217-21-yurand2000@gmail.com>
 <20260505151523.GF3102624@noisy.programming.kicks-ass.net>
 <afpLir8tD0Ycb3D8@slm.duckdns.org>
 <20260507163058.2c435922@nowhere>
 <agIfvZuvXEtK45em@slm.duckdns.org>
 <c446b9be-38d7-425c-9ca8-eda721fe1c9e@santannapisa.it>
 <b549b3cb062f2823ba6d4723b7b9260b@kernel.org>
 <20260514092546.4265d486@luca64>
 <8672eb9e7bbd6abde7762feb267799c5@kernel.org>
 <c51eb4b9-143d-495f-a35b-090fb688cca4@santannapisa.it>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c51eb4b9-143d-495f-a35b-090fb688cca4@santannapisa.it>

Hello, Yuri.

On Mon, May 18, 2026 at 05:27:17PM +0200, Yuri Andriaccio wrote:
> Interface:
> - File: cpu.rt.max
> - Format: <runtime>|"max" <period>
> - Default value:
>     "max" <parent period> - if the parent schedules on the root runqueue.
>     0 <parent period> - if the parent is instead using HCBS.
> - Meaning (incomplete/dubious):
>     The bandwidth allocated to the specific cgroup and all of its children.
>     Since sum(children bw) <= own bw, a cgroup's servers will be configured
>     with (own bw - sum(children bw)) bandwidth.
>     A cgroup set to "max" whose parents are all set to "max" (root cgroup
> excluded)
>     will run their tasks in the root runqueue.
>     A cgroup set to "max" whose parent has a non-zero reservation will
>     inherit the parent's configuration.
>     The root cgroup's cpu.rt.max file reserves the maximum HCBS bandwidth
> for
>     the whole hierarchy. Root set to "max" disable HCBS (as if set with a
> zero runtime).

I wonder whether it can be generalized more. Would something like the
following work? I'm going to ignore period for the sake of simplicity as it
doesn't seem to affect admission decisions.

- There is no root cgroup.rt.max in line with other control knobs.

- max means running in the nearest ancestor that has budget configuration.
  Obviously, if no one has budget configured, run in root.

- Setting a budget is subject to admission control in both directions - the
  budget source (the nearest budgeted ancestor, or the root pool if none)
  should have enough to give out and the target budget should be big enough
  to contain the actual usages and !max descendants in the subtree. Going
  to max is always fine - the source previously gave the budget out, so it
  has room to take everything back.

It seems like the above would give fairly generic behavior without abrupt
system-wide switches while staying relatively close to the behaviors of
other resource knobs. I could be missing something tho. Would something like
this work?

Thanks.

-- 
tejun
