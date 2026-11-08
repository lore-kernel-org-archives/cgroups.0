Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794163583;
	b=f6zrh6TkNHpdpaAePD83UFfdzg3ivJl1roZzsT2Pc33cOE6nwLjxxP2ApG/hLQWZsVv6
	 wdd1CrY51AIDMEVfuw44jB44y4TWsEXsEVqG/CcZKmbn9a8YHiu5c3Lx5IrqV+22TT5yq
	 9Duqioe8pYbtlplJvQxTwq1xBPbAliytoErrdWJDgqdgI5lDKWDOVx70PbgYzTts4Je9z
	 fCGAc99KENRPm4cwNSVQBdTvR9D2MU/H8tqlJgNHNmToQvKw3H8c98DX792PC2v0ieBIr
	 tGT0MesPTFiXnFhlVi4COC5Cn7gF05ZWryJIWOzBB87A4R5MsDlFaXUVwmHv8hl9aQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794163583;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QCrhUsgXN20C3cHPvx64AmtzG2nt7t8CFzH0M5AkzpA=;
	b=UTVWzTEuJ//vt1S8TBc4Q27oW4XzPa8gcx8Re44gdyeZMP/Qh5TJbudcaqW/NjNNYj+Z
	 hzybOc3z03AVw48UF9NvDhJ+jFomhPsrezL2CZy6xN49zh+n6pJK+YzVumJw9CrRyIfQX
	 ynfVqbN8GS4x538ns9Mws/yI1sJTM6GtojGlvEVLv7RJBF4qU0fCpyEEUec9rqmn2kLzn
	 7WLZ/Yv20/SoTdWOoiMMJztL/mR2iOtHCCksQ2fllUPG6Yl5cZu+btAu5aGrqASYXgCXy
	 0OVno4TACa0E+UYNbS1RCNZd5sfvjXqETb0gbA6gYLDSbEXJJzaceG3rdKMPUBh+DzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="NFVCwM1/";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA20606A31C;
	Sun,  8 Nov 2026 18:46:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFA20606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=NFVCwM1/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794163581;
	bh=QCrhUsgXN20C3cHPvx64AmtzG2nt7t8CFzH0M5AkzpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFVCwM1/QPsXAPO1nluPgdctj8OqFy3GfwY+YDPKKAPkDwvZ28ES+RLAvCcigkTEn
	 /E5BXNMCb/iPNk28O1C7LDpFR1XXy3FBb7UKeMEk8LSpMeVRdfCoMoGCoDOpMjH6MB
	 dIGoObEW/5Q4xQRH7VnNDs7dhLHAcAfYi0nxEKYQ1lOpvmHWceykAxLaDZsUXb19qH
	 ix+vUnknaX1lGR3KeMENZTlIh1znsL97jGk8e3XtB3VNvzCEgac9WSOjwOGFzE2SBj
	 Gc9kmp7NpEfEQCdPlIR+lYr/oqGNfaDwsj0A4Op5+yaVi68Cowoa1tx2iy+sdaRVtA
	 oFMwKEHDmUeIw==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN21n2X76zMmb;
	Sun, 08 Nov 2026 13:46:21 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Waiman Long <longman@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Valentin Schneider <vschneid@redhat.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] cpuset: empty sched domain with isolcpus=domain, panic at CPU offline
Date: Sun,  8 Nov 2026 13:46:20 -0500
Message-Id: <20261108184620.1548615-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <12cb0bee-57aa-4609-bc2e-77806e0b6805@redhat.com>
References: <20261108145744.1532128-1-mathieu.desnoyers@efficios.com> <12cb0bee-57aa-4609-bc2e-77806e0b6805@redhat.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 2026-11-08 13:35, Waiman Long wrote:
[...]
> Yes, we are going to add the check to make sure that there will be at
> least one housekeeping CPU left for the top_cpuset sched domain.
>
> See
> https://lore.kernel.org/lkml/20261105130344.664336-1-guopeng.zhang@linux.dev/

Thanks, I had missed that series. Refusing such a partition is a better
fix than giving the top cpuset no sched domain.

> This patch is correct AFAICS. I am not against it but it may not be
> necessary after we make sure that there is at least one HK online CPU in
> the top sched domain.

Then I will drop my patch and rely on Guopeng's series. I can test its
v3 on the setup that hit the panic: 5 vCPUs with isolcpus=domain,0,1.

By my reading, your _cpu_down() patch covers a case that cpuset cannot
fix. With no partition, the last online housekeeping CPU could go
offline. No partition could then give one back.

Thanks,

Mathieu
