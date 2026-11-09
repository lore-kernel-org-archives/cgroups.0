Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242213;
	b=D3Xzf6A99sLYyDIaTQK2o9XEoiGbU3yZXW0YNoi+A7Vh/AeJsZiKUTGn6EHAKatCMFda
	 TcnPFMowQoNvU5rPWG7xYzpmuYt9jJ1Wjk+trwTAGOK/Y4CnIqkiXakHtUTuBbLAXg3BG
	 vkKXXDSXitA5JHOc8r5PVWjI5eevgQHbeWBIJteXK9Dqb+tnak0wUzJuoTl/cVjYRzmVs
	 idTrIeO6nNsDj+OHb1/RZrEd9U7abr/abjHrm6xlR+WzNVeT1hWuGr1NHKu5TAB5U44F0
	 +qiplIFhnGPnpJisJ/n0OdqMkgjog4JDHAm1C0kg+30AXNZA5SOFdwgzIyTPf3AFkOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242213;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Y66CCqvB5g3qvi4M73+bXbiz/isEgzbHoHJvrAP9QsA=;
	b=bv4XLoXzC1W53LElZdgSOhY6h5CNc1gXlqIRWv/mdwGwXk2bf3wASeHqhJrm3bo3BD8p
	 EgX6OcHuKXQPsxBdX82HjbrduoC+m1v1s4Xyg3BSNzbYS6wUUFVQ+RQYXAx6y3cCqzj3O
	 zCj4Jn0GkL/Lh6Tp3dB4rq6ASrBdmY5LtKFuPy07FO6NUuceQv63P4uzi9PAww9ij9EeB
	 guQ7V+bBjDE2iC0k/R30m/Ty/9EpLM0o/Q/uIg0qGaWodgovUy4zQpgjjgIKxd/FHo/bn
	 2Stei20RyG6ZAz5eIdX0bjjiywPIWTP7E0XO6gUNOQ6g9P6tdh5kA2WdOzgeXFyumQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wEK460oy;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67CE606EE8C
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C67CE606EE8C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wEK460oy
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so9990615e9.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242211; x=1794847011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y66CCqvB5g3qvi4M73+bXbiz/isEgzbHoHJvrAP9QsA=;
        b=wEK460oyk5c/dCIonaDnWJVNXVDWPuPFmPt+5HCrz88sjJsIw0xBH9F3sSbftuow4d
         RoAJVt0qPS5PG5nuzcC+l1045LT9s2/K5q8vLjFcL6aMLoRxm9Wpn7haAKXyxewmN28B
         vRD3njt3DtwqRdcj32u+rBylQNWIHpJRaF7/sXbDkwkOoTSnL2acux/t6wvflR7G1tpk
         tXS4SgMVtnJTL5E5Nfc2OlvvxxRxxqQVA53tuRHEgfHAomSjW/l/O2alReKAlfh8fBMH
         Cue1thjp740s8UcVh7V6KA4SPX3gwPKHQD0U4PZpgiGdb80d/wuuc40dZI9DubsKCdbr
         uUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242211; x=1794847011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y66CCqvB5g3qvi4M73+bXbiz/isEgzbHoHJvrAP9QsA=;
        b=QJsqj1ffr161rlmJfW9vPz6p/b4wxJHD0ND9diDIzdzZ1lQipgUMIWo+NFcKO32VLr
         yo/ePOnxQgm5q0s7OwbSUlKueuhSpIBtlPtlSzBAtDQVN59NJ5j0fXwz2Cj/+yDnF8s4
         DgLUsmsP7UeCa0mxPNWNV1bRTR1yYiq2pICCKqRFXgDOO4OGCYlaR2OO0qcZmrnmdDhU
         ZYVAqfOcqaOPAiZ+JDyZhgGC8iGQmL2+k1ALS7PGPTCgakOIUyjU0Xfl4zhEh12YEjT6
         Vrgt7+c3tbXLzhNp4BzGOknM8G1bWfzhxy1o3LaCILirTnnXH5txbmSN7hXXjc4ZOShO
         VB7Q==
