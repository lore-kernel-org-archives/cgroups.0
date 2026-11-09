Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242227;
	b=jMI4ttCgGLFrl6zN3zun4QYzJZIyW8X4vACRmUD4WXk2aKHz6Tv5i5FwNvCA0o11QPqh
	 wYO41qMWzTNIVOG2NFTOsEU3NwdDG8ZwrnKTkhEShwj/5z90Ty9DvdE/RC5kKPJF46gpR
	 GUwyOS83+tVmu5a53RJHA4zbO1VjVo6XWMZSQZEXh7YfNWCFMfCq4/qGguzjPE5P1qdSU
	 PRVl+J7o4stpTood5B8u65C3LZOvNPfDdUZU2/xfvEkogIFW0sIr/wBNKoIoZ++r6wiZl
	 A+OFm14LgTVNPtf1JI9+KMr2cD78E1ofvw/ZgoI4QRRz+mhN/LMlfDkuA80Mo1URBlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242227;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SVT/DX3Qx5QX3fT0D0XLtiWgc2jruHl1ZHUq3Xr2ZxI=;
	b=oqgLYSUK1o3I3QdYyIX5JpEDuX4dBJoeSNlT10EcXwk4zEjNARxQPaCSmivREvkxy9ne
	 5Xqh84pB4CzE6Sv+8JQU0N1y3dg+keAk7rCuMJIw90BMQweMEHC8o/QqCYS69nOzipi98
	 3XOVa2c67t3CfhAAI5t/sftW7hzz2Bycjr5AKX3sz/4Lbgq5LRDBoS5O3FCyP2bFCVggg
	 8k9TbLLFboMdZmBvw4tn+qFMohqDVxd2XT8DxmvqAyUxn5PeKgt0LW1fEufcyNyMTv+WV
	 73cw7NvHRw7Grpt8RVz4UVmjv9zJLUc8HYhGSCKcRbiiIHxwWbjbak+uceGr2k8fCgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="xxOrue/X";
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E97606AAE1
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:37:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40E97606AAE1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xxOrue/X
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4ac95761c85so7939185e9.2
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242226; x=1794847026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SVT/DX3Qx5QX3fT0D0XLtiWgc2jruHl1ZHUq3Xr2ZxI=;
        b=xxOrue/XIP1cGeO805QDUjvWXOZZWysl0pKv3DN4oINbshIQXMxXwBSSepbZjUGwrA
         Zs+jJkR2Ra8aTWBSjvSQFA55gJoZEFCmT0Z/IR6VWYhUF+gNenibQdk8HChejRXdbiiG
         tXRL+PCiAYFG9v7P/TYP8ubqCofLSe3Q5A22TieJuBUvDdx6nbBiegCfwSmztI+6irzR
         CVJiQlBAIw+LHUsNHfwgQPjPj0DTUz34bC1NC2e+rxS4IkVAzSVJD9WbmQEBhprsEm2/
         C+EnIaQ8Id1Z7xThhIl5T+vfjtYGmBH3U1GSVXgzXlGX0RkBT48dLxY9AvNmF12pbTqR
         SPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242226; x=1794847026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SVT/DX3Qx5QX3fT0D0XLtiWgc2jruHl1ZHUq3Xr2ZxI=;
        b=ayW1rWV5CvcP2P8mHffQ9D7yhchZBf/g89vNCrrUKW3SNwdfxqqraWrnscfXHp2xK3
         x7oox8XkCg2HWiNMhAvNKgN1zjnrKwS1pSXJSuntFtcA39glmII46VHo/zvGZ4qfpm+o
         90JT544homKyGfwwkEq75kttr2tEEDkWOolsLtk0KPP0h7Ruh/WGAGmrC4M8TlZNKXvw
         JKK9IG2oQeoDV535hbvT+Ep/wj5RtiWJewZQRIqDpzuwYykuyMgFOKoDJwgBsl0ZRnBa
         A+ECI4PzEJCIZ3ehZ3u9cdWgo6q4/u9eQEYxmUSmBIpDdcF/jDm2CiC8eE/l1gRY69eP
         O8aA==
X-Gm-Message-State: APuU4Z9TsZ7CJctC1VUsywhckjkPh7AoWyyI0Y4Uh152hz8WGnPJXnzL
	+iPAq5wNafNb3LlusYHYR6kS/yvfOVhZ4WOF1FGwIU8KEl/iL/47fp+2
