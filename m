Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242218;
	b=N6keOGel9+ruaIljzUrJo2bm56gITVHHrGJ4eCuFVs4fenoOsrLokVtDlg7HACevyKSd
	 HalhjdISFTrQWtiG8rgn+S4hyBnFEFr/EtLfsvHbmntzOXH6PscuHe2IBmis5cKla16ss
	 v4M862zywNbXv3iof9dm+5HKfEmhPdjNpXP5FIYFqHXitQEGMUC3wUcwD1S/ELKN9nh0o
	 oH7VTmBOyb7QMl+wtlv0rAkf+IQ5trJGuSnQYamdlo9TEFMge3N1c7RFRSHNCqlzpzxsL
	 BrIrOaDGtb2Xy6u18ofz+r3T/yxdVSUgN0QNfw/FmbDF7uBWKK7ovJYg1uk9kPZJ4Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242218;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JkuHji0LxV8o1YCavB2wvroDiJ+Z9D9qJuz9cWiV9zA=;
	b=3/YiKPTzwMF2+hOPnXaN4FMQ4k9lIj8AMmgD+/XEFyhDfoJgpZLW6DoDLJATc7BBrdzU
	 WQEdRtzv5va454eih3PpBxHzNflF6db7+hsBHvZcObIFdGaaEjcfRHvU9ySuirLmSWhqd
	 uJwb8JtJj3ia+LYJ7exVs9dfw2ttafWUPZI5h/UxgtKxWFWzd8gppeGCdkNmTCvSkyFWG
	 mfXSrQut0Oy/IwZC6T5EaeUG0ztGzITraK+/6f46zlowNhu/b1sTaR0AqS8EJ5j95ii/4
	 3mQmGnkNoF0L4UqOe9EKTicli0ebRD187++mEz+htblPii796NZJGRSJledijGd1ZgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="YNk93/zZ";
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6357607366B
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6357607366B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YNk93/zZ
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4b467581b98so10379355e9.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242216; x=1794847016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JkuHji0LxV8o1YCavB2wvroDiJ+Z9D9qJuz9cWiV9zA=;
        b=YNk93/zZWqug2MBqv13SfAgg2UaDn/0LAwCs+uPx/KZFYJxtqU7WbZs8tZdQ5uCxIb
         tEbYj4t5KbH7CacIcVoyofLsXVPsoq3SDmxvZeen0JCIcPXeKYfQnbZRAOkW+ITIryWf
         liRqHwB3cBZ2dgCcUR37re+0pyNtBjmyc408mjvojkO3qVDRLLVirk0F4Vf7Rj4k51G/
         1KFTuaTMBWsIXR/zeAGt9uRLPbIzVuxMu9XQz8xbRYO6T4K8SodzI/ls1tALpSaGHKOx
         OtF44VccFuOEwJS7H8CWuanrUTVuVh400S2RVzjueErlkRfAppoou1NJXm8nMBMwzE5x
         PLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242216; x=1794847016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JkuHji0LxV8o1YCavB2wvroDiJ+Z9D9qJuz9cWiV9zA=;
        b=tgQpaANhESEb2lm16mpLX6byD4icK4UGxk32XUCRBsEjCTpGAAIYlm+ejvvS5A+lri
         XKGuFpiNSlODIvMivVtKAtKyiVSKBZD4TLluCiFPaG/wrqYpDqYlgC8PCGakENQzoF3J
         LOrFfh5jvRzatKBROXoDsUF+QSp+4bozacbSiVSU81ekmkgTCU3wOqi0XgRqRiHYxO0Q
         G9O+SC6ufdWPhjyFyGYBuhKhexxAJKJEyemaSy5HU6UZjtxUN+Yb8+NNWPIcvW7WsLBQ
         WflSFaLxT4NIep1AXzVPW9QXpr2BuzpYvoClXmtUwm3fL9IoWYxkznrO48RoKHJX61o9
         cg5Q==
X-Gm-Message-State: APuU4Z89mFQyLmG1Bg4fwNrSlH6Eg1fa6fPkweSdoVEjh1loiv6L2oSZ
	fzN8pUIFn1Lgos8Elf1bRxHtcq6tTCgFjnoVI02vFRyHg/1DlwH/VnUL
