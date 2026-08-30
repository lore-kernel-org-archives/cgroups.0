Received: from mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5C125B0A3
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 00:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788049281; cv=none; b=PpY0ByGGu37jOFTz3eUGWt4DkyjimP8y210VSIgLU/5OyLl9kL8LiJkUgBcX7LOvPSEIjR3lovmHbv2rT6NrRh587yI917yoKm20gERHLiXN1mWCal0gI6RlvBJufESRhUDogdXdxZMMj9xchv5oW5omH6aYB8UWI+mPYvqfaeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788049281; c=relaxed/simple;
	bh=BcGgUmgJ5bToxf4lyEoXBY/SvuxrW/zu7KIJo4jPTnU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=erFxmUSFwyDgcy2TEwIbm+iTZ2p7SWTTLhJQyPOwGbYYzphbjGMlthdXIxcshrGEugTcw9eZsw7S7DFIk0rKHPok/WicUw1t8HEoYbrO3BxyLMJmSKE/Dtr3RB4oYThwaoMsSy7wFI8iR7O0i5TeP7lrO25wBnd+ESdSPTAXQNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KlLBLmwt; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KlLBLmwt"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BcGgUmgJ5bToxf4lyEoXBY/SvuxrW/zu7KIJo4jPTnU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788049275; v=1; x=1788654075;
 b=KlLBLmwto/gjzqlJIF89Z4XIEYQdlJ+FKtWtI+IiDMoEoLyeRB80gg+j0avYydWUvIDoB4iI
 pRW/+Z7bFvvh5TKOxi6acq67WBcOLkrSt1brFF2SW64B/qG4Qy+x1NK7AQr/Cni2HWJjqg60kHZ
 cU6yU3b8vPiPZjIeXIqWAL1w=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 19d959b935d34d05;
	Sun, 30 Aug 2026 00:21:15 +0000
X-Mizu-Trace-ID: 19d959b935d34d05
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Finkel <davidf@vimeo.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 RESEND 0/2] mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Sun, 30 Aug 2026 08:20:42 +0800
Message-Id: <20260830002044.1938621-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

The memory.peak / memory.swap.peak per-fd watermark tracking has two
issues. Each open fd is a watcher and reads back max(its own value, the
shared local_watermark); both bugs live in that scheme.

Worst case for both is the same and is userspace-visible: a reader of
memory.peak (or memory.swap.peak) gets a value lower than the true peak,
so a tool that sizes or bills a cgroup by its peak usage under-reports it.

Patch 1 (read side) fixes the race Sashiko pointed out in the v1 review
[1]: peak_show() inspects local_watermark and the per-fd values without
holding peaks_lock, so a reader that races an unrelated peak_write()
reset briefly observes the lowered value. Transient. It takes peaks_lock
in the show path.

Patch 2 (write side) fixes peak_write(): on a reset it stores the
current usage into the other watchers instead of the old watermark, so
once usage has dropped from a peak a reset on one fd drags every other
fd's peak down too, even fds that never reset.

---
Changes since v3:
- Switch to guard(spinlock) in the peak readers, suggested by Muchun.

Changes since v2:
- Spell out the worst-case userspace-visible effect, per Andrew's
  Go back to v1 [2].

Changes since v1:
 - New patch 1: hold peaks_lock in the peak readers (Sashiko).
 - Patch 2: floor the peers with max(usage, local_watermark), mirroring
   peak_show(), and skip the writing fd (Johannes Weiner).

[1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
[2] https://lore.kernel.org/all/20260730115314.1069089-1-ridong.chen@linux.dev/

Ridong Chen (2):
  memcg: acquire peaks_lock when reading memory.peak
  mm, memcg: fix memory.peak reset clobbering other fds' watermark

 mm/memcontrol.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
2.34.1

