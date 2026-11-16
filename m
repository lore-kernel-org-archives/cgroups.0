Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794792234;
	b=sULRjrHe8pNew4uOEDIHUlbUUc6xKyUAcVFUUm4sKOWq1BE99xq2t0MaClufuDvopvry
	 RUq9C4349pgfqi7aTJjrk7jR8qTfut8jCY4HZBko4x3vryLXZMbcg7dCFHvpTh8wkJ0aL
	 UrwlzyZ+8B3wTIJ//BWSh/4sJHASPJV76xcbBAWw0fIJiDnsP0nqs78a3T5xOMt6+UKA5
	 4Syg+zd1ej2lM/dOFuaMRIuO8ZDIWIwyPLWrxCWmPVZMP/XdvWdYZF7w2SkJ47yX/XLbC
	 rJLwQ228njbsUdLsows9kHw+Zo08KDgNuORmu1VJdMBLl9HflFTvFC5ElQE8REpe44A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794792234;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=7/foLeZWh6mOx/E6h1htnKBNjksry5ms+vKjgn4bpO8=;
	b=gdTT07v3gNeRM0ykDJ7ScZdNKS81k4lboJv1yLV33iCyIcM6scqfUIET349d+QdTQTvM
	 RVk6mm2uyticgYPIwJPiLZw0jyET/PNkzCKNyy6UsEGHd1vqsTizye05DgX8LPVA6fzqV
	 UP1qGn+GzhByssui489ioVwjpBbN82W6bF0WVZddC/Be5VOkwckdkffu//2LRxbGeL27E
	 z9CW8vQ+DU+HQacXjllq6CTDMK+BH8dptN7pkxekmlIC09pWAZ61LvhczDF5Lf7UE1fq9
	 p3mhEMzB2N42ZQIbDcuHGA+OKnDspC3jjyB0sKUOkWuJgpCJt8EfHyBjFRYhDXLUwNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=a+79WBqz;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E60D606A321
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 01:23:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E60D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=a+79WBqz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794792234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7/foLeZWh6mOx/E6h1htnKBNjksry5ms+vKjgn4bpO8=;
	b=a+79WBqzgOqAapglWDvgp6XWzxbaOMeqfyn72tyytNmauSzzj38nADuORYqwo7JJhvHWhd
	swt8S+LpeCW0YaJBNX3wWBB+JmfpOTmCac6X6IPUVyJ9Pt8DrEgqugh2fJWZ0b9SNQaERv
	mXbGJqQdYQmr/VzME9i7UFqnmaQjoKc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-36-uAdGMwHPM7yOni6GEiFIQQ-1; Sun,
 15 Nov 2026 20:23:51 -0500
X-MC-Unique: uAdGMwHPM7yOni6GEiFIQQ-1
X-Mimecast-MFC-AGG-ID: uAdGMwHPM7yOni6GEiFIQQ_1794792230
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EDD619560AF;
	Mon, 16 Nov 2026 01:23:49 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 21029436;
	Mon, 16 Nov 2026 01:23:46 +0000 (UTC)
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
Subject: [PATCH-next v4 0/6] cgroup/cpuset: More fix patches
Date: Sun, 15 Nov 2026 20:23:03 -0500
Message-ID: <20261116012330.2271010-1-longman@redhat.com>
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

[v4]
  - Drop v3 patch 1 as it is fixed in a different way in patch 5.
  - Add a new patch 2 fixing a minor bug reported by sashiko.
  - Add patch 4/5 to fix a remote partition hotplug problem reported
    by Guopeng.
  - Add patch 6 to fix a bug in lockdep_is_cpuset_held().

[v3]
  - Drop patch 1, 4 & 5 of v2 as they are merged.
  - Update the new patch 1 as suggested by Chen Ridong
  - Add a new fix patch 3.

[v2]
  - Reorder the series by putting the original patch 4 before patch 2.
  - Update the Fixes tags in patch 1 and 5 as suggested by sashiko.
  - Update the new patch 3 to remove obsolete WARN_ON_ONCE() and update
    comment as reported by sashiko.
  - Minor fix to the test case in patch 5 as reported by sashiko.

This patch series contains an additional set of cpuset fix patches.

Waiman Long (6):
  cgroup/cpuset: Fix incorrect partition invalidation logic in
    cpuset_hotplug_update_tasks()
  cgroup/cpuset: excpus parameter of remote_cpus_update() must have at
    least 1 active CPU
  cgroup/cpuset: Check remote partition underneath before making an
    invalid partition valid
  cgroup/cpuset: Revert "remove global remote_children list"
  cgroup/cpuset: Handle remote partitions before local partitions in
    cpuset_handle_hotplug()
  cgroup/cpuset: Fix lockdep_is_cpuset_held()

 kernel/cgroup/cpuset-internal.h               |  10 +-
 kernel/cgroup/cpuset-v1.c                     |  16 +-
 kernel/cgroup/cpuset.c                        | 178 +++++++++++++-----
 .../selftests/cgroup/test_cpuset_prs.sh       |   6 +-
 4 files changed, 149 insertions(+), 61 deletions(-)

-- 
2.56.0

