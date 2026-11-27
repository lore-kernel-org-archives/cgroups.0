Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780122;
	b=2lRKNk3bdTwoSpi/BKjTTG09JXcaP6TSepOtUTOX3+69VMbEJGskE94vukdUbOu/9u0K
	 QkHbFS97X99h/CszjEyp0g8TCPtbEfW4el9jvxZSgtxIVsAMc2XC9Bhx5uFBnCESgJvaf
	 1dkNrnu48tMWhf4d/zMOcQJxScnxWeuw936ylZOF1bd2P1C6/axYZrOTuVnX44uit60oh
	 64K1LIjNmayKySbDKwVEjNI5xXm2Ao4FSIJaxYgJuTaK8y0d0TxChE9lcjCOIHDdD+hrC
	 G9g0ERpBWf+Z+5zLvTVgHQMghkoUKp8wzzl9r2HiwyvBy/2MZ/GM00Wq56+GrOGPlog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780122;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=XoVuZ/Auip5toU3PbcJl2w3oz1W2jXDEKyOD6MbonM0=;
	b=lEvhd/2jaMqBJ4E0Leks757mnN4Q2B71kXThUUSqhN6qZ8yMm8RqH6Pr+H4YPn5UJ8b2
	 bYTce9DEo1LCsAHaDMSTvNOH9vPEl0YtYxOVh9vkd+eZBIoHiAQPFlb7PJ4EJRzGvyBCg
	 dVPXsI9b6MQBMIPD2PgDK3hMhy0CD3IcfFgRcTZt/+cQoqrVMPuYzBcEgJx9W/obRbQ+2
	 e/cfKTGaSymgow0vFo4FImQsK3P9KIhAtJXBELXDWKDpsRn/rOLDxeAr3RtpBopUyXfU0
	 UGAUqoX9mMtAVTKnraMtEpe4oVASxpEgCEPR9DKNcY6MRLf7Jvx3dQUZ9Pzm5yraNEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b="oSt/Yhtz";
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369D1606A685;
	Fri, 27 Nov 2026 11:48:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 369D1606A685
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=oSt/Yhtz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XoVuZ/Auip5toU3PbcJl2w3oz1W2jXDEKyOD6MbonM0=; b=oSt/YhtzIHOaoNm99RLjfK79RN
	8a8JWywA/gz7/XGpQN1v1R81QjVNVZGflkLNZKa9dBN3oN34hYG/MJj8RNS0Y69tJjo8LZ4bgkcQt
	xZYOX8z1YzvouCGre1tM+sI39A+JsfggRETMlo3gH+UJEETn+c1eysPrPZ/lk7gmSCXhGyC+JlWEY
	YN45SR627HzO0qgm+XvJS7ljpJ3D9BjQeneIWBZ3EByUorS0kECRgy+P0OUmP3IyptaOQy3vfAnhB
	Q+Lfak9IK/bbSN6d5ywwCodIs3gwLPc5dszlXFWCAVAHPkH7RfFE/qCNBZOZ4ahyps8nJtkwxdiqT
	NGLMW3Gg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWuRK-00000007f2h-3Tbk;
	Fri, 27 Nov 2026 11:48:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D383B30027B; Fri, 27 Nov 2026 12:48:28 +0100 (CET)
Date: Fri, 27 Nov 2026 12:48:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: luca abeni <luca.abeni@santannapisa.it>, Tejun Heo <tj@kernel.org>,
	Yuri Andriaccio <yurand2000@gmail.com>, bsegall@google.com,
	cgroups@vger.kernel.org, dietmar.eggemann@arm.com,
	hannes@cmpxchg.org, kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com,
	mkoutny@suse.com, rostedt@goodmis.org, vincent.guittot@linaro.org,
	vschneid@redhat.com, yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <20261127114828.GS49833@noisy.programming.kicks-ass.net>
References: <20261111175657.250354-1-yurand2000@gmail.com>
 <58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
 <20261119151416.33f90a64@linux.fritz.box>
 <471bf8d446becabfca00041fb2a78067@kernel.org>
 <20261120120659.2e902463@linux.fritz.box>
 <6fef47e08a37079c08806b3c57994778@kernel.org>
 <20261120212418.10221f2e@linux.fritz.box>
 <06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
 <20261123084345.4e24e3ca@luca64>
 <awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
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
In-Reply-To: <awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>

