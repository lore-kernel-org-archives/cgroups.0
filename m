Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC2B9463
	for <cgroups@vger.kernel.org>; Sat,  3 Oct 2026 00:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790986751; cv=none; b=GI5/ijtkZYa3UT6VLw/EI/eH7oVVuettLkUMAgju5ItC8UGY01SE8qfQUaFq7K758VbtpHbooL3IBWdRiVHFE6/CgaO00D6L8rTjBY3XklIBpERUntHanld5htRKdy1h8FUwy22xmqYELnzrRETCepEkvNx7H3otYRitTDWGLLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790986751; c=relaxed/simple;
	bh=AOU0R5WQp1YjMRmbBopWcqChPcN9OCZPvivP6IH2nv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXKp62zBBm9z1NzS2Ik2jAdR382tho3leCyJSF0IAb7+Ct4/tCCEtaE9gNIjqvXlxoHAdSq7WM9ysFhaZXHcnonTgjz1DMf4qLr5+9rcX//KFWp+GEK83uop8fbz1tjfbc39pAX0e93YTxCgquM+GpTR90NDZZXG5Lh8STd97hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V5XwIJEg; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V5XwIJEg"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-81ba09a5d23so338639a34.3
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 17:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790986749; x=1791591549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WN+hcxT2obu+Cvnf4TklNkJLPL9EbhZzUN79EAadJMk=;
        b=V5XwIJEgLpqoagWKB2PMfaq//fshZUJQr1Iu7GMO5YPCzKE62GxdJxmWu3raz68azf
         pXI7GXkNc5LoMI9tbsx0bEmpEUMxqIj1GdbIhZX/YpVHPtGq/JqY2lA4XK5IXTsg6R8f
         Mpn3k45scwb4k/iqMAlvaVb2u3zLzZ8aIChEn5RPrkWX7TslRuTQlnl3wcpAgJu6JCiU
         +gXv+rHs9xJOtEx3xOK+sYq4QIZQby+XEQ7PJeWLlixvMGOMmjx4WK1dht9JGVaypBj/
         oo1Jz26SM/IP7eQPCN2XOGh5e0bCoFVDGyd04gQu3U6baeQXusJTqRuaWSS5tIc+Q0Cj
         4VRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986749; x=1791591549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WN+hcxT2obu+Cvnf4TklNkJLPL9EbhZzUN79EAadJMk=;
        b=msrKgTCUa99mpTNe35VJ3eF2aEZKrzxAa0MUf/SRnorL1omq9dZ0RBxcNaihjvDT0w
         V6E7XC1sdrz4KOJin4Qp88hRXFJN39Umzc6rHZ4sFgm5B+0Odgh1nGkk6m7GueBntMsC
         p+6PMNslOcudtwUm9/I0tgVBvzODCUY1n+HwFgcdU2xgp8Vs5z4Gw3vCwlm6n7rSb5Jd
         2MWfWicDG2HmYReblYWILLNeVXjw+MEK/cA2TSccN5qNT7+/3YHyIcJ66yCTg9ZAI3o0
         o1D57HkgCy4E/dHgni/odocYMZfsr0nFyDjCwWMnELsyVGvoRhVHhIj4yqCFQjLRM/T9
         4mPA==
X-Forwarded-Encrypted: i=1; AKwUvBzCPewcrwOCuukk/8qz57mWX4bOrkHBMmYZ5qirPJcACIqiWuk0fCLFtO9IcemOXENz4QelreRQ@vger.kernel.org
X-Gm-Message-State: AFuF++kZanQCjaEBUJs4JAwU+HO6cj01vImgNaVtiCwqiFUcUeugguz7
	Rs9qo4BOLAVrLcjOhovw4I1XScdyFGvDkQmHFjnfvXjNUtTUecMRCAwq
