Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB153C1F3A;
	Sat,  1 Aug 2026 19:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785611445; cv=none; b=TvymPukG41RtVOOIWYD92iJYjMroa78D95XJTp8o/ndCt0+LwgzIdabJQmStzpHbCEW6skETsMr3XWTm2acB2Ymf/vB9IVdko2wxetxEhHs+27tn7uTwSwXcw7rKhCNM3S1qPbGk6CGYYBONrTdRzQN00dOuuWtQVq9OG+sO9ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785611445; c=relaxed/simple;
	bh=P3tZ6N4jfvIjmreQ/C1Nm8WD8ULfJ+rus7cOhDSIgr8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SVbq827mC9Pibq5sylSq8GpKBSuz3Yz3ruB6xvyopRtj7ARJQz1nqPlNaTOrIqCfmhbNY9rpN9PeCFZeCxvD0Gy8FpJpPC1DJdq/E7EMKWbRnBVx25ofqCow+7QIULGiaWdOo+mT3PO0L/RVUMv8eZ2VN+XMqdn7ShTm8jYCmfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=f1OPetO9; arc=none smtp.client-ip=192.134.164.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="f1OPetO9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Fg5ZBoBgQD/Kd4IP5851d3w/Ypie/cGCCmYEWrWBmJg=;
  b=f1OPetO9CY/vFBhKFK9eps3SYYmfGe+Fbe2Gqh2KM2dyrHv7/2ta+CuP
   ueI7sHE4VYiRnjvDS/ZmsDuKWY/hexGUaocw73qF0lSpJ5JTF7RMemPOl
   eJ+TEY0hcASRlJ4Li69NHSRM2Hcsz4ErQL17T820a5yolQZIN0h356FLM
   c=;
X-CSE-ConnectionGUID: NeZmu1LFT52lR8/Z6HTLYg==
X-CSE-MsgGUID: xE/8NFJxRr+H0rotXr+obg==
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.25,198,1779141600"; 
   d="scan'208";a="288769011"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.102.196])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2026 21:10:08 +0200
From: Julia Lawall <Julia.Lawall@inria.fr>
To: Tejun Heo <tj@kernel.org>
Cc: kernel-janitors@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cgroup: drop unneeded semicolon
Date: Sat,  1 Aug 2026 21:09:55 +0200
Message-Id: <20260801191002.1383835-9-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a function-like macro expands to an expression, that expression
doesn't need a semicolon after it.  All uses have been verified to
have their own semicolons.

This was found using the following Coccinelle semantic patch:

@r@
identifier i : script:ocaml() { String.lowercase_ascii i = i };
expression e;
@@

*#define i(...) e;

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 kernel/cgroup/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 38f8d9df8..f87fc4550 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -104,7 +104,7 @@ DEFINE_PERCPU_RWSEM(cgroup_threadgroup_rwsem);
 #define cgroup_assert_mutex_or_rcu_locked()				\
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&			\
 			   !lockdep_is_held(&cgroup_mutex),		\
-			   "cgroup_mutex or RCU read lock required");
+			   "cgroup_mutex or RCU read lock required")
 
 /*
  * cgroup destruction makes heavy use of work items and there can be a lot