X-Gm-Message-State: APuU4Z+TrocQzJ9CZVuU/pHNWko5C8eJPJXF77Qoiu48FS9rO9cCuv1i
	yVBhv9Rc7q9hNlE/XMXnwUTjW16gvWifZLkEUdMqhVwGzHiG2AB174YN
X-Gm-Gg: AYBFou2CoJaZVftkAReg+JCVUONlX3fpqYYflgo71Rg+EiqvX+CmPeg1mqguajRXml9
	FhJPm64fA2AEZhDmSk2Ov4TAMkmnOT5BLuc2WBMNJ0uTIhh4H70V+sHbgXzPT8YsAmc9xjfVyx4
	T012Fd7kwoM/epMZXb+qW7+atqSGi/SkPK+QMRPliI4I0hsFdG+KdD2JwPXOryNNG/F34ZYP/Ck
	H+9FTOO4bEuA0w3k68ak9YJ/2BtiI37hf56fRRjJyBZFps105/YSLN9tC+sl+h1gdUKGZ10MqwB
	G2E3qcQpq1iySTbFlJhdfC+WbDlJJRdBYgJ3zslUg64TkxQQa78AR59q8IpAXwvlAPzcxNAz1PB
	8vG3jqgZR1b0G6Zi24/cANyReoL1SPJAM+ncBQMkWuylFX3zCZ/ELgU5OGKHRAX2pcbovCH8KgC
	okRlP4JXb1dv/EuGcUx/kTweejWczOn8Mef6ANFb0japC0aaHAGAG55MumH9ScWbcOoKluMQU2e
	ZFR1ngpsHwMArA9Jja6YX0bjxfEQhyIfSv66IrFvHhq0cao4bFObTq5LGP/X6sbb+tr8zdHexks
	t96rO0IW7zP2WHrwF0W/jthzNw==
X-Received: by 2002:a05:600c:6089:b0:4a3:59c9:a743 with SMTP id 5b1f17b1804b1-4b963c81459mr76059785e9.27.1794242211238;
        Mon, 09 Nov 2026 08:36:51 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:50 -0800 (PST)
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
Subject: [RFC PATCH v7 17/29] sched/rt: Update task's RT runqueue when switching scheduling class
Date: Mon,  9 Nov 2026 17:36:03 +0100
Message-ID: <20261109163616.195264-18-yurand2000@gmail.com>
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

Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/rt.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index cf756639d9e8..b16cc77d7015 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1926,6 +1926,27 @@ void __init init_sched_rt_class(void)
 	}
 }

+#ifdef CONFIG_RT_GROUP_SCHED
+static void switching_to_rt(struct rq *rq, struct task_struct *p)
+{
+	struct task_group *tg = p->sched_task_group;
+	int cpu = rq->cpu;
+
+	if (!rt_group_sched_enabled())
+		return;
+
+	if (tg == &root_task_group) {
+		p->rt.rt_rq = root_task_group.rt_rq[cpu];
+		return;
+	}
+
+	guard(raw_spinlock_irqsave)(dl_bw_lock_of_tg(tg));
+	p->rt.rt_rq = dl_bandwidth_read(tg)->active_context->rt_rq[cpu];
+}
+#else
+static void switching_to_rt(struct rq *rq, struct task_struct *p) {}
+#endif
+
 /*
  * When switching a task to RT, we may overload the runqueue
  * with RT tasks. In this case we try to push them off to
@@ -2127,6 +2148,7 @@ DEFINE_SCHED_CLASS(rt) = {

 	.get_rr_interval	= get_rr_interval_rt,

+	.switching_to		= switching_to_rt,
 	.switched_to		= switched_to_rt,
 	.prio_changed		= prio_changed_rt,

--
2.56.0

