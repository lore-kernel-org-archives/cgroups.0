Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F38E3B3BFE
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 21:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546028; cv=none; b=iL9BZjjr+DroII7NqL1QOjktoUuHwQ88kM7o5rL0oy13Pre9hzgzMtz5LvjbX5xdv+jBYZP7itzVcJKG0VtVqL4F57Obwqu7Blg9qiPP4TEO4eY3o0y9+VQ2tyAhF8g3dxbTJ0Mp+TA9VNqFqzInV30ycPdMRxe2363uLcipfEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546028; c=relaxed/simple;
	bh=6ZplsNQosshH9/Hdz9ePV+TevTkFFkKW5v9OPdS3UM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnhM1hNj6nKVZ+A1by2jyJKW/TkkERAQAfQuJ8bEGb0wICuYRRcsd7vuXB+kEpzkWQN8kL/eE9KDaE2yHsF6USL3HDHRskc+hS2Z8aIurM3F7yNsGOfyBO0vMnVkJQoERAafGUUOT/nuTjWETIhzSG/lQlbGM8bFlFlhUhX2Mp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XggdkwV8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XggdkwV8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790546026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=83CxIGmKlkUwPBTSwGajGchswxda2jUA/kxLQylCBKA=;
	b=XggdkwV858OkG7NCs2dbEP2GWtshldr2kvaTn4QKV2ZycVSPZAy14mmW/y0gqAmHMC5LDO
	c63PrF70EM20Xv3XvPYklxl9ymmRh7UPJFdsm0jpoL1rYo6wnwFAHjJDAPmws9OsQ4aYfq
	OEaTzp2xbJDXu1Ts7NcNaSz7/QNtDM8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-ZWV8H2N1Or2anEtmgNAF_w-1; Sun,
 27 Sep 2026 17:53:42 -0400
X-MC-Unique: ZWV8H2N1Or2anEtmgNAF_w-1
X-Mimecast-MFC-AGG-ID: ZWV8H2N1Or2anEtmgNAF_w_1790546021
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A2A8180067C;
	Sun, 27 Sep 2026 21:53:41 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4E6D8418;
	Sun, 27 Sep 2026 21:53:39 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v2 1/2] cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root only
Date: Sun, 27 Sep 2026 17:53:18 -0400
Message-ID: <20260927215319.382422-2-longman@redhat.com>
In-Reply-To: <20260927215319.382422-1-longman@redhat.com>
References: <20260927215319.382422-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Commit f82f80426f7a ("sched/deadline: Ensure that updates to exclusive
cpusets don't break AC") adds a check in validate_change() to make
sure that there is enough bandwidth for SCHED_DEADLINE tasks if we
shrink a v1 exclusive cpuset that has CS_CPU_EXCLUSIVE flag set.

With the introduction of cpuset partition in cgroup v2, we keep setting
the CS_CPU_EXCLUSIVE flag for a partition root so that the SCHED_DEADLINE
check will continue to work as intended. However it turns out that the
current code isn't perfect and there are cases where a cpuset isn't
a valid partition root, but the exclusive flag is still incorrectly
set. This can leads to SCHED_DEADLINE check being incorrectly triggered
when there are deadline tasks in the system. This can result in unexpected
-EBUSY failure when making changes to cpuset control files. Fix that
by checking for a valid partition root for v2 and is_cpu_exclusive()
for v1. It is far easier and less cumbersome than to make sure that
the exclusive flag is only set for valid partition roots.

Even though commit a86ce68078b2 ("cgroup/cpuset: Extract out
CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling") is marked as a
commit to be fixed, the problem may exist before that.

Fixes: a86ce68078b2 ("cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 753aa65afcd7..104fe10c336d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -771,8 +771,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	 * For v1, effective_cpus == cpus_allowed & user_xcpus() returns
 	 * cpus_allowed.
 	 *
-	 * For v2, is_cpu_exclusive() & is_sched_load_balance() are true only
-	 * for non-isolated partition root. At this point, the target
+	 * For v2, is_partition_valid(cur) & is_sched_load_balance() are true
+	 * only for non-isolated partition root. At this point, the target
 	 * effective_cpus isn't computed yet. user_xcpus() is the best
 	 * approximation.
 	 *
@@ -781,7 +781,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	 * becomes an issue.
 	 */
 	ret = -EBUSY;
-	if (is_cpu_exclusive(cur) && is_sched_load_balance(cur) &&
+	if ((is_partition_valid(cur) || (!cpuset_v2() && is_cpu_exclusive(cur))) &&
+	    is_sched_load_balance(cur) &&
 	    !cpuset_cpumask_can_shrink(cur->effective_cpus, user_xcpus(trial)))
 		goto out;
 
-- 
2.55.0

