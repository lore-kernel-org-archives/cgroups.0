Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197CE282F16
	for <cgroups@vger.kernel.org>; Sun, 12 Jul 2026 15:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783868503; cv=none; b=bExqrb+ViYcWuTeslwyp29anfc5IWbIfWylgToblCifaOQsNDBoCI+Cv6tZuPDkmnR4Wz2X5Q4mVYMF0MAyL17OzemoZOM9RTdKQljxjPwxfrg4AnP7UaZevxVFVCN9Wuh2c8TBZZlBiRvOXv4o7qxlRJkHjmcdaX199/SipTgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783868503; c=relaxed/simple;
	bh=P5ocRm25zAG+HxZL+Y6QENHLjkKhN2fEWajfcsIde8A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n33hlPLKmsqh4XaYp7idSumT/Ss0JI3m+Z7kM4YPAUk/z1qoiZduu5NXVyEYbNL4OnasbsKXPl+ZVplbnrZdeQDVe6/Cuwohv2BezSLyNYui260S3gkFxX+yQFlX20m8o/CZLj+VP/ZSO/ZZdT38eq/F48uJVX+0j4wwwOm4ges=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IHLCpuqA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IHLCpuqA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783868501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WJYwqagu9WHsJWgv4HkLcS30bz2gxDzF3vSIDOR0Q8M=;
	b=IHLCpuqAqJqpfCYmUJwMHzT+bD22Qgk8ZX5dUoQy0/b7UuWvXkkKWvmT9Ms+lcjVfZaAzq
	wsev6DOFgn3e2j1a8sFh83DSAXhK4oXRuKeUmyvKdFgaXTddYHPfEJrq8WoaB57jlsxJeP
	ViTl7KEfzcwsY/xPEM7j9h0iPuwKD3c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-30-TeR0nH3tPUexB58C00cFJw-1; Sun,
 12 Jul 2026 11:01:37 -0400
X-MC-Unique: TeR0nH3tPUexB58C00cFJw-1
X-Mimecast-MFC-AGG-ID: TeR0nH3tPUexB58C00cFJw_1783868496
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B04771955DD2;
	Sun, 12 Jul 2026 15:01:35 +0000 (UTC)
Received: from llong-thinkpadp1gen5.rmtusnh.csb (unknown [10.22.80.43])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AC0AA3000B50;
	Sun, 12 Jul 2026 15:01:33 +0000 (UTC)
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
Subject: [PATCH-next v2 0/3] cgroup/cpuset: Support multiple destination cpusets for cpuset_*attach()
Date: Sun, 12 Jul 2026 11:01:24 -0400
Message-ID: <20260712150127.236790-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

 v2:
  - Make sure that attach_ctx.old_cs won't be set to a source cpuset that is
    also the destination cpuset.

 v1: https://lore.kernel.org/lkml/20260711020540.176740-1-longman@redhat.com
  
This is a follow-up patch series to [1] to properly handle a special case
for cpuset task migration operation where the source and destination
cpusets are the same. Patch 1 handle this special cases by skipping
tasks are not migrating with respect to cpuset. Patch 2 enables
cpuset_*attach() to handle the case where thare many destination cpusets
which when a cpuset controller is enabled. Patch 3 adds a new test case
into test_cpuset to test proper handling of cpu affinity when cpuset
controller is disabled.

[1] https://lore.kernel.org/lkml/20260702214757.579012-1-longman@redhat.com

Michal Koutný (1):
  selftests/cgroup: Add test for cpuset affinity on controller disable

Waiman Long (2):
  cgroup/cpuset: Handle the special case of non-moving tasks in
    cpuset_can_attach()
  cgroup/cpuset: Support multiple destination cpusets for
    cpuset_*attach()

 kernel/cgroup/cpuset.c                       | 131 ++++++----
 tools/testing/selftests/cgroup/test_cpuset.c | 243 +++++++++++++++++++
 2 files changed, 321 insertions(+), 53 deletions(-)

-- 
2.55.0

