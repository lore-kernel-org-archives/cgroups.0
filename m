Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795469692;
	b=mOaIhwqNNGCzpBUwhbiBgrQ9HtIpJPlFm3b4rXhDdORmfddV8LEjl0uNwulcZ55YpKNA
	 9U5XIezOf5Xq8MdwUs9n0H2AIOtDS6rcWVPz80JFXj+HLGOd5zQkzOdymOkmE4egQFonR
	 h/Dg72zL5qmscIjOsaH5iDo62pWUmD7NtzKunUAMUw0sdhNP/3DR6OjWTwLSDTyYLM35W
	 jpSAng1qk25NuueFZ47LqntwcRUUI6tiS5YBSO9mehDHkxobWs6Nog1PBgRt9XKUAttTh
	 R+ikBfqQXarsPb9iXZjgrRDzYLI9/vXZ5NjZt6iW3z/vzPE471BPhq+S4sJFLEN38/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795469692;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=xPyUtPb5XVl2KLjLeK7kBg8OuXCGi44rHzik3N56ZY0=;
	b=kndJVgVP3zGruDqSQKNKiszjKItog4aBKRy0UGQrdQpqQm2n8TKWNMLlVyLFMNcOubuv
	 I8gv8puZsD954kogSEyum05e8U9BtCD2kqJ7J29DVAhWUShTdrUzyKw4GfuMjUDR0HQl+
	 WdPOh6xE0Waq7MuOYYm4mKF5bMppC2acTlXOiWQQYnvoyVRvhY/5YJ80hALwPC3mZQhhM
	 J+0nTvMf+dJ1Srwjn8iytX4lKIrQPmWjcd6uAbKAmrcHUwPeiCaD7TpZiWmJVzr43ev5M
	 oDyBcOXWydmf+y+59f1bTAir5xPXfpKfsg1317xfxleYPa2TmH6LX+aXCtBYozvj17A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ja2ksRkn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494A0606A335;
	Mon, 23 Nov 2026 21:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ja2ksRkn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FA91F000D4;
	Mon, 23 Nov 2026 21:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795469691;
	bh=xPyUtPb5XVl2KLjLeK7kBg8OuXCGi44rHzik3N56ZY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ja2ksRkn3r9StjppBgZKNaDlSOzAJimUlhZjFdCerhFuXUfnI5uqHBSdxfgEjIrlg
	 Jf1FSpAyyV7txOSCh3SX/Kobgls5fCYtzlhOIQCCibOFxWO+Ds5WFh71KLiZGEtKCT
	 475OHTbI5uq3+9j3GVYpX0y+YGGd0+/+eKwjqkZtAr2adXFgZBhqLUISroEBQqgi1T
	 70MPLPleyRG3882760QLiCIbSjEzLq2CygyMY6CwPInHUbzNm2p8Hc5byvEVfuh6xi
	 n89fEcyNVFUVcu+YXqzU+b8D6p3ENhaEIzqJeGgtUvng5+28HSoV7ewxjX0r4uB0gS
	 O8cC/Pbs8aDRg==
Date: Mon, 23 Nov 2026 22:34:49 +0100
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
Subject: Re: [PATCH-next v2 2/3] sched/isolation: Forbid the boot CPU from
 being domain isolated
Message-ID: <awSxeYqAB3FfMdDq@pavilion.home>
References: <20261123041209.382726-1-longman@redhat.com>
 <20261123041209.382726-3-longman@redhat.com>
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
In-Reply-To: <20261123041209.382726-3-longman@redhat.com>

Le Sun, Nov 22, 2026 at 11:12:08PM -0500, Waiman Long a écrit :
> It is reported that with CONFIG_CPUSETS=n, a kernel booted with
> isolcpus=domain,0 hits the BUG() in select_fallback_rq() during boot
> [1]. At boot time, cpu 0 is the only CPU online and an unbound kworker
> cannot be run on a domain isolated CPU causing kernel panic.
> 
> Sashiko also reports that domain isolating the boot CPU can break system
> suspend and trigger a BUG_ON() [2]. So it is problematic if the boot CPU
> is domain isolated.
> 
> There may be other kernel subsystems that have problem if the boot CPU
> is domain isolated as most of them won't take into account the fact that
> boot CPU is currently allowed to be domain isolated. Given the fact
> that the boot CPU is likely to be disallowed from the nohz_full list,
> it makes sense that we should not allow the boot CPU from being set in
> the isolcpus boot parameter as well. This will also avoid the kind of
> problems listed above.
> 
> Do that by clearing the boot CPU from the isolcpus range when it is
> specified in the boot command line. A warning may also be printed when
> that happens. If the users want to have boot CPU in the managed_irq
> or nohz isolation list, a standalone isolcpus boot parameter will be
> needed instead of combining domain and other flags in the same isolcpus
> boot parameter.
> 
> This is indeed a change in behavior which is customer visible. So the
> kernel-paremeters.txt is updated to mention the fact that boot CPU
> cannot be isolated.
> 
> [1] https://lore.kernel.org/lkml/20261117144817.265109-1-mathieu.desnoyers@efficios.com
> [2] https://sashiko.dev/#/patchset/20261108180849.1268263-1-longman%40redhat.com
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs
