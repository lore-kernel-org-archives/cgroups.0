Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692879;
	b=ugYRRFSCYAveAhkKVLbC4tE9eHN+Md4z4DdV7FRfE2Lhac8AjRfnbtSEEZhTU1bgYC0e
	 7sJ2zJiwDq7XbxBPoF0fxUA8uSCUSHKGCdUUsCLWeV22zm59ioI+e07yAQTCq4nfUnk0M
	 43zHQ6D1Wf8F8Zxw33HBpe1tIwWqDPcLExoeeSqq6pbzmRBUXs06cJ8+Bl3p6D+kB8she
	 WCU4pBaoA2ahj5Tkbx6wva35zgUxV7i0ya/QLQR1VvgmiMdxvaDISz8wuRlYoLRGOgtES
	 lTgFcXkg4QtZmLuBRIJJiBk1NZcrFphMKL730/VotXPAC8jCr3JPPNJGmPmIyDo99Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692879;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7czWU74VCUPrnLnmq02o91EF357Keqvg3cH2LY97Lm4=;
	b=xenUYUgFoqKj+olcr3Ue1YsYNpJwTsy1uVJgx4xJG+N4MI+xNjR/xWzPbsDL2sa4qJrp
	 yjlTWPHD9vzdMOycpQd4XnT+e6ch9ViqPP4nY8/f6YIuvmR/uhqWM6CylMFUdwrzK0Jt4
	 iAoMGzo7GIDuYR2+nW6Ud+uob/4sNZ/a/mCcd3dbmIafhhsOPEFzcT/jJCAyr5aGO4som
	 MM5WeqYZPXiJMStf+vWPziqR2G+Q5dq4qPacb8BA3235J68rb3X4SDn1JjPFVDG8qfOXV
	 2/IDZBw0gzkFK5K8cWHjZBI6x/88HYd0hqDGx2d19xqnitgrpbieJuD4mliDj2P0+nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=KIpQTFXv;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD33606A335
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:01:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CD33606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=KIpQTFXv
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3B02B3F520
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692878;
	bh=7czWU74VCUPrnLnmq02o91EF357Keqvg3cH2LY97Lm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=KIpQTFXvm6hxRGjKvYp9zJeXovq8su7N468Ad4dgwMJaWz9vEaiOCGDkokJUQKlkb
	 kECqOQ8JiLh/N3CLC272DWKKdaTs2IwG7u1pymBuoOp7KnuJa61ZKjlL7JpEJJ/oBI
	 M2x2FK1Vef0DBnEU16eNMNz/9g4J2daFucqUFZKnXdT1wyuVSL+Qe8lIbb8WLnWTi9
	 yeiOtyJ3t+Gbm8YpbO+6fbo7JqKOm8vqXkIdlcyOUgS7RWL381WJazqlbnlmGlWbD0
	 zas6THNsJF8KmcgAJflFxVi2NcpYPQZuZ3NJmlnxMpcAlib3/Oiu3SD9NVgqeLIlLk
	 kJvWKYgLC7FA9JkjorLJQFYcOiU4hySf+0VPqj34sfzMWsP9wHsXM9EnGs+Xx8hKAX
	 VMk57eIMda7ykl+uvIKwmW3eWgFGmLZ1jQHlVvnoKWmOKxeb4VNwjiOOVMemB0ZOqG
	 dCb5HaXihGq1KkdHN73W+MCCLiRTtY5P7Fs493WyyFpOQYOsAgjby9L4Cd1ZjN8V0T
	 z1W7rVOG+CQvrleZzhb0P1pW/4G50yyxmgIk5IHxOawk5VInOEcEqhCSnN4RcArTS0
	 p+YyAYfwOUINszRm0HzDETQzcslRddeadcEvHXcA4QHKpWUkqLmu8w8HvtAynhW35q
	 IUEW6GMs+1HV8eERJBSlEMRk=
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-359b81ad4e8so5243396eec.0
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 00:01:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692877; x=1794297677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7czWU74VCUPrnLnmq02o91EF357Keqvg3cH2LY97Lm4=;
        b=tDHLIgmKgWum0wRtQndqM1UjFg3L7UqDv739uOqkoEmoF+CiN40TKc8apI1clvAd8Y
         WFCz+oz9pw3RebILBacCmVRwWwEUbHuZXtu9uNpX6fXxRUPwDVcbrmfACXF+0Qlrv80z
         B6FMLwuv+ndG6GtwLDH6GUo5k6eUk94owKjNDdyEh67S8lz0MlUcKepyQC7blQS+AqaZ
         T45lV5saYfaBwP6bTTdYfI1F5Gg6XvKARWdC+PNbwM3fjMU8tZx+VlD1GJqnQUXKGSju
         TceYQQaqBATXwKSZkVuPmx/mDazguIZocqnrgZ+iyxtfcMJVdu51Zz83keJSzlqyDwy1
         XoRA==
