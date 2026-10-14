Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650E853F69D
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 14:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986784; cv=none; b=D9J8McAO8kPuOijGSr4gOBLf5DSw8D3dG2ylPOACDYa4KdrvEVRm2EhVuOdtXBmtaQlaEwmxoPgMwtbs2hBz3Ia54DCiIxvEovneKO/pY2Pa7D7dRUl3n5HIzj22+bfK9VJmvJkoUo9A/Q6n9TFXbX2qdj9wXpnQXAxDdD0FDD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986784; c=relaxed/simple;
	bh=Zockp4ShyfTmLHMgWEgJndAZNpFDwTZr2DR5+nDBQh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSI1U8lh8l7fZPPsPHyeCVD4NfCX+YDnpo3W89yMzpob0QkezitpG7VUIjBpyJS19ER5DA6bbbQro0CocvybKymvMUSXDi/+wXqiGA/s+OPZ+FBXWziRWbLTNGFeU9zLzf5nVDJmSzrujxqLy9/kX8Hoj1DACIk/R6eHQNhLY5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TFl7hyEY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TFl7hyEY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791986781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AhRKgET+QHEaZgszCaPSofIEfleRkehZ8m6XTDCfRWM=;
	b=TFl7hyEYImCKETaoxINDS7jd5EG98B/LT74+pVV5zln3nE17LatUXiMuiduNadTOIQlMke
	JRaULedSACRM69kMPLp5lnzsuYcx6xsd21ht1YtTYucfnfxzQg5FmxJTn4bFPVGIvZkq+c
	nInKtM7osH8Ponqyg8imm5xOGZf/quk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-fkkE0kVkOyeucqhF_3w9Yg-1; Wed,
 14 Oct 2026 14:06:18 +0000
X-MC-Unique: fkkE0kVkOyeucqhF_3w9Yg-1
X-Mimecast-MFC-AGG-ID: fkkE0kVkOyeucqhF_3w9Yg_1791986776
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15EE019560BA;
	Wed, 14 Oct 2026 14:06:16 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F0D9F418;
	Wed, 14 Oct 2026 14:06:13 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v3 4/9] cgroup/cpuset: Do housekeeping check before converting invalid partition to valid
Date: Wed, 14 Oct 2026 10:05:43 -0400
Message-ID: <20261014140548.575122-5-longman@redhat.com>
In-Reply-To: <20261014140548.575122-1-longman@redhat.com>
References: <20261014140548.575122-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

When a hotplug event happens or when update_cpumasks_hier() is called, an
invalid partition may be converted back to valid. However check against
housekeeping conflict isn't being done which can lead to a partition
state that violates the housekeeping rules. Update the code to allow
reviving an invalid partition only if it can pass the housekeeping check.

Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b2684c98d8c0..51723c299ca5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1959,9 +1959,14 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			bool exclusive = true;
 
 			/*
-			 * Convert invalid partition to valid has to
-			 * pass the cpu exclusivity test.
+			 * Convert invalid partition to valid has to pass the
+			 * cpu exclusivity test as well as the housekeeping
+			 * check.
 			 */
+			if (prstate_housekeeping_conflict(cs->partition_root_state, xcpus)) {
+				part_error = PERR_HKEEPING;
+				goto write_error;
+			}
 			rcu_read_lock();
 			cpuset_for_each_child(child, css, parent) {
 				if (child == cs)
-- 
2.55.0

