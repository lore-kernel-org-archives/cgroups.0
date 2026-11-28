Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795831511;
	b=UiOWFHyqW8WZNnk7wcaWFs7MfEItzLxsoW262gyP/fP2XQcy9nffaGIGAyLcFQC8xYCn
	 FNgTFkzOWo70flzvCxHG4Huf7UtqT5DV8exe1rUancytjUVHurUbbnRAoEzMLAqo5t/ZB
	 da+gBPKWHnX5uNcHexw8Qg7B91UOUBGfRu4bS61ltvEchaZenMZAOvxKY8xoLEicTRHKR
	 /edtFyWR0BjIgMNrqbj+fCB1ZbGPgoYKqWX9CSNXhTLJz8CLwZMQ5qVgimydiF1MZ7Vy9
	 9C8MKdtMYNHdsHwsM3MphjdcPu+ojeebuqCH+sZe30bBIb6Rpz9fiFiX+fbaf1Haf8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795831511;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=4/y7+l7+EWAi2AyE4VivUN5vGlD65eVWxEAZNKww8cg=;
	b=ydFTtGbar3ZAganrQFfaa3mLgSRe7oWZ5mrA1UCl4FSD4765Nqq23iriJ8SPFwUUZbR6
	 rETSVVdMHjxqz605BdV+BTkzJjy8jXwFZxL06bAlW03qPt0/stlUnB0IyNwZNJQMfIDLJ
	 EGh/di8FOE/ExzFooj91ZyBx2MpAt8suZyWEPxBT+MhdZdQI0gMDvTSOc6uu8ShmOd1ty
	 Q/fiCJyqNsYRzlYzqZgKjDlXjwTR4TW+v1rsI5kfC1FOaNtFzawOg5kYpK/4C6qakulBe
	 vp9Jt9pV15f+5DwRvKa89Z6sktaTvcuHpdRXaEItiF95iAgNkfcbZJ37PIEHuqmJ+XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=blu7n8kI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3352606A31F;
	Sat, 28 Nov 2026 02:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=blu7n8kI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655EB1F00893;
	Sat, 28 Nov 2026 02:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795831511;
	bh=4/y7+l7+EWAi2AyE4VivUN5vGlD65eVWxEAZNKww8cg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=blu7n8kIBgrY/XPFGmvxjXnxhmQf65TfpkQbGNFy2j996iIGxEzO2+DKMQarGKQaG
	 cpp6QM9HKXxB5062gDX94ZYnLvS0KxLxt0G3LcvLYrcJpzsClFiHWRUKNIlmB9/lEx
	 cdCOKY9172yKW7Yd1xursIkDVQ2FaQldFia13QZDPMyVAvAwL2oRSTlX6hVKTIfIsD
	 zPFKtgn8z6qV/2dvzDOxNEOcfqpHiytTyK9vwH4s1ge/ZwGoIy2ZL9S0D75xGColub
	 PUK5ytnHvF5zD7MJXI12+NEYlsg52Dwwd+P5OjJJwym6H89lc6ONnEg7SRWhnoL9yV
	 3TipnUzCVnnCQ==
Date: Fri, 27 Nov 2026 16:05:10 -1000
Message-ID: <c9eeab238a98617755772b8030109a31@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: luca abeni <luca.abeni@santannapisa.it>, Yuri Andriaccio <yurand2000@gmail.com>, bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com, hannes@cmpxchg.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, peterz@infradead.org, rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com, yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
In-Reply-To: <awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb>
References: <58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
 <20261119151416.33f90a64@linux.fritz.box>
 <471bf8d446becabfca00041fb2a78067@kernel.org>
 <20261120120659.2e902463@linux.fritz.box>
 <6fef47e08a37079c08806b3c57994778@kernel.org>
 <20261120212418.10221f2e@linux.fritz.box>
 <06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
 <20261123084345.4e24e3ca@luca64>
 <awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
 <20261123151846.3fdcbf4e@linux.fritz.box>
 <awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb>
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

On Thu, Nov 26, 2026 at 08:25:50AM +0100, Juri Lelli wrote:
>   P/          cpuset.cpus=0-10
>               cpu.rt.max: 4-10 runtime=400 period=1000
>   P/noncrit   cpuset.cpus=0-3   (threaded, no cpu.rt.max entries)
>   P/crit      cpuset.cpus=4-10  (threaded, no cpu.rt.max entries)
...
> Tejun, is this the kind of usage you had in mind?

Yes, and let me build on it a bit because I think it also shows why
tying cpu.rt.max to cpuset is problematic.

Here, cpuset is what keeps the two sets of threads apart, but cpuset
isn't just for RT tasks. Say the process also has normal threads which
should be able to run anywhere on 0-10. The two children can't carry
different cpusets then. The RT threads would be affined instead and
crit would carry the budget so that only its threads use it:

  P/            cpuset.cpus=0-10
                cpu.rt.max: 4-10 runtime=400 period=1000
  P/noncrit     RT threads affined to 0-3
  P/crit        cpu.rt.max: 4-10 runtime=400 period=1000
                RT threads affined to 4-10

cpuset confines everything in P, RT or not, to 0-10 and cpu.rt.max
says where the RT budget is. crit takes all of P's budget on 4-10, so
the noncrit threads have nothing to run on there and stay on 0-3. If
the budget followed cpuset, it gets tricky to express the restrictions
for the normal threads.

Now, say P sits under S and a second container Q is added next to it,
sharing 8-10 with P:

  S/            cpu.rt.max: 4-14 runtime=500 period=1000
  S/P/          cpuset.cpus=0-10
                cpu.rt.max: 4-7 runtime=400 period=1000
                            8-10 runtime=200 period=1000
  S/P/noncrit   RT threads affined to 0-3
  S/P/crit      cpu.rt.max: 4-7 runtime=400 period=1000
                            8-10 runtime=200 period=1000
                RT threads affined to 4-10
  S/Q/          cpu.rt.max: 8-10 runtime=200 period=1000
                            11-14 runtime=400 period=1000

P and Q each have 200 out of S's 500 on 8-10 and 400 on the CPUs they
don't share. Nothing has an entry on 0-3 and the noncrit threads run
there as before. P and crit now need different budgets on different
CPUs, so expressing partial sharing takes full per-CPU config anyway.

I'm not familiar with the analysis side, but wouldn't it be okay for
the guarantees to come with conditions? e.g. If the crit threads stay
affined to 4-10, they get the budgets crit has there. A thread which
doesn't follow the setup gets whatever is left where it runs, which
may be nothing, as with a noncrit thread on 4-10 above.

I think something like this, per-CPU and independent of cpuset, is the
most orthogonal. Intertwining configs across controllers or CPUs is
likely to lead to complications in the future, many of which we can't
foresee now.

Thanks.

--
tejun
