Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794385698;
	b=eeBeJioddQJ4Rpu3SUbSKNhai8f0to8eXTeTY6k5hzJP4ItxLgRKmEhGAfh93H+73l0C
	 ooZ3IoRHjsa3N1elkTEQbxRbQDhwpMn7X8Vs1/lkMFpu17kruJ+TinyyKoJ5YfgeTuHw8
	 gP0FMSzSvew05ES12PF52QGsOx5pzNcCftysGUeBKntBWMN/uszxFa/kz1Z157IGFBS6d
	 fEqxPI/z5XsO5YS6NPBUOSGEnB+j/308eYp3S6pyUWgDsire1iE/RMLMXCuFd4/FsQzGr
	 7fF5Rzi4isgPilvsU68s9gn3fklNGIwt53ErLIGa12Cp21HDeozv0QUdMfUjFEW75iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794385698;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=piYzj8MDGWtgXv/LodWB1t6aXM+EdwWnp3fWL/kNINY=;
	b=xNkczwOOxAkEeMO6K7LsEZGap53S2zNPaZ/mKUZdMeIGb0+fwoQ733CyWem/UQzr7q4s
	 9Wqnqv8MkJlDPokDGhN3rvKWhDfzTBovPNMd0cOQVp/Fbw9bw/IudHzxnFmZ9qFKtbBjh
	 Lp5NBGspRoA9neHGD2jzATyj1UB3uvlzj2TQro2tOh3/xTS3CAM1Pohz/LPg5b+cQ7HJF
	 WfgusaaEJ6TZ8+TGmxiTZ3dZUbhNyYL25kZbWXnYMmL9h5qWC/ZmzY9rG+smjDuK0Dujz
	 X2IfEyEsirmuLemO37X5n9LG7AEX9vtXDIdU+n1zfsKz1s3HrtWt6KW+wTdBU0w5ApQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqbmS2TQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688A9606A31C;
	Wed, 11 Nov 2026 08:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqbmS2TQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C8D1F00A05;
	Wed, 11 Nov 2026 08:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794385698;
	bh=piYzj8MDGWtgXv/LodWB1t6aXM+EdwWnp3fWL/kNINY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=fqbmS2TQ77JBPU/3OMzTiLkfyNKPqLUQKKdt0HdRm21za1iSlZo2xKrWJNS88ER/t
	 oL2xsF83+PGzjVeuJ+KB2K1/u8jQJew1DPFuHWnjnNLTjYMv8fJjGBmxWsziypA1TR
	 a6TknP8N+iYTpJ1WSc4lG/ZIeN3Iwi9WpwuRl3ptFoQLe6hwTlEaJVyifhlRVxnKSV
	 dh5RjQH+DmGX4/q6AOL/cilXnyR2aZU+zRDAHHLEowm7cY08b1t2cXN2gNw2pjHthB
	 O9qQsxtLN4Iub8+TBKvFcgqefiyeirTb5VXbusT3pOka1xe4Tdn1sjjdcy0Y1L2aGc
	 I6aQ6ewwAUm4Q==
Content-Type: multipart/mixed; boundary="===============8794389737657783961=="
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <6829aa96d3cda5fdc47f3040dfed6fd7c9c9e92d2dbd7a3ec5f138508db987f8@mail.kernel.org>
In-Reply-To: <9741224b8d2b19760f85c1f854d61f30fa7d9710.1794303670.git.sieberf@amazon.com>
References: <9741224b8d2b19760f85c1f854d61f30fa7d9710.1794303670.git.sieberf@amazon.com>
Subject: Re: [PATCH v2 1/4] sched/fair: expose cpu.max.runtime to set bandwidth runtime directly
From: bot+bpf-ci@kernel.org
To: sieberf@amazon.com,mingo@redhat.com,peterz@infradead.org,juri.lelli@redhat.com,vincent.guittot@linaro.org,tj@kernel.org
Cc: bsegall@google.com,dietmar.eggemann@arm.com,rostedt@goodmis.org,mgorman@suse.de,vschneid@redhat.com,kprateek.nayak@amd.com,hannes@cmpxchg.org,mkoutny@suse.com,void@manifault.com,arighi@nvidia.com,changwoo@igalia.com,skhan@linuxfoundation.org,corbet@lwn.net,rdunlap@infradead.org,cgroups@vger.kernel.org,sched-ext@lists.linux.dev,linux-doc@vger.kernel.org,linux-kselftest@vger.kernel.org,bpf@vger.kernel.org,linux-kernel@vger.kernel.org,nh-open-source@amazon.com,hborghor@amazon.de,fmubeen@amazon.de,dwmw@amazon.co.uk,karataev@amazon.com,sieberf@amazon.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 11 Nov 2026 08:28:16 +0000 (UTC)

--===============8794389737657783961==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> sched/fair: expose cpu.max.runtime to set bandwidth runtime directly

TL;DR: In fair.c, cpu.max.runtime may return stale leftover runtime (e.g.
50000) after a group is switched to "max" quota, while writes fail; a
behaviour question about returning 0 or failing the read.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c

[ ... ]

> +u64 cfs_bandwidth_get_runtime(struct cfs_bandwidth *cfs_b)
> +{
> +	u64 runtime;
> +
> +	guard(raw_spinlock_irq)(&cfs_b->lock);
> +
> +	runtime = cfs_b->runtime;
> +	if (cfs_b->quota != RUNTIME_INF)
> +		runtime = min(runtime, cfs_b->quota + cfs_b->burst);
> +
> +	return runtime;
> +}

When the group is switched to "max", does cpu.max.runtime return a stale
value?

tg_set_cfs_bandwidth() calls __refill_cfs_bandwidth_runtime(), which
returns early when quota is RUNTIME_INF:

    if (unlikely(cfs_b->quota == RUNTIME_INF))
            return;

After that nothing updates cfs_b->runtime, so the value left over from
the last finite quota is returned uncapped here.

For example, write "50000 100000" to cpu.max, leave the group idle, then
write "max 100000".  cpu.max.runtime keeps reading 50000 for as long as
the group is unlimited, while a group that never had a quota reads 0.

Writes fail with EINVAL in that state, but the read reports runtime the
group does not have and that is not being tracked.

Should this return a defined value (for example 0) when quota is
RUNTIME_INF, or fail the read the way the write fails?

This is documented as "The runtime the cgroup has accumulated and not
used yet", which has no meaning for an unconstrained group.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/42982707042
--===============8794389737657783961==--
