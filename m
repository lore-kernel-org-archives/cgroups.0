Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795469064;
	b=WYIrv8+C250P2ofHxyQDFfM6wiJokcCqJZ7YHqLG9lu6G7AV7m8+ZVg3a5dJSan8/4yi
	 iu1Pa3o7hFh7Q+NbuOYSKFehkGBL/4++Fc8TPwRrryi/O1YpammTOKrqmOUFXoHsxQhBJ
	 aCG/zaur3cXi+cGVJlrbId6O8L4AtSCiw7OPw4iCoyGRUKOCWF4cKOBVP0vq9JcqPshBn
	 rppBYVSEoCfZUdftM/MWJipzlbipMwMJD3GERoxsRvQfgrPY2xKSMMZDqRG2JOms03t8r
	 ISjBKcW2O8fW810Y7b367snY8s2+1qJl99bJlsU0+T692kO+UUVjT88k36zOVByurSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795469064;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=44fSmcNa7JbwX6ZPeuwc8lCXz45vkMPf7mYLc2yb+q4=;
	b=N3r7WDrtNWzFxicTwbx7//Bh08LsqkltLRwYwkFo8QCL92eFu8jdifGP4km2/CdaClrZ
	 UL5w+wDE7qM5GBoiFJXYeclBgbKxH2OW5O40IXiuHTEN5aZESI2ZUCTD20K4iaUiaYjpv
	 Su7wv0ROLJqd4hJ21c5pKDc+g9mottDl1cjRwbxtnANGk+nrgM1MVzaztNVujP18SfMvQ
	 ADi9yc4AYzJCNlviMBZT7pV52aPk6lrGXkFOR8ulxtigDZiTSn1VqkOJv2u0NWPCUQ352
	 vJQ6JA68NJzd8I6F8Mq7VMrRvt1UxppBMChtzEQwTNlwc7krGmANiwqvAL+x0mzHLOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="IV/sh11Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5141606A31E;
	Mon, 23 Nov 2026 21:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IV/sh11Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC001F000D3;
	Mon, 23 Nov 2026 21:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795469063;
	bh=44fSmcNa7JbwX6ZPeuwc8lCXz45vkMPf7mYLc2yb+q4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IV/sh11Z+5layzpcOTt9YRANdFcih3mQBeVEOmCc1dQqBl0sinmeZw+dX+g1zm4Or
	 tz8xZ40YQzhpVOLKEJX9R7d1mz7hz7yPYsIjZVH4Kc4eA45wTYpcK3Vzp0dk+SoMw8
	 l4WodwFvrYrD8bNO7Gunx2u897gPcAuRH3xccYAfibDsiN6d2ayxpTbgmHCvpNKcSZ
	 X7R9iSEmQg89rXyT3IaJE4q/bqBFRwXrv2bbLj9FQ7H+xENx429DlwuXvBKI4oqukU
	 QJao6X+FsTCWPiYa1JpoibOmFX35g+o+OaaD1jvelL/FTs9isWBRNtjXNo3KDmPD9s
	 vRFOCYGCr2R4Q==
Date: Mon, 23 Nov 2026 22:24:20 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ridong Chen <ridong.chen@linux.dev>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH-next v2 1/3] tick/sched: Make tick_nohz_full_mask and
 HK_TYPE_KERNEL_NOISE cpumask consistent
Message-ID: <awSvBOgM9WSj-1hH@pavilion.home>
References: <20261123041209.382726-1-longman@redhat.com>
 <20261123041209.382726-2-longman@redhat.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261123041209.382726-2-longman@redhat.com>

Le Sun, Nov 22, 2026 at 11:12:07PM -0500, Waiman Long a écrit :
> When the nohz_full boot parameter is first set, the cpu list parameter is
> passed directly to tick_nohz_full_setup() to set up tick_nohz_full_mask
> cpumask. Then the HK_TYPE_KERNEL_NOISE cpumask will be set up as the
> inverse of given cpu list parameter. Some of the timer code and RCU
> uses tick_nohz_full_mask directly while other timer code, scheduler
> and other subsystems use the HK_TYPE_KERNEL_NOISE cpumask.
> 
> With CONFIG_PM_SLEEP_SMP && !CONFIG_PM_SLEEP_SMP_NONZERO_CPU config
> options, the boot CPU will be cleared from tick_nohz_full_mask if set
> while the corresponding HK_TYPE_KERNEL_NOISE cpumask isn't touched.
> The nohz_full entry in kernel-parameters.txt does state that the boot
> CPU will be forced outside the range to maintain the timekeeping. So it
> makes sense that the HK_TYPE_KERNEL_NOISE should be modified accordingly.
> 
> Fix this inconsistency problem by adding a new cpumask_set_cpu() init
> function to be called by tick_nohz_init() when the boot CPU is cleared
> from tick_nohz_full_mask.
> 
> PM_SLEEP_SMP_NONZERO_CPU depends on ARCH_SUSPEND_NONZERO_CPU which can
> only be set for the PowerPC architecture. Moreover CONFIG_PM_SLEEP_SMP is
> on by default, it means most kernels will not allow CPU 0 to be set in
> the tick_nohz_full_mask and hence should be set in HK_TYPE_KERNEL_NOISE
> cpumask.
> 
> Fixes: 6f1982fedd59 ("sched/isolation: Handle the nohz_full= parameter")
> Signed-off-by: Waiman Long <longman@redhat.com>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

If you like, it would be nice to remove tick_nohz_full_mask and rely on
the housekeeping mask instead.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
