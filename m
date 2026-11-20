Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207365;
	b=DEL1KrQyCfLcRLZNTFiXnXQ+62uQ5rTKL6afmFiE2erAFtXOP7vFWHkoJ9MVFkcMDedg
	 tMpDlxBs4TY/hp4JEW9BAm1EezfdKLq68PBuikkNrhIlhAefJd0yG36T/3xncnHJO9NEt
	 Tkt17/XEzPKWSZyHIMyuuFnS2JV5/h0R2WHzkViRC/ZeBORMoK8XnGg+yjGA/fgQzZwnJ
	 bJkSe0jpTwYbmL704aJpScnKssI30wSI7tcH0nDe3uXDjEiZq/JtmqMVLSDBagPm5QWWc
	 uhtP8SG5MvtJQT6rhaQtmHqlEXzviUfvuW7za/XDSYUOtFxfdYEcA8c4syLsUnxUurw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207365;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9AnaBVPIq4AA2q6FroCbl6i3U4jWzCtInRBCW4UFMMY=;
	b=ySdxMP8fVkNSEEHwUcD16KJ7/YpaKV2jRYKx6nAUI2qcoxVDm384f0/hY6Z17XP2XCYs
	 9+kiKIpHd3669C9ItSl3229iTvtE6GQQ/NQ6VhIZtmCL7zqxlDpu6BL1GOMbeFMiKojaD
	 a+rHw2RalPnuDfO2fYwTkiotBFwsQdIKOyg/LYgctzFVVILeOcaiqLQIHJBy+THWKqS1v
	 UPRm1Mua7+ZGyl76xsqPLaET/PHSI9ZwH3/e0xOd/MUS9oqNjxjYfnA2Y2Y8aCEYAWJJL
	 hSGBfCJ9k4+FloGbmh5cqJfaDnTfL3qqlOfS2lx2yLkFD9Ks2rUrTPl5whn07RtyoOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=JbcNqQwQ;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD061606A6FF;
	Fri, 20 Nov 2026 20:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD061606A6FF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=JbcNqQwQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207355;
	bh=9AnaBVPIq4AA2q6FroCbl6i3U4jWzCtInRBCW4UFMMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbcNqQwQBfVbeLY96iBcdJcEIkAmLrAbeucq8ERM48cnLHnV2LBo0itpZ1KQH8Mnh
	 xF6hR6mrVOQYschTmNTHl4x7ohEuToFUNZ0IXP4MZymtBzF7J5RonHN1qHetsk1c2Z
	 Lp5PeC+hJHN6ZbS2VChq6p/Eqy7NnfD2bTXiwyYjy7xdNlA85crcEPpVUwtnFVmOqc
	 7DX2eN7/XcsZhixiYoSCXdWR8XsrKE+K5Q2xcd4DV0PT26Kn7+kpLfonK5MkXjCz3y
	 yrV8nKUjWNft0RGnFnuYctf29nJefAx3R7vexuPtiJsqKoya7vyTN7j0xC2gSsdf3b
	 F4iz6fN5Vv29g==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2M2vGwzTqX;
	Fri, 20 Nov 2026 15:42:35 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	longman@redhat.com,
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
Subject: [PATCH v10 19/40] sched/deadline: Count only active CPUs when spreading extra_bw
Date: Fri, 20 Nov 2026 15:41:56 -0500
Message-Id: <8d6cd989bdb5d1ed564e0a40c17056e3072d727d.1795207232.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
References: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
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

__dl_add() and __dl_sub() change the total_bw of a root domain. They
also spread the change over the extra_bw of its CPUs, which GRUB uses
for SCHED_FLAG_RECLAIM tasks. __dl_update() changes only the active
CPUs, so the cpus argument must count those. Most callers pass
dl_bw_cpus(), which does.

dl_task_offline_migration() and dl_add_task_root_domain() pass
cpumask_weight(rd->span) instead. That also counts the inactive CPUs of
the span. A span holds one while that CPU goes offline, which is when
dl_task_offline_migration() runs. Each active CPU then gets a smaller
share of the change than it should. A later change made with
dl_bw_cpus() does not undo it exactly. extra_bw stays off until the
next rebuild of the root domains resets it. SCHED_FLAG_RECLAIM tasks
would reclaim a little more or less than their share meanwhile. This
was found by reading.

Fix this by passing dl_bw_cpus() of the CPU whose root domain changes.

Fixes: 59d06cea1198 ("sched/deadline: Fix bandwidth accounting at all levels after offline migration")
Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d8a912ea13d1..9faaaf665459 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1070,7 +1070,7 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 			dl_b = &src_rq->rd->dl_bw;
 			raw_spin_lock(&dl_b->lock);
 			__dl_sub(dl_b, p->dl.dl_bw,
-				 cpumask_weight(src_rq->rd->span));
+				 dl_bw_cpus(cpu_of(src_rq)));
 			raw_spin_unlock(&dl_b->lock);
 		}
 		/*
@@ -1082,7 +1082,7 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 		dl_b = &later_rq->rd->dl_bw;
 		raw_spin_lock(&dl_b->lock);
 		__dl_add(dl_b, p->dl.dl_bw,
-			 cpumask_weight(later_rq->rd->span));
+			 dl_bw_cpus(cpu_of(later_rq)));
 		raw_spin_unlock(&dl_b->lock);
 		dl_record_bw_cpu(&p->dl, later_rq->cpu);
 		p->dl.dl_bw_gen = dl_bw_gen;
@@ -4357,7 +4357,7 @@ void dl_add_task_root_domain(struct task_struct *p)
 	dl_b = &rq->rd->dl_bw;
 
 	raw_spin_lock(&dl_b->lock);
-	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(rq->rd->span));
+	__dl_add(dl_b, p->dl.dl_bw, dl_bw_cpus(cpu));
 	raw_spin_unlock(&dl_b->lock);
 	dl_record_bw_cpu(&p->dl, cpu);
 	p->dl.dl_bw_gen = dl_bw_gen;
-- 
2.47.3

