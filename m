Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C279F38D403
	for <cgroups@vger.kernel.org>; Sun, 12 Jul 2026 23:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783900530; cv=none; b=hu5LeFVBll+He0p/jfzctn0lIIPBFaAWx1H3AXBWELGAWUzSxyzqKRzPCZ8ore5MEfGQfJT8HBi4nn7lY/B8ebWjOj424UyKUb4PBFRHmSpRStwP4YzcEF0NnQ/nhc9N2tTSdo9cceqJWukJkXY2JhqUpJtPKAwrcc4lOd/FBcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783900530; c=relaxed/simple;
	bh=kwRCKDD4F+AfEtwUC3jmEbXgGCevYPrnBsdRrQF7trM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n7ux3Oy73vCKa0gqTTVAJYYOGznAlqTDiOkj7v3a88IBr7qpQaNEclQoQx0iUqtdDYYRVnCWcXmGbSoSxhuGAjRDyXYtaHf12Q/t/Zyz6WW70JC7V4txFoMYrZuxXCXUjQu33afnfA9EubCBrjlkGD8jrnH+ndsk74rtB7YAi+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JSPTwaGh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JSPTwaGh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783900528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UwiA5rvBHZcYdpl7FN/brlqf6KRR5zlUzix9hOp1j4c=;
	b=JSPTwaGhGCO6BMyKYeZA7vwkAjOK/oJsJLsY8jO94lIoefSxArZLu50QGaFR1PIFPnIBYL
	B8l+1JMwsI1tnqYNMVl6YKG3x/VXwnPkbpSiwjDTSQD+GQavGfTPReQQ0/ZCcQ/gwifPty
	yfO77l4+cn/DNN6zQplsZnXjBClNjvs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-227-ydoQKEeNMo6Q02EWJQv39w-1; Sun,
 12 Jul 2026 19:55:24 -0400
X-MC-Unique: ydoQKEeNMo6Q02EWJQv39w-1
X-Mimecast-MFC-AGG-ID: ydoQKEeNMo6Q02EWJQv39w_1783900523
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCE4A1956089;
	Sun, 12 Jul 2026 23:55:22 +0000 (UTC)
Received: from llong-thinkpadp1gen5.rmtusnh.csb (unknown [10.22.80.43])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DC3F91956053;
	Sun, 12 Jul 2026 23:55:20 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v3 0/3] cgroup/cpuset: Support multiple destination cpusets for cpuset_*attach()
Date: Sun, 12 Jul 2026 19:55:07 -0400
Message-ID: <20260712235510.373125-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

 v3:
  - Swap the first 2 patches as the original patch 1 can introduce serious bug
    without patch 2. Doing patch 2 first will be less problematic.

 v2: https://lore.kernel.org/lkml/20260712150127.236790-1-longman@redhat.com
  - Make sure that attach_ctx.old_cs won't be set to a source cpuset that is
    also the destination cpuset.

 v1: https://lore.kernel.org/lkml/20260711020540.176740-1-longman@redhat.com

This is a follow-up patch series to [1] to properly handle a special case
for cpuset task migration operation where the source and destination
cpusets are the same.

Patch 1 enables cpuset_*attach() to handle the case where there are many
destination cpusets from enabling cpuset controller. Patch 2 handles
those tasks that have the same source and destination cpuset by skipping
them as they are not migrating with respect to cpuset. Patch 3 adds a
new test case into test_cpuset to test proper handling of cpu affinity
when cpuset controller is disabled.

[1] https://lore.kernel.org/lkml/20260702214757.579012-1-longman@redhat.com

Michal Koutný (1):
  selftests/cgroup: Add test for cpuset affinity on controller disable

Waiman Long (2):
  cgroup/cpuset: Support multiple destination cpusets for
    cpuset_*attach()
  cgroup/cpuset: Handle the special case of non-moving tasks in
    cpuset_can_attach()

 kernel/cgroup/cpuset.c                       | 131 ++++++----
 tools/testing/selftests/cgroup/test_cpuset.c | 243 +++++++++++++++++++
 2 files changed, 321 insertions(+), 53 deletions(-)

-- 
2.55.0

