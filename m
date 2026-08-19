Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2AE32A3FE;
	Wed, 19 Aug 2026 20:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787172961; cv=none; b=VEWht/NHDOqLDQ4Dv2UDrExOeP5TPvJxtaxkdfcq/UWJkncCRa+DSNkPvH9T8XyutXwxbijLAJQqpthx9OQMu9oG1vnU1c26Ee4y9AECbBjETK3+JibdLp7Mj/ze4kjYYzUL5DKWyARWAHslJ+pdgjLybOreeE1vV9XCKBRVdA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787172961; c=relaxed/simple;
	bh=3fMlJ5q4zJl8LSi+24VIiJMReeJUbFu+/qPmIwhhfZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezIyjB09s4ThRbl1KV7umWPvq4ximhSRC96UXUIP4WJmtGzTg7w/lW66Ivs4zJRicK009RXX/RJfssNuvP0LztySRI3cFQY/OlT68928YxrYUWr4H2qaCdxdmG5VZJlBB8OPYWyLgF+6bQsnvioaB1uK/lirOiQ/Qj5SkIfRwR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WsqfidD1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsqfidD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCF01F000E9;
	Wed, 19 Aug 2026 20:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787172959;
	bh=VeFgLXE0eOoS7AHpMF3PhMjzRNqkuytehVXLwAv1H7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WsqfidD12kj8bghrIGixK9B+HlQujU9bxPPYkzi8ejdZ3OroUueKiyhya4LuzyL90
	 IF3lujhfR8qL4zqTmSy3td+xzNRQO+DMKGOlPmAqP0gXXP0V7gPsv/uG1lrDMMGfJb
	 TwzKQaXcqNQincreKdL0Bq5ECcUIVTpgak/5p2PkEAklBHsGaVbF7MpZvq1bc5nqzO
	 taYY1PNe/e5/Dto/QMBw2CkQtCrDGyCMlkbvPeUA5uxtMmcUCOlcyScsDeLYLi9SRV
	 ZVRpWuY37efAaXlSaQFhqsOZwgu25Au33e7IpQ1blcTnDHGrW4xd4sh6WgYgU9/NG7
	 DVZcOQ4aJHPbg==
Date: Wed, 19 Aug 2026 10:55:59 -1000
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
Message-ID: <aoYYX60TCD6cd601@slm.duckdns.org>
References: <20260818002450.3071325-1-ziyang.meme@gmail.com>
 <20260818002450.3071325-2-ziyang.meme@gmail.com>
 <aoSTaFwsVEoNW01D@slm.duckdns.org>
 <aoTgVOTxsEbFXTp2@devvm16600.scu0.facebook.com>
 <aoTg7ybddqzoZbz7@slm.duckdns.org>
 <aoTx1eaNNJ+xrUq1@devvm16600.scu0.facebook.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoTx1eaNNJ+xrUq1@devvm16600.scu0.facebook.com>

Hello,

On Tue, Aug 18, 2026 at 04:59:17PM -0700, Ziyang Men wrote:
> > > The bpf_cgroup_base_stat() takes an rstat spinlock_t, which can sleep on
> > > PREEMPT_RT.
> > 
> > Is this actually required? This doesn't really make sense to me. Shouldn't
> > what SLEEPABLE mean change on RT kernels instead?
> 
> Oh sorry, I didn't notice that.
> 
> I might be wrong: this function calls the cputime_adjust(), which in turn
> acquires raw_spin_lock_irqsave(), so there would be NMI deadlock in the
> perf_event program. The __css_rstat_lock() take the spin_lock_irq() as well. So
> maybe a SLEEPABLE tag is still necessary?

I think this is for BPF folks to answer. I don't think SLEEPABLE is needed
because of RT but yeah it wouldn't be safe to be called from nmi context.

Thanks.

-- 
tejun
