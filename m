Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794240582;
	b=erNaHeK8pnQLlD9FlugWxRV+xIxg8BJRGRzoHsoid0IeTFk3fghpWJzenCo1Ef59mXls
	 bNnGJPZRhkcv77TULXzBYfcJ6dFJXtWyEFygnlCJYNmBm1JwwdX6uAHu4dx2ekuhQLb2W
	 X/CYZDxb+hYxETG4IdTFiOv9hPjDk+TQfX3d7yfsKATrPS8OoBA4m06Ii3mwd36xU45Rz
	 gYyO0ytIvXvVY87AiYZTxIk5DonGBcer6RTKFok18YIeBNTEtSHoRUTUxrv6Ekn7RVy0T
	 Pi9hEVWjpg2xLUC7A7BJME2ePGCvjnSKKUpCAu45JBII8o7zdhCLlthB2W0aRvCko2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794240582;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=DXSPfaV7kxolJWnOKot1CieAHZ75QGSf+nsTqu3pO8o=;
	b=VSYt7smUUg7yCybc6myfqqUUyqx7/nEqctD0XWg3TFcqysUfKN4aMFMaEeqSr5bYIQT6
	 cFUY/LWKgbmnbVL5EPSXQ5wpCdgXJsJ8m61PBnyGcwYTJB8KC9k0FFgkC9JZ6td3bDBpm
	 nh+KJcYjC+L3PBJjXpLwn26JNKx0mnWnJmEGUYpfmi6dfN03sdoUwDdvXcdsT4flNb8OA
	 eh0GVi+61m5UYQ3vzGFLmr94e3d4Qhx3AW9RHRdMeRF5x0iTlpqoFoj2PMbGhX311zXCl
	 DG9VMN1cEVQ5oMtAvKvMvVP4sSAZYDw8KxmHQwSWK83wG/JEFV0+LbDXq4GoUn+LG6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ANn6FAcV;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89561606A325
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:09:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89561606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ANn6FAcV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794240580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DXSPfaV7kxolJWnOKot1CieAHZ75QGSf+nsTqu3pO8o=;
	b=ANn6FAcVOt0VgnJV71C/3n3sQ2YmIwCsMLYzpg56kMDD5P7mtjc6IL4Zz8gEM9A0lexDDQ
	k6sJnlMmRLFUpq0mCoIQHGilV4O2gYnNTEA7zaYqcgFGw8HA9MqJsXUY+VMdji6zzu+TU6
	TD/LOnAv6YQRoL0RVwJzeinq9NYc2f0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-343--w5wPgMrPUSsEI5tA3MoCw-1; Mon,
 09 Nov 2026 11:09:37 -0500
X-MC-Unique: -w5wPgMrPUSsEI5tA3MoCw-1
X-Mimecast-MFC-AGG-ID: -w5wPgMrPUSsEI5tA3MoCw_1794240575
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63A1A1956062;
	Mon,  9 Nov 2026 16:09:35 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8594726C;
	Mon,  9 Nov 2026 16:09:33 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 4/5] cgroup/cpuset: Correctly set cpus_updated in cpuset_hotplug_update_tasks()
Date: Mon,  9 Nov 2026 11:09:11 -0500
Message-ID: <20261109160912.1369897-5-longman@redhat.com>
In-Reply-To: <20261109160912.1369897-1-longman@redhat.com>
References: <20261109160912.1369897-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

When cpuset_hotplug_update_tasks() is called with the conditions that
either remote_partition_disable() or update_parent_effective_cpumask()
has to be called, the cs->effective_cpus can be updated such that it
matches what is computed in new_cpus. In such case, cpus_updated can
be incorrectly set to false leading to stale CPU afinity remained in the
tasks not matching the new cpuset value. Fix that by forcing cpus_updated
to true whenever one of these partition helpers is being called.

Fixes: 4b842da276a8a ("cpuset: Make CPU hotplug work with partition")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-ab90f7e8-0d60-40ca-83e9-e405075b24d2
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1f25f27e0e9b..742a719b4180 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3998,7 +3998,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 {
 	static cpumask_t new_cpus;
 	static nodemask_t new_mems;
-	bool cpus_updated;
+	bool cpus_updated = false;
 	bool mems_updated;
 	int partcmd = -1;
 	struct cpuset *parent;
@@ -4011,12 +4011,18 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (!tmp || !cs->partition_root_state)
 		goto update_tasks;
 
+	/*
+	 * cpus_updated should be set to true when remote_partition_disable()
+	 * or update_parent_effective_cpumask() is called as cs->effective_cpus
+	 * may have been updated.
+	 */
 	if (is_remote_partition(cs) &&
 	    (!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) ||
 	     (cpumask_empty(&new_cpus) && partition_is_populated(cs, NULL)))) {
 		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
 		remote_partition_disable(cs, tmp);
 		compute_effective_cpumask(&new_cpus, cs, parent);
+		cpus_updated = true;
 	}
 
 	/*
@@ -4041,6 +4047,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 		partcmd = partcmd_update;
 
 	if (partcmd >= 0) {
+		cpus_updated = true;
 		update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
 		if (is_partition_valid(cs) || (partcmd == partcmd_invalidate)) {
 			compute_effective_cpumask(&new_cpus, cs, parent);
@@ -4049,7 +4056,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	}
 
 update_tasks:
-	cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
+	cpus_updated |= !cpumask_equal(&new_cpus, cs->effective_cpus);
 	mems_updated = !nodes_equal(new_mems, cs->effective_mems);
 	if (!cpus_updated && !mems_updated)
 		goto unlock;	/* Hotplug doesn't affect this cpuset */
-- 
2.56.0

