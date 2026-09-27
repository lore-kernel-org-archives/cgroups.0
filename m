Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7D1414435
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 16:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790526935; cv=none; b=atEVZBV4pMs0rj+L8jL4BrA+Di/avFXI6POQ2vLS2a6GLxxcxvwtFFZu92X8I3V2DPhTrgysSiihoV/ZcEj0Njo/G2G+c+pQP7gy5fxpVaIciaBWGxxEL1h7/rElwMe5R8UTIwxMNLG+5+JLz4/FYYkkMSLFCXeopcsKk00tLWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790526935; c=relaxed/simple;
	bh=MbqhlpzCHKe5FmLCcvgiwSkwvIf21Z7Pc0TWdER+LE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bLJYcONTUzQNlKPv4Ggbj3nYGWvWDcDIxgKf04zVu1nhVWspAXPYhQsxqRbgWvREZUwhS3MvnjxrVbQlNcKtdUVHhKCtr0L7B3X1r9jq+EF6uSzp1JQVhONaAi3ahPFuUPcF8GNM92B79SxwHRflFHGXLv9OLQaUjaULSlDknVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VcZ8E58u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VcZ8E58u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790526931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9UMU9pfGiHmwTYEcnkiQh2ToIRkXavMaQAYmGM1hHWk=;
	b=VcZ8E58uCPsndNTIMUebqu3DOSa5eSCGsoL+Ojb3wCeAJ7eIv1PJZt/BxQ9F+v+W8vwWLc
	E3MywG0xBnzLQ3Gvn+ToJwmkYh6K4FEoXFiWI2HJlZcEpidjrdSmJKE7zOr0dQfUwOogke
	9sRLiHXAot5/J1eHXCFdSml1uTV874k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-lciSn_CUO3iwxfaND65AWA-1; Sun,
 27 Sep 2026 12:35:30 -0400
X-MC-Unique: lciSn_CUO3iwxfaND65AWA-1
X-Mimecast-MFC-AGG-ID: lciSn_CUO3iwxfaND65AWA_1790526928
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D0AC1955F05;
	Sun, 27 Sep 2026 16:35:28 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E78A141D;
	Sun, 27 Sep 2026 16:35:25 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next 0/2] cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root only
Date: Sun, 27 Sep 2026 12:34:52 -0400
Message-ID: <20260927163454.345463-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

When testing some upstream cpuset patch, it was found that the current
SCHED_DEADLINE shrink test in validate_change() can incorrectly get
triggered due to the fact that the exclusive flag may get set on a
cpuset that is not a valid partition root. This series fixes this
problem by making sure that the test will only be triggered on a valid
partition root and remove the now unnecessary code to handle the
exclusive flag in the v2 code.

Waiman Long (2):
  cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root
    only
  cgroup/cpuset: Remove CS_CPU_EXCLUSIVE handling code from v2

 kernel/cgroup/cpuset-v1.c | 20 ++++++++++--
 kernel/cgroup/cpuset.c    | 69 +++++----------------------------------
 2 files changed, 27 insertions(+), 62 deletions(-)

-- 
2.55.0

