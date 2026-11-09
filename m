Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242184;
	b=uaOucyjv2o2YIEzOWmwNY1aOUvigoSyiefjU4f11UGRLdyb3F5CEIW255UWQ4msaZIC1
	 asu1J0msekeno6DptKpFqV1nvXf4UjbNEzRkC4m+gTlMySbkXdGWTPiOrH1s1DD3Bril+
	 SYX3RBXS5H9kVr9R5ZuOXw+tMdONAY5sROHVXV15rTtHVnfhHouWPC7WWuanQT/tI6FLv
	 k63Fx7Q1An6Mq8ce90RZ9uMmAQTDs2SXL94fLU6W1k5sAv4+jXEKBa7cM/UIiEAtF/u5A
	 GLTuO6pT5c9HxgpzAy+E2jidIsT2Jwprium1QwKAt7kLQ2RsntcIT3wIpUn56hCeYzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242184;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SpFA5SgbZJhb9ponpVrLzGNwdHqcbHvWyklpgw1Qw5A=;
	b=2kODbT7BoKnQwKGzxfXhlv+txD+kRk+3RKx9C4psHvAqkK0hsudKE/uclsVlGGpMqLVg
	 gukbPWW5XWKydyPHwjMGkpvxvBk7h2fMZIizwYljD7ncQc+u/P/9K9DNWNH6FrhDLvXRb
	 DgVTPqPE9wdzWOSHIgOaWU/lIFJQVzNraH3XBP2tnEZJQoNiuEtQpACTgLYG79ULGfcZx
	 +ZiMMXJ6PgqSQGTW8w8XDMeLHzu8ODMLRCa6IDIwG4yIGFrPaXEOeI7FoEV9v/ZTlt4zq
	 lrGTtoxFGPItj690zLyQOtqzvgEZMiHP/MudnU+OphZsTpV1lR292OeOsZaw9/XJ5BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E5SJX+2f;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA27606A330
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBA27606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E5SJX+2f
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a215e64962so12847325e9.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242182; x=1794846982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SpFA5SgbZJhb9ponpVrLzGNwdHqcbHvWyklpgw1Qw5A=;
        b=E5SJX+2ff3/h5onmzPB9GjihmE2+6WLp9hzZVK2hbtsAvbPrD7WJIJTpgNbLJycJ8t
         j3MBBCvHxsQRvltiTSiGyf2ajMBRLmuTAL22CUZZwLOaxn4TZ48N7ieg8yc+jN2O0Ci9
         pYl4B4s/t5Erxyx56M0KuaEX7NOLFw5AM9xLQplgrFcFJhLrCDsCtSgmTZPh6ohVOkuR
         XgQZYDizOplKlNqjDfoKwuGZRxaixXGBP+l+RpiVefC6J04bHRAULMt9HLSe7PwH2Yxe
         H4rAgut2QvQB/qiGo8/cHuI+O/uxgunk0Rj4846WBCQrEKIchLyZRmSY9fmigmL+VGDm
         chUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242182; x=1794846982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SpFA5SgbZJhb9ponpVrLzGNwdHqcbHvWyklpgw1Qw5A=;
        b=xcYZ+I8Efe2BM2g+xajhopJi2Wq6J/MPBSToaRZO4DK0/L9C2AxLyaJwTaFYr9o419
         +NsJwWGT56PrckC2t3YNZT3tP1SwkmnyCpeeHD0is3rseEhPsB3DWF1OKhkp45Ax844y
         Jx/xRmNArUCwO7bHqgv3ikvWshxlLucEKMuccF1xDpoo3VdlbgcoD4GcPXWmvU6+lmwS
         PYkRED9tQrIZs6Zx52emBi37axx8xtdzn9G8R637Zip4vQb1hzhEslrzkf7KG9gPSuvm
         tK4V6cq92IwyNuiZqysiLYbAPKmOAuNTOJWcn1oPXpDAD61Uk1/ASaQPpn+BL2chc3rK
         N8Tg==
X-Gm-Message-State: APuU4Z8io2axgTOJ0uTcVET2JUwNR3Q/7thIyBl4+rzW9Ucx0HlFpCQl
	wfRD6jgzmgUyUjLzfB4Gf1E5UGoG/mQqRurBZvXZq3vHclwbUm0ilbYI
