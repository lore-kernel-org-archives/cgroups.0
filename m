Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794989226;
	b=jiWyxOwofyWOcx5pS0PIF3I0wlsMAcYeCLFFiwJO23CTSZ/toRjrP+30HNiEy+AviOKC
	 la6001XAh9NNMEx9Y+ewWVZsphd10Eg45KC3HJ0aECxEM8kY7lh8v6NRhNoC9hv4JGB21
	 GLwa/SLeDFiCggJxa2C/E6bQ0/t107nD7NFtKwjVy/xLBIj5WDY3j+gOhpAEvG9hiPM9s
	 aOSgMb2cThV5u7tY0SsHgCy9XMEmW/Hrw31hHkVHKz710MlMeLHwOmF7bHzr8bI8v6BYX
	 CLBE3WLqJd44cAcDNAQG5tbviDhpYXXLfwl5Pk3OXatyi7OTt4D0K4EwTKFXin6U5Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794989226;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=1Bo/wvG56jqqMTFF5RAZSJ1/6NN/t3qLrAptrG7cT7s=;
	b=WRSMlP/cf6CkzXjoAOtJ0kpre/9wEEwXJHa+iHm/sbfbxBNBC+/21DefMSdt3bghZNQW
	 7wrng0pI8/CGohwFXDNxUZ1xoWnDL3zMz/buxPTpBFOMSVF70NjMykFpoK9RW7Y/Vc7iS
	 d3G4oxijjTfcoSaz7fUFQ39L4d82r2GMxzjiEPyBYTy5Lj9CbOoX392Eu/YGAl3oVwpJ7
	 RUzdwrq/FrdC/ioSpq/ynFdThU0ypQSgb+9Ep4ijN/UeXgYwpwbaL43odkF3Be/acbuKr
	 7mrHTSS7BkLBKdC+2W6KXpPvRndDbg7ktXU6Qq9cJg0O5uhNjaKvgAk2C2HWvltiYGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WklOBgTr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081D7606A31C;
	Wed, 18 Nov 2026 08:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WklOBgTr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BE31F000C4;
	Wed, 18 Nov 2026 08:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794989225;
	bh=1Bo/wvG56jqqMTFF5RAZSJ1/6NN/t3qLrAptrG7cT7s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WklOBgTrOnumaaV94d2YEKWrGjabVcrhdbw/IlAHUxYCQOX5oZ0l0e0bgHxYtvJms
	 SFmeaYjRuuv92m8WP08lvOOIpYftB2L0PszkK5Z4fte+8diwEGblvazYLQEtsOctSx
	 d8+lS0wFgF+EWafUzXvrwF/z3M0rrFV+Uldwb2hNMAMJVHuRnaAw+fjYY/opV6/nR2
	 B54E6vfyASCCnwJrov9shVK2KcCMCTFQ6PwhcwZpCSDqw4v41KW1djeMTsTkRXPPaC
	 V5kNEsheOngf1/jjQ0sUmZtqZAD+3MDH4vXVcsat74LcX1vorw1rdoWFkkyUiY+MKT
	 PhyaxrtPCyEzQ==
Date: Tue, 17 Nov 2026 22:07:04 -1000
Message-ID: <58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yuri Andriaccio <yurand2000@gmail.com>
Cc: bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com, hannes@cmpxchg.org, juri.lelli@redhat.com, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, peterz@infradead.org, rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com, yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
In-Reply-To: <20261111175657.250354-1-yurand2000@gmail.com>
References: <20261109163616.195264-1-yurand2000@gmail.com> <212c244d534ee1fdb0538a980789e16c@kernel.org> <20261111175657.250354-1-yurand2000@gmail.com>
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

Hello, Yuri.

The summary sounds fine for the most part. Some comments below.

On Wed, Nov 11, 2026 at 06:56:57PM +0100, Yuri Andriaccio wrote:
> - `cpu.rt.max` only accepts per-CPU settings, so the global "default" is
>   removed. Removing all overrides means the cgroup is a "max" cgroup, while
>   just a single override means that the cgroup has its own budget.
>   + This new interface disallows zero-runtime overrides, as a zero override
>     is equal to an empty override when there is at least one non-zero override.
>     As an example: [<CPU0 10ms 100ms>, <CPU1 0ms 100ms>] is equal to just
>     having [<CPU0 10ms 100ms>]. This seems a bit odd, how to make this better?

It's odd because a missing entry means "max" when there are no entries
and zero when there are some. Can a missing entry always mean "max",
per CPU? On a CPU that a cgroup has no entry for, its tasks would be
served by the nearest ancestor which has one. Zero then becomes a
regular value which is shown on read, and the two configs in your
example are different. The former can't run RT tasks on CPU1. The
latter runs them on the ancestor's budget there.

This means that a cgroup can have its own budget on some CPUs and be
"max" on the others. That is a fundamental part of the interface, so I
think it's best to get it right from the get-go rather than starting
with a restriction.

The root has no ancestor to fall back to, so a missing entry can't mean
anything there. It has to always carry an entry for every possible CPU,
which defaults to zero, and reject "max":

  0-127 runtime=0 period=1000000

> - `cpu` and `cpuset` controllers are decoupled, as it was before the `cpuset`
>   integration patch. The user/admin is responsible for inconsistencies between
>   the two controllers (i.e. empty intersection between active server in the
>   rt-cgroup and the allowed cpuset just disallows executing RT tasks entirely).

Yes, let's decouple them. With that, can the CPU offline lockout go
away too? An entry for an offline CPU can stay configured and take
effect again when the CPU comes back.

One more thing on the unprivileged FIFO/RR tasks in cgroups. No other
cgroup resource config grants privileges that way. e.g. If an rlimit is
set on memory, memory.low doesn't do anything to work around it. I
think who can use RT policies should be left to system configuration,
i.e. RLIMIT_RTPRIO and CAP_SYS_NICE. Can you drop that patch?

Thanks.

--
tejun
