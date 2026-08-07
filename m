Received: from out-173.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9DB1C862D
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 09:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093289; cv=none; b=psvT6UDYcOa8zf37g3+uvCvOy21NkfsnZmO6QQ6o+iEtPzFOuH9rEXBdbwh7CZwMGKVXsVTj6Dm6gRqHZ89ZPr2lnSimGOzE4k9xfpQ8iqva+qhfhdDb1kmVmcNa8vtfdQjHddDaclyobG22qO8xd68wloIPhJplW0wtPz6QZAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093289; c=relaxed/simple;
	bh=TJnUCbidlwGzGjYbztKu2y8hnN9tQkGSLHjqCNwQs+8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ei2S96ZYTRFn+q+FFO1p/0vgsELINXpCmNAG+F9fj0ucNW/kiKcO+3xpVN4fgpewIiX1c30DmCKBUi/Kr0D51QcfLHzlAjJ1Y03xnjw4ZjMUNP8jpn5zOTxrnMFMiFbNgELZgwcKpy22JCKBkSFh2G0AYsuRtbQs8e0Tt7f7hjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r3pfHblt; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r3pfHblt"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786093275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tc+4Pm1WPXx8lrlIpIcW9us+Omuxqmtf7stMvPslqPY=;
	b=r3pfHbltofdChVFLczD3R5Ob2r8ULIyo2ReT6AHaeUGlgbdsptevt7KU8NyqXudUu+2WI1
	Pn6HQYKelQMb0mhENxindbZn5PcO05AlIhAD7nwUtRHMNUYRmc4t6w6PHXQNkiMNoCZaZf
	zinKwp/Xo977YuUxbl1JRHt40RlhlSE=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	cui.tao@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 0/2] mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Fri,  7 Aug 2026 16:59:58 +0800
Message-Id: <20260807090000.1532495-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Ridong Chen <chenridong@xiaomi.com>

Two fixes for the per-fd memory.peak / memory.swap.peak handlers added in
c6f53ed8f213. Each open fd reads back max(its own value, the shared
local_watermark), and both bugs live in that scheme.

---

Changes since v1 [1]:
 - New patch 1: hold peaks_lock in the peak readers (Sashiko).
 - Patch 2: floor the peers with max(usage, local_watermark), mirroring
   peak_show(), and skip the writing fd (Johannes Weiner).

[1] https://lore.kernel.org/all/20260730115314.1069089-1-ridong.chen@linux.dev/

Ridong Chen (2):
  memcg: acquire peaks_lock when reading memory.peak
  mm, memcg: fix memory.peak reset clobbering other fds' watermark

 mm/memcontrol.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

-- 
2.34.1

