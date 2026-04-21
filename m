Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AF839C657;
	Tue, 21 Apr 2026 08:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776761969; cv=none; b=D410J9Hn1nFtfQN0261o01HGZt1Nm1ZlsMfvc25XACi9K8z2CVy/nnG741WBvExKrDlYFcWmFwAf6HjaYA7TQfqFI9b3dYBnJmCWS3hfHheZ8Xadi3ur0nRNGS1EUC0F5yh5zncwrKqVlO5D59RhTT6Bm77LEB6cQbmXU1m0C1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776761969; c=relaxed/simple;
	bh=0q0Gpy8lbZm91XWD5TmDJAobYHfE8UG/1WqUhR93NM0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=c22hs64lsCqkd85DhloDVbtMA/fhji0SZLoX9D2uIZPGvGeGsFGzcFLfW5cZdbycnrUNMmX597XtR4K952DYbYTH4w6fQeT/MPtjkGV3i7Ir9yyzZYgDtY0PGOGe039rM6u0ZibgTZdFznnIjV2ZOxfon2Duxwfxp0B0bXwKkg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZCu/+kUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZCu/+kUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828C3C2BCB0;
	Tue, 21 Apr 2026 08:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776761969;
	bh=0q0Gpy8lbZm91XWD5TmDJAobYHfE8UG/1WqUhR93NM0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZCu/+kUk82qDnHMMO6LfBHDcTLR/zEhWpNl9fdYgQdxm/xNzi+3OKS5RYOvdLfDoz
	 kNiu0Zg6PkSfg2oOtk43qfDHmgT0elCicP8BJe7MXfB04wE7Cme9EA0WSI929HydcS
	 T8hR04ipy64qcx9Ho+jPpiV0NA7ZAX7tPFux345/2psxILPUlrgcObeN3+q4KWTvVt
	 lmy1YVjISyiCBdVj35jnAgI7mv17I7V4nfenlvt6RCuonYCDDuhAvjW8nM6vqSK3sg
	 wy1kLGroMkQ8Potfz3j4Allbh6G50kClsfQDdxP4MK2/PVly+1TeDZU37OTBrtOrcJ
	 A+IkpJepKbBfQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Johannes
 Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan
 Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, "K. Y.
 Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li
 <longli@microsoft.com>, Guenter Roeck <linux@roeck-us.net>, Frederic
 Weisbecker <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes
 <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, Boqun Feng
 <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt
 <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Ingo Molnar
 <mingo@kernel.org>, Chen Ridong <chenridong@huaweicloud.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek
 Nayak <kprateek.nayak@amd.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-hyperv@vger.kernel.org, linux-hwmon@vger.kernel.org,
 rcu@vger.kernel.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Costa Shulyupin <cshulyup@redhat.com>,
 Qiliang Yuan <realwujing@gmail.com>, Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 11/23] hrtimer: Use RCU to protect access of
 HK_TYPE_TIMER cpumask
In-Reply-To: <20260421030351.281436-12-longman@redhat.com>
References: <20260421030351.281436-1-longman@redhat.com>
 <20260421030351.281436-12-longman@redhat.com>
Date: Tue, 21 Apr 2026 10:59:24 +0200
Message-ID: <87tst4bser.ffs@tglx>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Apr 20 2026 at 23:03, Waiman Long wrote:
> As HK_TYPE_TIMER cpumask is going to be changeable at run time, use

As the ...

> RCU to protect access to the cpumask.
>
> The access of HK_TYPE_TIMER cpumask within hrtimers_cpu_dying() is
> protected as interrupt is disabled and all the other CPUs are stopped

interrupts are disabled

> when this function is invoked as part of the CPU tear down process.
