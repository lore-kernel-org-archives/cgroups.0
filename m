Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.204
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795315688;
	b=2VXywjDqAQYOORvLCW+HksVIHSaEU29/p0teMrnqXjob0sMHb43TIKbrBDRPosyaPP5P
	 kaTy0cjcx+wqAx8vXtvlsg969knauZzpqzcl/M//AOtBzKpnQZxqPCJV3lWLB8tGD/ebj
	 aPK7CobdgzQLhTrfMd6CrP8MCO9NemB8RO5staYAhnX4nAfDL6jd989YKKkyEwPI8u6id
	 c7pBYjM6eWoGRtAETw/lIXVC6eZt1MtVf+8DOcl7aH9Dwm9V1X4ognzNvihmCJhyz/716
	 C0w8Ghb+vAKRcyUQ34fkMXdAkY6/lsz4yOThOEdWYZqGAuupViRU3neI4xsFnlvnq4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795315688;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kkxhsd+wNZ5decktFmYFGStmSBxY5/td+insSo0Xag0=;
	b=Fl4wMfKMbCL7t4b+UXagbc5IWVYhRTJteNB906VNryQBdkiXg/Nei8I8mK0fmK+AFaqS
	 DzDNW6jiDz+tIIp+UFwSYIYn8Xji1uB3O2r1T0jCtkwMZ5cdGxazcy/BuvB3H5nBatTFu
	 Br1jVOfYf5+gOiY8357UIu3pQ8HkDMXEt0zkI978g98AZriFb69VYXQ+7ljQEKuPgC+FY
	 kOdOd6gxZRME8YMtTzqVgtWpg35MYjEa7H42e16CCCxz8IJDX9gks2LJAs1wGrT4ltSGT
	 gmSGGAsMuLbMXPZcPXXKQZnSBWS9jp37Jk36zGLVm9ujlwTin3DBLmLm3CtXzl/ZzcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="rgR3igk/";
	arc=none smtp.remote-ip=91.218.175.204
Received: from mta0.migadu.com (out-204.mta0.migadu.com [91.218.175.204])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B54606A683
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 02:48:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3B54606A683
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rgR3igk/
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fU97LFAIirxa+/rlTWHr0TmU8aBTzCwdMVuMHL65nxA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315685; v=1; x=1795920485;
 b=rgR3igk/I/weVpqc719mO0amIqbu5Bush6VykTQXIVP7Hgc6xYXHbkpsGvoi0e8PXlKMmskc
 wQdTm2EqLYCt8t7wde+FHoBhXbwDaHyBuIBzk4FnIWu9L8GpEI68nbKF/y/Xtc3ZMBAXReQVpyE
 heYqth8DiLAG0CF6RyGa4ueA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7007ba29080ecc76;
	Sun, 22 Nov 2026 02:48:05 +0000
X-Mizu-Trace-ID: 7007ba29080ecc76
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/7] mm/shmem: handle memory.high overage in fallocate and reads
Date: Sat, 21 Nov 2026 18:47:34 -0800
Message-ID: <20261122024737.2741569-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fallocate() on tmpfs or memfd allocates the whole range in one call,
and a read can copy almost 2GiB, faulting in the user buffer and
swapping the file back in. Without swap, this memory can't be
reclaimed, and the internal mount behind memfd_create(),
MAP_SHARED|MAP_ANONYMOUS and SysV shm has no size limit. Today the
charge path throttles both for memory.high, except huge page charges,
which can't block under the default defrag setting. Writes go through
generic_perform_write(), which the previous patch covers.

A later patch stops enforcing memory.high in the charge path, where
the task may hold locks other tasks need. Handle the overage after each
fallocate iteration, where only inode_lock is held, and after each
folio a read copies, where no locks are held. This covers huge pages
too. Reclaim doesn't need inode_lock: shmem_writeout() reads i_private
under i_lock. As in filemap_read(), reads into kernel buffers and
IOCB_NOWAIT or IOCB_WAITQ reads skip it. Reclaim uses the mapping's gfp
constraint.

