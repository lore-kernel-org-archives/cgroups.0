Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5454EFFA7
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 14:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986777; cv=none; b=FbDXhAxWG8mAJlDGtAj0ANtKO6ojZL6MsOE1DaFeYcKKCo8FLyURJAnxpqnZPBapAIkH0izuK56U/Sqr4YwvrQZVlIShgMWnLEB4mmK/d4Wl4I+89s//138PoOGKkd/4n5HLwrRjxNSc2DEAGYWN9qb4gXxKR7bTHiu1G8oZ9Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986777; c=relaxed/simple;
	bh=+LPtWh1qFJlgPBvFQMTukUCo0zpCSuwiIYzyQE9FwWU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fqW0/Sw6ukUMEm+O7tGgkaRyJoOlbBH7nlYfTGv96teyX4w8BnnBhyfcg1RlhjpJ9nlegP78aMB3DLhkty5uvpJmjA0KL5gjbjQLhZ0noofOsiFefYcb2kSBj31gEtuaQVGv/sW9AB9f6qj6qQx5fIfc6Yb/wG9wx19evlFQtoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CulZ2B5F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CulZ2B5F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791986774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HnvQD1sI3SbVIiglYRsgOb/vLGwCrdATaXJSnvrFMk4=;
	b=CulZ2B5FG9GyngShTXibCQEjhostvHKAKG7IHI6tAOnDc7N32RgGkGsWrC4o0gqwD87DJo
	zupXhwrjBGy3lOb4WiX/H5juCrD4LgU8Lutd9Wi4fHiRbRMP3/GsZfmkQP/ez9e9pN22ln
	kJhCJhuEhccCVHK48r2No1k/JwG7VWg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-tHSEdSL1PrqhHCTsg4Jbvg-1; Wed,
 14 Oct 2026 14:06:08 +0000
X-MC-Unique: tHSEdSL1PrqhHCTsg4Jbvg-1
X-Mimecast-MFC-AGG-ID: tHSEdSL1PrqhHCTsg4Jbvg_1791986766
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A8221956056;
	Wed, 14 Oct 2026 14:06:06 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8BFD0418;
	Wed, 14 Oct 2026 14:06:03 +0000 (UTC)
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
Subject: [PATCH-next v3 0/9] cgroup/cpuset: Fix various housekeeping check problems
Date: Wed, 14 Oct 2026 10:05:39 -0400
Message-ID: <20261014140548.575122-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

 v3:
  - Further revise the code based on feedback from sashiko and
    reviewers.
  - Add a new fix patch which fixes a bug found during the testing process.
  - Add a patch to impose a new restriction that creating a child root
    partition under an isolated parent partition is not allowed.

 v2:
  - Update patches 2 and 3 to address bugs reported by sashiko.
  - Add a new test_cpuset_prs.sh patch to skip the test if some of the
    required CPUs are offline.


Commit 4a74e418881f ("cgroup/cpuset: Check partition conflict with
housekeeping setup") and commit 103b08709e8a ("cgroup/cpuset: Fail if
isolated and nohz_full don't leave any housekeeping") add housekeeping
checks to fail partition changes that will violate the housekeeping
rules. However there are several issues that make the check incomplete and
missing in some cases. This series fixes the various known housekeeing
check issues as well as imposing a new restriction that a local root
partition cannot be created underneath an isolated partition. This
new restriction will eliminate a number of hard to tackle corner cases
which are unlikely to be used by the end users at all.

The first patch fixes a bug found in the testing process which is not
directly related to the goal of tackling the housekeeping check problem.
This series also updates test_cpuset_prs.sh by adding new test cases
to test the new code.

Waiman Long (9):
  cgroup/cpuset: Fix a missing isolated_cpus update in
    update_cpumasks_hier()
  cgroup/cpuset: Consolidate isolated_cpus_can_update() into
    prstate_housekeeping_conflict()
  cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping
    check
  cgroup/cpuset: Do housekeeping check before converting invalid
    partition to valid
  cgroup/cpuset: Properly disabling partition when partition state
    switching fails
  cgroup/cpuset: Don't allow a child root partition under an isolated
    parent
  selftests/cgroup: Add tests for isolcpus housekeeping check
  selftests/cgroup: Add tests for nohz_full housekeeping check
  selftests/cgroup: Skip test_cpuset_prs.sh test if some required CPUs
    are offline

 Documentation/admin-guide/cgroup-v2.rst       |   4 +-
 kernel/cgroup/cpuset-internal.h               |   1 +
 kernel/cgroup/cpuset.c                        | 191 +++++++-------
 .../selftests/cgroup/test_cpuset_prs.sh       | 234 ++++++++++++++----
 4 files changed, 294 insertions(+), 136 deletions(-)

-- 
2.55.0

