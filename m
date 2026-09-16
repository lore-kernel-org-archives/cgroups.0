Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4288E4E56CB
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 12:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563494; cv=none; b=ult1OSPSgoaZKzNZ7wYi1hW3pEbsTq1MziRDYFZIespcGOpX2uZjuedUzjkANSKneuVSpyxct5H9GdY1YB/aPOi8MbXqVfi1eN4isOjjpXjusNygesJDneStHyIoA5WdcHAV8Smu3y1cP4KsaMTkODLBi+qPDqVtxm6fCBTtmmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563494; c=relaxed/simple;
	bh=bdXVZ1Kbw6bqlFSxE/MaNfB3RIbM8xtQX+eZUVejI94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhmeagA02FaSdHSCTOiDtEN1mqyLbhdHyX89mJhdO9Cf+yJnnPTOx0GvwHB86Pb0Ubj+smDWaEy6vI4LG/LZO/l5WP1b0ysH6YGDLcjBhb0Hiej3iq/WeUXJHNS7syx42AYtFrWw1OklHEfpE/ObYuwsfD1G7VJVf4tUTL2+twg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pq2dSTG7; arc=none smtp.client-ip=91.218.175.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pq2dSTG7"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bdXVZ1Kbw6bqlFSxE/MaNfB3RIbM8xtQX+eZUVejI94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789563490; v=1; x=1790168290;
 b=pq2dSTG7Q95TTIaQMizi0n5RB6McC4WDKKzoXmE6vWjaxc4iTbdPjsYAgbCeHS8ppbsrWyw0
 tJQD6nm9hEqxjd0k9itvXFOfG4DJY6pCv488cr2OfNVNLxap8Qa2jm0fb9BMhtZTjwrhp3hJOpr
 +lbceArzVhgaKTqo2denBr9w=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9a5d3f7511db98d0;
	Wed, 16 Sep 2026 12:58:10 +0000
X-Mizu-Trace-ID: 9a5d3f7511db98d0
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 3/3] docs: cgroup-v1: note the v1 memory controller implementation boundary
Date: Wed, 16 Sep 2026 20:57:37 +0800
Message-ID: <20260916125737.1095414-4-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916125737.1095414-1-cui.tao@linux.dev>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Document that the legacy memory controller is now isolated behind
CONFIG_MEMCG_V1, with its state in struct mem_cgroup_v1, and that new
functionality belongs to the v2 memory controller.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 7d2a44af52c9..2eff1dc6e13b 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -8,6 +8,13 @@ Memory Resource Controller
       here but make sure to check the current code if you need a deeper
       understanding.
 
+.. note::
+      The legacy (v1) memory controller implementation is isolated behind
+      ``CONFIG_MEMCG_V1``: its interface lives in ``mm/memcontrol-v1.c`` and
+      its per-cgroup state in ``struct mem_cgroup_v1`` (see
+      ``include/linux/memcontrol.h``).  New functionality belongs to the
+      cgroup v2 memory controller.
+
 .. note::
       The Memory Resource Controller has generically been referred to as the
       memory controller in this document. Do not confuse memory controller
-- 
2.43.0

