Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FBD32142B
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 22:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791670805; cv=none; b=KGkBLHe9N8imUeq/Dk0PZ8+e5boY2olPJyh9yyRm/vKFYCffGpfRn8ZwTetKAE55xtUbk34I8NM3S8OXOiZtWF6QxDd7rGqgBAILY9dHM8MsWeONe/oBnOM1HTLV8jkW0HKa2Cwg4FMhHUtsuhqY4hIK7Eo7iadjL+FvNQTZJEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791670805; c=relaxed/simple;
	bh=8M/HLatrySuK91muF/3AxnaVQnHzyFlrpDf35ZdHhgU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OdorbF/RKUYeyCfkoFZdbdsU9IMQ/yMg5c9Vw3IkEkv0P1/NcsP6gu2n/zAL+NALL/G22rfGZ6rT7zu9JoKWMoLWoKJElXeO3k5Eg4IDXTPZ8Jac2Ly45MR2BfCwC1qIrTW7BmdqcHKrLITXt8lAGRwGm0F/cFRU4cTk/FoVVys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gry+6fJ0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gry+6fJ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791670802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Z4IaVNVLUW4GvtVkHUILuCPdsadbUzjm6pOrDBwn+Z8=;
	b=gry+6fJ0xtVseI5SH7aWP/jEMpPitfRQ7VAcL57h0zNkl5oUnAGJ6Oihq2QHpF+Boh/9mu
	5bAxaY575LKp38Cvd3t958qAts3ZE8kM95ZbFbAMBCMBdiE2N5j1RrEMdf9xXm5vc3gHaw
	rvu+b9lt1drbOSIn7/y5fjlt1x2rRHw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-QcmVpveXN6SAGT28mi1POA-1; Sat,
 10 Oct 2026 22:20:01 +0000
X-MC-Unique: QcmVpveXN6SAGT28mi1POA-1
X-Mimecast-MFC-AGG-ID: QcmVpveXN6SAGT28mi1POA_1791670799
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 075D41955D99;
	Sat, 10 Oct 2026 22:19:59 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C3721800579;
	Sat, 10 Oct 2026 22:19:55 +0000 (UTC)
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
Subject: [PATCH-next v2 0/6] cgroup/cpuset: Fix various housekeeping check problems
Date: Sat, 10 Oct 2026 18:19:32 -0400
Message-ID: <20261010221938.243859-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

 v2:
  - Update patches 2 and 3 to address bugs reported by sashiko.
  - Add a new test_cpuset_prs.sh patch to skip the test if some of the
    required CPUs are offline.

Commit 4a74e418881f ("cgroup/cpuset: Check partition conflict with
housekeeping setup") and commit 103b08709e8a ("cgroup/cpuset: Fail if
isolated and nohz_full don't leave any housekeeping") add housekeeping
checks to fail partition changes that will violate the housekeeping
rules. However there are several issues that make the check incomplete
and missing in some cases. This series fixes the various known
housekeeing check issues and adds additional test cases in
test_cpuset_prs.sh to test for some of those issues.

Waiman Long (6):
  cgroup/cpuset: Consolidate isolated_cpus_can_update() into
    prstate_housekeeping_conflict()
  cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping
    check
  cgroup/cpuset: Do housekeeping check before converting invalid
    partition to valid
  cgroup/cpuset: Properly disabling partition when partition state
    switching fails
  selftests/cgroup: Add tests for housekeeping check
  selftests/cgroup: Skip test_cpuset_prs.sh test if some required CPUs
    are offline

 kernel/cgroup/cpuset.c                        | 170 +++++++++---------
 .../selftests/cgroup/test_cpuset_prs.sh       | 125 ++++++++++---
 2 files changed, 195 insertions(+), 100 deletions(-)

-- 
2.55.0

