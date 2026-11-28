Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795850549;
	b=DU0RJUj1OCgl49OKGpiid37V4hKvRYJKQYvyx5qLh3JcLxB/y42p8I3sicebq3ER43ct
	 bJ0C+gdhzYjZvW8VuVlOAlb41DyX4OaaztiJWfoXybfFesiZtpM7ajw6FwzcVaPVAYW8L
	 Qn6EQShOZA3Hk5GUblBDZTmZLToECqVX1ufwjfJZhy7c0JWibkGX/gK+mLzPYa9dIccsH
	 43fRoHqc7l2Y34EdXLM7YB8bN6zjhGdoFshmcyUkIHqcN/sXWN5vZjGDiWJWk1DHSOnBC
	 XA9miOR4eikHgWVEIGmNqB9OakZtpReS+8dzHiiWAaZIxL8Nhbf0oBp/iNJxDZeg+HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795850549;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=E7BaQwHFvE2qtlxcKRVFeBFON9qvj8Rex8GDT8MBJvw=;
	b=1Spqb0tQaJ/3q24Dh7NUv5QSfWQVu8NeFxyHiHWPp3kszvZ01VjzZlMU8RZZRW+IqddI
	 3q/G+gLQODDxw1b834//gVuVeAtW4fd54SdJ/JTzvHcn07AOVxxLPY0fm0ANggmYiSFHR
	 mn5EloL2X/Paq8REtpamWUWCcV7JmznzzqrPGcmoRJFc+4FvRcsn5oq6OQnxu5MCDfb06
	 ksRm4jY9DpUYON8nPIN+F88VqfcxmE/hmNOLqweCY0lLCuuNriqyNssr9Ye8iHLsUD8xY
	 0ir24x1mnys+dVE/mwOB4gfa9y0oSS+Txa9eag1rfXLwrXrSedtEQdcEzG9T31oC7cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HyVeavEc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C24606A31C;
	Sat, 28 Nov 2026 07:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HyVeavEc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58F21F00897;
	Sat, 28 Nov 2026 07:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795850549;
	bh=E7BaQwHFvE2qtlxcKRVFeBFON9qvj8Rex8GDT8MBJvw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HyVeavEc+f23hvBgSkePGRfaBBQ60HpTQKM2q/7ta4RAjR7uauxwPxYctUa5SxDSZ
	 lvAfG3jVEVSJMDhqY4Zoxi8hdH5RjBVkQC3zFoEE+HXZS7Fj0ErB3aXdQXNGC+ggLY
	 P0PO27DAAxzUDgCSkoB2HV9lQ9vKs/BGUEJTgiwjBfsOuIjI1KSJT2Wq5sP4kvjFml
	 e0U03RyfwZI8H04uPfP5fJgWige6lkiPfGFtodNrq46otBF/FKcKlDRNxfLBMs67Vj
	 aFPETN5RYVBVW4gmgZZS0QJtf/qxlhn67NL4CfjoRLH721J5q/vgr1+4sKSz7N1AWo
	 Uq2cfF+LERrxw==
Date: Fri, 27 Nov 2026 21:22:27 -1000
Message-ID: <4f3afbc84c522f9477d62a35ad01d5a5@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, luca abeni <luca.abeni@santannapisa.it>, Yuri Andriaccio <yurand2000@gmail.com>, bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com, hannes@cmpxchg.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com, yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
In-Reply-To: <awmVSkc4T0AuFntw@jlelli-thinkpadt14gen4.remote.csb>
References: <58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
 <20261119151416.33f90a64@linux.fritz.box>
 <471bf8d446becabfca00041fb2a78067@kernel.org>
 <20261120120659.2e902463@linux.fritz.box>
 <6fef47e08a37079c08806b3c57994778@kernel.org>
 <20261120212418.10221f2e@linux.fritz.box>
 <06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
 <20261123084345.4e24e3ca@luca64>
 <awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
 <20261127114828.GS49833@noisy.programming.kicks-ass.net>
 <awmVSkc4T0AuFntw@jlelli-thinkpadt14gen4.remote.csb>
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

Hello, Juri.

On Fri, Nov 27, 2026 at 03:35:54PM +0100, Juri Lelli wrote:
...
> Either the entry's bandwidth
> stays claimed while its CPU is unreachable, so cpuset changes never
> fail but that bandwidth sits unused, or it's released and claimed again
> when the CPU becomes reachable, which means growing a cpuset can fail
> because of the cpu controller. Tejun, Peter, does either work for both
> of you?

My preference is the former. I'd like to avoid intertwining the two
controllers as much as possible, so an entry would keep its bandwidth
claimed whatever cpuset says and a cpuset change wouldn't fail because
of cpu.rt.max.

Cross-controller operations are possible and useful on cgroup2, e.g.
between memcg and blkcg, but I think it's best to keep the interfaces
as orthogonal as possible. Interlocking configurations across
controllers gets too complicated and confusing in general, and
especially so given how limited the failure information we can
communicate to userspace is.

Thanks.

--
tejun
