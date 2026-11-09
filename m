Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242186;
	b=pUCAth+k9aZGJHW4YJhkkbPwx8P7O1+7P0mUlKWMyPX+WQEJkaClzv9Xt201/6QEaopX
	 BwfZN+YaF8Ck5MDsqm2OOCQG/QTkw71sP9CKa9GK6NL5jqpqCDTdtxtVjIDfC0dW/KONo
	 l7s0NrLTH9LP+LxFI1AD/98nQQLDamRYkCyme8xmqitus3DNm3sTPTgnNBZPiZkFQoKx/
	 VoPneRystqBvaqWburYNsCsX2WKc9v+PFDI5+E4lWZXj63qmkExRgL8QRKL2IcxmGeyNC
	 fov4iM/+U9BBv+S2tTSF7misJlAmk8O4ylRXEfI2jzT6gnqyUnBtti6wyoiN7bZAIyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242186;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZrkVR5mXFjugKxMsS6+5gUfgoZd/TSJdYFOiJryJnwY=;
	b=NtMhIxYGgJyhGFkGS4LmGQhkpChIZ/siDy1LqaZK3EjcmCjsLLBt7qO4xfKxnY0qAajr
	 hBIuSaUtiN3uubsAQKlEugMfDx0cCdlVCCFQhRUyGbsmtyf1TF0f4Vz7hkeciHaIZcn+h
	 SgT83HkCJ89lT5VzHN3tYwsE3Qbt5PMVa6CCkW0hIh6qcxrNlzYAVZg88NqMiqmtekaWn
	 Aeu071ugdxZHVIe8I+Ba1DzKoK+uyCKavmrMHI3lSmExHYzwPOjMS0tHTHwWb+fO6u1o3
	 qL3cSvARliT2GYOwCwPCF+7MqUFDhAFuemR/S+vHEcxl17q5NUs36UcEOoCq/HZ8+nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MoGq4ijb;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920A9606EE86
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 920A9606EE86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MoGq4ijb
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a208d93758so11587865e9.3
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242185; x=1794846985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZrkVR5mXFjugKxMsS6+5gUfgoZd/TSJdYFOiJryJnwY=;
        b=MoGq4ijbYVarJ9kFWIv73DFei5kldJDcuv4Nu0Qvyur+JN+Sn7Gv3zWKCzG8kMEZ+W
         tL0CItmuB3KLCDikHZPTSjr33SI9Veyz6SiqfYUWOT8Gf9pljWHRc3XKi/j0HaQJbuYo
         P/Ure7T1fgayzzFXTxa4KaCkfrCMNl5nak1M1ogRvPlRzr/zEleqknwZonzC6EFzWFpq
         ovsXQX9ia5VLwJLk858SIX36S3s2a4h+/HZ2llCag2LOsdfT66drY4PNgqSgGXw66pEI
         iO6x2wXzSt2CtEG2nDp/Dp9BvDmujtbjbW5ALxMTYwjOCwemdlt0lbeL9d53WYwc+CMj
         B5vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242185; x=1794846985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZrkVR5mXFjugKxMsS6+5gUfgoZd/TSJdYFOiJryJnwY=;
        b=v2w0a7Q3k0+gQWCAXkLIEMVps+RaC+3hTAWVQW8xZcx9OjmwY6QLe4TZu7SRKNQQ9c
         tByfaBeL18Qy5T5rU3Qh0KOpmXXuwovTTji7NfFU4Gv56V6q4prafwhrVXgCplLJi6Yd
         yePC2ml99+KNh+A8F7ecoZwGx+/LQnokX0TCG1otF1oVZvhRPpN4TXP+EzFKhBkCwnHa
         EkaZ3cPsPIjG77mxyJXgB74nRRcTKIeEC+o7yJ+pu61hbjKk7577bTJXGySoVDPilRvj
         noHoRALQnLyphTKx/XlCl02dQpXn3R/Z9OJtBir8hAjLhssWYqxrCxoFJTkdZxpvhM7d
         WHDQ==