X-Gm-Gg: AYBFou108w9wNydVASpa5uDiI4tXn3sdwSQql4puBT175MDw3jjMFO6EfqfRu4uNxRr
	PLfTKzxuSqJatdz2yHwQIui8mmBjcwVCfiBA2e0iqxsgk6gsoVSyKkYcUlmGquwhItahSVJLU4A
	M/XwsnFc+4CWnV8BKyYycxjagLx6Dly0s3ScD5oZJzvLNoAfJzKblzk17WNJ3JBi6bxBbx6kM7Q
	ZIxWhcXx7L+d8b1a8zkwBeU1678vSm+fpkLKfCAv4KYWyjTZmIPBg48R89+GkqQzNWKENEsL34l
	rT1EWhBxBYOvN4scxcKfyqSGN3mWHirEi6UZtWU360ycsMJNpqTvJ9Edl1HWCVIHcgOWGxOadYZ
	MNEoTWrippX3/XtsKcOZ0Byc25uXfk66Wj2bER55LXANfCG2fGrrojGuuxVBDwKy7Z+C957Rs+w
	thLa4q4L67sPKATqzI6BlCO8Q9v+zw+bvsSmr0Gb8u/1M1aiJxzE2T+qbTaZpM0grbM99f0DGC/
	3HRLC3WW7Pg00Vv8fdRCI5A+yYI/cD0fan1BBxlghnm/DSSxKnhOTI7eq1RPzbKOr8uWeedlY+K
	a6K3mxE9GbpeZgloHwU/soDYeQk=
X-Received: by 2002:a05:600c:8509:b0:4a1:a2c0:7b73 with SMTP id 5b1f17b1804b1-4b963c8da55mr78790525e9.30.1794242225594;
        Mon, 09 Nov 2026 08:37:05 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:37:04 -0800 (PST)
From: Yuri Andriaccio <yurand2000@gmail.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: [RFC PATCH v7 28/29] sched/rt: Prevent CPU offline operation on active rt-cgroups.
Date: Mon,  9 Nov 2026 17:36:14 +0100
Message-ID: <20261109163616.195264-29-yurand2000@gmail.com>
X-Mailer: git-send-email 2.56.0
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
Content-Transfer-Encoding: 8bit

Introduce tg_can_offline_cpu and prevent CPU offlining if any rt-cgroup has
requested bandwidth on the offlining core.

Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/core.c  |  3 +++
 kernel/sched/rt.c    | 27 +++++++++++++++++++++++++++
 kernel/sched/sched.h |  1 +
 3 files changed, 31 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 59bd9599c509..4321be11c6c7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8717,6 +8717,9 @@ int sched_cpu_deactivate(unsigned int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	int ret;

+	if (!tg_can_offline_cpu(cpu))
+		return -EBUSY;
+
 	ret = dl_bw_deactivate(cpu);

 	if (ret)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 37e4b24183ab..e5f05aeabd5c 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2853,6 +2853,33 @@ int cpuset_can_change(struct cgroup *cgroup) {
 	return 1;
 }

+static int __tg_can_offline_cpu(struct task_group *tg, void *data) {
+	const struct dl_bandwidth *dl_b;
+	int *d = data;
+	int cpu = *d;
+
+	if (tg == &root_task_group)
+		return 0;
+
+	guard(raw_spinlock_irq)(dl_bw_lock_of_tg(tg));
+	dl_b = dl_bandwidth_read(tg);
+	if (dl_b->dl_runtime == RUNTIME_INF)
+		return 0;
+
+	return cpumask_test_cpu(cpu, dl_b->active_mask);
+}
+
+int tg_can_offline_cpu(int cpu) {
+	if (!rt_group_sched_enabled())
+		return 1;
+
+	guard(rcu)();
+	if (walk_tg_tree(__tg_can_offline_cpu, tg_nop, &cpu))
+		return 0;
+
+	return 1;
+}
+
 int sched_rt_can_attach(struct task_group *tg)
 {
 	struct task_group *ctx;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9410d1909729..a6aae4375a31 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -590,6 +590,7 @@ extern int tg_rt_internal_bandwidth(struct task_group *tg, int cpu,
 				    u64 *rt_period_us, u64 *rt_runtime_us);
 extern int tg_set_rt_bandwidth(struct task_group *tg,
 			       u64 rt_period_us, u64 rt_runtime_us);
+extern int tg_can_offline_cpu(int cpu);
 extern int sched_rt_can_attach(struct task_group *tg);

 extern struct task_group *sched_create_group(struct task_group *parent);
--
2.56.0