X-Gm-Gg: AYBFou00VnXs3yxdkgj/2AH8cAVVr8KKJ4Xt70Hhd/tlAOCfZgFM5J1uX8bZ7dviumX
	+u1OPa6ngNhlrPfFYj3zv15iusdIHLBoUyIloslEx7RD7EkNaAnhOjjJgs16zyA/RbF4YOwN/Jk
	IDkievG5D4auP7EM/fu5lZnUoF1d+aqrku1n7ECH7RW2yJseq4pFHd0tDvmaehpdZEpfhdpy78D
	tPks4dzEJkT0fXqKz7JYGjQLWZX/5Fmbi6PDEE5U+ZRnx+bxaT+AGIqOIh+IrWxC744k3JpF1rk
	ByrxT+2Z5GLPzb6jkW2kfYIpQ3ZUGD9tDaGy2wXsBfSVHdP+4zg4cTFJupBSZTdPED9I9X++i5m
	hme/3HREGGcp4sMxtWWGOnZaBqgVlELQwQvCXmLd4ropFsjhACtRIhQVCvMMd4CWo1fFKcJ+V2d
	I7vlSM9l627R2ACcKggfvUciwTQ8Csd7dZTJ142SOp3z4id7XtL8/Xz3WBD+n1dBzt+2fuhMdLB
	UqsC1tXee75pjmi5QWFHza7AX/rb08zVFYI+/PHFmMWJfzuwRvWyJNiHp5n3g==
X-Received: by 2002:a05:6830:44a6:b0:81f:acdd:bd0c with SMTP id 46e09a7af769-823fca26dbemr965968a34.12.1790986749202;
        Fri, 02 Oct 2026 17:19:09 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-82279e73822sm4601292a34.16.2026.10.02.17.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 17:19:07 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	willy@infradead.org,
	jack@suse.cz
Cc: mhocko@suse.com,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	riel@surriel.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 3/3] mm/readahead: avoid per-folio memcg reclaim
Date: Fri,  2 Oct 2026 17:15:55 -0700
Message-ID: <20261003001555.3498357-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261003001555.3498357-1-joannelkoong@gmail.com>
References: <20261003001555.3498357-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Readahead adds the folios in its window to the page cache one at a time.
Each folio is charged separately. When the memcg is at its limit, each
one of those charges triggers reclaim (readahead's __GFP_NORETRY only
stops try_charge_memcg() after a reclaim pass). With many tasks faulting
in the same cgroup, the margin one reclaim pass frees gets consumed by
the others, so the faulting tasks keep reclaiming, all to make room for
speculative folios, and in the worst case, reclaim livelocks.

On Meta's fleet, this per-folio reclaim is a large cost. Page cache
insertion triggers around half of all memcg limit reclaim CPU, 93% of it
from mmap fault readahead, in services whose cgroups run at their limit
while many threads fault in mmapped files. Of the CPU time spent in
filemap_add_folio(), 83% is memcg reclaim while inserting the folio into
the page cache itself is 6%.

To avoid this, add readahead folios to the page cache without direct
reclaim, and when the memcg is at its limit, reclaim for the rest of the
window at once with mem_cgroup_reclaim_for_batch() instead of once per
folio. If the memcg hits its limit again before the whole window has
been added, try one more time, since other tasks charging the same memcg
may have used up the room the first attempt made. If there's still no
room, stop readahead early rather than reclaim harder, since readahead
folios are speculative. The count of reclaim attempts lives in
readahead_control so that it covers every path that adds folios for the
request.

This only affects speculative readahead folios. There's no change in
behavior for the folio a fault or read actually needs. If readahead
didn't bring that folio in, filemap_fault() and filemap_read() allocate
and charge it with the mapping's normal gfp mask, like before.

There are two other differences from the current behavior. The first is
that readahead charges that push a cgroup past memory.high leave the
high reclaim to the return to user space, as other non-blocking charges
do. The second is that under global memory pressure, readahead's page
cache xarray node allocations no longer enter direct reclaim (they still
wake kswapd). If one fails, readahead stops early, as it does when a
folio allocation fails.

Tested on a 26-core/52-thread machine with btrfs, running 26, 52 or 104
processes (one per core, one per thread, and 2x oversubscribed) that
each mmap their own file in one memcg with a 1G memory.max (before and
after measured in the same boot), reclaim passes per major fault drop by
94-96% for both random and sequential reads. With data compressing ~3:1
under compress-force=zstd:3, the runs that livelocked in reclaim without
the patch (4 of 18) no longer do. Throughput with incompressible data,
where the disk is the bottleneck, is within 5% of before in either
direction, and the drops are within run-to-run variation. With the
compressed data, it is 9% higher at 104 processes, where reclaim
contention is. Sequential readers get up to 18% fewer pages per major
fault, since readahead now stops early when there is still no room, but
their throughput and read bandwidth are unchanged or slightly higher.

