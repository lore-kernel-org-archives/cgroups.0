Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795315686;
	b=WaiO+3VctJS7iEHMQZFPlsYn05dHkVvsRPVwt577vTtKPGER0J4bDaY3dJ2Y+jKIXayP
	 AXby7gd6T42e613z6KanaVBXwdyUola8B31v7aRs9N5+6Cq/sDc/U1odyVgyG1myRx+kD
	 xqV50MveW7kP5//kYNCBZh0/9yiIV+uMaTlYbpFaWC2dVvuuKnbjzgfEXCjdDzgODiPmu
	 oN5H6wgSekQI8Z1ygnuX8Fwd7H3y8hl9JBvKPA1tAIoGZXQ4nEBiXBwIJ2etdtXB5Knsq
	 nxdAFwFOoPqCOWAMOXvFTtxf6tuikwSD6DqTHr4ZnVwA8Ao8qjsh7amgxpzeLI+7zZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795315686;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=93KEZZm79T4K4z1XzJKlBY4GniO+4cdR8lKTt2J+MH4=;
	b=Sx/Qia5i51d/4LAb4IzEPYFNh29mIVI7tq6SasMAmo26YnugTLsySLbn0bueTJXewzZ2
	 fjaPmoWkZei5w/D13RoWC9XyMOc+cqL16xZziEDHUfpthI4fAxjzIvF726fab8MXtd2j8
	 LdlSEQJnduMKJq09SC2agwSqi1W99rmOspZATq/yflv0a+2zsEIRIqBCGbwx92gXboTd2
	 2RD8YyX/+4XSkCT60NknRSKftnA4c6AbENLy8XpxdDNqJTSJT+OqVtR4aNrOPaXgkEvoi
	 tYrbjWWbn13YqbKIybOVhDejDx6zc5Q4A9Ol0+RAvGm2oELbvGDhBBHr5AxcRdd8rVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xwRWhxda;
	arc=none smtp.remote-ip=91.218.175.197
Received: from mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A69606A338
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 02:48:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79A69606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xwRWhxda
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Snj41/CC0oxxSA8iI87cvSw/qxupw/kfZbBBp8fjQq4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315683; v=1; x=1795920483;
 b=xwRWhxdaIy107ah3iAY22Gu7XWqiG9ljdHQHoHNTkKyPS6wytCpH7vUhJ+wqUKO4anH7S8fF
 nm91CScm9w736dGPnvxhZ4bk0nIvbMpXwiAO1OVuAqbdfcwLbMa/23d7byVPABMhe171wUKZbqj
 iXVmrBuFJN+SWzB1QXZAaP6Q=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 47c6b318c025fda0;
	Sun, 22 Nov 2026 02:48:03 +0000
X-Mizu-Trace-ID: 47c6b318c025fda0
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
Subject: [RFC PATCH 3/7] mm, fs: handle memory.high overage in buffered reads and writes
Date: Sat, 21 Nov 2026 18:47:33 -0800
Message-ID: <20261122024737.2741569-4-shakeel.butt@linux.dev>
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

A buffered read or write can copy almost 2GiB in one call. A write
charges the page cache it fills. Dirty throttling limits only the dirty
part, and does nothing on tmpfs and memfd, whose bdi has no
BDI_CAP_WRITEBACK. A read charges the page cache it reads, and the
anonymous pages it faults in when the user buffer is untouched, which
can't be reclaimed without swap. Today the charge path throttles these
calls for memory.high, except huge tmpfs pages and THP faults on the
user buffer, whose charges can't block under the default defrag
setting.

A later patch stops enforcing memory.high in the charge path, where
the task may hold locks other tasks need. Handle the overage in the
copy loops instead:

- generic_perform_write() and iomap_write_iter(): next to the dirty
  throttling call.
- btrfs_buffered_write(): between ranges. btrfs has its own loop, which
  the other two hooks don't cover.
- filemap_read(): after each folio is copied. Once per batch isn't
  enough, as a batch of large folios can hold tens of MiB.

Writers hold the inode's i_rwsem there, and dirty throttling already
sleeps under it. Two cases hold more: splice() from a pipe also holds
the pipe's lock, and gfs2 holds the resource group and quota glocks in
writes that allocate, which other writers to that resource group wait
for, on any node. The charge path sleeps with all of these locks today,
plus those taken in write_begin(). In btrfs, copy_one_range() has
already released its space reservation or handed it to delalloc, and
dropped the snapshot lock of a NOCOW write.

Most readers hold no locks. XFS, NFS and netfs hold the file's lock
shared, and gfs2 and ocfs2 a cluster lock, so a writer to that file
waits while a reader is throttled, as it does today. filemap_read()
keeps its folio batch referenced while the task is throttled. If it
dropped the batch, reclaim could free the folios not copied yet, and
they would be read again: in a VM, a cold 256M read under
memory.high=64M then read five to nine times as much from disk for the
same progress. After the sleep, it reads i_size and
mapping_writably_mapped() again.

