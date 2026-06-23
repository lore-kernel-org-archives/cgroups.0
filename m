Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B213793B8
	for <cgroups@vger.kernel.org>; Tue, 23 Jun 2026 23:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782255908; cv=none; b=n9v3eAIeL2Y8aWHBcQ57+WfaVwd+I2Z5fGsTz9Y1Sk5gP0WIb46Wx6PHEWwnN2Ymobzh3Uvvi9VDM1mPXN5Wpqnt9YRD0na61xs17A4nt7mS28ed8ldPqYHM7jhRNe4pc8EllB/erXkSFJjNXZZ+nNyS/E9oNsjRLkLKPFvKc1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782255908; c=relaxed/simple;
	bh=NOWm49NtWeSP+HGDLgYO2W+bn53eMINx0zG2lhRG5pE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZLKV1cPMnapPB3yMlWYElHyzBc6skMfULc2s4453a+TGs7c01xwUlJRiLaxKeeqKZRMgTOEy6nkX0hg+QnY8lvwlvlN6WufACIArrzBtTaXs+J4uEYsobPnhE5PnFUdlieGaggIe4a5/QXqTmL/YbKSR2aE4GH4N4tzqFXjVowk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VvVehDvN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VvVehDvN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782255906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bBUFqxbe5JSvwRcjo5zgOOA2wcQYy9lkMF0E+6kIiuo=;
	b=VvVehDvN92NdV3nKjcTF2wIvBtrIamHRm/EieVUtlWV/IAqNRxNE9C2jPRrL0MO28HQZG5
	wxdQn7aj/SP8XevTCYBzXGwh9AxoZw0V0bEQx9Tus3i9Od0ud/r1TJL3AVR8kwSsxVxMe8
	uexJCyTSB/PaLJHCt2+n07TisaUA0M4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-128-SjuaneBgPxalr4-PjMIVWA-1; Tue,
 23 Jun 2026 19:05:01 -0400
X-MC-Unique: SjuaneBgPxalr4-PjMIVWA-1
X-Mimecast-MFC-AGG-ID: SjuaneBgPxalr4-PjMIVWA_1782255899
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE4A51956040;
	Tue, 23 Jun 2026 23:04:58 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.2.17.30])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 447AF1955F6D;
	Tue, 23 Jun 2026 23:04:55 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v2 0/2] cgroup/cpuset: Miscellaneous fixes and cleanups
Date: Tue, 23 Jun 2026 19:04:11 -0400
Message-ID: <20260623230413.1984188-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

 v2:
  - Update patch 1 as suggested by Ridong Chen and add new test cases.
  - Minor update to patch 2 code and comment log.

Patch 1 updates compute_effective_cpumask() and adds new
compute_effective_nodemask() helper to make sure that effective_cpus
and effective_mems will inherit parent's versions for v2 if
cpuset.cpus/cpuset.mems is empty.

Patch 2 makes cpuset_update_tasks_nodemask() to perform memory rebind
and migration only for thread group leader like cpuset_attach().

Waiman Long (2):
  cgroup/cpuset: Avoid unnecessary cpus & mems update in
    cpuset_hotplug_update_tasks()
  cgroup/cpuset: Rebind/migrate mm only for threadgroup leader in
    cpuset_update_tasks_nodemask()

 Documentation/admin-guide/cgroup-v2.rst       |  7 +++
 kernel/cgroup/cpuset.c                        | 49 ++++++++++++-------
 .../selftests/cgroup/test_cpuset_prs.sh       | 11 ++++-
 3 files changed, 46 insertions(+), 21 deletions(-)

-- 
2.54.0

