Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26B42E06ED;
	Thu, 18 Jun 2026 21:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781816491; cv=none; b=pCasvH7SHLApoU0/PvO1tQASmm8CqVKrguTCKDdTrB613/0u0bys4C2aeyf5jkzwTtEo6rVJgAIXKPxQ+3dtFjdr1YAKRv0FfdCqwgrhjc+PGBpyRgPVXn5t3R2dyEr4JbYHSToc3NfO7YQdgfs0FlaFpVjHWUwRsz2MXhyECMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781816491; c=relaxed/simple;
	bh=sZ0YsnmAii4GUE3rEvNb3q8s9zGP0Km82q3SrqPALKg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IPfxQJbngWgw+dAmkjmNmJr5eQdBeOA5jGLVvCzCIFgh0CHe+lLJ3j4aesiGpVnyzNL/6a/nYWS+pX3cxzwZEXiqxgP47EDInuGpDmiygc8Zag9ZqiCP5IHo7htFpNlMTnunc6eBzwcDApH4/3gWgu5egEQnBZ6kNnzlbF+Z7/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3QhKDvT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3QhKDvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BD41F000E9;
	Thu, 18 Jun 2026 21:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781816490;
	bh=OcqBE6HGNxLABUAPdiGERKF3VjVKs+X2JL5EI1LlHO0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=O3QhKDvTbMFyRLz7vMEYvPy9x/fgkp+4gS66msLkSHNRlhzWZqlc9G2JCKX8lw2cg
	 +SHpnwwVTi5AG53xOnmHBQPHVDwwXOSao5DDsGm7JwZiwVFbAYdcyPgaHDF2aa8jO+
	 wFu8gS3Ew9XLi4bgBn0/YkRQDN1GZdBD6fFaNAcgRDFg/i0bKzlBSSdR+3XAkJonU3
	 1rF2GPWW85FLYROdllsL9c4hd3Iiq5k5odrjfBbo0xzXWAh13TrKFg6+7BPNVc3bkF
	 4HJO5VIdff8BmDNZk5YUu2Qos22VOZgM2+qVo7g8s7zlnFC8ez9pp9k1WDzMuMW5DC
	 dgY/c1t38y9Fg==
From: Thomas Gleixner <tglx@kernel.org>
To: Jing Wu <realwujing@gmail.com>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, Uladzislau
 Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang@linux.dev>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Tejun Heo <tj@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
 <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Jing Wu <realwujing@gmail.com>, Qiliang
 Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH v3 05/13] cpu/hotplug: Reserve CPUHP states for
 nohz_full and managed IRQ down-paths
In-Reply-To: <871pe3de9b.ffs@fw13>
References: <20260618-wujing-dhm-v3-0-28f1a4d83b68@gmail.com>
 <20260618-wujing-dhm-v3-5-28f1a4d83b68@gmail.com> <871pe3de9b.ffs@fw13>
Date: Thu, 18 Jun 2026 23:01:27 +0200
Message-ID: <874iizef6g.ffs@fw13>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Jun 18 2026 at 18:06, Thomas Gleixner wrote:
> On Thu, Jun 18 2026 at 11:11, Jing Wu wrote:
>> Add CPUHP_AP_NO_HZ_FULL_DYING and CPUHP_AP_IRQ_AFFINITY_DYING to the
>> cpuhp_state enum.  These dying callbacks are invoked during CPU offline
>> before the tick is stopped, enabling clean tick handover and managed
>> IRQ migration when a CPU transitions between isolated and housekeeping
>> states.
>>
>> The existing CPUHP_AP_IRQ_AFFINITY_ONLINE already handles managed IRQ
>> restoration on CPU online.  The new dying callback completes the pair,
>> migrating managed interrupts away from the CPU before it goes down.
>
> What? They are migrated away today already when the CPU goes down unless
> the CPU is the last one in the affinity set of the interrupt. So why do
> you need a new step for something which already exists?

Aside of that these hotplug states are not used at all. So what is this
patch for?

