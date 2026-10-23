Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785652;
	b=IqFZv/m76B/E561h3bUteoAQYlbK5E+8ig7YMfWDKC+QdqcjSr3aWDNGC0fPJUhpqxtd
	 4Ho/PGdSmd9k02Zy0q4aTDNs1pwbu6pPK50rJPSiBvnWTnUUBG9W1bp7U3PAenVPeLWec
	 AtIVTOvYsmJ9V5DWtNso5LSdrd8keL/W7jjw1NTsTuIqA0uqTfAoOJU69i5gYBpllo03b
	 gqPSqcLQwa7uEMcsEf++5eRjyg/ZH3N3Wm3aogcxdtl/VHEBUj3pxXG98qwZmKAs+xvMi
	 Dj7mOWjnOaPluKnca+wSSy0ZErYEvaNMLjt0w4UMy5VwkfeZriVoGCzFBmnKUYtY0zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785652;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=LOjczTFU62fH5OmF+0SVjvko0moJ0Pzk+EdY7j/COVg=;
	b=uuruHpl1Xzg8+mtNrvhcFPKa/AYQ3U/ODnHIOuS3w76cI+b1O8OpbIn/HSW57kAiegtw
	 cNzoJuaUhUayg8qYIGR+feVbqrsxE4HMvsPKuvCJRkXsfzOgEtQyCpsU1w9ngbT3vNkVH
	 VSCwBIxVW6J7oT4uYAqOhdjeAZeTB9i2zRMKywFYynqcNwxgASOfcA9oAGpTWneuX7FZL
	 G0s2QNNbG8ppe2MD690mP/7oB6KTt2O/g9qv1MPSwxqjrFUnNSFVbojsAnyQq0k8hOmeq
	 otOXGSOLpq+czd79MfLoGGGQDUwl2Nr4r7UtWOrtC2uh6aZAL8n0fUT5n2Mwj49p9/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=a0ZkUgny;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86872606A31A
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 20:00:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86872606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=a0ZkUgny
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792785650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LOjczTFU62fH5OmF+0SVjvko0moJ0Pzk+EdY7j/COVg=;
	b=a0ZkUgnycYNyXjzy5kKHaVaiIya6VE822RWmMZKB6cF0+d2bAVB1gzRSjcaQ5hTzuVebc6
	FfTIwLEQ5TK2MVk99sX13GT+lT3mf7p2XTlaLc3A7JM1E8nTCNzO6K4G5AWxCizoe5ZiUF
	W68DokE2IhTydbK+FVoLVY/ZwMoAKzM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-132-q3lSk8OqMrec9_RfDsozlw-1; Fri,
 23 Oct 2026 16:00:49 -0400
X-MC-Unique: q3lSk8OqMrec9_RfDsozlw-1
X-Mimecast-MFC-AGG-ID: q3lSk8OqMrec9_RfDsozlw_1792785647
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DACC01955DC2;
	Fri, 23 Oct 2026 20:00:46 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BDBAA1956088;
	Fri, 23 Oct 2026 20:00:44 +0000 (UTC)
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
Subject: [PATCH-next v2 00/10] cgroup/cpuset: Miscellaneous bug fixes & cleanup
Date: Fri, 23 Oct 2026 16:00:26 -0400
Message-ID: <20261023200036.60560-1-longman@redhat.com>
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

 v2:
   - Update patch 2 to resolve problem reported by sashiko and Guopeng.
   - Add 2 more fix patches to resolve problem found by inspection and
     sashiko.
   - Add 2 more cleanup patches suggested by Ridong Chen.

This patch series incorporates 8 fix patches for problems reported
by sashiko, Guopenp Zhang and by inspection. The last 2 patches are
cleanup patches suggested by Ridong Chen.

Waiman Long (10):
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
  cgroup/cpuset: Update isolated_cpus if necessary in
    compute_partition_effective_cpumask()
  cgroup/cpuset: Relocate compute_*effective_cpumask() and
    compute_effective_nodemask()
  cgroup/cpuset: Integrate compute_partition_effective_cpumask() into
    compute_effective_cpumask()

 kernel/cgroup/cpuset-internal.h               |   5 +
 kernel/cgroup/cpuset.c                        | 409 +++++++++---------
 .../selftests/cgroup/test_cpuset_prs.sh       |  27 +-
 3 files changed, 231 insertions(+), 210 deletions(-)

-- 
2.56.0