X-Gm-Message-State: APuU4Z8U/CRx+ORyC5luJb4vYIPOa3e2iC+Se65AbUhoiL2JU5L13wNC
	1S7UySkVez8BDuN3sFjg/6lfEZ9GmkWL1twFzsg7tT48jTX03KFsiPpJ
X-Gm-Gg: AYBFou3wJwEAhgu+Fi1okn3uW15xpyWYw0KF/p6zsQ+qViaGZDklU6mdaPv60ir9FnG
	193vbgsOibfk5Ku8TpuVZI2xUpioxXYVqmhlkVxf7aDiyKaQMnfQw3mZss/dst/xxeym8VshK1n
	6rI3F6teBC+LWMufYNFUO1UeD2hDrh/99OenVcv4s5v2MJbApjMydh3F/Gi775BEgxIntZ8ShAX
	mp+KCxrTqOXHJs1kdSvfu77U4m6hrQFKokYtPeZS+Rnea0ZQb3ZlFIgs+G1pZJGtvF0q/DZgXrD
	wpvHHZuoN4BWDo5IEz/6yZi84ZyJP7Wnc21i0LZZWGWhiSIpmW1XUAU9PTX7beNI4O/D/2cJ/0u
	k675QuYjRsX0lY/hk4M5s0kc+6bQnkiWiC3zjdT7OtVuN5fe2kE1D+BULb8+mxCpJLeWRPg/dSm
	hwPrswP1Uio4VlBxjInv0c0oEWYdyBJY4bD0vovHajuFj/ZG+JZgPUGxOaRX21s7NvujNPjeeVQ
	7zjTkp5fL4Jot0hxSpO/zWnSIhU1cvC0eF0el5ve109eoCSWgcntdfTpioHmUE73VBuDCW27DjG
	ayx3Ijxe5ET7VcPI0fb01QmgTgAkDhutaZB/YSpyK4+AHdA=
X-Received: by 2002:a05:600c:8b8c:b0:4b3:9540:47a6 with SMTP id 5b1f17b1804b1-4b963c9b6e2mr84346175e9.28.1794242185031;
        Mon, 09 Nov 2026 08:36:25 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:24 -0800 (PST)
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
Subject: [RFC PATCH v7 03/29] sched/deadline: Distinguish between dl_rq and my_q
Date: Mon,  9 Nov 2026 17:35:49 +0100
Message-ID: <20261109163616.195264-4-yurand2000@gmail.com>
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

Split the single runqueue pointer in sched_dl_entity into two separate
pointers, following the existing pattern used by sched_rt_entity:

- dl_rq: Points to the deadline runqueue where this entity is queued
         (global runqueue).
- my_q:  Points to the runqueue that this entity serves (for servers).

