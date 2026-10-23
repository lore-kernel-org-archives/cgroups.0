Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785666;
	b=O9knuNCUy6iXXrYug4Cq8aUNKnYf4gWcBoWuh+YCT0lj5IF6NYP0Mi1I/6J3kvsXn8PG
	 2YggzXZg1JiEpZtwzxvNhQMo0XDlfSBIoQLX9CxiIZcxWg+laG/kHKxKYtd8IpDs34YOx
	 P7LaiOBaSmZzLYCoFyanHn3iD0IZKTN+Ldvvqmx8jBGpvIBUzJAgILxxoNVDf/P3Si06y
	 LswrQWBmIdQbi+6fIILUEQI3txdKNACZJYIlnUKpqdD3Y60FgCS9SoV6HXzzgtqB0Es40
	 yQmnB3qGSL74U7/H1tg6AozKzsS19xKt2oxi+SpRIe54O+b8rnpIKEFXl/QlOwkbt9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785666;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=41akheXLDiu5sa/hLvnKGPpvOk6X/oqZPDwHABeQ4+A=;
	b=p4/a1Cep9z5VPrdJERmdddohW0cbzgFHaWQDhu8ZpQAa9K9g8sFOo5XNdqMgXEBThzyf
	 o68u6sb9os6l70ZDAw2Yxuu9ZCEhZyKzYeem1d2UNTSeMKUxnq3qL4yxdMxuXVKwSlTJX
	 j3jehIBWO5r9sNmJI6InFCwmMkD3yyYfIYy1aEgSU2mQRrZhEglTdXL3NG/NZ/z+j5p+Q
	 qD4ENSjc9QsJyDzxmSHtEu8xXiDU8j456x2H2CHnBtuHSS92M+RlmZxsoKj6q8u9RO1Fb
	 t4pH1ufbchOK1oRwqUHqV+jawCXElH3w7NXoGlxtXVf4Lycrf36KZQ8+SsBXSGZTJwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZdI9ATcT;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A5A606A32C
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 20:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29A5A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZdI9ATcT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792785664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=41akheXLDiu5sa/hLvnKGPpvOk6X/oqZPDwHABeQ4+A=;
	b=ZdI9ATcTvu+C70tP4XE9Jo7K5btDJqDlhLLWwxoyVwC4LTNU94itcZe+qxvFu5senlPLPc
	gxcVklGB4asM3rbXbt8e6rLjJbBns69AVPyTY8Dw2++/QqeMIxS5TBlHEDUIr5BTi9aS01
	ooJrRjwVwUtDoHipSyGIkUBvajH5uiM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-167-_pcV6CCsOoak6Q-1Wj-fKw-1; Fri,
 23 Oct 2026 16:00:52 -0400
X-MC-Unique: _pcV6CCsOoak6Q-1Wj-fKw-1
X-Mimecast-MFC-AGG-ID: _pcV6CCsOoak6Q-1Wj-fKw_1792785650
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49BF41944B38;
	Fri, 23 Oct 2026 20:00:49 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4C8611955F25;
	Fri, 23 Oct 2026 20:00:46 +0000 (UTC)
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
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH-next v2 01/10] cgroup/cpuset: Find furthest isolated ancestor for invalidated isolated partition
Date: Fri, 23 Oct 2026 16:00:27 -0400
Message-ID: <20261023200036.60560-2-longman@redhat.com>
In-Reply-To: <20261023200036.60560-1-longman@redhat.com>
References: <20261023200036.60560-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Commit 46b885416c27 ("cgroup/cpuset: Fix a missing isolated_cpus
update in update_cpumasks_hier()") searches for the closet partition
root ancestor to determine if the isolated CPUs in a to be invalidated
isolation partition should be removed from isolated_cpus or not.

As reported by sashiko, this method may not work when there is a deeply
nested isolated partition hierarchy. For instance, Consider a nested
hierarchy A0 -> A1 -> A2 -> A3 where all four are PRS_ISOLATED:

  A0: effective_xcpus = 0-4
  A1: effective_xcpus = 1-4
  A2: effective_xcpus = 2-4
  A3: effective_xcpus = 3-4

When A1 shrinks its exclusive_cpus from 1-4 to 1-2, A2 will update it
effective_xcpus to 2. A3 will find its closet partition root ancestor
A2 and decides that its effective_xcpus 3-4 should be removed from
isolated_cpus which is incorrect.

Address this corner case by searching for the furthest isolated partition
root ancestor instead to decide if its isolated CPUs should be returned
to isolated_cpus.

There are other pre-existing problems that will still prevent the
above test case to work correctly. These problems will be addressed in
subsequent patches.

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Fixes: 46b885416c27 ("cgroup/cpuset: Fix a missing isolated_cpus update in update_cpumasks_hier()")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 585a982249ad..1ca548cd50fd 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2156,22 +2156,20 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 }
 
 /*
- * ancestor_partition - Find and return the closest valid partition root ancestor
+ * furthest isolated_ancestor - Return furthest isolated partition root ancestor available
  * @cs: the current cpuset
- *
- * Return: The closet partition root ancestor cpuset
+ * Return: The furthest isolated partition root ancestor available or NULL if
+ *	   not found.
  */
-static struct cpuset *ancestor_partition(struct cpuset *cs)
+static struct cpuset *furthest_isolated_ancestor(struct cpuset *cs)
 {
 	struct cpuset *ancestor = parent_cs(cs);
+	struct cpuset *iancestor = NULL;
 
-	/*
-	 * The top_cpuset is always a valid partition root which will stop
-	 * the loop if it is reached.
-	 */
-	while (!is_partition_valid(ancestor))
-		ancestor = parent_cs(ancestor);
-	return ancestor;
+	for (; ancestor; ancestor = parent_cs(ancestor))
+		if (ancestor->partition_root_state == PRS_ISOLATED)
+			iancestor = ancestor;
+	return iancestor;
 }
 
 /*
@@ -2283,23 +2281,23 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 				 * For a to be invalidated isolated partition,
 				 * its isolated CPUs may or may not need to be
 				 * removed from isolated_cpus depending on if
-				 * its closest partition root ancestor is a root
-				 * or isolated partition. With a PRS_ISOLATED
-				 * ancestor, the CPUs are checked against its
-				 * effective xcpus to see if any of them needed
-				 * to be removed.
+				 * there is a furthest isolated partition root
+				 * ancestor available. When such a PRS_ISOLATED
+				 * ancestor is available, the CPUs are checked
+				 * against its effective xcpus to see if any of
+				 * them needed to be removed.
 				 */
 				if (is_partition_valid(cp))
 					new_prs = -old_prs;
 
 				if (old_prs == PRS_ISOLATED) {
-					struct cpuset *ancestor = ancestor_partition(cp);
+					struct cpuset *iancestor = furthest_isolated_ancestor(cp);
 
-					if (ancestor->partition_root_state == PRS_ROOT)
+					if (!iancestor)
 						del_cpus = cp->effective_xcpus;
 					else if (cpumask_andnot(tmp->delmask,
 								cp->effective_xcpus,
-								ancestor->effective_xcpus))
+								iancestor->effective_xcpus))
 						del_cpus = tmp->delmask;
 
 					if (del_cpus) {
-- 
2.56.0

