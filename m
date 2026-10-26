Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016177;
	b=Q30eBoZhzuYumm0xGPF2hW9NmGeER7j2eyl0720u9yn5FaoHegCOJ0cEfOWISpNrGW/B
	 z9kl25riqmN6Q0FaahYrbQ64BrClgOjDPDTOg/EYfJM7IpuPJa/74x4ySwzqtM5k6IB+j
	 a/X+VYI5RxDqa2eZa2mT/cjGa7i8F+p2NQT8ixN8sT+6IfBLnSEraEUX5+9uCN7oqUSjR
	 lz9JR3TFPwh4X8abY/XNDLa/hrMb7KfRMglav8IDZPGnncnyUdhbInzhuvz/3CRlmfqWG
	 lXtsnNoFufHs2YR6s3VBLFCepx14xO+7AknsPftuNYgT9BGFvVWiPXY8D/Pd+N3rMEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016177;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RFJJleyh4O8FR2L0iIk2GYhVD/sdkcXc7KlKPVTmZgw=;
	b=WGXySTdD/8ovGdJ6c+xOGkP9pgJ4cLgCpJPvD576n47kp3rQAYs+gpD2Z95NLC2z4IgN
	 5giznyCnKZM51bGrxezUgNo+IT9CfIQiisP6JDc9+VoohcqeNjzHFqWkKPzNfuD8MXPKW
	 boBXy4jLqL9ggPlF2vR5709n+tzGzoUHTQ5QhxbrNq+DlJ4fU0Div7OCdnOlWayKNStj8
	 OB6kT0zcTz8+7D9aJ5X1HQ0Pg6G6huUN/WbCfn7eAYq+qk1qsTbldeH88zT0ugNIVhL7w
	 nZ1y3CdNN+5u9j2vC9+ifl0me2pn99QgQSVU0Har1pRJ0B6kv3rlMnU9W7t0x0/+Y0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VMnlktqq;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF4460A2602
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 12:02:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CF4460A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VMnlktqq
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ac77270fbfso1444230a91.2
        for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 05:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793016177; x=1793620977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RFJJleyh4O8FR2L0iIk2GYhVD/sdkcXc7KlKPVTmZgw=;
        b=VMnlktqq1P5+NGTwtAUJ0zULOOEPun0/fz7oT3TFf9lj1vcN/jx6qXlGKidU3B9ube
         PLfvIvon9bPkji3Tnnr9TV80+IjbIBXYAhrSYcnF2jbItWyOs565LsDqWP9KIm9PveaJ
         Hdbmy+F9UJm0n87Qr5wDY+ZThgewWQyvbxABtLm8rREtWCiO0C2eoDo2VldjiE+gRdPR
         QX7zPJD61fN0HaqdVLRU6/HBqmLNvlp4aQLNmn6hUM+daptbXBHTWQzpjuUo2wTqJAbY
         Ga9wAn8TUIGiXo1kZiTofYoGk+hrEwSzgl+euKch6STjTZHZmKNNKRHMQzgweYcRBlXn
         Rqng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793016177; x=1793620977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RFJJleyh4O8FR2L0iIk2GYhVD/sdkcXc7KlKPVTmZgw=;
        b=r0XPlrfksvjD9B8GDR9sUesRGLPfdGUX2brYBLDIOnz+gSvFxolAVl3cFCMwBknvGx
         3u77YEnAt98nHdPkZ9vaGS4HQDkRgZiEweCSCqh/mcvu2S/UlqEVecEN0L0MpxNTvQA4
         l2Yr0mXfHXkhAelY4xkA1yRQE3SYAVqNbjKTtGUR2qjfNw0tpMBpIxKRFU5hc/FcveVQ
         3jZG8EJ4CKA11p+CCFm2mqVcuLsUgVwRZuanPsL5D5O4UQAI+taUHdEgLzm2U6yveW3b
         fFDgUbXcJogFM7DKL8wX+wvUJvtnUwg6r7FSCY2C3V7lb6SFWOoa8fwY5P4mIxEeSOkZ
         IgyA==
X-Forwarded-Encrypted: i=1; AKwUvBxruO2Ujomn0KwciNefip6R/PFkTEvEOO+g2XLCfEI1fJgvaZ+Ah6hhwbMJD36GW7pKrvzIcD6h@vger.kernel.org
X-Gm-Message-State: AFq9FYK3V6DeSQTMax6r7tqOBw/a7XMPvFuFvQMd35GCYb8T1b+VCpfR
	cZ037T9zgW78P8pNoahkLNdE+CzTBLHbQijT1UMGw7wU7ODeCF0ZFfAB
