Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242201;
	b=oa1PEwgTFOraCkKa4a8SxIQELIuXawwtEVWcMkw1HoWL5RY951bKxwOl5iOBUeq8/Vge
	 oZJqelIaEaBvjtxzkV+6Dk2e2XYU1zl1LN6aQgIMT/rWnZUWxv09UoF5i8rEhTjx1Pgm/
	 EY8NwpaqUojxuO62rFYhWreKfbYSuBhUBrFg/Lu27utfm960UF6A4hS2394iQe+LyU0k5
	 cTMEI8VoNiAH38/fBO5OoHGhXrZwXGTs2KTLkOr8kCXt5f9ySKSABdrytybnyUAgnk0ZS
	 EdKjTkwERXx5ngTBLVZaRn5e96h0zooSt201yH6ATtxSNvZOPzwT8+XBhjo1J7MrS9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242201;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ErQf4cPvfS+1Yq71iFQrR+o0j0UZEjto9pKX8GV+5D0=;
	b=QYffe7LXvhtOlkh607s8WKP4CA1bTMAV0clJa7QIHFpoqwQMxMbxq4xHKI+VD7W3Sdwn
	 83EceVY284DsUCEFn/gkwS7d92LW7eIlZrGHaojnGxhS/NXQTBdPJ0A4RLbgkmUqSLyin
	 Xk0M6tNhnsdJz45QDNBFPEDnl/DMFRamlROiB5zeDNEE/H3HItVjyn4Vucv7X7mu92aMG
	 Y+FBsuPl+FG21nEtlOoankhD/h3aU2H3qqDvFy7pT4VFEJiQjiK9C/UOJ3nyMDuqJdJjo
	 rlIhNKV20W9J7sCEkYeTp5v4WamrxlN6TZeeMSjLcyw9yhUWpwkWzUpF8jVBWG8OZRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cVtAEvv3;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2034760A3816
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2034760A3816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cVtAEvv3
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so8731925e9.3
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242199; x=1794846999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ErQf4cPvfS+1Yq71iFQrR+o0j0UZEjto9pKX8GV+5D0=;
        b=cVtAEvv3EHpbPbOgoAn0iP3dC/fR+li4Mk815i0Xcwl0TvlkhEI1cziWW6UfhAUiYu
         X+o2MTtnGFZTCGJel3c5h0er53GeSp2PVvDzsAOI8Fo/KoH5Yz0nECwOm1BffNkwgwtf
         LyQCIf4Z3LPpwmbOap32xxqebFiDe+QpTsBJivBguqQbCVQjfwVdsRKCV1/hiAUVid1x
         n6rqqKi4yOeawOzAnF/4J8Ig7e27nexZjUiTBBODtRWzkJSYD4Vk/TK8hphqPPnoz/zE
         Ac9Cz15eW38QkpzlaXvSEIKkOeBXmx8Fe/ghGuLgdUXwRGIqCebYdaTAo93DuAN7x3iP
         Dwjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242199; x=1794846999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ErQf4cPvfS+1Yq71iFQrR+o0j0UZEjto9pKX8GV+5D0=;
        b=FirJ422GJo+k647i9+yvhoUGv2+BlTDTcNm+rLj2AuNFpaz8IgcPuafAEt6RWGyjhL
         XMq7AV46VQ37GNf6zdg6FG2tnnVavc7cWDG7RAUL5HFp5iN7S9sdqy2cJ7kuARl7g9hV
         NSch+c8MZ0X9joHJ1kDtMnJeypX7phduRCDTt/+qA8GwnfOf5PgIg6Uy4T0YdpZ2hAmL
         3CDTQK5wYyraCQnTtZN6jS+/hCS8d/0dyLNzEMbcGiodqUv53cQuyu9ZoFWe3WlaMVhh
         IPIKVXNeaZ4lxeu6GpapXEktqqjV/llQcOwUtVIX01PvikIk47XuWmCfGFA2iAZWryHp
         qrRg==
X-Gm-Message-State: APuU4Z/zzOiVm8zEPjxygqY4XoShypoVNa/G2Aob/bJEN9gx/uZMxG3s
	wDwW1DlsdGvu050kzFYaQWUQZ4/SLj1HeGdvRqrilKfZNeBJus3SAqPe
