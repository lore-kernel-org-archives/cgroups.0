Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119781;
	b=Kwnr7BqquCJihWgEDQINW8b26FyHodYxf5oNrWAiAHBjSlDk03Vd2YYgpYWBMDz6CFy0
	 F11A2JmbUpIUyU8axadVtwtym1dRCqcant1qwVTVmljgZrw9vrIU0gFLehgIvrFqX7BEC
	 fQGUqEd14loJ7ka/ZgIg1viVVgLpS/zaTABbKR45igTcVTzAAaekTFinZBEn1kqVsrggX
	 wdYnuCNZBE8X42G2pRIIt2ldGv+C6XjfYAuDVqILluP9s7wDQdGyX0FQXvkR2hHYt1fww
	 Gce2JqOd8I6Y4BAKPInOP9bY0FSlTKF4aFFoLl/XKt9P8wX/NIbNZ085BH3nSxHYiXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119781;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2gccSn53ZnVOaSnvlcCJ2hrIOo8D4wPxNhxzB5nX8/8=;
	b=A6JhjRqWGvSmy2H46Q/Tw9IYPpXmTckXDmhirL0fon5w72VU1aqBz9Lbb9GXQArIRj4I
	 r6Mq99B1/W96SBL3QCEqNTucEJFlfl2rXVE3vLBq8UtHF18iBOwz/jtL2fgkyDjd4Bl3N
	 ubr+Fj2nXsauIxA0uYt/1n822SBT0JXGAEHFX3rcH3hU7anGrFh0/nez1APnKsEVNiPmT
	 QbIbNNj+AuWsdLrmPwbc1ufXqCu6KjUc8Q24+bwwPZBJQy53eF/f9P71H6ilsvRqwp/eW
	 /FCR1xNzGa8B/ynWzMndt+ixzyZ9NoKI3k//tX9gWr25+6zGjRnafczSTXrdVrmppLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=p9cl5sUr;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A8C6071A5B;
	Thu, 19 Nov 2026 20:23:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32A8C6071A5B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=p9cl5sUr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119780;
	bh=2gccSn53ZnVOaSnvlcCJ2hrIOo8D4wPxNhxzB5nX8/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9cl5sUrPT5hjg4nby6fWiqoQEuodlfYBeo1IpeAQYueGJpXYmVhDEXAV1yYgfICW
	 ss1oc8QMhHlMspiwgVwrTLAefsyb9MELRDT7yCzcd5vj6UJPQkB1TSsNQJVH4yUB8M
	 +jRRKp/YovgS5ENOAey1h+pjo7Nu8o9zwSYaCqmtRYA3fQJzL+Qsk4WRwxYZT0yg1p
	 UnX7MNNM/ZCJZVKxRE4crqXLvCAbnwqzCLg2D8ipjOmqT2zJse+uIBmNWNzH4tTJh1
	 yNAeX2lAUSA/1ErLuVycP7BidwCUlGfxwq3hhg01zByuyWDHVir8+zDd8W/Z9XyZe1
	 O3x4id3zETvYA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqfD2SXgzST6;
	Thu, 19 Nov 2026 15:23:00 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Waiman Long <longman@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	parri.andrea@gmail.com,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v8 16/33] sched/deadline: Keep the last CPU a task has in its root domain
Date: Thu, 19 Nov 2026 15:22:57 -0500
Message-Id: <20261119202257.419139-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <6e555ba3ad1013206d77ded129a127dadfd3b983.1795116791.git.mathieu.desnoyers@efficios.com>
References: <cover.1795116790.git.mathieu.desnoyers@efficios.com> <6e555ba3ad1013206d77ded129a127dadfd3b983.1795116791.git.mathieu.desnoyers@efficios.com>
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

Hi Waiman,

This patch refuses a CPU offline when a deadline task would leave the
root domain that counts its bandwidth. It also refuses an offline that
makes a partition invalid, when a deadline task in it would change root
domain. To decide, it predicts the new effective CPUs of each cpuset
after the offline.

We checked the prediction against the cpuset code, cgroup-v2.rst and
test_cpuset_prs.sh. This is what we rely on. Please tell us if a point
is wrong:

1. A cpuset that is not a valid partition root keeps the CPUs of its
   parent that its cpuset.cpus holds. If there are none, it takes all
   of the parent's CPUs. cpuset.cpus.exclusive plays no part.

2. A valid partition root that keeps a CPU of its own only loses the
   offline CPU. A child partition is made invalid only when its
   populated parent has no other CPU left. The parent then takes the
   CPUs of that child.

3. A populated partition that loses its last CPU is made invalid. It
   then follows rule 1 against its parent. This holds for a local and
   for a remote partition.

4. When the last CPU left to the top cpuset goes offline, every
   partition is made invalid.

5. Any hotplug event tries each invalid partition again, an offline
   too. So an offline can make a partition valid, when what blocked it
   went away earlier.

6. housekeeping_update() can run during an offline, as the changelog of
   a84097e625f2 says. We see no lock we could hold in the offline path.
   So we read HK_TYPE_DOMAIN under RCU and accept an old value.

We have one question.

7. At an offline, select_fallback_rq() runs before the cpuset update.
   cpuset_cpus_allowed_fallback() gives the task its cpuset.cpus, then
   the housekeeping CPUs follow. A deadline task could land in another
   root domain. The previous patch makes select_fallback_rq() give it
   the CPUs of its root domain instead. The task can then run outside
   its cpuset until the cpuset update sets its mask. The comment in
   cpuset_cpus_allowed_fallback() already allows a temporary mask of
   this kind. Is our case acceptable too? On cgroup v1, a task of the
   top cpuset keeps that mask, as it keeps the housekeeping mask today.

One note on cgroup v1. When a cpuset is left with no CPU, a work item
moves its tasks to an ancestor. We refuse the offline when that move
would take a deadline task to another root domain. The attach has its
own admission test. But if it fails, cgroup_transfer_tasks() stops, and
the other tasks stay in the empty cpuset. Tell us if you prefer to let
the attach decide.

Thanks,

Mathieu
