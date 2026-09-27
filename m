Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3483859EC
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 21:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546027; cv=none; b=WkOy3tCRIQlZLj7TEwxHuJkOBBglbB5XmC+tXFwIiKbZv3LFX+FY31122UkQFstp8KSklour1eE+I3Sy5io6wAfFnFy+cp/z9H6rDTJ2iLRf8v09V2oo3oDUTBXVCIhuobr6gcS4wYjwkavMSSbuE5NFaI9oi0RjzK3u6pQ9aGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546027; c=relaxed/simple;
	bh=eRxtN20qVgmSKHWYiDSV0CrelvjK2ghyUv5/UlR5jHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iCuxKkv/qY2xEqEuKqlqUEQcp4WeRmnhpWBpOnWbe58+RL4aNm5CRsTVEDT68lhOAjZ8I7XqPz7ff2mt5+r0PeYBO930GWlNTPetL4XWSKHvh3y+tPZq4/cc324l2WCYu1+Q5J8FtJUmlrfQD/vlRg7ETfMFWuZYISGp7zLp/ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KF2aPQZ5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KF2aPQZ5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790546024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kZH4v7K1jaDieo8jJAF8+gFQF7CFWBnSD4vp3wuUmQ0=;
	b=KF2aPQZ5f6vpZKAPKud0/9km4IfUV8nzAlwqk36KzdkwEwXc8ffprjLbttn0NPJjPVaHlj
	ymSWpdmDCVSRThq5ASlN6+/hs2q652hlw/vNH13di9OSZINXYrrEqxhwLbS540je0x74uh
	zeUQHXxAmOICNxWGywziMso0f9EucBM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-ZzbZE6N2O9mo8gIUMmroyg-1; Sun,
 27 Sep 2026 17:53:40 -0400
X-MC-Unique: ZzbZE6N2O9mo8gIUMmroyg-1
X-Mimecast-MFC-AGG-ID: ZzbZE6N2O9mo8gIUMmroyg_1790546019
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05A3F1800632;
	Sun, 27 Sep 2026 21:53:39 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F2AF441D;
	Sun, 27 Sep 2026 21:53:36 +0000 (UTC)
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
Subject: [PATCH-next v2 0/2] cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root only
Date: Sun, 27 Sep 2026 17:53:17 -0400
Message-ID: <20260927215319.382422-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

v2:
 - Leave the v1 code as is and switch between using is_cpu_exclusive()
   for v1 and is_partition_valid() for v2.

When testing some upstream cpuset patch, it was found that the current
SCHED_DEADLINE shrink test in validate_change() can incorrectly get
triggered due to the fact that the exclusive flag may get set on a
cpuset that is not a valid partition root. This series fixes this
problem by making sure that the test will only be triggered on a valid
partition root and remove the now unnecessary code to handle the
exclusive flag in the v2 code.

Waiman Long (2):
  cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root
    only
  cgroup/cpuset: Remove CS_CPU_EXCLUSIVE handling code from v2

 kernel/cgroup/cpuset.c | 59 ++++++------------------------------------
 1 file changed, 8 insertions(+), 51 deletions(-)

-- 
2.55.0

