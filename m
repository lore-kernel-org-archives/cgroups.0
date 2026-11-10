Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794346983;
	b=FpMZMLLrJM7zNpFQjmkyy1QJ1vmdcbVsSzpkhjtW2f13CZM0PFnI9yvxVwhLXYqPM0KD
	 5FEwPijx8djfs2Gh1ulj+QY2Nlg3yrEldZvDdbJmHoSQtczocumyduq/raOxSwmqH+KUE
	 fEtbzvn1fm6KdcrBYLIpiDvXwcipdNlyV1vMbp5PeIniSfpyrswh0P0RIlRiR4TWMF3QV
	 CYR4iN+F07YsXrzSxuQ++QeKWh0/ksewZBe8PiAEE6gQz9TDRzpp5WGYT0ln/0a/lFYqP
	 wUC2NfGAJrQj7IQ9V4cirsiWsbiwDHhV3rUWfJu8YHnmktnqgMeHHa7w/us0Rplghnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794346983;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=pnXAd+meB78C0W69mohSNWy0BbL4q+X+O2hCF8dlocg=;
	b=vXABD7kf00rMC+dyj2AG5q73fcuDu/Ly8Vi2ttle4Rj56BQh32nxZMNm6pw+ZzmTh/hG
	 ZxAHdvVx5+4bm24js1sZ9wQ17gBFSKrYIlQExI5mm/MqvzbMaTvMwE+FKEByrcIbKp/NH
	 vGaE6rnplE5vHsIG9tmKMOQMUaNwuq65037UVY5qcuzUxjtDqMlO3+623JxfGG0rwerTa
	 +Ap5KbdWy6es51BaI/NNOqWIgpSClV2HV3Zc9xcbzvPj7p459rxlWB2EjHeAEG6V9PPAp
	 KTirrgGx48YYkM3S3D2M93s5YovpjgfXXnvImL+TnAmemOgbZIiOaMDIB1vEwIgnrIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O1acM+3x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A96606A320;
	Tue, 10 Nov 2026 21:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O1acM+3x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109071F008A3;
	Tue, 10 Nov 2026 21:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794346983;
	bh=pnXAd+meB78C0W69mohSNWy0BbL4q+X+O2hCF8dlocg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=O1acM+3xSupuQdSoL+hoS1H57j46gpHKZMqKEoT5zOxQLZcyTQ36T7aOWHXXTfSWO
	 Qb9j3m5LwefNKjd994g+YXOGG9dlenUuImXDNQNaz1RGjq/lRc4wjOXXQcfE8/9sHY
	 U6JWp7p+cDp+Te/Bn3c6I2VTGBtRbg6Q8aWxJnbSFOmL8KihaYAPNhR4p0JLyCknQ8
	 x8bZp9RytrI80IRIYXUcsmgoedtUxWfPbE8nOu/p58KWJFT3Fxsf6Y6dhW+gEcizz/
	 D2zlGDvEYvgrQuDlRLiI0whPHHstIaY2dPRnI3WgC7Tthvw4tAhJk0wT0hB8h6KjMc
	 xc0Im4ftJU2wA==
Date: Tue, 10 Nov 2026 11:43:02 -1000
Message-ID: <212c244d534ee1fdb0538a980789e16c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yuri Andriaccio <yurand2000@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
In-Reply-To: <20261109163616.195264-1-yurand2000@gmail.com>
References: <20261109163616.195264-1-yurand2000@gmail.com>
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

I only looked at the interface and the user-visible behavior, not the
implementation.

On Mon, Nov 09, 2026 at 05:35:46PM +0100, Yuri Andriaccio wrote:
> - Rework cgroup-v2 interface:
>     + Rename cpu.rt.internal to cpu.rt.effective.local

The new name still doesn't follow the cgroup2 naming convention. Every
.effective and .local file is a suffix on an existing file:
cpuset.cpus.effective, cpuset.cpus.exclusive.effective,
memory.events.local, cpu.stat.local. There is no cpu.rt file, so can
we go with cpu.rt.max.effective.local as suggested for v6?

