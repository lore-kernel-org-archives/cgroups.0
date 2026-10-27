Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793112026;
	b=0+BlwgVQreqvZpibS/JDhz/2zv09Etpp1EPm+OPxykXqj22lMZYYqWkYztybGremUrJ6
	 hKrK9NrZFCYoQKfP6vhBTERLgHNW/usIK/BKurYENmBJnmJNpnY701BTcO/QUpZrKi6lV
	 jrD0IqxyCYPNJ+6DJQuDdwA/hnZui4bjaswjm4qlXUW8HHUwnR0AYa+qFHZmQp44FyB5x
	 ND2pTC7hQ52RFgJUN+RmD8UkOVNu9NRhL0RQ0Y9ldMLjjov/kCLtErpBB+IIolorAYum/
	 eKgdAEp+pDeWBPrNtxWqpRBZ6S6d5Wwpg0oo24WwHDewXsSZJwqMpwaoLG+nTqwxxYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793112026;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=T1E/r4jGzpmWVwuykcjDGwY++XCWizWnAfM22Qf0RY4=;
	b=nY2rXSNqGEEOKYIxTsK87wDFr86rPmcipo3nAB6Gw+eqotXl5vXbbejQHuOqQc183S+g
	 HglMpNG4c8v4Xtpoehvg9+hnig6sy6qhZ2q2FPKwNVhE/DAVKmY+iXga/NJpvVMo1qH5W
	 d+BYasezZx6aM/YS0u5LDDm8SORW3RVS9wT5c9x5QEiHL3xuxPC8hjSUZqWA1zPbJWPoO
	 v/RlSfxUlsd+dh0+783gA23+thYUzoaNrgftXtdLsTr7B2L9T//IoxSNXFwSLQXrjXyMJ
	 OStbG7iO7hYuEDiRThCkMjPtjnTF6WCnHeUhvomdzcGHWWQLh2jgoP1xpidw7ZMIf1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="hkV/NtVt";
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA052606A31D
	for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 14:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA052606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hkV/NtVt
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-36a1947498bso673846eec.1
        for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 07:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793112025; x=1793716825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T1E/r4jGzpmWVwuykcjDGwY++XCWizWnAfM22Qf0RY4=;
        b=hkV/NtVt+9hXtT9TZ9RxA6SHUJvK+GPTgc7A8PHd3EKBSKD3xBsljRYWpxqzEYgQCY
         bL4seHN3+U1JnaHXaX3LX2BNV8JPAXAzLWzUWSui5RMzk9bXwZoDtvDxC0FoVcVXsCuE
         ASPqN4tjjGCxsD1kDzfEVaj+mHUzAQCadoyg3ydo8f0zRLD7+Xd8EJKYvhNjF8r+zjSD
         NGtaTbWD1DtZcWTAO7ma3n/NxUfx8uFoLjuUsw3xZ6JqaaO1elRU8hP9zjxOok7z4Gds
         gwfmurKxf6SwF9qTedwOh0cEu7yTSI1J9+syn8RS88M7plXs4SsoCbQgRLplbaNxb8ya
         uoXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793112025; x=1793716825;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T1E/r4jGzpmWVwuykcjDGwY++XCWizWnAfM22Qf0RY4=;
        b=WJdce9mrPRpArrjAL5pU7Yc9+A8NCEV5ft7sNDsFynilppo0zlpo8V/La2i70UsCma
         IByKGhpx6yxWBQc1qhg6uwBk52bIJZrdxloy4XRbwcI/TGnubum4yFG21GXQfORu9LPj
         cwwwoXZmCAuUJAgOB8o+4LRPSksbsaNzJBfwdSwl+QRVzes2fPbj7UXZ3rvTvnHK2v7U
         YgJY0CGV4CoWj80SkARpq8DDOuz232h8LN07b3HUEXWV1jvBksVYAKZNVeoNijQNsNiP
         MahnhYb7/FPQzk0N8ksJrWm2L+z7a3/tNyi+yQYvQinfsmn7lNkcvbP+95MvzM1xGvvh
         GIOw==
X-Forwarded-Encrypted: i=1; AKwUvBwkTMTatYTTgbNohc4qUWYc5azGXae0gF15JBUIG45T6vK402AlLs0i7rQPY9/ShKeAuZ4Su/QJ@vger.kernel.org
X-Gm-Message-State: AFq9FYIpmK9GsOOAXnDCBNB9FEdtrwnGkiLnAfwDW9bGU9r78bYbtvPz
	C/bDM7ImAmHq7itpVz8XWFYcoXxsrWjCCLZmh9CKqOj9HaEsVNUDYC7P