IOCB_NOWAIT writes and IOCB_NOWAIT or IOCB_WAITQ reads skip the hook:
io_uring issues them with ctx->uring_lock held. Reads into kernel
buffers skip it too: kernel_read() callers may hold other locks, like
cred_guard_mutex in execve(). Reclaim uses the gfp mask of the
allocation that follows, so filesystems that clear __GFP_FS get
GFP_NOFS reclaim.

Without these hooks, once the synchronous step is gone, a 256M write
under memory.high=64M in a VM reaches 257-264M on ext4, XFS and btrfs
instead of 64-67M.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/btrfs/file.c        |  9 +++++++++
 fs/iomap/buffered-io.c |  9 +++++++++
 mm/filemap.c           | 31 +++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f978c6524aa0..d5a00a26fba6 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -18,6 +18,7 @@
 #include <linux/uio.h>
 #include <linux/iversion.h>
 #include <linux/fsverity.h>
+#include <linux/memcontrol.h>
 #include "ctree.h"
 #include "direct-io.h"
 #include "disk-io.h"
@@ -1320,6 +1321,7 @@ ssize_t btrfs_buffered_write(struct kiocb *iocb, struct iov_iter *iter)
 	struct file *file = iocb->ki_filp;
 	loff_t pos;
 	struct inode *inode = file_inode(file);
+	const gfp_t high_gfp = btrfs_alloc_write_mask(inode->i_mapping);
 	struct extent_changeset *data_reserved = NULL;
 	size_t num_written = 0;
 	ssize_t ret;
@@ -1356,6 +1358,13 @@ ssize_t btrfs_buffered_write(struct kiocb *iocb, struct iov_iter *iter)
 			break;
 		pos += ret;
 		num_written += ret;
+		/*
+		 * A large write can charge a lot before the task returns to
+		 * userspace. Handle memory.high overage between ranges, where
+		 * btrfs holds only the inode lock.
+		 */
+		if (!nowait)
+			mem_cgroup_over_high_throttle(high_gfp);
 		cond_resched();
 	}
 
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6d843b168d5f..861aa600b3af 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -7,6 +7,7 @@
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/swap.h>
+#include <linux/memcontrol.h>
 #include <linux/migrate.h>
 #include <linux/fserror.h>
 #include <linux/fsverity.h>
@@ -1193,6 +1194,7 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 	struct address_space *mapping = iter->inode->i_mapping;
 	size_t chunk = mapping_max_folio_size(mapping);
 	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
+	gfp_t high_gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 
 	do {
 		struct folio *folio;
@@ -1212,6 +1214,13 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 		if (unlikely(status))
 			break;
 
+		/*
+		 * A large write can charge a lot before the task returns to
+		 * userspace. Handle memory.high overage here too.
+		 */
+		if (!(iter->flags & IOMAP_NOWAIT))
+			mem_cgroup_over_high_throttle(high_gfp);
+
 		if (bytes > iomap_length(iter))
 			bytes = iomap_length(iter);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index dc0ceaa58a0f..b0cefe71c1fd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2822,6 +2822,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	struct file_ra_state *ra = &filp->f_ra;
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
+	gfp_t high_gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 	struct folio_batch fbatch;
 	int i, error = 0;
 	bool writably_mapped;
@@ -2913,6 +2914,28 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 				error = -EFAULT;
 				break;
 			}
+
+			/*
+			 * A large read can charge a lot, for the page cache and
+			 * for faulting in the buffer. Handle memory.high
+			 * overage after each folio, as a batch of large folios
+			 * can be big. Keep the batch, or reclaim could free
+			 * folios not copied yet and they would be read again.
+			 * The file may change meanwhile, so check its size and
+			 * mappings again. Reads into kernel buffers skip this:
+			 * their callers may hold other locks.
+			 */
+			if (user_backed_iter(iter) &&
+			    !(iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ)) &&
+			    mem_cgroup_over_high_pending()) {
+				mem_cgroup_handle_over_high(high_gfp);
+				isize = i_size_read(inode);
+				if (iocb->ki_pos >= isize)
+					break;
+				end_offset = min_t(loff_t, isize,
+						   iocb->ki_pos + iter->count);
+				writably_mapped = mapping_writably_mapped(mapping);
+			}
 		}
 put_folios:
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
@@ -4385,6 +4408,7 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
 	struct address_space *mapping = file->f_mapping;
 	const struct address_space_operations *a_ops = mapping->a_ops;
 	size_t chunk = mapping_max_folio_size(mapping);
+	gfp_t high_gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 	long status = 0;
 	ssize_t written = 0;
 
@@ -4401,6 +4425,13 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
 		bytes = min(chunk - offset, bytes);
 		balance_dirty_pages_ratelimited(mapping);
 
+		/*
+		 * A large write can charge a lot before the task returns to
+		 * userspace. Handle memory.high overage here too.
+		 */
+		if (!(iocb->ki_flags & IOCB_NOWAIT))
+			mem_cgroup_over_high_throttle(high_gfp);
+
 		if (fatal_signal_pending(current)) {
 			status = -EINTR;
 			break;
-- 
2.53.1-Meta