The file prints a "CPU runtime=R period=P" line for each possible CPU.
It does so even when the value is the same on every CPU, and the CPUs
that the budget doesn't cover are listed with 0. 1k CPU machines are
becoming wide-spread as we speak. This isn't a scalable interface.

Switching between "max" and a budget is refused while the cgroup or its
"max" descendants have RT tasks. That's okay as a restriction for now.
Ideally, the switch wouldn't be restricted as long as the budget is
sufficient, but that can be left for the future.

> `cpu` and `cpuset` controllers integration:
...
> first setup the `cpuset` cpus and later setup the HCBS bandwidth. The current
> integration disallows changing allowed cpus while the HCBS bandwidth is
> reserved (thus the admin must first remove the HCBS reservation, change the
> cpuset, and re-request real-time bandwidth).
...
> dl_server override feature:
> Following the `cpuset` integration, we integrated the multi-runtime/multi-CPU
> feature: the admin can request the override of the default runtime/period pair
> for a specific set of CPUs.

This is my main objection. v7 sits in the middle on both axes. Per-CPU
config is allowed but only to a degree: an override must be within the
cpuset, can't be zero and isn't allowed on a "max" cgroup. cpuset is
integrated but not fully: the budget covers the cpuset as it was when
cpu.rt.max was written, and cpuset changes and CPU offlining are
refused while budgets exist.

Can we separate cpu.rt.max from cpuset? I can see the following paths.

1. Make the allocation global. The interface then becomes system-wide,
   and cpuset and CPU hotplug become transparent for the most part.

2. Make the interface per-CPU. The overrides mostly make it so
   already. Config entries are keyed by cpulists only, with nested
   keys like io.max. Reads collapse the CPUs that share a config into
   one cpulist entry:

     0-1,4-5,7 runtime=400000 period=1000000
     2-3,6 runtime=800000 period=1000000

3. If you want simplicity while staying per-CPU, make every cgroup's
   cpu.rt.max allocate on all CPUs.

In any of these, cpuset and cpu.rt.max are orthogonal, and what users
do with intersecting configs is their problem.

On the per-CPU budgets themselves, they don't match cpu.max, and giving
a budget per CPU is a bit odd when the consumption isn't per CPU. The
threads move around. Maybe it can't be avoided, but I'd like to see a
discussion of the rationale behind the design choice and some
exploration of alternatives.

> Hotplug does not cause issues but HCBS reservations will need to be updated to
> make use of the newly enabled core (the cgroups' HCBS specific cpumask is only
> updated when setting the cgroups' bandwidth).

The cpuset coupling creates all sorts of problems. AFAICS, disabling
the cpuset controller above a budgeted cgroup moves it to the
ancestor's cpuset and changes its effective CPUs without going through
the lockout at all. A newly onlined CPU joins cpuset.cpus.effective and
the cgroup's tasks can run there, but the budget doesn't cover it until
cpu.rt.max is rewritten. A partition change in a sibling isn't refused
and can still move CPUs underneath it.

What users configure on the config surface should always match what's
in effect. Interfaces that let internal state deviate from that are
almost always bad ideas and long-term headaches. Hopefully, the lockout
can go away eventually.

> - PI-boosting will cause starvation if cgroups have zero (internal) runtime.
>   There are many solutions, such as bandwidth inheritance or forcing cgroups to
>   not have zero runtime, but this has yet to be investigated. We are open for
>   advice on the matter.

Zero runtime is a problem without PI too. A budgeted cgroup's own
servers get its budget minus what its budgeted children take. When the
children take all of it, the tasks running on the cgroup's own servers
stall. Those are the internal threads of a threaded cgroup and the
tasks in its "max" descendants, and the latter doesn't need threaded
mode. The tasks are still accepted because the attach and setscheduler
checks look at the configured budget, not what's left.

One option is to treat the RT tasks on a cgroup's servers as usage in
admission. Config changes that would leave a cgroup that has RT tasks
with zero runtime would be refused, and attach and setscheduler would
check what's left instead of the configured budget. There may be
better ways.

PI doesn't need to be perfect. Skipping the boost when the target has
no runtime is fine as long as nothing stalls.

Thanks.

--
tejun
