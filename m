Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794240573;
	b=TdY+TpQL2CDOEV52tMXgyfwdf1yRjxRfRwJU/g5PknD0EzZW10zvZq80VKgexWBOy8Fd
	 eRdpFtSWjGriqvXiV6+6pLkVunbMVaWerhZKIPYWZr8PtKLeam6HoXgs+pjvXR6vteO3d
	 5LipETzknkgD2hyJUqllU+OcNA2801X8jfQWSiwsAnzphVLorZyUnxBM4G/PlUQJDK2cu
	 EhCVN1PuR01XShxMEba7aeAOhISyCLti2o3kMfYfpsg+/Hc3CxZU+RWBasm5OE7jKwtWf
	 YTBNzlgMpioE/pS4lUZqee83QvC/l0T52UDoEK1nEkW39TmunS+C6ibV/mQaD+tUsbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794240573;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=oUBECy7Kye9hL8xkXSPQ6hpNWvgAWLC7yF5gCgHsvsU=;
	b=2XYkZRqguvkA9jm5fwvfqfiEt4ZHEdNoBnxU5NKY19dvDlr3iIE9SjYfmf8KMglb0J5e
	 vIfmqCAZxvzfZA/HVTqG82iW2ifGaKipBZd4PrUFD7M0bOaHnWAg7p5/fkbN4mAPwn24J
	 LQ1Ko4WpO9PGGmK5Y2ITS7JqSLObHDbQa1kZVcjXVw8tfg89lnXAM9NddhovilOX1wzoZ
	 cHqMdAFVoWAoMx8AZYNrR7QW98Hz0BdNY6GpvAKR0YECdk6Rg8hwmNsFcV+twmxI2UT53
	 dViwAhrZbMNY7dAqD/rAHn3mBt5ClZjG9asEPQRsVtV6DuFVzy76IVrCGTTY1+Bt7lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZZRzFvqw;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76229606A31C
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:09:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76229606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZZRzFvqw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794240571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oUBECy7Kye9hL8xkXSPQ6hpNWvgAWLC7yF5gCgHsvsU=;
	b=ZZRzFvqwOE92O99g/PeJyf5lkyUEPQw695PydHl6lJkyp7rgkM0mTWpB6jXo0g4c6kwdd9
	z7VOdvknH/L/bpfzzzv7ARylyBSZH8I4F0syaJFM8MNtxZ8Mk9ez8fUFg3hQe2j1cSsjbQ
	4+iv8MtWIzYbSpekLQf5rz76MgZV7rg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-Q3ant5ugPyC2v36aBQvWSA-1; Mon,
 09 Nov 2026 11:09:29 -0500
X-MC-Unique: Q3ant5ugPyC2v36aBQvWSA-1
X-Mimecast-MFC-AGG-ID: Q3ant5ugPyC2v36aBQvWSA_1794240567
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13E60195607D;
	Mon,  9 Nov 2026 16:09:27 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9745E26C;
	Mon,  9 Nov 2026 16:09:24 +0000 (UTC)
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
Subject: [PATCH 0/5] cgroup/cpuset: More fix patches
Date: Mon,  9 Nov 2026 11:09:07 -0500
Message-ID: <20261109160912.1369897-1-longman@redhat.com>
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

This patch series contains an additional set of cpuset fix patches.

Waiman Long (5):
  selftests/cgroup: Fix "test_cpuset_prs.sh -v" failures
  cgroup/cpuset: Fix incorrect partition invalidation logic in
    cpuset_hotplug_update_tasks()
  cgroup/cpuset: Protect current->mems_allowed read in cpuset_fork()
  cgroup/cpuset: Correctly set cpus_updated in
    cpuset_hotplug_update_tasks()
  cgroup/cpuset: Correctly set isolated_cpus when switching partition
    state

 kernel/cgroup/cpuset.c                        | 66 ++++++++++++++-----
 .../selftests/cgroup/test_cpuset_prs.sh       | 20 ++++--
 2 files changed, 63 insertions(+), 23 deletions(-)

-- 
2.56.0