X-Forwarded-Encrypted: i=1; AKwUvBx6aXVDGUxXVHpVdxaCwckutrt02bfWPG7LDiULTlNjspSCKguw4j5HjbaNGQ73UlVwx0w0ThcN@vger.kernel.org
X-Gm-Message-State: APuU4Z9jCrtYAP+B4zTiJEb0IdY9yhE5w5jtf/bx531ssDIcuWNsv3nf
	YNlg3CqOw4bZGJKUi1pt/mETPRSJQ/k6dtLJN+YykYTl01WXw7yyOhLzV5GX3PtMvREN5xsXW0P
	yPdIg0hB33TBkir2XESr0VUjS4RTN1GqfxMYUmpX+9d+Tldu8VTw9tKnhXowApJE+nBvjZ1FPrZ
	k=
X-Gm-Gg: AYBFou0fCQQL5eBnGiQlHd7gfI89t+UiaKxIOmEtTLVtvm6hm2K4myZc/GirQkHENm5
	vDLe8r+oCmbwhw66heyFuj4pdy5E3KKS+YLvlB2MMjOQUXBFdmWU4uLraZ65fvV8xoYK2H/RC3w
	bF6GwMsHdIe++vfWuKpufSsebUrki9nvnrI4KI1z7ZPzN4Qt9baGgZfuYHHMnV3lxtsBt2j8Yho
	meEkAdLtDpQxmY9TfJQ0tMRx9fiVSZmZgQgMa/UOuGOYziilnNxf9dQhJbELaARzL5EoZX4ErG4
	HdMSt3jmMMkW43gD4PVALsiWdUg9JwOivtQD6MkCjFx0sqnQAt85+y1pKSWMbo2lbyP5FI97GME
	a4qmF/XompSLLkzaZ6aYj7N2O8bO7x6nec7dfymdDtLfZ2sqcj9NBfjvZevUyd61MCC9hdeiJmn
	jte4vyau1VqATSUpTD9g==
X-Received: by 2002:a05:7300:8813:b0:36c:49a7:86ac with SMTP id 5a478bee46e88-36c49a78c8cmr1128087eec.37.1793692876454;
        Tue, 03 Nov 2026 00:01:16 -0800 (PST)
X-Received: by 2002:a05:7300:8813:b0:36c:49a7:86ac with SMTP id 5a478bee46e88-36c49a78c8cmr1128033eec.37.1793692875819;
        Tue, 03 Nov 2026 00:01:15 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.03.00.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:01:15 -0800 (PST)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 6/6] cgroup/cpuset: Don't make a forking task wait for memory migration
Date: Tue,  3 Nov 2026 20:59:40 +1300
Message-ID: <20261103075940.110308-7-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
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

From: Caron Wills <caron.wills@pulsar.com>