X-Gm-Gg: AYBFou0TzSzFAxcjz92OXVCpxr+RQItevyndWr3YD+W+tNPAiF9XKGzTdtJI0nGR9Uj
	h8G1z6asqVcyk7el3X7r4rMQovI4bynyeamea459actDul321m3cOcSrc6/OsvAesLNUNdxKIY7
	z69rNQgpxQS/zZfZ3wxRM5YeVvvMm4WpL824DvbkVbfS5DDr+tJQ2W/6PYlRL3B67rPqMZ4dkkr
	GRiiDHLgkXUEpIoWYevGiDsNDjEZvXPPTZe7tjO/SqrtThSrq6lh27BkJmmdCtJLwRI7NiZJC3/
	pJuj1JBv/2h0aiuAAtBwHZ7w2ctOLnKT8pM+0N/4zEWDgpvtjy9waQmRGerEdEuw+EMzqZdhTJy
	1XJGFHbTF9oz1Ls5g827iSfhw6USRvGS+yufVWdREKhY0jwf1CuWu1g53WlituqQ/Qk3v+Afxft
	EKGD42VdcEyKQz2oVyon5Tqo1UeeXh2yGBv6FmvNGsvcWprGMfgoB1KIRrFs6vFTegYyLGSJJP0
	SS2aY8/uufkGM8F5JSQgTNE80lY0OBf+O1hytxO66kvUYrnNQSQSlMtouoNnu6/WUVFQz0nPnBt
	uDSZMWeUKY8oURM/rxfPWkurvIr+SabTx8HTBB4HEG5M7kg=
X-Received: by 2002:a05:600c:3107:b0:4b6:540d:6317 with SMTP id 5b1f17b1804b1-4b960da5deamr87546205e9.12.1794242199350;
        Mon, 09 Nov 2026 08:36:39 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:38 -0800 (PST)
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
Subject: [RFC PATCH v7 11/29] sched/rt: Add {alloc/unregister/free}_rt_sched_group
Date: Mon,  9 Nov 2026 17:35:57 +0100
Message-ID: <20261109163616.195264-12-yurand2000@gmail.com>
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

Add allocation and deallocation code for rt-cgroups.

Declare dl_server specific functions (only skeleton, but no
implementation yet), needed by the deadline servers to be called when
trying to schedule.

Initialize a cgroup's active context to that of its parent.

Co-developed-by: Alessio Balsini <a.balsini@sssup.it>
Signed-off-by: Alessio Balsini <a.balsini@sssup.it>
Co-developed-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Co-developed-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/rt.c | 156 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 154 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 3ca932ddcf75..e6f018db7579 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -120,24 +120,176 @@ struct dl_bandwidth *dl_bandwidth_write(struct task_group *tg)

 void unregister_rt_sched_group(struct task_group *tg)
 {
+	int i;
+
+	if (!rt_group_sched_enabled())
+		return;
+
+	if (!tg->dl_se || !tg->rt_rq)
+		return;

+	for_each_possible_cpu(i) {
+		if (!tg->dl_se[i] || !tg->rt_rq[i])
+			continue;
+
+		if (tg->dl_se[i]->dl_runtime)
+			dl_init_tg(tg->dl_se[i], 0, tg->dl_se[i]->dl_period);
+	}
 }

 void free_rt_sched_group(struct task_group *tg)
 {
+	int i;
+
 	if (!rt_group_sched_enabled())
 		return;
+
+	if (!tg->dl_se || !tg->rt_rq)
+		return;
+
+	for_each_possible_cpu(i) {
+		if (!tg->dl_se[i] || !tg->rt_rq[i])
+			continue;
+
+		/*
+		 * Shutdown the dl_server and free it
+		 *
+		 * Since the dl timer is going to be cancelled,
+		 * we risk to never decrease the running bw...
+		 * Fix this issue by changing the group runtime
+		 * to 0 immediately before freeing it.
+		 */
+		if (tg->dl_se[i]->dl_runtime)
+			dl_init_tg(tg->dl_se[i], 0, tg->dl_se[i]->dl_period);
+
+		hrtimer_cancel(&tg->dl_se[i]->dl_timer);
+		hrtimer_cancel(&tg->dl_se[i]->inactive_timer);
+		kfree(tg->dl_se[i]);
+
+		/* Free the local per-cpu runqueue */
+		kfree(rq_of_rt_rq(tg->rt_rq[i]));
+	}
+
+	kfree(tg->rt_rq);
+	kfree(tg->dl_se);
 }