X-Gm-Gg: AYBFou12yLcQus90ukRhzkS9KZA3K3dQpF6SO64RKZTMXDmXsBC39DNo96XNnV+XiTu
	r2JwMMocUMIbX/ooZxKuWrwu6RY5aL0E9QIFN4OwyIvWfXSgbQ7kAQmddqNUxLnVSdEOzQP5wEF
	4KU4pelbj7smh1TBIqAM3Y9oLEYU1qSrPDG2w2tybz/xLHOT4NbB+7lGcJtrwILOToJ2JagAaVC
	QGD6G8/Nlg3q8FkpNr/7ctupH4TnGUAZCkNKh/+Z10ZlTYetPzSatTjaTDlTUP1JDZqFgEtvDBP
	gCdNIznFACPNC4ap4ESL01Vl1loxXE4xBWlpQfDvP4T5EGir59qhXcQbLRXn4Tqv6uYKSTtusvl
	ttONZTRjKIvnB4RkuS/RHO5pKVj7WReGlOjwN/ZN3IEij3V7QlT8MABbqPGW5EhtvFC6JXKCcwC
	N9+/hIgLTYymEaEJeLOYKL9SeuMNbCzP0gEu5/rOAuuPe8sGz6LrWXeoAjF5BsZVMyj4gUoTk/T
	nPbMHbmGVlI9BejXRIkvpRcjabZTSPVM/Xo8ObPmtOOec+1VBRBA745YwKD3UqHRBHsK9/hqWx8
	L0nEfYFbrMJAYmtzkWQqBMjH5lDDRyNP+Y7Qb34h4aE33vU=
X-Received: by 2002:a05:600c:8712:b0:4b1:2026:6b41 with SMTP id 5b1f17b1804b1-4b963c9de56mr86531255e9.30.1794242182232;
        Mon, 09 Nov 2026 08:36:22 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:21 -0800 (PST)
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
Subject: [RFC PATCH v7 01/29] sched/deadline: Introduce dl_freq_invariant flag for fair/ext servers
Date: Mon,  9 Nov 2026 17:35:47 +0100
Message-ID: <20261109163616.195264-2-yurand2000@gmail.com>
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

The fair/ext servers are by design frequency and capacity invariant, i.e. their
maximum allowed runtime is fixed, regardless of the frequency the CPU is
running. (See also https://lore.kernel.org/all/20250702021440.2594736-1-kuyo.chang@mediatek.com/)

This inevitably broke non-fair dl_servers, which would want to instead scale
their execution time to be consistent with CBS and GRUB-PA.

The newly added flag allows deadline servers to adopt the frequency invariance
behaviour as fair/ext servers.

Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 include/linux/sched.h   | 4 ++++
 kernel/sched/deadline.c | 5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c93da75226e..b78ca828f694 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -706,6 +706,9 @@ struct sched_dl_entity {
 	 * contributes to the root domain's total_bw. Only meaningful for server
 	 * entities (@dl_server == 1). Allows toggling the reservation on/off
 	 * without losing the configured @dl_runtime/@dl_period.
+	 *
+	 * @dl_freq_invariant tells if this server's runtime must NOT be scaled
+	 * by the CPU's frequency and capacity.
 	 */
 	unsigned int			dl_throttled      : 1;
 	unsigned int			dl_yielded        : 1;
@@ -718,6 +721,7 @@ struct sched_dl_entity {
 	unsigned int			dl_defer_running  : 1;
 	unsigned int			dl_defer_idle     : 1;
 	unsigned int			dl_bw_attached    : 1;
+	unsigned int			dl_freq_invariant : 1;

 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c0ebdcde5fe5..57c7a8802d8e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1432,7 +1432,7 @@ static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64
 		return;

 	scaled_delta_exec = delta_exec;
-	if (!dl_server(dl_se))
+	if (!dl_server(dl_se) || !dl_se->dl_freq_invariant)
 		scaled_delta_exec = dl_scaled_delta_exec(rq, dl_se, delta_exec);

 	dl_se->runtime -= scaled_delta_exec;
@@ -1862,6 +1862,7 @@ void sched_init_dl_servers(void)

 		dl_se->dl_server = 1;
 		dl_se->dl_defer = 1;
+		dl_se->dl_freq_invariant = 1;
 		setup_new_dl_entity(dl_se);

 #ifdef CONFIG_SCHED_CLASS_EXT
@@ -1873,6 +1874,7 @@ void sched_init_dl_servers(void)

 		dl_se->dl_server = 1;
 		dl_se->dl_defer = 1;
+		dl_se->dl_freq_invariant = 1;
 		setup_new_dl_entity(dl_se);

 		/*
@@ -3957,6 +3959,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer			= 0;
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
+	dl_se->dl_freq_invariant	= 0;

 #ifdef CONFIG_RT_MUTEXES
 	dl_se->pi_se			= dl_se;
--
2.56.0