With swap, this reclaim finds the folios the fallocate added.
shmem_writeout() won't swap them out and counts each try in
nr_unswapped, and once there are more tries than new folios, the
fallocate fails with -ENOMEM. memory.high should throttle the call, not
fail it, so tries made by the fallocating task's own memory.high
reclaim don't count. Tries by other reclaim still count. In a VM with
swap, a 512M tmpfs fallocate under memory.high=64M fails with -ENOMEM 3
times out of 3 today with small pages, and would with huge pages too if
this reclaim's tries counted. With this patch it is throttled instead.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/shmem.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 951bb3c8f837..fad86c96170f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -110,6 +110,8 @@ struct shmem_falloc {
 	pgoff_t next;		/* the next page offset to be fallocated */
 	pgoff_t nr_falloced;	/* how many new pages have been fallocated */
 	pgoff_t nr_unswapped;	/* how often writeout refused to swap out */
+	/* set while the fallocating task handles memory.high overage */
+	struct task_struct *high_reclaimer;
 };
 
 struct shmem_options {
@@ -1918,10 +1920,13 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			if (shmem_falloc &&
 			    !shmem_falloc->waitq &&
 			    index >= shmem_falloc->start &&
-			    index < shmem_falloc->next)
-				shmem_falloc->nr_unswapped += nr_pages;
-			else
+			    index < shmem_falloc->next) {
+				/* See the memory.high comment in shmem_fallocate() */
+				if (READ_ONCE(shmem_falloc->high_reclaimer) != current)
+					shmem_falloc->nr_unswapped += nr_pages;
+			} else {
 				shmem_falloc = NULL;
+			}
 			spin_unlock(&inode->i_lock);
 			if (shmem_falloc)
 				goto redirty;
@@ -3567,6 +3572,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
+	gfp_t high_gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 	pgoff_t index;
 	unsigned long offset;
 	int error = 0;
@@ -3675,6 +3681,15 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			error = -EFAULT;
 			break;
 		}
+		/*
+		 * A large read can charge a lot, for faulting in the buffer
+		 * and swapping in the file. Handle memory.high overage here,
+		 * where no locks are held. As in filemap_read(), reads into
+		 * kernel buffers and reads that must not block skip this.
+		 */
+		if (user_backed_iter(to) &&
+		    !(iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ)))
+			mem_cgroup_over_high_throttle(high_gfp);
 		cond_resched();
 	}
 
@@ -3883,6 +3898,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	struct inode *inode = file_inode(file);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	gfp_t high_gfp = mapping_gfp_constraint(inode->i_mapping, GFP_KERNEL);
 	struct shmem_falloc shmem_falloc;
 	pgoff_t start, index, end, undo_fallocend;
 	loff_t aligned_end;
@@ -3962,6 +3978,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	shmem_falloc.next  = start;
 	shmem_falloc.nr_falloced = 0;
 	shmem_falloc.nr_unswapped = 0;
+	shmem_falloc.high_reclaimer = NULL;
 	spin_lock(&inode->i_lock);
 	WRITE_ONCE(inode->i_private, &shmem_falloc);
 	spin_unlock(&inode->i_lock);
@@ -4031,6 +4048,20 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		folio_mark_dirty(folio);
 		folio_unlock(folio);
 		folio_put(folio);
+
+		/*
+		 * Handle memory.high overage here, where only inode_lock is
+		 * held; reclaim doesn't take it. shmem_writeout() won't swap
+		 * out the folios added so far, and counts each try toward the
+		 * -ENOMEM check above. memory.high should only throttle the
+		 * fallocate, so tell shmem_writeout() not to count tries made
+		 * by this reclaim.
+		 */
+		if (mem_cgroup_over_high_pending()) {
+			WRITE_ONCE(shmem_falloc.high_reclaimer, current);
+			mem_cgroup_handle_over_high(high_gfp);
+			WRITE_ONCE(shmem_falloc.high_reclaimer, NULL);
+		}
 		cond_resched();
 	}
 
-- 
2.53.1-Meta

