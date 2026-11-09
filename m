Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242200;
	b=Ll2iJRaMZB0Xr1ZQpcEp+3A8PWsjk4toj1q/nEq/ikZnIs4m7TLychPeYHGekaI5i4mR
	 //41a9o0tSgRu9pHFqSs8MtxL3aW8nTzaKQ14n9tiLA8N0LXfKv9/frkHYjdxKUbHoxYl
	 seNMWhIzyO6lKI1c6Pi2F19f+SqR8/WRkai6CKlnkJOm4+JvPYIwtAfCi05hJUBLJqa2c
	 Vj6nbVwUJZ4egkradgldWJNXQmRqLYdSqd4rJ53vX/2CpLTlyrQ8/O4sY0Q9GTypVilha
	 d2HhTAwGPuWoHmX2stP7cpbW0r8e15G0UTQg/gOddqupj6GqaD1+XOPZr2+hNo/xavg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242200;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Qc3dyiPx/W4X/rGPB8m5a/kBhaoScoqCV/wwR71LaO4=;
	b=CRfFqjUTfTQun64yL3zYfo0UVBa8Hf+OR4N+KF1gTeq2g08D5NZh6/cgbHoNwZWdRncP
	 Upf797IOpAF7eYy/3c1W9Kgn1S7PFicGD3499zFL/P43HRi6bpDSvrPE1XYqdUY+4AEZg
	 CX7d0LAtdMmVfasyIy53Xmgi4pJjeZnOkSNFQg1dT9/T6w+95yEx5pUCdxgXIdrQvZfsc
	 brlE/vE12/BtkhP5ohc9mpBXtWLb79Dct3c+p86c/csUnxJ2dHvHhkNw1cwMRSwWFxXF3
	 l5jXsyXjVso33z4RZLYtnXvqO/eb1zpxIQ4BqasakwE35RV1qmIMmMI6sTqgl7VhVng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m56waSXI;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8C5606EE9C
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D8C5606EE9C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m56waSXI
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so8731595e9.3
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242198; x=1794846998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qc3dyiPx/W4X/rGPB8m5a/kBhaoScoqCV/wwR71LaO4=;
        b=m56waSXIGbDoPCqa3EPTpb83A8+SHp7KEUmMvHW1ZtD2SteEhHHU7gDbyJzpQpVt2r
         o30K1n1EqiqougesSW8wvQ+mTEP72/V4OS3lImkQ7fnzRn+1g5Zb6zauhqyNdcizT48e
         jGYWtSzdHTDmk+Ql+zIcVGD7VX6/p/DwmnqT7E9MY8a6uVzfJ+Bs8LwdGX9jvL81vJtd
         d0pg6Rm/XBJeF9tw2Ebw3Ly8daRURKusVyrHlDQr5A0wGf3b9TrKyGLKgY2QJ5xnHlJ4
         EYCRq7EAq094BBs7qxacKSDkdaQ8F3PKb67kGnWGLiu0t0OyY8gZkbjLkXvlOZ9TJmcQ
         8tnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242198; x=1794846998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qc3dyiPx/W4X/rGPB8m5a/kBhaoScoqCV/wwR71LaO4=;
        b=U2CCsub/cT0/esCjbi0ge+GahkkD8vQMoFAAIEdTda/9D+AInKcZ1IJQ9VyLI9FOPE
         rtpD8j7HjVTEQqe9PaV0gIkNcCjhFeJEywLdE7IUFrMyx1G15EwM4C6xWqogAM6hTAI/
         nHvF6baKDenJ6e3REZZaDWFD99nMwd0piU+Q3XO7gSwmP5vhP528F1tCnhCr6CQCyJfe
         PVeG+WSVKYE5Dl+rVXF3pw31TKzZF9AkId0vqYVuh0pgds0XG+trNGSX7aV2uofflfXx
         cIDYi6oyY6EUlMu4Ghj2mJxPAHLyALQPC0O15GriQvDcOSow3wyW9FpmBHDuH9BdHnqE
         DRdQ==
X-Gm-Message-State: APuU4Z+CCDqSlO5uyT4XvQEicrBnhF/1pWcFih96YJDqHmM02KZwXru/
	oFpVNF0e0wy8VjbLQN2vVEhpzQrq4fODhWEVMYWV/dmenFWPufhT2RAA