Since commit 65e510cd30d0 ("cgroup/cpuset: Move mpol_rebind_mm/cpuset_migrate_mm()
calls inside cpuset_attach_task()") a CLONE_INTO_CGROUP fork into a cpuset that
differs from the parent's goes through cpuset_attach_task(), which queues a
memory migration of the child's mm and sets attach_ctx.task_work_queued, and
cpuset_fork() then schedules flush_migrate_mm_task_workfn() on the *parent*.
Two things are wrong with that:

 - task_work_queued is set whenever is_memory_migrate(cs) is true, which
   on cgroup v2 is always, even when cpuset_migrate_mm() queued nothing
   because the nodemasks were equal. The parent then flushes
   cpuset_migrate_mm_wq for no reason of its own.

 - cpuset_migrate_mm_wq is a single ordered workqueue, so the flush waits
   for every migration queued by anyone, not just this fork's. systemd
   forks services with CLONE_INTO_CGROUP, and as soon as one slice carries
   a cpuset setting every top-level slice has a cpuset of its own, so PID 1
   blocks in flush_workqueue() on every service start for as long as some
   unrelated cpuset.mems migration takes. On the AWS systems of
   LP: #2165410 that is minutes, during which logind cannot create
   sessions and SSH logins fail.

Make cpuset_migrate_mm() report whether it queued work and only set
task_work_queued in that case, and don't schedule the flush from
cpuset_fork() at all: the forking task is neither the cpuset.mems writer
nor the cgroup.procs writer for whom the synchronous semantics were
introduced by commit e93ad19d0564 ("cpuset: make mm migration asynchronous"),
and nothing depends on the child's pages having moved before the parent
returns from fork(). The migration itself still runs, in the background.

Fixes: 65e510cd30d0 ("cgroup/cpuset: Move mpol_rebind_mm/cpuset_migrate_mm() calls inside cpuset_attach_task()")
Link: https://bugs.launchpad.net/bugs/2165410
Signed-off-by: Caron Wills <caron.wills@pulsar.com>
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 kernel/cgroup/cpuset.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 439b55a310fe..b331689eab24 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2704,26 +2704,32 @@ static void cpuset_migrate_mm_workfn(struct work_struct *work)
 	kfree(mwork);
 }
 
-static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
+/*
+ * Returns true if migration work was queued, in which case the caller may
+ * want to flush cpuset_migrate_mm_wq before returning to userspace.
+ */
+static bool cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 							const nodemask_t *to)
 {
 	struct cpuset_migrate_mm_work *mwork;
 
 	if (nodes_equal(*from, *to)) {
 		mmput(mm);
-		return;
+		return false;
 	}
 
 	mwork = kzalloc_obj(*mwork);
-	if (mwork) {
-		mwork->mm = mm;
-		mwork->from = *from;
-		mwork->to = *to;
-		INIT_WORK(&mwork->work, cpuset_migrate_mm_workfn);
-		queue_work(cpuset_migrate_mm_wq, &mwork->work);
-	} else {
+	if (!mwork) {
 		mmput(mm);
+		return false;
 	}
+
+	mwork->mm = mm;
+	mwork->from = *from;
+	mwork->to = *to;
+	INIT_WORK(&mwork->work, cpuset_migrate_mm_workfn);
+	queue_work(cpuset_migrate_mm_wq, &mwork->work);
+	return true;
 }
 
 static void flush_migrate_mm_task_workfn(struct callback_head *head)
@@ -3376,9 +3382,9 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 		 * migrate mm from.
 		 */
 		if (is_memory_migrate(cs)) {
-			cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
-					  &attach_ctx.nodemask_to);
-			attach_ctx.task_work_queued = true;
+			if (cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
+					      &attach_ctx.nodemask_to))
+				attach_ctx.task_work_queued = true;
 		} else {
 			mmput(mm);
 		}
@@ -3887,8 +3893,13 @@ static void cpuset_fork(struct task_struct *task)
 	attach_ctx.task_work_queued = false;
 	attach_ctx.old_cs = oldcs;
 	cpuset_attach_task(cs, task);
-	if (attach_ctx.task_work_queued)
-		schedule_flush_migrate_mm();
+	/*
+	 * Unlike a cpuset.mems or cgroup.procs writer, the forking task has
+	 * no business waiting for the child's pages to be migrated, and a
+	 * flush of the ordered cpuset_migrate_mm_wq would make it wait for
+	 * every migration anyone queued. Let the migration run in the
+	 * background.
+	 */
 
 	dec_attach_in_progress_locked();
 	mutex_unlock(&cpuset_mutex);
-- 
2.55.0

