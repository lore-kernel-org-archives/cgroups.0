Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9FB37E5DF
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 08:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791620976; cv=none; b=jwZL1YVPacCCPnAmSuKLmMDumV9c2DzlPw/oRWb9iNPWk4KX2OEGD9VZlgBPn82y+xWhEoSJ/pdfU9NfQp4VscXpvfLBGEfcgYljGBTmt1XAwaBWvxvQOScfZI06hODUGOQLEhGmIJzvKEcK94IS73V06MtzbY5W5wje54ihlUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791620976; c=relaxed/simple;
	bh=w+ZNKRF8wS1QXPydSkLEsf/c3QifbY7C+D876KJZqDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5ms92LLkhQnI0hZDlmqAjrQAjXKIf6chLigvV8cLcxhBgkPAKvQYwMiJlRk6lRnkMF5oL0SpNI5oUR2eOy4O9MBsTPtrDBwaVRZ9oyRd6Ta6kt80Ys2WNdMmH4RUX2K0VBhP1bQXpe8eW8fE69jG2z257mgeHXWPn9gOE91xqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fy4Qtv2d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fy4Qtv2d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791620974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PWkNXTSHc4IBa0QmeFa2FNHrAvqGpQUMoOynGlswMhQ=;
	b=Fy4Qtv2dQ5Ba7gE17n2V4yRUurtD6VJb7ZqPFTjMEVEFsUusmFZ3XyZPAs40nMpDiwy1VZ
	qxU6CiChhbaZduUHNj0iiKyRIy5GWqttamtMkk6OGJjjeY5ywedZqQZ5ZXBSN5nLpiOJsF
	s/dVyoZNFPqPJ2SXxJMnyx8T0lDrGSQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-355-HIx_mJ1dN8aSv3ZRkQAOxg-1; Sat,
 10 Oct 2026 08:29:28 +0000
X-MC-Unique: HIx_mJ1dN8aSv3ZRkQAOxg-1
X-Mimecast-MFC-AGG-ID: HIx_mJ1dN8aSv3ZRkQAOxg_1791620967
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3635C1955BEE;
	Sat, 10 Oct 2026 08:29:27 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 643DD18005AE;
	Sat, 10 Oct 2026 08:29:24 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next 3/5] cgroup/cpuset: Do housekeeping check before converting invalid partition to valid
Date: Sat, 10 Oct 2026 04:28:46 -0400
Message-ID: <20261010082848.193182-4-longman@redhat.com>
In-Reply-To: <20261010082848.193182-1-longman@redhat.com>
References: <20261010082848.193182-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

When a hotplug event happens or when update_cpumasks_hier() is called, an
invalid partition may be converted back to valid. However check against
housekeeping conflict isn't being done which can lead to a partition
state that violates the housekeeping rules. Update the code to allow
reviving an invalid partition only if it can pass the housekeeping check.

Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ce32e7a31c72..77cf6e8db0f6 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1953,9 +1953,16 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			bool exclusive = true;
 
 			/*
-			 * Convert invalid partition to valid has to
-			 * pass the cpu exclusivity test.
+			 * Convert invalid partition to valid has to pass the
+			 * cpu exclusivity test as well as the housekeeping
+			 * check.
 			 */
+			if (prstate_housekeeping_conflict(-cs->partition_root_state,
+							  parent->partition_root_state,
+							  xcpus, NULL)) {
+				part_error = PERR_HKEEPING;
+				goto write_error;
+			}
 			rcu_read_lock();
 			cpuset_for_each_child(child, css, parent) {
 				if (child == cs)
-- 
2.55.0

