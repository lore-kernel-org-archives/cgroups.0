Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5453438AD;
	Tue, 18 Aug 2026 22:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787093234; cv=none; b=rUHkDuuwpyxMOm6GVh5kOOEiXdp7Jl8BtI6IwU3rkNxiQ1A5SxFDoPbHffuAGhRjZqTFKDXG8tDXQL/mCFWH5IIX1nrxZcNxJpGdwYbuBSmZZc0WgwkBr1XCu+FSF9O9E22n4IE080n8c1D2MpIaEadMAShPWwaQDBKxh8O0Xu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787093234; c=relaxed/simple;
	bh=D+D3n/MHHwa/wZuKxcdIa1S+VEfAHrl3hOCkdawxaOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUJgOlPmsaaj+8cbKx/Tpw9N9Vadw/BgUKXqcNxlZU4CfM7wCsqGokD77R/1qM9x+a4JpsLV5bSDB813fQCfhj32tP//fYBeGqnnqnyYff4Wd0Qe4EutOAwOShuFPUp9ufmRtHvow8HtcPD0wPvd1GXURe+Ff1Ddc2avmd/I3uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FMRySoef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FMRySoef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07721F000E9;
	Tue, 18 Aug 2026 22:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787093232;
	bh=6y3O9NvZg0DpM/RYLdDOGlq1iJ/HDAF2Ji2AF3eh7ww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FMRySoefaxPPKHyYckE7+qgXLbpo+ZKMH5wDCLr1TTVKRwOv3158zd8TIKtx0NeWc
	 VPGzL99RzQFLG5etYP7Dbkq7xGCxvuEotDR9YuCsZXc34C9uR+twabUI9nNcKvBJSS
	 BERBTNQu9IiDfttQ6TMNRda37JAbBdvbJ+EDmrLaDykgEl3/7m5mnLh67VArG6aPXt
	 FX6XqXzbEcyOjdqdKyQVza7x2atotkKu4YRdrw0A9L6fhsPuqJq2Gxp1llEpm2ngci
	 VX3YVdqr6erCHlvgC6ArDVSvAoh9F4fIfuHFq1kUjYuALPWYe2hZoSUK9TbURvMP0+
	 PZRe2On7cgIbw==
Date: Tue, 18 Aug 2026 12:47:11 -1000
From: Tejun Heo <tj@kernel.org>
To: Ziyang Men <ziyang.meme@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Shuah Khan <shuah@kernel.org>, kernel-team@meta.com,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, bpf@vger.kernel.org,
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] cgroup: add BPF kfuncs to read a cpu cgroup's
 stats
Message-ID: <aoTg7ybddqzoZbz7@slm.duckdns.org>
References: <20260818002450.3071325-1-ziyang.meme@gmail.com>
 <20260818002450.3071325-2-ziyang.meme@gmail.com>
 <aoSTaFwsVEoNW01D@slm.duckdns.org>
 <aoTgVOTxsEbFXTp2@devvm16600.scu0.facebook.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoTgVOTxsEbFXTp2@devvm16600.scu0.facebook.com>

On Tue, Aug 18, 2026 at 03:44:36PM -0700, Ziyang Men wrote:
> > > +BTF_KFUNCS_START(bpf_rstat_common_kfunc_ids)
> > > +BTF_ID_FLAGS(func, bpf_css_flush_rstat, KF_SLEEPABLE)
> > > +BTF_ID_FLAGS(func, bpf_cgroup_base_stat, KF_SLEEPABLE)
> > 
> > Why are these SLEEPABLE?
> > 
> 
> The css_rstat_flush() calls might_sleep() and cond_resched().

I see.

> The bpf_cgroup_base_stat() takes an rstat spinlock_t, which can sleep on
> PREEMPT_RT.

Is this actually required? This doesn't really make sense to me. Shouldn't
what SLEEPABLE mean change on RT kernels instead?

Thanks.

-- 
tejun
