From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 5/6] mm: memcontrol: per-lruvec stats infrastructure
Date: Wed, 31 May 2017 13:14:50 -0400
Message-ID: <20170531171450.GA10481@cmpxchg.org>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
 <20170530181724.27197-6-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6ep+qqeZ+4hMg7WWimvThQEVUnhlKFPKlZERJ6GOXaY=; b=AA+F+OQWFA73NuxJFFvEnN0lZy
	zj+V2KHhbuC6s5UNPsLfvOeqIBafj5Q8qmD0VAuJfaz7jzD0VE0y8sLv4mTCJQum1iDbkFHeWGIdp
	XTM8t3VFmKyrVVRDM8Dr1SD1mrENgTJmoV5T2ZMIvBAgMyGZZUIwE95S8w2pZOaV+x2Q=;
Content-Disposition: inline
In-Reply-To: <20170530181724.27197-6-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josef Bacik <josef@toxicpanda.com>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Andrew, the 0day tester found a crash with this when special pages get
faulted. They're not charged to any cgroup and we'll deref NULL.

Can you include the following fix on top of this patch please? Thanks!

---

From 0ea9bdb1b425a6c943a65c02164d4ca51815fdc4 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 31 May 2017 12:57:28 -0400
Subject: [PATCH] mm: memcontrol: per-lruvec stats infrastructure fix

Fix the following crash in the new cgroup stat keeping code:

Freeing unused kernel memory: 856K
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 1104K
Freeing unused kernel memory: 588K
page:ffffea000005d8c0 count:2 mapcount:1 mapping:          (null) index:0x0
flags: 0x800000000000801(locked|reserved)
raw: 0800000000000801 0000000000000000 0000000000000000 0000000200000000
raw: ffffea000005d8e0 ffffea000005d8e0 0000000000000000 0000000000000000
page dumped because: not cgrouped, will crash
BUG: unable to handle kernel NULL pointer dereference at 00000000000004d8
IP: page_add_file_rmap+0x56/0xf0
PGD 0
P4D 0
Oops: 0000 [#1] SMP
CPU: 0 PID: 1 Comm: init Not tainted 4.12.0-rc2-00065-g390160f076be-dirty #326
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-20170228_101828-anatol 04/01/2014
task: ffff88007d380000 task.stack: ffffc9000031c000
RIP: 0010:page_add_file_rmap+0x56/0xf0
RSP: 0000:ffffc9000031fd88 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffea000005d8c0 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88007ffde000
RBP: ffffc9000031fd98 R08: 0000000000000003 R09: 0000000000000000
R10: ffffc9000031fd18 R11: 0000000000000000 R12: ffff88007ffdfab8
R13: ffffea000005d8c0 R14: ffff88007c76d508 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000004d8 CR3: 000000007c76c000 CR4: 00000000000006b0
Call Trace:
 alloc_set_pte+0xb5/0x2f0
 finish_fault+0x2b/0x50
 __handle_mm_fault+0x3e5/0xb90
 handle_mm_fault+0x284/0x340
 __do_page_fault+0x1fb/0x410
 do_page_fault+0xc/0x10
 page_fault+0x22/0x30

This is a special page being faulted, and these will never be charged
to a cgroup. Assume the root cgroup for uncharged pages to fix this.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a282eb2a6cc3..bea6f08e9e16 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -585,18 +585,26 @@ static inline void mod_lruvec_state(struct lruvec *lruvec,
 static inline void __mod_lruvec_page_state(struct page *page,
 					   enum node_stat_item idx, int val)
 {
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
-	lruvec = mem_cgroup_lruvec(page_pgdat(page), page->mem_cgroup);
+	/* Special pages in the VM aren't charged, use root */
+	memcg = page->mem_cgroup ? : root_mem_cgroup;
+
+	lruvec = mem_cgroup_lruvec(page_pgdat(page), memcg);
 	__mod_lruvec_state(lruvec, idx, val);
 }
 
 static inline void mod_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx, int val)
 {
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
-	lruvec = mem_cgroup_lruvec(page_pgdat(page), page->mem_cgroup);
+	/* Special pages in the VM aren't charged, use root */
+	memcg = page->mem_cgroup ? : root_mem_cgroup;
+
+	lruvec = mem_cgroup_lruvec(page_pgdat(page), memcg);
 	mod_lruvec_state(lruvec, idx, val);
 }
 
-- 
2.13.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