X-Gm-Gg: AYBFou2hi5apYVgePplWJ3ZuMjJ2e+4A1rXNxcvSxMQscMtODbO/9Q2fcDlA5yFo3ac
	DQF9oV11kRRormhJk7FCYSLjnqL0koU4OWgsHTA+IpoAFGZ2tiqD9xzWLrW0z0FHXEkw7ab8Ioa
	kQ0nCsUMXVqZZKQk290RVJP6TrAX1QiCQQAmH+HSJR7aNHHmvi8Tcn0OdUeyhKsa2urmWP5zX3j
	tUqdRRY5mGBC+GqO42Oo4H7kcfyEalcatWMxuS3g4SbNSuqv5Jmid8LqnRCp/6shfxJva4c3mfo
	AL3hraYYJkdUMBt5DVnMBvz/fJUDRIhn8iQNkEndsuQR5sfRyNHdgQGLdSG/6yj2AGOY1Q71LER
	E3nI/HMVlQpN49N+525jLgd98r1klkECtr9VjTDdOcgb7JpbE0YB83RH4J9I9iqkEw7OAlN+zxn
	WilvguYIXJorOz3fi22YurDjt7MdhapZFKqoIxh5iy17Y0Y94l9pHCUk27e3ERIpK9rxuAMi3et
	xNZvVPL6YKtPDKsQ8CX1R7F8FIAtIGIiFGefjf/zZwo72QswWmpYIa8Fu6yssRv63N5KiOSTN6N
	1SmcngjQ8BDQ2BNKd7+6UJIy/J4=
X-Received: by 2002:a05:600c:3b04:b0:4a2:e0c:2b0a with SMTP id 5b1f17b1804b1-4b960e9a794mr86657665e9.16.1794242198055;
        Mon, 09 Nov 2026 08:36:38 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:37 -0800 (PST)
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
Subject: [RFC PATCH v7 10/29] sched/deadline: Add dl_init_tg
Date: Mon,  9 Nov 2026 17:35:56 +0100
Message-ID: <20261109163616.195264-11-yurand2000@gmail.com>
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

Add dl_init_tg to initialize and/or update a rt-cgroup dl_server and to
also account the allocated bandwidth. This function is currently unhooked
and will be later used to allocate bandwidth to rt-cgroups.

Add lock guard for raw_spin_rq_lock_irq for cleaner code.

Co-developed-by: Alessio Balsini <a.balsini@sssup.it>
Signed-off-by: Alessio Balsini <a.balsini@sssup.it>
Co-developed-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Co-developed-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
---
 kernel/sched/deadline.c | 31 +++++++++++++++++++++++++++++++
 kernel/sched/sched.h    |  1 +
 2 files changed, 32 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index aceeb28d4b2b..b6b5fcb15f43 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -335,6 +335,37 @@ void cancel_inactive_timer(struct sched_dl_entity *dl_se)
 	cancel_dl_timer(dl_se, &dl_se->inactive_timer);
 }
 
+#ifdef CONFIG_RT_GROUP_SCHED
+void dl_init_tg(struct sched_dl_entity *dl_se, u64 rt_runtime, u64 rt_period)
+{
+	struct rq *rq = container_of_const(dl_se->dl_rq, struct rq, dl);
+	int is_active;
+	u64 new_bw;
+
+	guard(rq_lock_irq)(rq);
+	is_active = dl_se->my_q->rt.rt_nr_running > 0;
+
+	update_rq_clock(rq);
+	dl_server_stop(dl_se);
+
+	new_bw = to_ratio(rt_period, rt_runtime);
+	dl_rq_change_utilization(rq, dl_se, new_bw);
+
+	dl_se->dl_runtime  = rt_runtime;
+	dl_se->dl_deadline = rt_period;
+	dl_se->dl_period   = rt_period;
+
+	dl_se->runtime = 0;
+	dl_se->deadline = 0;
+
+	dl_se->dl_bw = new_bw;
+	dl_se->dl_density = new_bw;
+
+	if (is_active)
+		dl_server_start(dl_se);
+}
+#endif
+
 static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 {
 	WARN_ON_ONCE(p->dl.flags & SCHED_FLAG_SUGOV);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e8a62b37a72d..b55ce13412d6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -425,6 +425,7 @@ extern void dl_server_init(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq,
 		    struct rq *served_rq,
 		    dl_server_pick_f pick_task);
 extern void sched_init_dl_servers(void);
+extern void dl_init_tg(struct sched_dl_entity *dl_se, u64 rt_runtime, u64 rt_period);
 
 extern void fair_server_init(struct rq *rq);
 extern void ext_server_init(struct rq *rq);
-- 
2.56.0

