Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE5C3B7B71
	for <cgroups@vger.kernel.org>; Fri, 26 Jun 2026 18:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782499060; cv=none; b=VezEyDWqvUfTJu3+14mpn70RffTYI0sDswqx9yfA5gJjy0KhuSPk+qis1KNmJbGNQgbIWLQ4WbMbXZa7FIFuPeGSFR+A+VZofRDn+GzvO9uOO3h2+D89FKI9gdsm1qUeZmn/h5vQQYXxZxqbFTwrj38zp7qQ22Ga7wxrY74kV0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782499060; c=relaxed/simple;
	bh=mXjcUTmDVowFnF9K3FeEzkTX3raWKMYk0w6ariuPN1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4GWuZV4uIrgGjD2CdFi0IzoKUxlIAUFDXBJY7QmQpVBhqQEhIMLkNhcUr1W0nVOK/wyhTdORLGa7AM0vG0zQM5XGftZZMlyDLoqjtNXsfs+jHnNzefCoJokrSAXDTBwhoMbFdI54HgvlAQRepbjHnW1q8RJBehESeE3ImZ32UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZjTKjyTu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZjTKjyTu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782499058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j1M2Kx3NvMzhbZMhdtI1I3GYyt89oduJLnaewNi/5PA=;
	b=ZjTKjyTu0bLUpIOqS9on6OAOOyswjxWFHWGNZF0VlspIMFB51YUuWYX0olXWASps49b1g7
	h0u0VBu8jgZngyU6HXDfaSc6PkWvWdReuMsNWm2fqHuDDZaBXY5kwgEm+uF99/mFWzUlEr
	MKY25GdSHvIfk3EM9PYGohSJp02RCkU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-170-w3zl_Y3lOa60FNxNfpLSSQ-1; Fri,
 26 Jun 2026 14:37:35 -0400
X-MC-Unique: w3zl_Y3lOa60FNxNfpLSSQ-1
X-Mimecast-MFC-AGG-ID: w3zl_Y3lOa60FNxNfpLSSQ_1782499052
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B98C1955DC5;
	Fri, 26 Jun 2026 18:37:32 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.2.16.156])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 637B519560AB;
	Fri, 26 Jun 2026 18:37:28 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Aaron Tomlin <atomlin@atomlin.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	David Hildenbrand <david@kernel.org>,
	Waiman Long <longman@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH v8 01/11] cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
Date: Fri, 26 Jun 2026 14:19:13 -0400
Message-ID: <20260626181923.133658-2-longman@redhat.com>
In-Reply-To: <20260626181923.133658-1-longman@redhat.com>
References: <20260626181923.133658-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Farhad Alemi <farhad.alemi@berkeley.edu>

Creating a child cpuset where cpuset.mems is never set leads to a div/0
when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
CPU hotplug event.

Reproduction steps:
 1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
 2) Move the task into the child cpuset
 3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
 4) unplug and hotplug a cpu
      echo 0 > /sys/devices/system/cpu/cpu1/online
      echo 1 > /sys/devices/system/cpu/cpu1/online
 5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
    call to __nodes_fold()

The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
nodes to the rebind routine.  Use cs->effective_mems instead, which is
guaranteed to have a non-empty nodemask.

Closes: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/
Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
Suggested-by: Gregory Price <gourry@gourry.net>
Suggested-by: Waiman Long <longman@redhat.com>
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Acked-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: stable@vger.kernel.org
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e53f35e2726f..49d8564d1a48 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2671,7 +2671,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
 
 		migrate = is_memory_migrate(cs);
 
-		mpol_rebind_mm(mm, &cs->mems_allowed);
+		mpol_rebind_mm(mm, &cs->effective_mems);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
 		else
-- 
2.54.0

