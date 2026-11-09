Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794240577;
	b=i9YBvkwuDba8TF0kQ9tiTeJ5HfsH2v4HNaCWmaH7PZvneHF/xIT04mYu3Sx2ubCZo+wH
	 MjW3dIX16ADYVKqwRt0ru4kFtC8tT1OjOnOehntkFpVObBnnl5kMc5V85JT+hOPMbFWoR
	 FuApkiJ9UqAXJu6rWEJPCbB88yeukTGcbILA4DwmMvMJ1o/GU/dKkEZiQcAfw25ZyVzYJ
	 cIeUZeTg27apd8sg9sMzvWFXnnU32ARni2D2r5p2AJDWGlEeInY1WwkQLQMd9fpfPYVms
	 pE73pw0ET3mlnTsLkvVJs9DB76Rue0VGj6dsWQ4mrWAOPBsl1T3wKHyquh/dhWzJwWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794240577;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=CilHB2QJxes/RbxW8DdIdUjgRZu+jKegkhox90qTSy4=;
	b=37wjlLnRwIgMQ+yFA8Db8GF553/33VlBZoFsVCA1cS0O3LstLTOO8oW7O6o9nPi3faOt
	 m+e+R1l9HG8wVK/supGw3DtaH0r6DwYzQVtPvWFLq62dVdtzIDzs172kGGycA9cGI44a/
	 5aJso5qoiYsoVJmBBcYD74s9A+BkVgzZTrk5ZbyOdI9svR1dFq0/w75rmK0DamChcLi8c
	 244E1VZezHPeMsvJt1Ccao7LjruqmWyR4nreGCLXdr66G1elpzGNmO7ACcEJHiMqxj0VS
	 VaWCypFDRcuWDk5CbeGhZzOhZXRlp9RDVwekYod/sQp4p4GzgcWbbnmNS7ygFQ6pzsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=i6N8JmpV;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B948D606A33C
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:09:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B948D606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=i6N8JmpV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794240575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CilHB2QJxes/RbxW8DdIdUjgRZu+jKegkhox90qTSy4=;
	b=i6N8JmpVyNhWZl5TGIrTdi37yQA6d32QhDyw0XVO6I8OTkLoLmkn4aUDhc03aZvxaHv4CR
	KcP+m5XuWaI0BRtAeAQdMsL5MhyeW6ysB2GXWo1l5Zc+eRSwEc3Qdj3GUZKWZLAs38yG1K
	3SPMEOX+7F8N8+I/21No8shgHcNm+OQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-IH9CHWuyM7at2hEPJ05lAA-1; Mon,
 09 Nov 2026 11:09:33 -0500
X-MC-Unique: IH9CHWuyM7at2hEPJ05lAA-1
X-Mimecast-MFC-AGG-ID: IH9CHWuyM7at2hEPJ05lAA_1794240572
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 773B91955EB1;
	Mon,  9 Nov 2026 16:09:31 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D16D326C;
	Mon,  9 Nov 2026 16:09:29 +0000 (UTC)
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
Subject: [PATCH 2/5] cgroup/cpuset: Fix incorrect partition invalidation logic in cpuset_hotplug_update_tasks()
Date: Mon,  9 Nov 2026 11:09:09 -0500
Message-ID: <20261109160912.1369897-3-longman@redhat.com>
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

When most of the active CPUs of a system are allocated to
sub-partitions below the top_cpuset partition, it is possible that a
CPU offline operation may remove the last active CPU in the top_cpuset
partition. When that really happens, cpuset_handle_hotplug() will clear
the subpartitions_cpus to make sure active CPUs are present in the top
partition and let the other sub-partitions get invalidated and then
competes for their exclusive CPUs again.

In cpuset_hotplug_update_tasks(), the current code use
"cpumask_empty(subpartitions_cpus)" to determine if that partition
should be invalidated. That is fine if there is only one sub-partition.
As reported by sashiko that when there are more than one sub-partitions
and the first sub-partition will get invalidated and then it will
try to acquire the exclusive CPUs and become valid again. When this
happens, the subpartitions_cpus will no longer be empty. The remaining
sub-partitions will assume their exclusive CPUs are safe and proceed
as normal. As a result, active CPUs owned by those sub-partitions
remain in both top_cpuset.effective_cpus and the sub-partitions'
effective_cpus while missing from subpartitions_cpus, breaking partition
CPU exclusivity and triggering WARN_ON_ONCE() in generate_sched_domains()
and remote_partition_disable().

Fix that by checking if the sub-partitions' effective_xcpus are subset
of subpartitions_cpus to determine if they should be invalidated.

Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-bf69cd3c-833a-4599-a1f9-8dd9e044cd7c
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 40e7d33847f7..e8169b739454 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4002,9 +4002,9 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (!tmp || !cs->partition_root_state)
 		goto update_tasks;
 
-	if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) ||
-				       (cpumask_empty(&new_cpus) &&
-					partition_is_populated(cs, NULL)))) {
+	if (is_remote_partition(cs) &&
+	    (!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) ||
+	     (cpumask_empty(&new_cpus) && partition_is_populated(cs, NULL)))) {
 		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
 		remote_partition_disable(cs, tmp);
 		compute_effective_cpumask(&new_cpus, cs, parent);
@@ -4021,7 +4021,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (is_local_partition(cs) &&
 	    (!is_partition_valid(parent) ||
 	     tasks_nocpu_error(parent, cs, &new_cpus) ||
-	     cpumask_empty(subpartitions_cpus)))
+	     !cpumask_subset(cs->effective_xcpus, subpartitions_cpus)))
 		partcmd = partcmd_invalidate;
 	/*
 	 * On the other hand, an invalid partition root may be transitioned
-- 
2.56.0

