Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900153B9610
	for <cgroups@vger.kernel.org>; Fri, 26 Jun 2026 18:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782499076; cv=none; b=jrZgCJTcSmiuhK7OXu5SLPpBy5kmescysl+fBWXw5RoEKH2RYMeFeBvDm6V5ryzWP8k2Af1foIX69BFzvA5/43SGK8hkQQQuOnFo3lyfQJL4R3VF/NgDKaXX7SkUQVzL3+9741F6NSOpAWcYXEzNdfaEj0BoHAsMkBVVRgHA36g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782499076; c=relaxed/simple;
	bh=KPcThry/bOi+98P5g0pzg/lN3e+pE8CKXHPS3+RUjZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWQi+eATtzSJA7bM/JzpDe9sG5+mcSMmc6tW5TMMmPPHj1pGxMlg3Kkbxq6V95sagGQOYzx7J8tx+UyHUSS2W7cEmy1hM9evpB/iCJ2WAvnI5BMggSca1Ko7OpCQXhiLrSw4pquHvALU+sY2hJevgBCagZE443A/jJopz8DLGy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FrcZlUcn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FrcZlUcn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782499073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jrjf8NRhkq6x0gUPLl9yGOAtPkl52wr9CYyel1tCawY=;
	b=FrcZlUcnTIC90/wNuV4uAdFFvRc+RbjFmi72SwXzakeXRdEa2YSPRNueKK+UAnNT2u4xht
	W+0kXD/7DyIVjM+CDJCw5kHqVJv5zoNy2mialBVsvU4/OMhF2PAxq1yv1xzGlyPrZxvYyl
	RzYGAakaCt93sSbLscklXZzxgL5MCwM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-ocFP3K5SPjWzjm0CUS53hw-1; Fri,
 26 Jun 2026 14:37:50 -0400
X-MC-Unique: ocFP3K5SPjWzjm0CUS53hw-1
X-Mimecast-MFC-AGG-ID: ocFP3K5SPjWzjm0CUS53hw_1782499068
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 62E88180AD66;
	Fri, 26 Jun 2026 18:37:48 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.2.16.156])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DB7B719560A3;
	Fri, 26 Jun 2026 18:37:44 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Aaron Tomlin <atomlin@atomlin.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	David Hildenbrand <david@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v8 05/11] cgroup/cpuset: Add a cpuset_reserve_dl_bw() helper
Date: Fri, 26 Jun 2026 14:19:17 -0400
Message-ID: <20260626181923.133658-6-longman@redhat.com>
In-Reply-To: <20260626181923.133658-1-longman@redhat.com>
References: <20260626181923.133658-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Extract the DL bandwidth allocation code in cpuset_attach() to a new
cpuset_reserve_dl_bw() helper to simplify code.

No functional change is expected.

Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Gregory Price <gourry@gourry.net>
---
 kernel/cgroup/cpuset.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1f31f340e0ec..1bcc3af77c94 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3012,6 +3012,25 @@ static int cpuset_can_attach_check(struct cpuset *cs)
 	return 0;
 }
 
+static int cpuset_reserve_dl_bw(struct cpuset *cs)
+{
+	int cpu, ret;
+
+	if (!cs->sum_migrate_dl_bw)
+		return 0;
+
+	cpu = cpumask_any_and(cpu_active_mask, cs->effective_cpus);
+	if (unlikely(cpu >= nr_cpu_ids))
+		return -EINVAL;
+
+	ret = dl_bw_alloc(cpu, cs->sum_migrate_dl_bw);
+	if (ret)
+		return ret;
+
+	cs->dl_bw_cpu = cpu;
+	return 0;
+}
+
 static void reset_migrate_dl_data(struct cpuset *cs)
 {
 	cs->nr_migrate_dl_tasks = 0;
@@ -3026,7 +3045,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	struct cpuset *cs, *oldcs;
 	struct task_struct *task;
 	bool setsched_check;
-	int cpu, ret;
+	int ret;
 
 	/* used later by cpuset_attach() */
 	attach_ctx.old_cs = task_cs(cgroup_taskset_first(tset, &css));
@@ -3082,27 +3101,14 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 		}
 	}
 
-	if (!cs->sum_migrate_dl_bw)
-		goto out_success;
-
-	cpu = cpumask_any_and(cpu_active_mask, cs->effective_cpus);
-	if (unlikely(cpu >= nr_cpu_ids)) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
-	ret = dl_bw_alloc(cpu, cs->sum_migrate_dl_bw);
-	if (ret)
-		goto out_unlock;
-
-	cs->dl_bw_cpu = cpu;
-
-out_success:
-	attach_ctx.in_progress++;
+	ret = cpuset_reserve_dl_bw(cs);
 
 out_unlock:
 	if (ret)
 		reset_migrate_dl_data(cs);
+	else
+		attach_ctx.in_progress++;
+
 	mutex_unlock(&cpuset_mutex);
 	return ret;
 }
-- 
2.54.0

