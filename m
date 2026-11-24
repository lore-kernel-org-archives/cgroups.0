Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795491365;
	b=kfeTz332uMJ87x5fLUI7r4MBxr00kjB9q1mJ00rHjZMt8ASQskzil5fAYlytZUgW2hO5
	 TxvR/IYiNJ5XTLNjVjEeR9FKDKDjvaBGjkAuuL6iukCmugGv0lpbWWo70xHw/TYBQbwaE
	 tW/oc0XP2dUZFaKu25Id1PMZCjhToeIDahEZPT4wIOMFo7CqEPHeX813sIXU0fimCCSUS
	 zsSBMcxUUeei1h3O6H8Gt7+zXsdpYBc8lJe5MGLCkvGMAWquNP0OgyRyW7TMC0khWkfC4
	 TQoxLsGfdfpi2sfHjIRpxW6uRw/4uQmxjyjKEkaZAa6foP3uDgGSRDaayvnKZoJ2TXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795491365;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tPwzcSn9YCtkUcYX05pvK2PhOcLN5eFatEAbk1VC3Ao=;
	b=juqyTVDlom8jGVF2g1K9SGAk7wFruV6EDN0FZvdFIukz22w2eryjqVG9j2UEvOBmM1wY
	 +FwWV0jr3RfBpZfpbnwX39f/WamUpcpBN5PzEA0YkGshETJtn1TQ4BaF6Cgl4oq6Qjkeu
	 YATEsuWZD4YZ7VaZl7zl/xgUiK1IpTsivGeBBmkPxO/drP2Lwz0jXo3ZUGboWd6KlFGKZ
	 lqJnGTsFskE+FKx6PACWneOqu8ILUU6NQ7hDvf8vwK2EnY4HiafSkytnpcpeTHvdfiyf3
	 VUIyNr0BWrxV1M4N8N6pd8HUTcBEpokPFCk9kpYtknuajnwT3i6SnhE49CHHDJ4AyJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tds5q10B;
	arc=none smtp.remote-ip=209.85.214.181
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B04606A327
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 03:36:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4B04606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tds5q10B
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2f04fab527eso29505475ad.0
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 19:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795491364; x=1796096164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tPwzcSn9YCtkUcYX05pvK2PhOcLN5eFatEAbk1VC3Ao=;
        b=tds5q10Bethl0FfyiXZva4IzMwY9rSAd99cHIo9BJ0aalRiX9U199zumfts2SrIOcP
         M0ElpB8TXNN+39CQJ/83sq3CBLLGn5Ts47U54hAGmtOqpBauy4iNOuJ0zL6BvMJeOOJG
         mk0BSbVFmNWFvBJjC74WWVmAb0XCaBVDyWMM4pN1EOv/IM1LWFzAVR6v68kxSkdx7RBG
         Q+ud+KfixiNbOgFhe6FJxy2Bgg3mDDp5+wyH9SOaGfi3gBy0Ev3p1ITaOeDDaLJ1tfa7
         uWb6+oNWIWG8qgpagiTR2xyzzgFWy3E1JjyaCGNNqzHjt3erllK/GrYLo9qfXfCJaadi
         F5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795491364; x=1796096164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tPwzcSn9YCtkUcYX05pvK2PhOcLN5eFatEAbk1VC3Ao=;
        b=qBhslEYXBGD/FeoszmluLbzJZiOkmZVWKZx38e5YR7i/cWhQeF6peaEW3Blc9ExrhX
         EQWtld5GhQhh9VbF1KZIQxmb9jBozbwLQ/LBe+ti+nMp2STn2yEUSvHsvJyckx7w9EaE
         0lkRzPCsFknc7cv+4/Am+rhhdsrDeUGWPwxUSymJR15U96+TuvS3QFjjc8ncWLuj6zZW
         /si4yASJTwjsYIOj+a9pAoxoEXJUk2QIwioKsOJRFPnS8trgyK9yhbzr6ebVPaCtDoQi
         TY3SXzy9Sqz+JI86g3esTLDqF8m41e2wLBs5AaHJKonedq43Abpee6XgmE79GPpNGiH6
         DxFg==
X-Forwarded-Encrypted: i=1; AL+hErGkY9QKVRjQ+AircQeA2aNfXugAgJerc5vRTaV/xo6QOljWsEi6wJtaptscDE3HfrQNIHe5yjOJ@vger.kernel.org
X-Gm-Message-State: APuU4Z82m4sR9fK5fgEAM3r8/ySsossrHnRFXD7OC78QjLlVWxv+glOn
	CRMX8dWPC/9PigqrNqYo+WeINAjbHadGzXxS10a6JQrjUg9MBgLhNjEu
