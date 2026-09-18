Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20769485CF7;
	Fri, 18 Sep 2026 08:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721654; cv=none; b=KouslKIsBpgfLYbRRbseNlQsx0/rVIHg4Jp60rAMbHh4zJ47xBGx5PCaJtBVsEKf2nJzohwe3qXEmEON9B67Zq4reNgCn4pPEB+FvRcj5CyF/67faB1fBav+vUOWSRLv609BtAxn8XLGRNoT1e1ERd1/nS0BPyKCIA9pWPvdXpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721654; c=relaxed/simple;
	bh=/9TCN4nj48er2nF+5svVR6bjZx5z5MT9HxKzhS8mbPg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VjClmcu1YEKIssIlpIa6gFH0hLzvQkd+1RmucAfhLTU162ioQUkiPDTyX3lGU2Z0iP3QFe6JqYX+Y2loweaxynZZQI9POzsNPuTT9UivgnTY03Ix99EtPkK/SPPLrOwWJXq+0jC8totVXo05MQLyIAxCkYfp2DJznrzRCjZNGgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N5heMBhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N5heMBhi"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A092FC2BCFA;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789721653;
	bh=/9TCN4nj48er2nF+5svVR6bjZx5z5MT9HxKzhS8mbPg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=N5heMBhiUdbRycjA66PMTBjUd0NULsArduaj8elWTzE33EG7piDFAIG+MbpZXUE7C
	 9MchWNwOnUb29ixyQdfT3izy59RGjld9d2btsoo/Y+9MR/FaQ1BL/DUrlYAcKDUIY+
	 un7RBXjSSb4beSCa9lXywyg4W/dMrbDB/JdEXz7BWmMowjkNVkKNrYlylOhpVr8lmV
	 bfIaT6ZcX6xqI31PW5kI4+Yr8F21uQ0c6qlaBGY0BDo83wHhPuDPVx2oOBsALW+Ch3
	 y2ab+He++k1KQJYad2IFexvES7WJX3+jihVtp9Dhz83sHgM8OHu1wTYO2CevZ7j5S8
	 M1vNLO+Dou2xg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8257AC982D2;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
From: Jingxiang Zeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 16:53:43 +0800
Subject: [PATCH 3/6] mm: page_counter: drop protection fields from struct
 page_counter
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-descriptive-name-v1-3-dfcfdd91b456@tencent.com>
References: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
In-Reply-To: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: Jingxiang Zeng <jingxiangzeng.cas@gmail.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org, 
 Jingxiang Zeng <linuszeng@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789721651; l=1721;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=GADlg4c7MuNMFrgGvBXbc27o0HpJUKcrZX5lbsFPXjs=;
 b=1jXeFmMF4d9zQQS9hsdMiN/aPBms3k02q4O+kWhQZ8m+MkzNteDbtTrmxJgIpSWeZDVGUAUdr
 L4jsYEoTO8mCLqkgVNx9pNECUvDG3RsxJoXyoLpns9C1TmS/Ppv9kUl
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: Jingxiang Zeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com

From: Jingxiang Zeng <linuszeng@tencent.com>

The protection state now lives in struct page_counter_protection, so
remove the emin/min_usage/children_min_usage, elow/low_usage/
children_low_usage, min, low and protection_support fields from struct
page_counter.

Also drop the now-orphaned _pad2_ padding and its comment: with the
protection fields gone it no longer separates the read-mostly fields
from anything, and the structure's cacheline alignment already pads the
tail out.

swap/memsw, kmem, tcpmem and hugetlb counters no longer carry this
unused state: on 64-bit the structure shrinks from three cache lines to
two, saving one cache line.

Signed-off-by: Jingxiang Zeng <linuszeng@tencent.com>
---
 include/linux/page_counter.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 5020e62aacb4..27467bf3b8e6 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -56,27 +56,11 @@ struct page_counter {
 
 	CACHELINE_PADDING(_pad1_);
 
-	/* effective memory.min and memory.min usage tracking */
-	unsigned long emin;
-	atomic_long_t min_usage;
-	atomic_long_t children_min_usage;
-
-	/* effective memory.low and memory.low usage tracking */
-	unsigned long elow;
-	atomic_long_t low_usage;
-	atomic_long_t children_low_usage;
-
 	unsigned long watermark;
 	/* Latest cg2 reset watermark */
 	unsigned long local_watermark;
 
-	/* Keep all the read most fields in a separete cacheline. */
-	CACHELINE_PADDING(_pad2_);
-
-	bool protection_support;
 	bool track_failcnt;
-	unsigned long min;
-	unsigned long low;
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;

-- 
2.43.7


