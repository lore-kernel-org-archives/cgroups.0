Received: from mta0.migadu.com (out-16.mta0.migadu.com [91.218.175.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68B1348C54
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 12:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563475; cv=none; b=pMAWMdntBdg18jtKUecLcxDaX2moO/Qv2qDK7F3NB+uZn7kgLs2CKyiQqYa4QxSg8xXTxjU4RS0cORpQ9m/bi+kN/eMaEjmf1ea6GLiIjAbXIcZbGA65FN0RafCB/dewrQOVqkMP6zhDYk8zBBdj7l5T+WLWrMwpdKoOM2YgbBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563475; c=relaxed/simple;
	bh=BDH6FArRRvE+3dLKSpGnjrGvHJG5nza7z7Yx6pA8U9k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bQisTG2VwXzmE3F6OhMRtn/HuW/DGEZn/LUC0O0YSgN1qS7U+LazhesGW0P2kalnCCJ77aEzjxrrbd6Nmk4XCrPJLpX269XxsFcaCLlwFehrorDB6lKHkrq7WE8TC/sYLyPfgMf446CFgy8XcqMA1KMjHwLJeoa98bjPfAuxhWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s4Xh1WSK; arc=none smtp.client-ip=91.218.175.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s4Xh1WSK"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BDH6FArRRvE+3dLKSpGnjrGvHJG5nza7z7Yx6pA8U9k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789563470; v=1; x=1790168270;
 b=s4Xh1WSKdwOjNiQ8eD0NOLf522d0JY13f4oPJlpsW/yoG+ECbe6bVXYYjNdsKMjoa+4HUrIC
 SZxDRESXo6Zf5xczH0y5JQBQKRdMm8kvxf7f3dXlhegtYFqjFzJuph7imecyqVUxmqjvIkDq3OT
 aUEOCFwY5HYtVpxkzrNf/4tY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 13d5477597e6c301;
	Wed, 16 Sep 2026 12:57:50 +0000
X-Mizu-Trace-ID: 13d5477597e6c301
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
Subject: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from struct mem_cgroup
Date: Wed, 16 Sep 2026 20:57:34 +0800
Message-ID: <20260916125737.1095414-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

The legacy cgroup v1 memory controller has already been moved out of
the shared implementation at the file level (mm/memcontrol-v1.c) and at
the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
per-cgroup state, however, still sits as individual members inside
struct mem_cgroup, guarded by #ifdefs.

This series isolates the deprecated implementation from the shared hot
structure: all v1-only members are grouped into a dedicated
struct mem_cgroup_v1, and every access goes through memcg->v1.X.

With this in place the v1 implementation is self-contained: its
interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
its eventual removal becomes a localized deletion of this struct
together with mm/memcontrol-v1.c, instead of unwinding
ifdef-scattered members across the shared header.

Patch 1 introduces the substruct behind a transitional union whose
anonymous side preserves the historical layout, so the patch is
semantically empty.  Patch 2 converts the access sites and drops the
anonymous side.  Patch 3 documents the boundary.

This demonstrates one possible pattern for isolating deprecated cgroup
v1 implementation from shared structures.

As a validation detail, this does not regress the layout: the member
order is preserved, so offsetof(struct mem_cgroup, v1.swappiness) and
sizeof(struct mem_cgroup) are unchanged (verified with pahole), and the
generated code of hot paths such as mem_cgroup_swappiness() is
identical.  Build-tested with CONFIG_MEMCG_V1 both enabled and
disabled, and boot-tested with both a v1 and a v2 hierarchy.

Tao Cui (3):
  mm, memcg: introduce struct mem_cgroup_v1
  mm, memcg: move v1-only members into mem_cgroup_v1
  docs: cgroup-v1: note the v1 memory controller implementation boundary

 .../admin-guide/cgroup-v1/memory.rst          |   7 +
 include/linux/memcontrol.h                    |  74 +++++------
 include/net/sock.h                            |   2 +-
 mm/memcontrol-v1.c                            | 122 +++++++++---------
 mm/memcontrol-v1.h                            |   4 +-
 mm/memcontrol.c                               |  22 ++--
 mm/swap.h                                     |   2 +-
 7 files changed, 121 insertions(+), 112 deletions(-)

-- 
2.43.0

