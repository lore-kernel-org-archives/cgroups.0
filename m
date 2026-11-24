Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795500459;
	b=kSr9g8gzATg4zk4PSM+GLrLff0VOmdECQy3gxuhPa7RhyPV32KF5mxgF9IlMiDxEM4bJ
	 8DdFyfvTVVzXX2wBbElwK3S9FbUO+GBklctW0c0euSdF6oQs3VIAdvz+2kR7FK4twabc7
	 3RQggC2Ox1rRoI9CqMukKNKcaX1fpn8D3iEs2JRC/hMLcrW/QP9Cg73ixk83cjCyVcBo+
	 VsdbraFpXFdAloLtJXZiKRdH9F26E0CotQDUrdyY0e4NlYeXZDWlxOlG85+mjfH3Xegoy
	 H21/l1QP8B5MTmFRaWIUOK7aPEKz2kGTiDU5RIaiY7x5U+eIpOryNauobz+JrfXDIFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795500459;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=bU7tRYB1GaaA5lNIxOwbSv+9H6TbnuriyfJNLcDv1V4=;
	b=HtjR0F0uFKaU3qxVXKWeLgz7hOJw2RQq4ZKQcyeiyW78yBT4nNPOtsCmRI5R3EEdjfa7
	 g+kOXNUgWWsRytCXdYc61FI6PHLaNjuZsw26IvOlQE8Gly7gzGuPhQlt/96wo+KF/1KEI
	 k+nvR52Bi3+pJGIzeSfyCTDvUyiu2squyxgr4PSmg5H6vxRckKHJ3smxN8t4MrHWG2+jN
	 pUw/SNXJbyBSqEkjxG5HnjQu1zIF7G1n6/G7kfPuzLarBey4ZERJ4VI8jKXqAHbl8yqFJ
	 hU8bhdq9sN/q06CTZcNxLI89fzf30AZvB/kbIWj4koQohnVwNeQu+ZD4H1TqaxpfRyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5VkCyP+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E243606A336;
	Tue, 24 Nov 2026 06:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5VkCyP+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B111F000CF;
	Tue, 24 Nov 2026 06:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795500458;
	bh=bU7tRYB1GaaA5lNIxOwbSv+9H6TbnuriyfJNLcDv1V4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=f5VkCyP+c9Q6d5JUXR3bBdThg0iuwf6qsiB6+0r9y4w4BWXSNtqNEVhR4GUryi1M2
	 bPQXnIb5C3LLvEoXFPslIpHCF0UKHEsYDGtqojOXopG7yW7di18BXG9B6lcfGEoIw0
	 khtjwp9FJbgjwluGOeijZQtBvkEiZDRFxeDZ9yHs6ShqgTKFQc/Y9afG7ROHyDKaQA
	 4O8tzZZRj7+yHQN9G9Ojsn07nlPiAXM0b59q0KlI2F4rIQP2nL874ZBl2Kb/26S+C1
	 bsc+i1NdZrwT4kr8raZe4GNkLWaznN1AFA34vewMuo0odcIqr6WHXuwi/ASuv2PS0x
	 s1q844nA4dLww==
Date: Mon, 23 Nov 2026 20:07:30 -1000
Message-ID: <99af4229ed5463003387ecf8ecaefa69@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Ridong Chen <ridong.chen@linux.dev>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, Thomas Gleixner <tglx@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH-next v3 0/3] Skip boot CPU or don't allow it from being used in isolcpus and isolated partitions
In-Reply-To: <20261124042802.532633-1-longman@redhat.com>
References: <20261124042802.532633-1-longman@redhat.com>
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

> Waiman Long (3):
>   tick/sched: Make tick_nohz_full_mask and HK_TYPE_KERNEL_NOISE cpumask
>     consistent
>   sched/isolation: Forbid the boot CPU from being domain isolated
>   cgroup/cpuset: Disallow CPU 0 from being used in isolated partition

Applied 1 to cgroup/for-7.4-fixes and 2-3 to cgroup/for-7.5 after merging
for-7.4-fixes into for-7.5.

Thanks.

--
tejun
