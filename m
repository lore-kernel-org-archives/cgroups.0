Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795230852;
	b=GDbutrBvjsRWospBQxO3ud/ga5T0n8zuO2RgTfzMwViAWFLuAyuObXBbunN2AlacCvW3
	 RLtlh/pap25CWAuDAgZxiYPaH4PsYqMxfeZQ4jjZRjsVJDcoWn8XC2uch/zq5TZZvc3lf
	 o8TCTDE+53a3r+riGnhjsT5XzNkiAWIwGxjPoseHHNJ5wnWQlkZxiZVP6ag6bLMB1ccIn
	 DbLtGK68PIsq2+OPwaHHraThQoquSjYmjHCU0NPKGpiOGEmgZDtfiwkSRruNCm1V7Y6/+
	 KHtl5Tpi/Ig2sWzZ7Em5HCrQF/xu27SwY52Jn6ecwawAaCXugIt3JyGJbOf1PSmWzbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795230852;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=w/twyn5fL4Un2evBmHGKFGo65M7JVmRl736VHcYrZPU=;
	b=oIJNDe2ks/11Z0bCvmyXIL/ChwMWRTOIm+Ub2Kq8zfau3aNzc1pb/Nt+TI0C/i3ebj1q
	 ApJqo5S5bh/hq3ZbA1ii9WIiHrZtJPVnibgC6o8zKNT49KSvOxjxsbOtARc/RgiGIgKDV
	 fh/O7znDttDfEKtkb8HFcCCYwpVXqaT9kFDJvlLRMMrv60gbYwLza/RK1y4WAMYhEQf3w
	 icOG8ubeLIKSlCC6yvcln97EK3DjTYATz9W/xO0v3giS+CJvt9S8Unj1eCc3HFiVLeJgQ
	 cy9cOW/cSjgM9dCVaJqC2hj1MBKcjbHzPNn5AWWorvo0yJ4+AeEwL0aABG55/zsYWfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=M6OkDt9o;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E010606A698
	for <cgroups@vger.kernel.org>; Sat, 21 Nov 2026 03:14:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E010606A698
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=M6OkDt9o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795230849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w/twyn5fL4Un2evBmHGKFGo65M7JVmRl736VHcYrZPU=;
	b=M6OkDt9oEwuYXjJnzSvsZLYN6dSbAnaULc3LLul8I8Csw2WroZ2eXKZkpDF+g9UMcjHoPR
	/zi6En8xo4SodRlUqasq5sTkNbEeavnYaONNRMCJv+Rc6a0T/ld90Z5ySi0HeXKdUaWFN0
	W5wKFTSMn7x+zHRL1Coft9xxOcB796U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-338-MXA2E3_bPqS-dh1paShKgQ-1; Sat,
 21 Nov 2026 03:14:05 +0000
X-MC-Unique: MXA2E3_bPqS-dh1paShKgQ-1
X-Mimecast-MFC-AGG-ID: MXA2E3_bPqS-dh1paShKgQ_1795230842
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56AD0195608B;
	Sat, 21 Nov 2026 03:14:01 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 517701956087;
	Sat, 21 Nov 2026 03:13:56 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next 0/3] Skip boot CPU or don't allow it from being used in isolcpus and isolated partitions
Date: Fri, 20 Nov 2026 22:13:26 -0500
Message-ID: <20261121031329.240177-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

It is reported that having CPU 0 being domain isolated can cause
problems in the some kernel subystems which don't take into account
that the boot CPU (CPU 0) may not be a HK_TYPE_DOMAIN housekeeping CPU.
As a result, it makes sense to just disallow CPU 0 from being used
in the isolcpus=domain boot parameter as well as in cpuset isolated
partitions instead of trying to fix the problems when they show up.

The first patch fixes the inconsistency problems between
tick_nohz_full_mask and HK_TYPE_KERNEL_NOISE cpumask.

The second patch removes the boot CPU from the isolcpus=domain parameter
if set.

The third patch disallows isolated partitions from being created if CPU 0
is specified in its effective exclusive cpumask.

Waiman Long (3):
  tick/sched: Make tick_nohz_full_mask and HK_TYPE_KERNEL_NOISE cpumask
    consistent
  sched/isolation: Forbid the boot CPU from being isolated
  cgroup/cpuset: Disallow CPU 0 from being used in isolated partition

 Documentation/admin-guide/cgroup-v2.rst       |  1 +
 .../admin-guide/kernel-parameters.txt         |  7 +--
 include/linux/sched/isolation.h               |  2 +
 kernel/cgroup/cpuset-internal.h               |  1 +
 kernel/cgroup/cpuset.c                        |  6 +++
 kernel/sched/isolation.c                      | 31 ++++++++++---
 kernel/time/tick-sched.c                      |  8 +++-
 .../selftests/cgroup/test_cpuset_prs.sh       | 43 ++++++++++++-------
 8 files changed, 74 insertions(+), 25 deletions(-)

-- 
2.56.1

