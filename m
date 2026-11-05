Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793899168;
	b=CntT4cYbhGAe4TX2GRMertN22caWerO1gDh1W2nammmjq76sKt5zOyK7y9YpuZlEp/pV
	 rQ0yMml0KG7QGrw46aJ4+1AYUGDiijdrWYjkAygt6I0lMhtzKdQDojNZGyx4qK+V12KJ9
	 guV05kxtZfxL6tShkWYpAGYem6Zu6xJAlbFyvR3lQkVqR/R8+PUEDDNf4JvsenS68zqj0
	 bMRuf7Q/BeBBenuHEO9TPc1ioDXvdGdpERJxZzzG4ZJkuiDObw1cYN/6/RRB3ru2jh/rn
	 rA0mZoTVOKscX/NPJA7gtOczm/Th3OKct/niBU40/ypYDLUYcPKzUmczs41TKHxbhcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899168;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jW+ShPCH/HH5xFBtj2AJT4YnP+sykfn5FDocpGx/xxE=;
	b=gjDTrkSzcg8kzA8nCqXVRv+XftubXaLoP8nFPyCF2P7Xzw/OgtkwFxuWb2qwCK4GG8d9
	 xyYk5HydBAA/YJCoGQd/1n5dGgScZyb3y7IzfAqSgPc5aKz8hIu1djA0NqMGWaOoTuDj3
	 SpO5YJM/c4QpcOT+9sTgNFiUjeKLclL4gKSUjsfKVhG63Sd89UK15GrSNZ7bjI5ieS2s3
	 RhGeOuR4eymhAj9K1jh6xv27aaDY77OtYSgTWmqOs09tWliU8aurmBRpNdW8xrO0lxkHm
	 JMftYMuVRbTkI0bgKxOIoKxYwQez51fob7X7EfuQGLsJ/kFSw8XbYoXC9ADXSDSIGdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GM3m6oMK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A87606D80A;
	Thu,  5 Nov 2026 17:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GM3m6oMK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE3E1F00A1C;
	Thu,  5 Nov 2026 17:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899168;
	bh=jW+ShPCH/HH5xFBtj2AJT4YnP+sykfn5FDocpGx/xxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GM3m6oMKxMCjOMKWhEd+UkKNUZIm1+KHdwaTXxONvKIl0QdPt2OquxFxSmMFg7Hei
	 vNKPdcU8ZeQTaW0+FnUzLUul7dXM9aOW3GQWYLyaebB0jGJjDDD5p9GysOqpp+EHCh
	 KFxuvv0iDZbTe4CtD9oCF1Wga1VstmyU0V2dMYpG6k7C2cvUA38Z91HrMh+BmzyrS1
	 Wi/AA3PNvSy6vUpv4M9S0WOvU3ac1fbnlriGH4IXqp4+P1JZw+RsK9noXJ5H8eULDJ
	 ycfeqAK4k6UoFEIGM1IbGUL5A729HhLcu3Qf1joTJZzffOJ2zKWyo+9zDDeYnIpSxX
	 aPt04u6iPUB6w==
Date: Thu, 5 Nov 2026 07:19:27 -1000
From: Tejun Heo <tj@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: Re: [PATCH] sched: Remove CONFIG_RT_GROUP_SCHED
Message-ID: <auy6nyTUuHBlgrV_@slm.duckdns.org>
References: <20261105164724.yxONBd03@linutronix.de>
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
Content-Disposition: inline
In-Reply-To: <20261105164724.yxONBd03@linutronix.de>

Hello, Sebastian.

On Thu, Nov 05, 2026 at 05:47:24PM +0100, Sebastian Andrzej Siewior wrote:
> The RT_GROUP_SCHED is broken beyond repair and it is to not enable it
> during compile. If enabled it is recommended to disable it at boot time
> with the rt_group_sched= option.
> With it enabled it is not possible to set the policy of a task to
> SCHED_{FIFO|RR} because its cgroup has no runtime assigned. The runtime
> can not be assigned with cgroup v2. The root group has however all the
> runtime assigned meaning the global sysctl runtime parameter
> (sched_rt_runtime_us) can no be reduced because the new bandwidth will
> be less than what is current available.
> It is possible to schedule SCHED_DEADLINE tasks but the admission
> control is stuck can only be disabled via -1 (same sysctl parameter).
> 
> As a result all major distors (Debian, Open Suse, Fedora, Archlinux)
> have it disabled.
> 
> I don't think it is needed to somehow fix RT_GROUP_SCHED. The DL fair
> server already handles the RT throttling mechanism. There is work on
> Hierarchical constant bandwidth server (HCBS) which aim to group
> multiple real-time tasks within one deadline configuration.
> 
> Remove CONFIG_RT_GROUP_SCHED.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

I'm not against it but wonder whether it'd be useful to do it more gradually
so that people can pipe up if they depend on it. ie. Mark it deprecated and
put it behind EXPORT for a bit and then BROKEN before actual removal.

Thanks.

-- 
tejun
