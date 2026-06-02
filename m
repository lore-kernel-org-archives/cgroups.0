Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9153E8C55
	for <cgroups@vger.kernel.org>; Tue,  2 Jun 2026 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780409313; cv=none; b=j3ma6eu3o2FXjzaEEEue+Ydw7zcVFK3Q8xR3BvJUN1kcFPBDtKdkNuZSlI0UFoOcBfe4zL/rHqmI7BdRhzCCUHI/zby4YFxjWNgxNaNrS9CIC41NksniGiysyONzp4DAZx4TsYVJLxqzzsoLPGPejey1721oZfoERwZjXpiqWSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780409313; c=relaxed/simple;
	bh=45FTODGfxeZksKjF8YtW3aN8gYQw5xae1kNsF9SFnwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D/UvlGIT9HXoBV2U2DojFuj87TJ16aMNCknXxMUReImxtWQWHEMiTudtKanFKlT0Tc5ETdZ9JPE6WsIWbfbrLbAp+dqV0vDzBXcsNiA8WADxwatK+3XHSqvK4XO7ZuYXU2vVZ61jbCWvGI3acD6dbRFvAcFjohUgfpZp4PVTjyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cCsU2LJt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cCsU2LJt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780409311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NrP+90gZERq3weo5ikhs73u7wrFza68VLSMqYpLuit4=;
	b=cCsU2LJtEr8lxDGvvwyiaOVsw0DtjA1JWLaxzrMNWGvYWdEQfGlvsoVQTTrhtR8T/bR+Sb
	G3FSYWJsbknx9/NAF5Ft4Yp3F92Nfu0Blw2bt0Y02z+TnM+rlgRcYtcr1eoF5mvcEdVbdT
	pqIiXnIRlcad+1bU+vdQU6wFDOIDSvQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-299-mrXN9fLVP0asoc-YCEtSLw-1; Tue,
 02 Jun 2026 10:08:27 -0400
X-MC-Unique: mrXN9fLVP0asoc-YCEtSLw-1
X-Mimecast-MFC-AGG-ID: mrXN9fLVP0asoc-YCEtSLw_1780409306
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 405171955F19;
	Tue,  2 Jun 2026 14:08:26 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.80.32])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8F71019560A6;
	Tue,  2 Jun 2026 14:08:24 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v2] cgroup/cpuset: Change email address of Chen Ridong
Date: Tue,  2 Jun 2026 10:08:19 -0400
Message-ID: <20260602140819.265274-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Chen Ridong has contributed quite a lot of fixes and cleanups to
the cpuset code. Recently, his email address has been changed to
ridong.chen@linux.dev. Update that in the MAINTAINERS file.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 74c86cf9bc65..634eb67acd06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6526,7 +6526,7 @@ F:	include/linux/blk-cgroup.h
 
 CONTROL GROUP - CPUSET
 M:	Waiman Long <longman@redhat.com>
-R:	Chen Ridong <chenridong@huaweicloud.com>
+R:	Ridong Chen <ridong.chen@linux.dev>
 L:	cgroups@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
-- 
2.54.0