X-Gm-Gg: AYBFou2eMKGpi8Q4OWX7KBtlHscw905nyCiPoAV6O2YZW2VuVgSBME5G4Y3XnZWr8Az
	7GqIPArgRcKznj4X5EG7Nqq6drvkG1RCGm0kuG8Mob1WjSktNhBIq1vOO0W2JMfJJ1se7AA+5CO
	zlDRZbd/G/MNBGMzrpduXvV0iCFa7RXc0746rJSBniwRmqeLXCjKsVrY2KceNmcDWMDIoL6klCW
	K04Gt1qnoBXJJLGo6/uckAVQItx8wmUvMIYw/KTV8r7hP9P3JZrM4aoF8NEyOi0n1NDklMtVRvw
	iMvT/0OxjA7gQXb8a1j9/Ckc+EVw/8wQpoQEm8oLoFgSnejAh7gMlOPMpAOkz8jPfhcgFL+tLGM
	wPDO0dpLVdSOJesrS7xTuusNawJf1kNZXNHWBo8JPEc+QLjA8/HVXs6BOn4flYuUNjSOFY9CxSc
	LyaexSizQAEPlAxMtXNK7peCiDxtyW2KymYWglQQV7FKlgO2dqHl26XTWHucjGdreMB5TW5JmdK
	bLYLcvqhKhLSUI7+MEzvXQ4FrEf505O2JWLgXj/yHPrw0bO4G/m0J9FiZKTGQLzRYLN0LQJtnQl
	IPm/Z2CE4X/hHOdHmw==
X-Received: by 2002:a05:7300:2301:b0:347:8d01:164f with SMTP id 5a478bee46e88-369e84b15ccmr22877138eec.19.1793112023769;
        Tue, 27 Oct 2026 07:40:23 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8db7e73sm34727318eec.20.2026.10.27.07.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 07:40:23 -0700 (PDT)
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
	cui.tao@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: [PATCH v2] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Tue, 27 Oct 2026 22:40:16 +0800
Message-ID: <20261027144016.2582880-1-zhanxusheng1024@gmail.com>
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

Walk all tasks and let one task of each thread group in the memcg stand
for it: the first one that is not exiting, or the first one that has not
exited yet once the whole group is exiting, so that an OOM victim stays
visible until it is gone, as the leader does today.  Exiting threads left
behind do not count while the group has live threads elsewhere.

Tested in a VM with memory.max=64M: in each case above the process using
the memory is now killed, and a process whose exited leader was not
moved, or whose leader is alive, is killed as before, with and without
memory.oom.group.

Fixes: f168a9a54ec3 ("mm: memcontrol: use CSS_TASK_ITER_PROCS at mem_cgroup_scan_tasks()")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
v2:
 - Do the whole check under RCU and walk the group through task->signal;
   v1 read task->group_leader, which a reference on a thread does not pin
 - Keep exiting threads visible while the whole group is exiting, so a
   concurrent scan still finds an OOM victim and aborts
 - Pick the representative among the tasks in the scanned memcg

Tao's Reviewed-by and Tested-by are not carried over, as the check
changed.

The walk visits every thread again, as it did before f168a9a54ec3, but
the check stops at the first thread of a group whose first thread is
live and in the scanned memcg, which is the usual case.  A group can
still be visited twice, or not at all, if the task standing for it
finishes exiting during the scan.

v1: https://lore.kernel.org/all/20261026120248.2188024-1-zhanxusheng1024@gmail.com/

 mm/memcontrol.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4d00748c8a5b..cdb8ca4d4625 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1427,6 +1427,38 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
 						dead_memcg);
 }
 
+/*
+ * Let one task of each thread group in @memcg stand for the group: the
+ * first one that is not exiting, or, once the whole group is exiting, the
+ * first one that has not exited yet, so that an OOM victim stays visible.
+ * The leader is not enough: a group whose leader has exited can be moved
+ * without it.  Exiting threads left behind in @memcg do not count while the
+ * group has live threads elsewhere.
+ */
+static bool mem_cgroup_scan_skip(struct mem_cgroup *memcg,
+				 struct task_struct *task)
+{
+	struct task_struct *t, *dying = NULL;
+	bool live_elsewhere = false;
+
+	guard(rcu)();
+	__for_each_thread(task->signal, t) {
+		bool here;
+
+		if (READ_ONCE(t->exit_state))
+			continue;
+		here = mem_cgroup_from_task(t) == memcg;
+		if (!(READ_ONCE(t->flags) & PF_EXITING)) {
+			if (here)
+				return t != task;
+			live_elsewhere = true;
+		} else if (here && !dying) {
+			dying = t;
+		}
+	}
+	return live_elsewhere || dying != task;
+}
+
 /**
  * mem_cgroup_scan_tasks - iterate over tasks of a memory cgroup hierarchy
  * @memcg: hierarchy root
@@ -1452,9 +1484,10 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		struct css_task_iter it;
 		struct task_struct *task;
 
-		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
+		css_task_iter_start(&iter->css, 0, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
-			ret = fn(task, arg);
+			if (!mem_cgroup_scan_skip(iter, task))
+				ret = fn(task, arg);
 			/* Avoid potential softlockup warning */
 			cond_resched();
 		}

base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
-- 
2.43.0

