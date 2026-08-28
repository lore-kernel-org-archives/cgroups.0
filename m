Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44B33890F6
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 18:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787940238; cv=none; b=Kiv4tneCPilpG4xi7QgSk+RBhoQEfwdlinENH42hwJU84tdO57R0bi9M7AeMMeSSyrGWr+WsIaa0/h89mNWz3nmUwJPNzsxKHbvUemrOCy8eNPTPBoKQ52hV3/wNRm0KeTn/gpzCrBe/VEovOk3ruKvXy8XXM4H3be1LVgYZZuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787940238; c=relaxed/simple;
	bh=wlp+QZrCllIFBjVEu2o493c8HKY2QOlo86a4xnkaCdo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MGKofUlfLuHxZwORZo1E/F1S85qsT0s6T96Ld34DfVuA1IL0xO55WErQEMc2WNrr5nwzup4uuEqMqpT1602/25RcMstlwSRBgeqmAAOUQaF/cAk8mqoFL8MgXq7sM91+SEnzAjVNTHgsLIxWfAnVd9t/6F7d4vkX2zRCTjeSrbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fbZYpI2d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fbZYpI2d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787940234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R6u5D0eKBr0PHMMC8e24ZiiUyM5N/sfQfhD2fU9Nzh8=;
	b=fbZYpI2d6/94rBgKMG10rJCnvNmlaHW8X7xR+Yc6NfCAhkiwINZJeBVavY3Z9Auae5uRet
	dIgU41W4Hp73a+0jdddrmggn61ZlPiJTGj2llCpOaHZ66sjxTthBrbawY3u9suGy+LHfM0
	8VE1jdpivmThKc+HSM1r46W0t38Ahic=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-HQqSgqhpOzKVH6VEZ9hqMw-1; Fri,
 28 Aug 2026 14:03:49 -0400
X-MC-Unique: HQqSgqhpOzKVH6VEZ9hqMw-1
X-Mimecast-MFC-AGG-ID: HQqSgqhpOzKVH6VEZ9hqMw_1787940228
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B420E195606B;
	Fri, 28 Aug 2026 18:03:47 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E50F1803A40;
	Fri, 28 Aug 2026 18:03:45 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH] cgroup/cpuset: Handle cpu hotplug race in guarantee_active_cpus()
Date: Fri, 28 Aug 2026 14:03:22 -0400
Message-ID: <20260828180322.730419-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

With commit 2125c0034c5d ("cgroup/cpuset: Make cpuset hotplug
processing synchronous"), the cpuset hotplug operation becomes
synchronous. That commit also removes the code that handles the race
between cpuset_hotplug_work and cpu hotplug notifier with the assumption
that race is now gone. Later commit 7a0aabd9ce69 ("cgroup/cpuset:
Always use cpu_active_mask") updates the cpuset code to always use
cpu_active_mask instead of cpu_ohline_mask in various places including
guarantee_online_cpus() which is also renamed to guarantee_active_cpus()
in that commit.

In the case of CPU offline operation, cpuset_active_mask is updated
first in sched_cpu_deactivate() to remove the offline CPU before
cpuset_handle_hotplug() is called to update the effective_cpus of the
affected cpusets. The cpu_online_mask is updated after that near the end
of the offline operation to remove the offline CPU. As a result, the race
comes back and the top cpuset may not have any active CPU leading to NULL
pointer dereference during the race window when guarantee_active_cpus()
is called after cpu_active_mask is updated to remove the CPU to be torn
down but before cpuset_handle_hotplug() is able to properly update the
effective_cpus of the top cpuset.

Fix this by adding back the NULL cs check to avoid this problem. However,
the output of guarantee_active_cpus() will be unreliable during that
race window.

Fixes: 7a0aabd9ce69 ("cgroup/cpuset: Always use cpu_active_mask")
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Link: https://lore.kernel.org/lkml/CA+0ovChh3VjsKN1g+ZGjwwY2fGTpP7uD+aCCByLj5Qbymw=bfQ@mail.gmail.com
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 0bad5bbec6bf..309478ab21ad 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -513,10 +513,26 @@ static void guarantee_active_cpus(struct task_struct *tsk,
 	rcu_read_lock();
 	cs = task_cs(tsk);
 
-	while (!cpumask_intersects(cs->effective_cpus, pmask))
+	while (!cpumask_intersects(cs->effective_cpus, pmask)) {
 		cs = parent_cs(cs);
-
+		if (unlikely(!cs)) {
+			/*
+			 * The top cpuset doesn't have any active cpu as a
+			 * consequence of a race between its caller and the cpu
+			 * hotplug operation where cpu_active_mask is updated
+			 * asynchronously before cpuset_handle_hotplug() is
+			 * being called to adjust the effective_cpus of the
+			 * affected cpusets. But we know the top cpuset's
+			 * effective_cpus is on its way to be identical to
+			 * cpu_active_mask minus the exclusive CPUs dedicated
+			 * to other valid cpuset partitions. Just pass back
+			 * the filtered cpu_active_mask in this case.
+			 */
+			goto out_unlock;
+		}
+	}
 	cpumask_and(pmask, pmask, cs->effective_cpus);
+out_unlock:
 	rcu_read_unlock();
 }
 
-- 
2.55.0