+static inline void __rt_rq_free(struct rt_rq **rt_rq)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		if (rt_rq[i])
+			kfree(rq_of_rt_rq(rt_rq[i]));
+	}
+
+	kfree(rt_rq);
+}
+
+DEFINE_FREE(rt_rq_free, struct rt_rq **, if (_T) __rt_rq_free(_T))
+
+static inline void __dl_se_free(struct sched_dl_entity **dl_se)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		kfree(dl_se[i]);
+	}
+
+	kfree(dl_se);
+}
+
+DEFINE_FREE(dl_se_free, struct sched_dl_entity **, if (_T) __dl_se_free(_T))
+
+static int __alloc_rt_sched_group_data(struct task_group *tg) {
+	/* Instantiate automatic cleanup in event of kalloc fail */
+	struct rt_rq **tg_rt_rq __free(rt_rq_free) = NULL;
+	struct sched_dl_entity **tg_dl_se __free(dl_se_free) = NULL;
+	struct sched_dl_entity *dl_se __free(kfree) = NULL;
+	struct rq *s_rq __free(kfree) = NULL;
+	int i;
+
+	tg_rt_rq = kcalloc(nr_cpu_ids, sizeof(struct rt_rq *), GFP_KERNEL);
+	if (!tg_rt_rq)
+		return 0;
+
+	tg_dl_se = kcalloc(nr_cpu_ids,
+			   sizeof(struct sched_dl_entity *), GFP_KERNEL);
+	if (!tg_dl_se)
+		return 0;
+
+	for_each_possible_cpu(i) {
+		s_rq = kzalloc_node(sizeof(struct rq),
+				    GFP_KERNEL, cpu_to_node(i));
+		if (!s_rq)
+			return 0;
+
+		dl_se = kzalloc_node(sizeof(struct sched_dl_entity),
+				     GFP_KERNEL, cpu_to_node(i));
+		if (!dl_se)
+			return 0;
+
+		tg_rt_rq[i] = &no_free_ptr(s_rq)->rt;
+		tg_dl_se[i] = no_free_ptr(dl_se);
+	}
+
+	tg->rt_rq = no_free_ptr(tg_rt_rq);
+	tg->dl_se = no_free_ptr(tg_dl_se);
+
+	return 1;
+}
+
+static struct task_struct *rt_server_pick(struct sched_dl_entity *dl_se, struct rq_flags *rf);
+
 int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
+	struct sched_dl_entity *dl_se;
+	struct rq *s_rq;
+	int i;
+
 	if (!rt_group_sched_enabled())
 		return 1;

+	/* Allocate all necessary resources beforehand */
+	if (!__alloc_rt_sched_group_data(tg))
+		return 0;
+
+	/* Initialize the allocated resources now. */
+	scoped_guard(raw_spinlock_irq, dl_bw_lock_of_tg(parent)) {
+		init_dl_bandwidth(&tg->dl_bandwidth, 0, RUNTIME_INF,
+				  dl_bandwidth_read(parent)->active_context);
+	}
+
+	for_each_possible_cpu(i) {
+		s_rq = rq_of_rt_rq(tg->rt_rq[i]);
+		dl_se = tg->dl_se[i];
+
+		init_rt_rq(&s_rq->rt);
+		s_rq->cpu = i;
+		s_rq->rt.tg = tg;
+
+		init_dl_entity(dl_se);
+		dl_se->dl_runtime = 0;
+		dl_se->dl_deadline = 0;
+		dl_se->dl_period = 0;
+		dl_se->runtime = 0;
+		dl_se->deadline = 0;
+		dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
+		dl_se->dl_density = to_ratio(dl_se->dl_deadline, dl_se->dl_runtime);
+		dl_se->dl_server = 1;
+		dl_se->dl_bw_attached = 1;
+		dl_server_init(dl_se, &cpu_rq(i)->dl, s_rq, rt_server_pick);
+	}
+
 	return 1;
 }

-#else /* !CONFIG_RT_GROUP_SCHED: */
+static struct task_struct *rt_server_pick(struct sched_dl_entity *dl_se, struct rq_flags *rf)
+{
+	return NULL;
+}
+
+#else /* !CONFIG_RT_GROUP_SCHED */

 void unregister_rt_sched_group(struct task_group *tg) { }

@@ -147,7 +299,7 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	return 1;
 }
-#endif /* !CONFIG_RT_GROUP_SCHED */
+#endif /* CONFIG_RT_GROUP_SCHED */

 static inline bool need_pull_rt_task(struct rq *rq, struct task_struct *prev)
 {
--
2.56.0

