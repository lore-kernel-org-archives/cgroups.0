Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242219;
	b=tAgSuCGCp0F2uRJhW8DhCex2YfPdl8GVptpC19LRsTPJZu4QFdYT0Bhz5aNarTTvlJzM
	 cD0lYbc2CXuCBy8chXg+mnum+qLVhcmtZId4ptPPmRWGpEgmzgv99DrHpeYCcc5vBWtJ+
	 ohxVFC8gG1jkrCmP9xDBNi00QmTihr+QyqinhcFGY9o2Riy/BWsoFOqYDGX1UaDx8sygX
	 YKVcKskjkMCaFFE7bE9YcG3j0wO7QFC+sGxKPcHoYP0ci/QvQtq8RmeXKe7ClS+XWg98a
	 LZjcqNKTSmTSxgtCTypnd2pFcDimnY1kAam1rzlA2oA1o3yRi+BW4b1I2WB/wkuTqRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242219;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JLlaKTPbLeb3/gH7AJPm/GuRoGA7hDQrgsFi/3akh7M=;
	b=PbsJ9StmHUUfkL1q3EubZ1Vik/TdjAB8m6GvJkc4rlfCcD3cRLEhP2HC1k1Aj4NURwQf
	 bvSBXVzEOV9FN4gFosURWn0DzVVCbur9fJCNoHnVc5s/eBjN13AzE3gfg2BfD76JoXRy1
	 R65icwE00itwQWaVe5hZ8yjQy9UDlECH4NkQut0CjyE1ALxs1bmpuJk9wK+sIyJVN5jMw
	 WiMqu/AZQFYnJkrEHYSNjTD2oSvhzMwl+P0BZTQ4cmS1Y+HxE0BVFwxMFrRI6ItdTE0Pp
	 SQp3OUJyFe+iHCUWZYS3Or7vR0du+DRaYTkfB5He/LhT8ZhWltAwoaiAQ2Grv/HMukw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vqUgHQ2v;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271E360A6F71
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 271E360A6F71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vqUgHQ2v
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso8475515e9.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242217; x=1794847017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JLlaKTPbLeb3/gH7AJPm/GuRoGA7hDQrgsFi/3akh7M=;
        b=vqUgHQ2vNCQ5nG+Dlu0E31TLu6AgQHG414t4NmyiyEfkjDF7U5c79e0+Pj0Hkj1kMX
         mnl6fj7xBdzbvHhkFCASOv8y/2gqCw68E4KFwSKvwAjgGIIBAkfimEfo+3MJaZKbUjdP
         1FEMUTrhzP96MzqZl0N97/ESBaTdzSJPabdO3/Phz15TUiaXihp9f2QSE67hK1Z+Zars
         lfNTj0FEaGuVVAntOkWK+wvqEHzwHRJcJtSfWXpaVQcieItV5pNMiLizhdmE0PUjUg8y
         71M0TvQab3uLzEfbQ1dGj8eWeIGZ8a8nhnhfICm9BIPgGHjLam10mI7NraAC73aSxoKQ
         M4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242217; x=1794847017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JLlaKTPbLeb3/gH7AJPm/GuRoGA7hDQrgsFi/3akh7M=;
        b=Zmgi0VxQyokxJGD4uJ4p+rdTUkHAGkp2VwMkxHL6Ll0XaaGwFL/KedvNTpC+cUZAg2
         z/CxzBglkyySDLz2CpjkjzqPqS2inr4EDWmA3HJvGghNQd0Z/QpI7wGDV39ld6zmItaD
         E0K9JPPS9rlK/jol5EvC524tlTIU6f51DNo4YRmjdF5u9p9chFuDB+gJNTa/UPE5lXtD
         jXHQWKywURshrW92dbkGvGDoSpsJT3Mz5VG47rs/lqgKfhdosrOFyad8NWTeDhxYBCjN
         nLmljVfEecyNz6U0/3ZH9ECmPP0nCHEBTQXcdekitEJxS2t+Tm+CD1O/aVPdHGNuexSE
         /awA==
X-Gm-Message-State: APuU4Z9eDH8tg9qCZoeTxpZjxwI4QYhmpfy3SQRwTpX616r6O80YT1+8
	tOq2K0rEXLHmgggHPC8Hsw+50MALdY8tYBK2BVpyT7O9l3GfKlwPzaot