Reported-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/pagemap.h |  1 +
 mm/readahead.c          | 51 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 73af18a37367..973a836076bd 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1409,6 +1409,7 @@ struct readahead_control {
 	pgoff_t _index;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
+	unsigned int _nr_memcg_reclaims;
 	bool dropbehind;
 	bool _workingset;
 	unsigned long _pflags;
diff --git a/mm/readahead.c b/mm/readahead.c
index 6e5563290287..e06375559e9b 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -204,6 +204,41 @@ static struct folio *ractl_alloc_folio(struct readahead_control *ractl,
 	return folio;
 }
 
+/*
+ * Max number of memcg reclaim attempts per readahead request. The first
+ * makes room for the rest of the readahead window. If the window runs out
+ * of room again, try one more time since other readers in the same memcg
+ * might have used that room up.
+ */
+#define READAHEAD_MAX_MEMCG_RECLAIMS	2
+
+/*
+ * Add a readahead folio to the page cache without direct reclaim. This prevents
+ * a memcg at its limit from running reclaim for every folio in the readahead
+ * window (folios in the window are charged one at a time). If adding the folio
+ * to the page cache returns -ENOMEM, reclaim enough room for the rest of the
+ * window and retry adding it.
+ */
+static int readahead_add_folio(struct readahead_control *ractl,
+			       struct folio *folio, pgoff_t index,
+			       unsigned long nr_pages_left, gfp_t gfp)
+{
+	struct address_space *mapping = ractl->mapping;
+	int ret;
+
+	ret = filemap_add_folio(mapping, folio, index,
+				gfp & ~__GFP_DIRECT_RECLAIM);
+	if (ret == -ENOMEM &&
+	    ractl->_nr_memcg_reclaims < READAHEAD_MAX_MEMCG_RECLAIMS) {
+		ractl->_nr_memcg_reclaims++;
+		nr_pages_left = max(nr_pages_left, folio_nr_pages(folio));
+		if (mem_cgroup_reclaim_for_batch(nr_pages_left, gfp))
+			ret = filemap_add_folio(mapping, folio, index,
+						gfp & ~__GFP_DIRECT_RECLAIM);
+	}
+	return ret;
+}
+
 /**
  * page_cache_ra_unbounded - Start unchecked readahead.
  * @ractl: Readahead control.
@@ -290,7 +325,8 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 		if (!folio)
 			break;
 
-		ret = filemap_add_folio(mapping, folio, index + i, gfp_mask);
+		ret = readahead_add_folio(ractl, folio, index + i,
+					  nr_to_read - i, gfp_mask);
 		if (ret < 0) {
 			folio_put(folio);
 			if (ret == -ENOMEM)
@@ -457,7 +493,7 @@ static unsigned long get_next_ra_size(struct file_ra_state *ra,
  */
 
 static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
-		pgoff_t mark, unsigned int order, gfp_t gfp)
+		pgoff_t mark, pgoff_t limit, unsigned int order, gfp_t gfp)
 {
 	int err;
 	struct folio *folio = ractl_alloc_folio(ractl, gfp, order);
@@ -467,7 +503,7 @@ static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
 	mark = round_down(mark, 1UL << order);
 	if (index == mark)
 		folio_set_readahead(folio);
-	err = filemap_add_folio(ractl->mapping, folio, index, gfp);
+	err = readahead_add_folio(ractl, folio, index, limit - index + 1, gfp);
 	if (err) {
 		folio_put(folio);
 		return err;
@@ -532,7 +568,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 		/* Don't allocate pages past EOF */
 		while (order > min_order && index + (1UL << order) - 1 > limit)
 			order--;
-		err = ra_alloc_folio(ractl, index, mark, order, gfp);
+		err = ra_alloc_folio(ractl, index, mark, limit, order, gfp);
 		if (err)
 			break;
 		index += 1UL << order;
@@ -813,7 +849,8 @@ void readahead_expand(struct readahead_control *ractl,
 			return;
 
 		index = mapping_align_index(mapping, index);
-		if (filemap_add_folio(mapping, folio, index, gfp_mask) < 0) {
+		if (readahead_add_folio(ractl, folio, index,
+					ractl->_index - new_index, gfp_mask) < 0) {
 			folio_put(folio);
 			return;
 		}
@@ -842,7 +879,9 @@ void readahead_expand(struct readahead_control *ractl,
 			return;
 
 		index = mapping_align_index(mapping, index);
-		if (filemap_add_folio(mapping, folio, index, gfp_mask) < 0) {
+		if (readahead_add_folio(ractl, folio, index,
+					new_nr_pages - ractl->_nr_pages,
+					gfp_mask) < 0) {
 			folio_put(folio);
 			return;
 		}
-- 
2.52.0