X-Gm-Gg: AZFdTZe2x/sT+D8eu/eQBhXb6MFTu/1B5G+dUsNJ02vcXoa/v8peu6w9AvIc/avbO5v
	uVzKDWCvxM8o+aeXCB7H5od8u7Iq06iRvWmFB9mFqixIuyzZ9GWpLcZXS8CJpfXO7unhD5+rKO7
	COTrRQFCzlCXG7BBBE7mXqDh2yO86WwA0r3TLoNcx3ebtXRsPCvKBAbwmcD5/QK/k96oSxPNzg/
	7yIXUE49lq8dEMFEaWsR2WiBuXkONY44lKrBH8H8HBWEqHBew2buBv91vSgsX4UtfD5ArADGsBe
	AZJuM6slsfUrGD+R6iyRkkFZU2BlcxA+zIroMEZxM4rygOVl8SC11amtRb0pVAcFAr06aT48ADI
	bS/QT+4iaUkfedHhZff901gA+iRHHDR3QaR8bvybAJ8mLPcvV4FTZFK/KqPVMELVIUN5aFdmBms
	DkmVPO/dVzRZR56aFXBX7Y4D1VhUXckf9/FyHpeeB2qr8fXe/VyRJBx7cBnCJ09xVm62qAU34b+
	uqM4yv5T/3/KMUL9COQwneS4Ix4trnyL5NzbFUbSlXE1FsvEbNRZHSrcbe4+t7bWA0N2PcIhoCe
	aQwQ3LjjkoUkW+ueS83MFnT+CSeLE/3gdouDjEHWrYtd9gW3a0MnVGi4pPpXQ/F79KE=
X-Received: by 2002:a17:90b:4a92:b0:3b3:fd13:683a with SMTP id 98e67ed59e1d1-3b41c995b82mr12834105a91.59.1795491363557;
        Mon, 23 Nov 2026 19:36:03 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecb486sm23397939a91.16.2026.11.23.19.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 19:36:03 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: tj@kernel.org
Cc: hannes@cmpxchg.org,
	mkoutny@suse.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	kolyshkin@gmail.com,
	chris@chrisdown.name,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: [PATCH 2/2] mm: memcontrol: find the OOM group of a process where its threads are
Date: Tue, 24 Nov 2026 11:35:47 +0800
Message-ID: <20261124033547.2373352-3-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
References: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
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

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

When a cgroup.procs migration leaves an exited leader behind, a
CSS_TASK_ITER_PROCS walk visits the leader at the first live thread of
its process.  A memcg OOM walk of the cgroup the threads were moved to
can then return that leader as the victim.  mem_cgroup_get_oom_group()
takes the memcg from the leader, which is still the old one, so
memory.oom.group of the cgroup the process is in has no effect.  With
memory.oom.group set in dst and a second process in dst, an OOM in dst
killed only the moved process.

Add task_procs_css(), which gives the css of the process a PROCS walk
returned, and use it to look up the memcg.

Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 include/linux/cgroup.h | 18 ++++++++++++++++++
 kernel/cgroup/cgroup.c | 11 +++++++++++
 mm/memcontrol.c        |  2 +-
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5dfa915a630e..cb05808f2172 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -548,6 +548,24 @@ static inline struct cgroup_subsys_state *task_css(struct task_struct *task,
 	return task_css_check(task, subsys_id, false);
 }
 
+struct css_set *task_procs_css_set(struct task_struct *task);
+
+/**
+ * task_procs_css - css of the process a CSS_TASK_ITER_PROCS walk returned
+ * @task: the task returned by the walk
+ * @subsys_id: the subsystem ID of interest
+ *
+ * The walk can return an exiting thread group leader that a cgroup.procs
+ * migration left behind for where the rest of its process is.  Use this
+ * instead of task_css() to find the css of the process.  Must be called
+ * under rcu_read_lock().
+ */
+static inline struct cgroup_subsys_state *task_procs_css(struct task_struct *task,
+							 int subsys_id)
+{
+	return task_procs_css_set(task)->subsys[subsys_id];
+}
+
 /**
  * task_get_css - find and get the css for (task, subsys)
  * @task: the target task
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ab442f94e29d..0be7f96ce074 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5237,6 +5237,17 @@ static bool procs_stand_in(struct task_struct *task)
 	return leader != task && procs_live_thread(leader) == task;
 }
 
+/**
+ * task_procs_css_set - css_set of the process a PROCS walk returned
+ * @task: the task returned by the walk
+ *
+ * See task_procs_css().
+ */
+struct css_set *task_procs_css_set(struct task_struct *task)
+{
+	return task_css_set(procs_live_thread(task));
+}
+
 static void css_task_iter_advance(struct css_task_iter *it)
 {
 	struct task_struct *task;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..5704e4415a16 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2003,7 +2003,7 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 
 	rcu_read_lock();
 
-	memcg = mem_cgroup_from_task(victim);
+	memcg = mem_cgroup_from_css(task_procs_css(victim, memory_cgrp_id));
 	if (mem_cgroup_is_root(memcg))
 		goto out;
 
-- 
2.43.0

