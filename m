Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792964718;
	b=nLOVcSp3VILzveb8E3Q6cQeq4mcpkTxGP9u2M42DEa5xQDNT2b7olJLSEdOkG/HTTaTA
	 4H4gkLo1IkufBi7C6/Boj6SQ3Z+IwZxjJ/NWhE6XB4pZ/qUf2wZhaf7SQaiqit4zR15k8
	 8AR0t/cgn0aDxSxA6ACkfoR6JyZxov8j2yMxe5bjtDOmFgVLWMzKIoxHhKFqWeIuHix9o
	 /b4zmaQ9UYYZITPqoTXAHwNIchLc0ccEwfSn/P9lqxFZ6X20hvBiKYK+8l+IT86XBDh4m
	 BLYh0PLis3vPvG05b5NTR3gCoqoZDt0uR0zt09+mo4CdwqxKKrgN0SQymW3oy5MOi2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792964718;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=pHj1zr5ZQvp+0WHwshSy5opjd1aOuZJRXDEaRaa1IWU=;
	b=zLUVwpgpJu79TYtfhxlYaK3ng4P55bS8t3vHcL4XB1njUmiwDZc9Q6+8B1aTKKLjGNr0
	 yHQaBFP7xJC/aEFzZ+lAzHPBXZR/YzV4zNPqGlio4EDv2up6QzyH/T2R0DwtRSidwUpyP
	 qi5seMScD/yQV5Dizeho0e5+d7RbPTxG1nqSQmT6NOunaM2skF77f0mtL78YvD3yxEDsj
	 O0UhsBF0LrmAudnjkRMjjkOfwpnK8L6dvxK/3ktzWCxoaMmIxGmIPHCFxxR4NQQ7vU4HO
	 /anbnvgMhCORGIwYL2aBqxKOHPsAQgHHSk07g2sM6EAgG/KkPjGrEqqjJojy/HGj1rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Un70kx4K;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44425606A31E
	for <cgroups@vger.kernel.org>; Sun, 25 Oct 2026 21:45:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44425606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Un70kx4K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792964716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pHj1zr5ZQvp+0WHwshSy5opjd1aOuZJRXDEaRaa1IWU=;
	b=Un70kx4KV1UHjvz1jN1UwaCiFj5193mSdB2lEkgrI4kqeCxxiQekre+c/qzQfg2kPIiVvp
	vsm+/r6sr09oGtGRMs4q+G18Fjpzv865Ez6ynVx5JVg4qrjIag50M5sLB6sGe+s41w16u4
	0uxUt1oe1JctuectwewwIgMNSlwa2BQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-8Pt6mSaZMzOrFf98ql_ruQ-1; Sun,
 25 Oct 2026 17:45:12 -0400
X-MC-Unique: 8Pt6mSaZMzOrFf98ql_ruQ-1
X-Mimecast-MFC-AGG-ID: 8Pt6mSaZMzOrFf98ql_ruQ_1792964711
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0ECA1801351;
	Sun, 25 Oct 2026 21:45:10 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A616A1956089;
	Sun, 25 Oct 2026 21:45:08 +0000 (UTC)
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
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v3 00/11] cgroup/cpuset: Miscellaneous bug fixes & cleanup
Date: Sun, 25 Oct 2026 17:44:38 -0400
Message-ID: <20261025214449.310715-1-longman@redhat.com>
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

 v3:
  - Update patch 1 to further encapsulate the code to release isolated
    CPUs into a new isolated_cpus_release() helper to replace
    furthest_isolated_ancestor(). Other than adding a remote partition
    break, patch 1 should be functionally similar to the one in v2.
  - Add more comment and some minor adjustment into patch 2 to make
    the exclusivity rule apply only to invalid partition with empty
    exclusive_cpus.
  - Add a new fix patch "cgroup/cpuset: Release invalid isolated CPUs
    with a shrunk root partition parent" to handle isolated CPUs release
    in update_parent_effective_cpumask().

 v2:
   - https://lore.kernel.org/lkml/20261023200036.60560-1-longman@redhat.com
   - Update patch 2 to resolve problem reported by sashiko and Guopeng.
   - Add 2 more fix patches to resolve problem found by inspection and
     sashiko.
   - Add 2 more cleanup patches suggested by Ridong Chen.

This patch series incorporates 9 fix patches for problems reported
by sashiko, Guopenp Zhang and by inspection. The last 2 patches are
cleanup patches suggested by Ridong Chen.

Waiman Long (11):
  cgroup/cpuset: Find furthest isolated ancestor for invalidated
    isolated partition
  cgroup/cpuset: Properly compute effective xcpus in
    update_parent_effective_cpumask()
  cgroup/cpuset: Fix incorrect effective_cpus bug in
    update_cpumasks_hier()
  cgroup/cpuset: Minor fixes to prstate_housekeeping_conflict()
  selftests/cgroup: Check for a single range nohz_full CPUs before
    running test matrix
  cgroup/cpuset: Prevent recursive call of remote_cpus_update() via
    update_cpumasks_hier()
  cgroup/cpuset: Make sure compute_partition_effective_cpumask() is only
    called for valid partition
  cgroup/cpuset: Release invalid isolated CPUs in
    compute_partition_effective_cpumask()
  cgroup/cpuset: Release invalid isolated CPUs with a shrunk root
    partition parent
  cgroup/cpuset: Relocate compute_*effective_cpumask() and
    compute_effective_nodemask()
  cgroup/cpuset: Integrate compute_partition_effective_cpumask() into
    compute_effective_cpumask()

 kernel/cgroup/cpuset-internal.h               |   5 +
 kernel/cgroup/cpuset.c                        | 505 +++++++++---------
 .../selftests/cgroup/test_cpuset_prs.sh       |  33 +-
 3 files changed, 298 insertions(+), 245 deletions(-)

-- 
2.56.0