X-Gm-Gg: AYBFou3QT5H830Ej8J4FM0KV2JWOHoef+FFHozAjaWQqt6ICYDnshh+vOirfv9DySXl
	ROlY3CuC8M8u9GGk7R0HbxI7WyLjOayB38vsMtVRiAFh2RM5TUawZfxxS6W70nf0SEmRfh9oJ/5
	sWxMIgEJSSNlCF/wxFFR3ecUmgDMp8AMLOO9t8l8vZE0vGTrLWMD2FemvxaOs/li/Vh7XgqtkCI
	A5jEsp2tzzUG52HB8jScYYq64+xPrL4dosltWfcrHGnmuIDZa+wj24ZNVRjpOFEv4XWdz1Spllh
	3WPCeAQ6z6igDqIP3TJOdeDw3tydnhH3QkEkmXa33zzw3uUheoyfX1EjGGjHp9XUjFTNRX7nUBw
	Fo7pyYBwtGGF+l5RQerlhtLLz/YG0MMavF9DlSNmlmsvdMy3Lhyc4ErHT4sxUtuCuS8DC7I8ouy
	9crEnwp0pGPDuEwqiLJZN+S04WKnjxWhKAnUIzlmSLOv6PnywekZHU5igqf2tx6/Mu1yXEgKNaH
	tXCj0grjM8hsGj2A8hc7YVCXEhes922kdMKxzvYejmAjJwRYrNTTbx+xqDBdQw1lroByYYmRVSr
	n7hFzD/pnW3EAzOpyBXXidFbzw==
X-Received: by 2002:a05:600c:3e0a:b0:4a7:d9b1:b684 with SMTP id 5b1f17b1804b1-4b94d762e54mr87248405e9.2.1794242217597;
        Mon, 09 Nov 2026 08:36:57 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:57 -0800 (PST)
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
Subject: [RFC PATCH v7 22/29] sched/rt: Try pull task on empty server pick.
Date: Mon,  9 Nov 2026 17:36:08 +0100
Message-ID: <20261109163616.195264-23-yurand2000@gmail.com>
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

Try to pull task on a server with an empty runqueue before returning NULL (and
thus shutting down).

---

When all the servers of a cgroup are throttled, work is pending, and any one of
the servers is replenished, it may happen that the runqueue is empty and thus
the replenished server is immediately shut down.

The server may try to pull a task so that the cgroup could consume its
allocated runtime as soon as it is replenished.

Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/deadline.c |  8 ++++++++
 kernel/sched/rt.c       | 13 +++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 64df71ab370d..219493427e0b 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2910,6 +2910,14 @@ static struct task_struct *__pick_task_dl(struct rq *rq, struct rq_flags *rf)
 
 	if (dl_server(dl_se)) {
 		p = dl_se->server_pick_task(dl_se, rf);
+
+		/*
+		 * server_pick_task may drop the runqueue lock, so check if
+		 * something has shifted.
+		 */
+		if (pick_next_dl_entity(dl_rq) != dl_se)
+			goto again;
+
 		if (!p) {
 			dl_server_stop(dl_se);
 			goto again;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 9d95cf5fd520..839977b05d53 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -286,14 +286,23 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 }
 
 static struct sched_rt_entity *pick_next_rt_entity(struct rt_rq *rt_rq);
+static void pull_rt_task(struct rq *);
 
 static struct task_struct *rt_server_pick(struct sched_dl_entity *dl_se, struct rq_flags *rf)
 {
 	struct rt_rq *rt_rq = &dl_se->my_q->rt;
+	struct rq *global_rq = global_rq_of_rt_rq(rt_rq);
 	struct task_struct *p;
 
-	if (!sched_rt_runnable(dl_se->my_q))
-		return NULL;
+	if (!sched_rt_runnable(dl_se->my_q)) {
+		rq_unpin_lock(global_rq, rf);
+		pull_rt_task(rq_of_rt_rq(rt_rq));
+		update_rq_clock(global_rq);
+		rq_repin_lock(global_rq, rf);
+
+		if (!sched_rt_runnable(dl_se->my_q))
+			return NULL;
+	}
 
 	p = rt_task_of(pick_next_rt_entity(rt_rq));
 
-- 
2.56.0