X-Gm-Gg: AYBFou311nRsVbm1pHwjL/Kr7XJy8IBfOYJfg5p8cf8aO2vTJqbcWmlANTXcmWnO2LO
	uDS3/rbSJO/WwR/pJeSQd5rzsigbxgkuJCrJfE9pmB4zR45H0a61r38T4MMvmi3tnw2jjT9w5oP
	rBQSb9MwRePaa4t43+EN36vjV/KHoZDs7xQcAswG2uHJG3aQRunQlnOJnKBK55MJEqntd3vDaDn
	jeGG5Higpa1MbRpVm72JQt0qOdlPtmBWfnjzG5nisr340R/WVjq+W2ii5WG30UTnri2tMIfLQ9c
	4koW5eanI45nnITY2E9NctDhulSGe7acFv/aVBFxxj7vMGgVcEWY/HiD2T8TshDxpuckQKe9mmf
	dTtSUXLF8vp17MQVv/osE7eDlDJs5KW2vPV6cO/dM+Kr5ox8CnvDgs3gaPUHofQQRPLzmN4gPL0
	YZS62+i9bA9G+bHRUazi0czwQtOq6ZK+WqqEZUwh8g5cC1vNVXsGwF7yLCFWM0sGrrrOgrU9VR7
	GFiSvfxQLLBiPIjGP9DH8xNtn5OXssWKw/ybLtG/q1aDNRi2rnBHwXaZMHRiid5mGQwiwlm
X-Received: by 2002:a17:90b:164a:b0:3a4:ba6b:cc24 with SMTP id 98e67ed59e1d1-3adeb137823mr4733512a91.58.1793016176366;
        Mon, 26 Oct 2026 05:02:56 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeba47266sm4750299a91.1.2026.10.26.05.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 05:02:55 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@I-love.SAKURA.ne.jp,
	tj@kernel.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: [PATCH] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Mon, 26 Oct 2026 20:02:48 +0800
Message-ID: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
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

mem_cgroup_scan_tasks() walks with CSS_TASK_ITER_PROCS, so it sees only
thread group leaders, plus a dying leader that still has live threads.
Moving a process whose leader has exited, by writing its PID to
cgroup.procs, moves the live threads but leaves the leader behind, as
cgroup_migrate_add_task() skips exiting tasks.

The destination's OOM killer then cannot see the process.  If it is
alone there, every attempt ends with "Out of memory and no killable
processes..." and the charge is retried indefinitely, and
memory.oom.group kills nothing; otherwise another process is killed in
its place.  The source's OOM killer still finds the leader, reaches the
moved threads' mm through find_lock_task_mm(), and kills a process that
has left the memcg.

Walk all tasks and take one per thread group: the leader, or the first
live thread once the leader is exiting.  Skip exiting threads, which may
belong to a group that has moved out.

Tested in a VM with memory.max=64M: in each case above the process using
the memory is now killed, and a process whose exited leader was not
moved, or whose leader is alive, is killed as before, with and without
memory.oom.group.

Fixes: f168a9a54ec3 ("mm: memcontrol: use CSS_TASK_ITER_PROCS at mem_cgroup_scan_tasks()")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 mm/memcontrol.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4d00748c8a5b..8823c549b6af 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1427,6 +1427,36 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
 						dead_memcg);
 }
 
+/*
+ * Take one task per thread group: the leader, or the first live thread once
+ * the leader is exiting, since migrating the group leaves an exiting leader
+ * behind.  Exiting threads are skipped, as one left behind may belong to a
+ * group that has moved out.
+ */
+static bool mem_cgroup_scan_skip(struct task_struct *task)
+{
+	struct task_struct *leader = task->group_leader;
+	struct task_struct *t;
+	bool skip = true;
+
+	if (READ_ONCE(task->flags) & PF_EXITING)
+		return true;
+	if (task == leader)
+		return false;
+	if (!(READ_ONCE(leader->flags) & PF_EXITING))
+		return true;
+
+	rcu_read_lock();
+	for_each_thread(leader, t) {
+		if (!(READ_ONCE(t->flags) & PF_EXITING)) {
+			skip = t != task;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return skip;
+}
+
 /**
  * mem_cgroup_scan_tasks - iterate over tasks of a memory cgroup hierarchy
  * @memcg: hierarchy root
@@ -1452,9 +1482,10 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		struct css_task_iter it;
 		struct task_struct *task;
 
-		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
+		css_task_iter_start(&iter->css, 0, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
-			ret = fn(task, arg);
+			if (!mem_cgroup_scan_skip(task))
+				ret = fn(task, arg);
 			/* Avoid potential softlockup warning */
 			cond_resched();
 		}

base-commit: 6b4b543fa18757297ac756a6fe6e64f506b7844a
-- 
2.43.0

