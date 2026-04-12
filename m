Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BB437B007;
	Sun, 12 Apr 2026 19:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776020411; cv=none; b=rmXA5njvMqdRd6gucav7UczNTZjpfjh65TzghnXu5t11H2uNmHXJHJgZ7qCSh96WyYzBh+Z6iyv335uBWc9FSDKdNRxQXjXYlYJROa9NlRoypa+aJT+BuHrnrrlkPXXgF2s0dXKdJuSAZGu5WWk/ZsOp4YueXRMwIxCeZBYYp74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776020411; c=relaxed/simple;
	bh=aaFn5rBZ2ZBLI8uD6bytE2KuPrplmji55gqtSf/LxAo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PGW/JvsVibmuZuXA2I+uqwHxxC5BDCzKESwNvmxRjdSrHQA5pzDgWjPN21mGeooXofqN7eJsAnMneMlEOcbHaCyaPrc9rHShcQRh6mHiXNuVy9qkCNap3/rcSEBkqp1xWbRxFQtVgFvW73QUU6dpdU/BkAsPA4gIE1yo3VExotc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hj3K/4X0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hj3K/4X0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E8AC19425;
	Sun, 12 Apr 2026 19:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020410;
	bh=aaFn5rBZ2ZBLI8uD6bytE2KuPrplmji55gqtSf/LxAo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Hj3K/4X0vU+on1n2LepoMzRKUFfJqrsBx5yY9WIyn1Af+4VW86ETEyZstM7vdxJvg
	 sDvByFawl9+gYSm6q8VGfBw60vGF6aur+wgNVP4fcJaM3NIxYHhakhip/or5KwJgAA
	 PddqinQ4VbtPzYynvYYeGtLHPwoRc05tb+kN6E06fTtlFuX8GJOm+5UKCKNHrSS6It
	 zen2aZptohFS3fGReE66+0tsEtgT3zdlqynwmSzN00OpuM2SQYzjGkIEOgt2twvQcH
	 5z1BxmIwm/yMviTrgTCc2p5Bu4hQdKzzWnboZLrMZYoNw+DVI7wYv83kzCAZd6IDeY
	 r3R93oF7d8X1Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 12 Apr 2026 20:59:33 +0200
Subject: [PATCH RFC 02/13] fs/proc/task_mmu: remove CONFIG_PAGE_MAPCOUNT
 handling for "mapmax"
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260412-mapcount-v1-2-05e8dfab52e0@kernel.org>
References: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
In-Reply-To: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Zi Yan <ziy@nvidia.com>, Pedro Falcato <pfalcato@suse.de>, 
 Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0

In preparation for removing CONFIG_PAGE_MAPCOUNT, let's always use a
folio's average page mapcount instead of the precise page mapcount when
calculating "mapmax".

Update the doc to state that this behavior no longer depends on the
kernel config. While at it, make it clearer what "mapmax" actually
expresses.

For small folios, or large folios that are mostly fully-mapped, there is
no change at all.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/filesystems/proc.rst |  8 ++++----
 fs/proc/task_mmu.c                 | 11 +++--------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 628364b0f69f..1224dc73e089 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -699,10 +699,10 @@ Where:
 node locality page counters (N0 == node0, N1 == node1, ...) and the kernel page
 size, in KB, that is backing the mapping up.
 
-Note that some kernel configurations do not track the precise number of times
-a page part of a larger allocation (e.g., THP) is mapped. In these
-configurations, "mapmax" might corresponds to the average number of mappings
-per page in such a larger allocation instead.
+"mapmax" is the maximum page mapcount of any page in the mapping, i.e.,
+the highest sharing level observed. For pages that are part of larger
+allocations (e.g., THP), it is derived from the average mapcount per page
+in the allocation, since precise per-page mapcounts are not available.
 
 1.2 Kernel data
 ---------------
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca1..ad0989d101ab 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3137,12 +3137,7 @@ static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty,
 			unsigned long nr_pages)
 {
 	struct folio *folio = page_folio(page);
-	int count;
-
-	if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
-		count = folio_precise_page_mapcount(folio, page);
-	else
-		count = folio_average_page_mapcount(folio);
+	const int mapcount = folio_average_page_mapcount(folio);
 
 	md->pages += nr_pages;
 	if (pte_dirty || folio_test_dirty(folio))
@@ -3160,8 +3155,8 @@ static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty,
 	if (folio_test_anon(folio))
 		md->anon += nr_pages;
 
-	if (count > md->mapcount_max)
-		md->mapcount_max = count;
+	if (mapcount > md->mapcount_max)
+		md->mapcount_max = mapcount;
 
 	md->node[folio_nid(folio)] += nr_pages;
 }

-- 
2.43.0