On Mon, Nov 23, 2026 at 11:22:03AM +0100, Juri Lelli wrote:
> IIUC reading your RTNS'21 paper with Stephen and Jim [1] right, those
> are its conditions (1) and (2) for semi-partitioned systems, and
> together they keep the system feasible. Did I get that right? The catch
> is that the paper also needs changes to the migration logic (no throttle
> bypass for tardy tasks, and the pushed task not counted in cpudl when
> looking for a target) for tardiness to stay bounded, and AFAIK we don't
> yet have that in mainline.
> 
> So today's DL isn't "pinned aware", but we already live with that:
> fair/ext servers are pinned and simply added to total_bw. I don't think
> this series should fix that too. What I'd suggest instead is:
> 
>  1. keep the interface per-CPU as Tejun proposed, and do admission as
>     above (sum into total_bw plus per-CPU check). When a config is
>     symmetric across the CPUs of a root domain, this is the same as
>     today's uniform reservation, so it works with the current DL
>     implementation with the same guarantees we have now;
> 
>  2. accept asymmetric configs too, but document that, until DL becomes
>     aware of pinned bandwidth, they come with no tardiness guarantees
>     for DL tasks (as with non-default fair server settings today).
>     Once the migration side is fixed (the paper's changes, or
>     something similar), they get the guarantees without any interface
>     change.
> 
> This also avoids the cost of the max approach, where 50% on one CPU
> takes 50% of DL capacity on all CPUs of the root domain, and it should
> be less code, since cgroup servers would just follow the dl_server
> accounting paths (dl_server_apply_params(), dl_server_add_bw() on
> root domain rebuilds), but Yuri should keep me honest here. :)
> 
> The root entry would then just limit what cgroups can reserve per CPU,
> on top of the above, which I think is what Tejun described.
> 
> Thoughts?

Still slowly working my way through all this email :/ So bear with me if
I missed things already discussed elsewhere.


So my suggestion to make all this cgroup-v2 only and couple with cpuset
is exactly because of the bandwidth accounting. Specifically, cgroup-v2
makes it possible to map a cgroup to a cpumask (exactly like we do in
tg_cpus()). This in turn means we have a natural limit on the bandwidth
consumption -- a cgroup's deadline servers will never run outside this
mask and will thus never consume bandwidth outside of it.

Without this, you get to account every cgroup to all CPUs, which is
incredibly pessimistic; to the point of not actually being worth it.

As to bandwidth accounting; I once started adding per-cpu reservations.
Sadly I never finished it and I seem to have misplaced those patches.
But yes, that is something that wants to be done.

I'm not sure I see how all this can function without having that TBH.
All this runs on a giant pile of per-cpu servers; without strict per-cpu
accounting much goes out the window.

The basic idea isn't hard either, give each CPU 100%, subtract the
per-cpu demands and hand out the rest to the global pool. When demand
exceeds supply, reject. The only somewhat tricky bit was that adding a
local claim means you first have to try and lower the global supply --
if that fails the whole thing fails.

[ I think at the time I wanted to add pinned DL tasks support or so, but
  its been so long that I can't even remember that :/ ]


A cgroup setting bandwidth for CPUs it cannot reach -- fine; the value
will not be used. If the cgroup is grown (through cpusets) to include
such a CPU, it will enact such a value, and if bandwidth reservation
so demands, block the cpuset mask extension.

Since FIFO/RT themselves don't actually request bandwidth, shrinking,
either through cpuset or hotplug, will not be a problem as such. Were we
to offer this cgroup bandwidth to DL tasks however, then we must ensure
the total cgroup bandwidth stays sufficient to serve the existing DL
tasks and refuse shrinking if not (however, I do not believe this is
currently proposed).


As to the whole max thing; am I understanding things right if I say this
means the cgroup itself will not have a constraint? I saw talk about one
cgroup having mixed constaint and no constraint CPUs? That's crazy talk
and makes absolutely no sense. Please don't support this.

Either a cgroup has a constraint or it does not.

I would suggest that writing a reservation into the file that is not
specific to a CPU, results in (runtime/nr_cpus, period) for all CPUs;
where nr_cpus is the cpuset's effective weight.