This distinction is currently redundant for the fair_server and ext_servers
(both point to the same CPU's structures), but is essential for future RT
cgroup support where deadline servers will be queued on the global dl_rq while
serving tasks from cgroup-specific runqueues.

Update rq_of_dl_se() to use container_of_const() to recover the global rq from
dl_rq, and update fair.c and ext.c to explicitly use my_q (local rq) when
accessing the served runqueue.

Update dl_server_init() to take a dl_rq pointer (use to retrieve the
global runqueue where the dl_server is scheduled) and a rq pointer (for
the local runqueue served by the server).

Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 include/linux/sched.h   |  6 ++++--
 kernel/sched/deadline.c | 17 ++++++++++++-----
 kernel/sched/ext/ext.c  |  4 ++--
 kernel/sched/fair.c     |  4 ++--
 kernel/sched/sched.h    |  3 ++-
 5 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b78ca828f694..febc03b02fa4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -742,9 +742,11 @@ struct sched_dl_entity {
 	 * Bits for DL-server functionality. Also see the comment near
 	 * dl_server_update().
 	 *
-	 * @rq the runqueue this server is for
+	 * @dl_rq the runqueue on which this entity is (to be) queued
+	 * @my_q  the runqueue "owned" by this entity
 	 */
-	struct rq			*rq;
+	struct dl_rq                    *dl_rq;
+	struct rq                       *my_q;
 	dl_server_pick_f		server_pick_task;

 #ifdef CONFIG_RT_MUTEXES
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 00f584c7bbd5..d24a1e14dd21 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -65,10 +65,12 @@ static inline struct rq *rq_of_dl_rq(struct dl_rq *dl_rq)

 static inline struct rq *rq_of_dl_se(struct sched_dl_entity *dl_se)
 {
-	struct rq *rq = dl_se->rq;
+	struct rq *rq;

 	if (!dl_server(dl_se))
 		rq = task_rq(dl_task_of(dl_se));
+	else
+		rq = container_of_const(dl_se->dl_rq, struct rq, dl);

 	return rq;
 }
@@ -1819,11 +1821,14 @@ void dl_server_start(struct sched_dl_entity *dl_se)

 void dl_server_stop(struct sched_dl_entity *dl_se)
 {
+	struct rq *rq;
+
 	if (!dl_server(dl_se) || !dl_server_active(dl_se))
 		return;

-	trace_sched_dl_server_stop_tp(dl_se, cpu_of(dl_se->rq),
-				      dl_get_type(dl_se, dl_se->rq));
+	rq = rq_of_dl_se(dl_se);
+	trace_sched_dl_server_stop_tp(dl_se, cpu_of(rq),
+				      dl_get_type(dl_se, rq));
 	dequeue_dl_entity(dl_se, DEQUEUE_SLEEP);
 	hrtimer_try_to_cancel(&dl_se->dl_timer);
 	dl_se->dl_defer_armed = 0;
@@ -1832,10 +1837,12 @@ void dl_server_stop(struct sched_dl_entity *dl_se)
 	dl_se->dl_server_active = 0;
 }

-void dl_server_init(struct sched_dl_entity *dl_se, struct rq *rq,
+void dl_server_init(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq,
+		    struct rq *served_rq,
 		    dl_server_pick_f pick_task)
 {
-	dl_se->rq = rq;
+	dl_se->dl_rq = dl_rq;
+	dl_se->my_q  = served_rq;
 	dl_se->server_pick_task = pick_task;
 }

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index f74ffb3b1aca..3dd7d8998924 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -4099,7 +4099,7 @@ ext_server_pick_task(struct sched_dl_entity *dl_se, struct rq_flags *rf)
 	if (!scx_enabled())
 		return NULL;

-	return do_pick_task_scx(dl_se->rq, rf, true);
+	return do_pick_task_scx(dl_se->my_q, rf, true);
 }

 /*
@@ -4111,7 +4111,7 @@ void ext_server_init(struct rq *rq)

 	init_dl_entity(dl_se);

-	dl_server_init(dl_se, rq, ext_server_pick_task);
+	dl_server_init(dl_se, &rq->dl, rq, ext_server_pick_task);
 }

 #ifdef CONFIG_SCHED_CORE
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cfc982205b98..a8e547c144af 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10311,7 +10311,7 @@ static struct task_struct *
 fair_server_pick_task(struct sched_dl_entity *dl_se, struct rq_flags *rf)
 	__must_hold(__rq_lockp(dl_se->rq))
 {
-	return pick_task_fair(dl_se->rq, rf);
+	return pick_task_fair(dl_se->my_q, rf);
 }

 void fair_server_init(struct rq *rq)
@@ -10320,7 +10320,7 @@ void fair_server_init(struct rq *rq)

 	init_dl_entity(dl_se);

-	dl_server_init(dl_se, rq, fair_server_pick_task);
+	dl_server_init(dl_se, &rq->dl, rq, fair_server_pick_task);
 }

 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6c7c5633524a..1b04b4c40ae9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -412,7 +412,8 @@ extern void dl_server_update_idle(struct sched_dl_entity *dl_se, s64 delta_exec)
 extern void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec);
 extern void dl_server_start(struct sched_dl_entity *dl_se);
 extern void dl_server_stop(struct sched_dl_entity *dl_se);
-extern void dl_server_init(struct sched_dl_entity *dl_se, struct rq *rq,
+extern void dl_server_init(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq,
+		    struct rq *served_rq,
 		    dl_server_pick_f pick_task);
 extern void sched_init_dl_servers(void);

--
2.56.0

