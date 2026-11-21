Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795246350;
	b=OIUqFsaSyZ9Iwdc+BrbW7A+h/Gu7nAyNxEnwQoMVZirtKkFkPwbSPTirx1U7vbiKuMET
	 /dDS4PCk5h1DmaSZ0UApnewwd4bjOKRS4k8KMkxj39QfPL4rWnmiWPRlg0OX5x4YbL+C/
	 KJ7bZ+PUVS3pTxli3C/VSkSFvSwv4mir17pGrhoh8deOJSX5N3mQRVZ4yjJAjdLSl1omx
	 LWFj6edW4O8Sux/dnNMzpY4hugbhtsY3uDmjfHzW3Yi219IDtveGbm9YFyyNZmkCQgTvp
	 Z5p9SLSWpDyhM4s5q7JvB39KPMKXIeUwfHGDP/+3eAI2fmjWG0SY+H6QGCHAkM0V9jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795246350;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vZXEIX5bRG+X47GzywXngypFAMMr6NGpMI+nKBGpwCc=;
	b=ycZKPAZiAvpBm8z+ExegPQtxffiDrKSoyEmX8wmu4hjy/Xc7wLaXNhno76DKhVdBe0In
	 aHLwUcUHLmsn5i3pihz+XcVbsmbacqfzy21TWiiW9xqn8uOk1v6aLjO30ZifdJ1lvQGYC
	 9k0dWhJex5CubRBnV+YwaCwYhHcyXL+BeYiwY5pb8QmFTvVsY4q43Zy+t5yAwNmc43fS3
	 PNXe20I+yWlN15ylwnfep7u3/AirwhOMsEr5Q3JiP+HBf7w7d9kPyvAJpxxAFEnmlzyBu
	 JPjaA+LYGI6n9hlxpz0pKO9lmlv/qZ9dk1sPPhZ1obHOWWV578x+vDOAa1t5kstnVsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qI5s+qRP;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FABB606A32A
	for <cgroups@vger.kernel.org>; Sat, 21 Nov 2026 07:32:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FABB606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qI5s+qRP
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e9e53d011eso13617145ad.1
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 23:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795246350; x=1795851150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vZXEIX5bRG+X47GzywXngypFAMMr6NGpMI+nKBGpwCc=;
        b=qI5s+qRPc8lOrId2pgvo/2iBSN/HidJP3kKtKe5Ref0DOKJB8y9o6Sl6ruSIUVdTxu
         luFddQp1/bbZokmYJs5Y4+QmshC+0KoM4JuTA/6kZ+qDbBUm5jLZlgeEJ71FuwES4Nre
         bCnX1om5e4PhAUnuMy8IzexWQej5EpbWDk2rjFiMVnRsoKqQghq7LIPSG3QAW5t6SILv
         cPTTgx8pC1Opcp2W4FJQbsFgdYRaB4I6nv8FwC1NPsKsy7SDwIiVTVISZRFpRzNJqBRl
         fCfFi8vA55yD8RrU4uEeMRWOANIWukzcbubMKu9nKBFhAavfQH8i18W5yICVfo/PZwcV
         91Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795246350; x=1795851150;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vZXEIX5bRG+X47GzywXngypFAMMr6NGpMI+nKBGpwCc=;
        b=GEalH5E78dybdK5JN7KaBTiuEav1O12QGUhpociTrOZyj69nQhCGTLudlNben8y1uS
         1b+gP6HzZZ0g+03D501lGwEF0m0MDA2zB3GUv489057CakygVNk9Fs7Xq0fHbESecExF
         PjaCwCvJyNsZxOhaKft1Q+ksEnQ4rWAckenKDVOTTid91Q5GB4B9JvMz6sCnPPvER9ee
         NGWBxE/znx30j7V7CMz0Fc7s2SPd3sk1Mu6RD/9YnPYjCurG6sykzzC5+vOZe3sOOX3h
         wA196axYtNGmPAnAvZJtV6oke7K8j6OwBup8QFKQReM1LC+3sfLq1WDNcuyMvx5KF8Oo
         Qg7g==
X-Forwarded-Encrypted: i=1; AL+hErFYMAUI8g+LqkZLJVEzogQLxZKU8RJfqfxql1fCi0TUnEnBFHdv8ahu2M++c8Q8V/BssF9VEAZj@vger.kernel.org
X-Gm-Message-State: APuU4Z+SZikI2Cd6ycmDgHoWO8DF/LL3+VGG+gqsA3+DnsdeSY5JhDyi
	rSyyAYvLRdzA6fPBEhiLqVL1ps4VvNJYJd6B+leUffmYJH/0e5zylmYX