X-Gm-Gg: AYBFou1zaDTkvu2Tbka73QbHwuLhlerrVJcciGIq/Av07dTQmyhVAGHQZCbtdxc0LpU
	Z0UJZbtXq+dW7rW8RgqgRBU9jxeunew55PPYGgCwSvWxkk7qElB6Jcf3gJbX8LMU3N3McsFZXz5
	bzVXA6GqP8k8cHZjzQfgTl/dKuPoHbs7JcyBLy0ysCd0imx+BtMl7F9Ho4ZT3xtFXppmhR/0NYP
	WEyjSKW9SqiPHKkoOnmmwwfOIA1Mt81lslOSil6zjogoihxFKKZDR/bxiziAORjdTixnRiMAkIi
	vJAPw2TFRdLMzf/AXiuWuKM8wj5D9gabnST93YmvjGfuHUqR9RH5r9rXn4q4LtktzxzDoL2XLbb
	p68dkByV20m7FbWRc43OhQYln7L0WaWaEj5B81D9K2vF8RlQcm5VYleh/ufHm1sAobX8kRgMLnr
	xZyKztXP4v1yB4p7GsCVPAaU7b6i8p98r+GoS2kenMf/dlNZs0ljc2k9ACp1wbAmrOkVwp4qrtD
	+dF3GvN9VstLd0q+Hh4/gqgl5ogIiRGtl35CR/0p4U9y4SNCJdVdAjGJSDqiC4Wtrhe8pTIy9Pu
	FhdEyOU/2NHvJn94vqkaR9atJ56XszEGEETmHYnoh7oZ5r8=
X-Received: by 2002:a05:600c:3d96:b0:49f:fd40:80fa with SMTP id 5b1f17b1804b1-4b963c8a047mr84071075e9.34.1794242216364;
        Mon, 09 Nov 2026 08:36:56 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:55 -0800 (PST)
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
Subject: [RFC PATCH v7 21/29] sched/core: Execute enqueued balance callbacks when changing allowed CPUs
Date: Mon,  9 Nov 2026 17:36:07 +0100
Message-ID: <20261109163616.195264-22-yurand2000@gmail.com>
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

From: luca abeni <luca.abeni@santannapisa.it>

Execute balancing callbacks when setting the affinity of a task, since
the HCBS scheduler may request balancing of throttled dl_servers to fully
utilize the server's bandwidth.

Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 62039972ded6..aef019cef859 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3019,6 +3019,7 @@ static int affine_move_task(struct rq *rq, struct task_struct *p, struct rq_flag
 	if (cpumask_test_cpu(task_cpu(p), &p->cpus_mask) ||
 	    (task_current_donor(rq, p) && !task_current(rq, p))) {
 		struct task_struct *push_task = NULL;
+		struct balance_callback *head;

 		if ((flags & SCA_MIGRATE_ENABLE) &&
 		    (p->migration_flags & MDF_PUSH) && !rq->push_busy) {
@@ -3037,11 +3038,13 @@ static int affine_move_task(struct rq *rq, struct task_struct *p, struct rq_flag
 		}

 		preempt_disable();
+		head = splice_balance_callbacks(rq);
 		task_rq_unlock(rq, p, rf);
 		if (push_task) {
 			stop_one_cpu_nowait(rq->cpu, push_cpu_stop,
 					    p, &rq->push_work);
 		}
+		balance_callbacks(rq, head);
 		preempt_enable();

 		if (complete)
@@ -3096,6 +3099,8 @@ static int affine_move_task(struct rq *rq, struct task_struct *p, struct rq_flag
 	}

 	if (task_on_cpu(rq, p) || READ_ONCE(p->__state) == TASK_WAKING) {
+		struct balance_callback *head;
+
 		/*
 		 * MIGRATE_ENABLE gets here because 'p == current', but for
 		 * anything else we cannot do is_migration_disabled(), punt
@@ -3109,16 +3114,19 @@ static int affine_move_task(struct rq *rq, struct task_struct *p, struct rq_flag
 			p->migration_flags &= ~MDF_PUSH;

 		preempt_disable();
+		head = splice_balance_callbacks(rq);
 		task_rq_unlock(rq, p, rf);
 		if (!stop_pending) {
 			stop_one_cpu_nowait(cpu_of(rq), migration_cpu_stop,
 					    &pending->arg, &pending->stop_work);
 		}
+		balance_callbacks(rq, head);
 		preempt_enable();

 		if (flags & SCA_MIGRATE_ENABLE)
 			return 0;
 	} else {
+		struct balance_callback *head;

 		if (!is_migration_disabled(p)) {
 			if (task_on_rq_queued(p))
@@ -3129,7 +3137,12 @@ static int affine_move_task(struct rq *rq, struct task_struct *p, struct rq_flag
 				complete = true;
 			}
 		}
+
+		preempt_disable();
+		head = splice_balance_callbacks(rq);
 		task_rq_unlock(rq, p, rf);
+		balance_callbacks(rq, head);
+		preempt_enable();

 		if (complete)
 			complete_all(&pending->done);
--
2.56.0

