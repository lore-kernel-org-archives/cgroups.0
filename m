Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792433445;
	b=YvxHQLPkVY1ybzfhvSK2OLgStE2OCNx2k1nVAT46vtOc40nn/9ohftuSZXfULpilPn8h
	 vvWr/YCm23u1NFYBiDpq6N1ZNe+mZflIVrlH0TG9lZTDAblpXZaNXG9c9P6xHpgOd+KMj
	 h4au8MF+D28li/4xClzKM6Ut0pzFem53UTWQGnTTE9/IDTNKpMh0kdAAnCyBlVIn+Mp/h
	 to3/VpyAxdcHSaIggPOyd97lsinVVjKr3BNRxgqLHYYVYvAxjcnLGWO8vRmqVM46lOFRU
	 /OV2fdM4Lk755TFn0f4m0Gx+ucCty6MtRgwlJeesvFkRZAsSTAl5dFecWa0iAmZCPqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792433445;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=rVBdJ6yJMaQPx6GERzuHZnG8FVacMhnzi0aZeMf4c/M=;
	b=b+SjyXMN3pZ1rVElYAvh9cOIpsRXpdfZAu5LW3SYRJnP3FxIflmZ0Re/c6ZQS/f/UZyx
	 d/ix9DHP4fva9NOezpPESYqkGxnp1CgH03GWJzTOR6LgisPNTUpzEPYuvwwMAvMHbZ9ab
	 7W8N6TgJQzFETMvQJpDCWXY8ecxJ//1qnEYEY4LIhPpNhA7Hx0MlMrMZiDQiQaLpaHE7E
	 4sdO0hZ3eOQxZMjBfn9EizdscsLyMYQzRjnLIImjN8akhRInebafVyV/ZMAqz4GZ4j7tj
	 dQ/LiJFvzxEHnakVBVC/PFGbwmJjdbvOuBT/7KpiqGUcNN+41RfqZQmawwtdnP/+nyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VVxcX7Bx;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D76A606A326
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 18:10:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D76A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VVxcX7Bx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792433444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rVBdJ6yJMaQPx6GERzuHZnG8FVacMhnzi0aZeMf4c/M=;
	b=VVxcX7BxbGok13NCytw5aQZGpKb+BARUpgusVQ7yHKFmlp4TC1pfZGKGn9NhZo5EYigVQy
	GfpHxUtL5t6YC8yrt/Lxn4Thy881HbqLZOIGi/myPTtgOYOJ8f0/nbiK8Pez4gaZ25MNNz
	tLhNqEiL5MVuEg9akXOw0NjGUAFmlfU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-381-x0pb6JNaNIulsyF7emrWJA-1; Mon,
 19 Oct 2026 18:10:34 +0000
X-MC-Unique: x0pb6JNaNIulsyF7emrWJA-1
X-Mimecast-MFC-AGG-ID: x0pb6JNaNIulsyF7emrWJA_1792433432
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0826C18015FA;
	Mon, 19 Oct 2026 18:10:32 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7542B418;
	Mon, 19 Oct 2026 18:10:28 +0000 (UTC)
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
Subject: [PATCH-next v4 0/9] cgroup/cpuset: Fix various housekeeping check problems
Date: Mon, 19 Oct 2026 14:10:11 -0400
Message-ID: <20261019181020.1069325-1-longman@redhat.com>
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

 v4:
  - Adjust a number of patches to fix issues reported by Sashiko and
    Guopeng Zhang.
  - Add more test cases to test_cpuset_prs.sh to improve test coverage.

 v3:
  - https://lore.kernel.org/lkml/20261014140548.575122-1-longman@redhat.com
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
 kernel/cgroup/cpuset.c                        | 268 ++++++++++++------
 .../selftests/cgroup/test_cpuset_prs.sh       | 248 ++++++++++++----
 4 files changed, 381 insertions(+), 140 deletions(-)

-- 
2.55.0