X-Gm-Gg: AZFdTZcrqI6nDLs6YcVg6CPy052T/bTShr/G0GrLYulyR/8/2XWIMYQDZ1qT/Q7120h
	MGtxBeU12kTysEfjyxNYjr2O2Sv2ybY3NwhHQVeg/W+NdAs1/xDScptSUD2nyTJ45CwwfU+eQLC
	5s6vKlF50neRTdPelLkX4snrmSNOhpn6GzFNlPdTp6+EeE+F2kE18p1D/LRCu7K3638ZqHbAOyO
	DZozyNlfmmY2K1G/AzoD2PfKumuLUjqb8Jft7+A5h6HoztPeqdLmMtXyv6sWffKveS+mhvUH4/F
	exJH+oohCxvXppBdr8QN3lW2FVbpHnSZfMO3mKpXHBPA94RPtNcVhWYYlQC3kwKemq4a3tPV9Pg
	E4rFooBCX6cndnab0z4qEGi0ifbG2mXJiMv1rxkWwC+tyK6ph2nFjS3vlC21PQeUiddVh+y4LHa
	mCqyZRL9p3hroLSytic6sZrR6jisNloNiFZguPHL9hGgRxg+6P9wszyjF7U3qbYhqw9u6y5GIYR
	LfBHDsg+2gnt5n5aldnxowBL0N1W5nuMwmd9qcKSUO9fLAi6bLkqZoonJvmuErlOrTJ7YyJm7ZR
	F0bsUKp0M7gpsunCuXWnPYDNoVyWekhp3dE7s8hEFJbFEw==
X-Received: by 2002:a17:902:dacc:b0:2ef:d54b:fb64 with SMTP id d9443c01a7336-2f03f16ca9amr57805835ad.47.1795246349410;
        Fri, 20 Nov 2026 23:32:29 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0ddf40sm23423465ad.37.2026.11.20.23.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 23:32:28 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp,
	tj@kernel.org,
	mkoutny@suse.com,
	chris@chrisdown.name,
	cui.tao@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH v3] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Sat, 21 Nov 2026 15:32:22 +0800
Message-ID: <20261121073222.834282-1-zhanxusheng1024@gmail.com>
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
for it: the first one that is not exiting, the first one that has not
exited yet once the whole group is exiting, or the leader once every
thread has exited, so that an OOM victim stays visible until it is gone,
as the leader does today.  Exiting threads left behind do not count
while the group has live threads elsewhere.

Tested in a VM with memory.max=64M: in each case above the process using
the memory is now killed, and a process whose exited leader was not
moved, or whose leader is alive, is killed as before, with and without
memory.oom.group.

Fixes: f168a9a54ec3 ("mm: memcontrol: use CSS_TASK_ITER_PROCS at mem_cgroup_scan_tasks()")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
v3:
 - Rebase on "mm: memcontrol: don't lose track of exiting OOM victims"
   in mm-hotfixes-unstable and keep CSS_TASK_ITER_WITH_DEAD
 - Let the leader stand for the group once every thread has exited, so
   such a victim stays visible as it does with that patch alone

Moving the exited leader along with its threads came up on v1, and
there has been no answer from the cgroup side.  cgroup.kill had the
same case: da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread
group leader") walks all threads instead of the leaders, and
5f4a3f743acc ("cgroup: don't kill migrated processes through their
exiting threads") then had to keep an exiting thread left behind from
standing for a process that has moved out.  This patch does the same
for the memcg scan; the second case is what the live_elsewhere check
covers.

Retested on mm-hotfixes-unstable 2ba4d2c9ae3c: the cases in the
changelog behave as described, and with the reproducer from the review
of Chris's patch, memory.max=400M, 10 runs, oom_kill is 1 in every run
with and without this patch.

v2: https://lore.kernel.org/all/20261027144016.2582880-1-zhanxusheng1024@gmail.com/
v1: https://lore.kernel.org/all/20261026120248.2188024-1-zhanxusheng1024@gmail.com/

 mm/memcontrol.c | 44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index afbb638e7e1c..3355341666db 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1426,6 +1426,44 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
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
+	/*
+	 * Once every thread has exited, the leader stands for the group until
+	 * it is gone, as with CSS_TASK_ITER_PROCS.
+	 */
+	if (!dying)
+		return live_elsewhere || !thread_group_leader(task);
+	return live_elsewhere || dying != task;
+}
+
 /**
  * mem_cgroup_scan_tasks - iterate over tasks of a memory cgroup hierarchy
  * @memcg: hierarchy root
@@ -1456,10 +1494,10 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		 * torn down. Keep it visible so oom_evaluate_task() can
 		 * back off while there's still memory to free.
 		 */
-		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS |
-				    CSS_TASK_ITER_WITH_DEAD, &it);
+		css_task_iter_start(&iter->css, CSS_TASK_ITER_WITH_DEAD, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
-			ret = fn(task, arg);
+			if (!mem_cgroup_scan_skip(iter, task))
+				ret = fn(task, arg);
 			/* Avoid potential softlockup warning */
 			cond_resched();
 		}

base-commit: 2ba4d2c9ae3cfdad96ee925c92b14d7acd886954
-- 
2.43.0

