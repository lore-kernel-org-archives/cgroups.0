From: Hao Lee <haolee.swjtu@gmail.com>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Thu, 25 Nov 2021 08:02:38 +0000
Message-ID: <20211125080238.GA7356@haolee.io>
References: <20211124151915.GA6163@haolee.io>
 <YZ5o/VmU59evp65J@dhcp22.suse.cz>
 <CA+PpKPmy-u_BxYMCQOFyz78t2+3uM6nR9mQeX+MPyH6H2tOOHA@mail.gmail.com>
 <YZ8DZHERun6Fej2P@casper.infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CSciBp70ctz/T70TEHciU/vFhHdn0cLDtlceFTilb1c=;
        b=It30LTcXDZF58CHAlmKZ7KsZm6cBiiG66ou8PSaAROYspvZMNMWnzN6Yk9neUAPDjS
         GueCzvSqJwQ6/exWRTYZGJ0Zx9yWvNJ3rhzNXB37Q7np9hdsIK8UWe6tblkLG7s8KwyL
         /Qa/Q6ZGm4bFPECOBzayBO3QS1FyG6l2waLmn9B+nSfBogIq1lvOzCLq5nuORnVVDPZw
         GSo9gm8OTNzZ/jq4fHqt+JGTvUSP8ymwaC1ViJ2wxHTfnrzAjLJUPtyxflk9C0+Amqyq
         lbWFiMfsYVgeNoA6BT2ujDDGFHSSfUHVYlIASGg5/JI7ZDeIOxAPvcm3z53nHvw93Cy1
         U23w==
Content-Disposition: inline
In-Reply-To: <YZ8DZHERun6Fej2P@casper.infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>, Linux MM <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, vdavydov.dev@gmail.com, Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Thu, Nov 25, 2021 at 03:30:44AM +0000, Matthew Wilcox wrote:
> On Thu, Nov 25, 2021 at 11:24:02AM +0800, Hao Lee wrote:
> > On Thu, Nov 25, 2021 at 12:31 AM Michal Hocko <mhocko@suse.com> wrote:
> > > We do batch currently so no single task should be
> > > able to monopolize the cpu for too long. Why this is not sufficient?
> > 
> > uncharge and unref indeed take advantage of the batch process, but
> > del_from_lru needs more time to complete. Several tasks will contend
> > spinlock in the loop if nr is very large.
> 
> Is SWAP_CLUSTER_MAX too large?  Or does your architecture's spinlock
> implementation need to be fixed?
> 

My testing server is x86_64 with 5.16-rc2. The spinlock should be normal.

I think lock_batch is not the point. lock_batch only break spinning time
into small parts, but it doesn't reduce spinning time. The thing may get
worse if lock_batch is very small.

Here is an example about two tasks contending spinlock. Let's assume each
task need a total of 4 seconds in critical section to complete its work.

Example1:

lock_batch = x

task A      taskB
hold 4s     wait 4s
            hold 4s

total waiting time is 4s.



Example2:

if lock_batch = x/2

task A      taskB
hold 2s     wait 2s
wait 2s     hold 2s
hold 2s     wait 2s
            hold 2s

total waiting time is 6s.


The above theoretical example can also be proved by a test using usemem.

# ./usemem -j 4096 -n 20 10g -s 5

lock_batch=SWAP_CLUSTER_MAX          59.50% native_queued_spin_lock_slowpath
lock_batch=SWAP_CLUSTER_MAX/4        69.95% native_queued_spin_lock_slowpath
lock_batch=SWAP_CLUSTER_MAX/16       82.22% native_queued_spin_lock_slowpath

Nonetheless, enlarging lock_batch can't improve performance obviously
though it won't make it worse, and it's not a good idea to hold a
irq-disabled spinlock for long time.


If cond_reched() will break the task fairness, the only way I can think
of is doing uncharge and unref if the current task can't get the
spinlock. This will reduce the wasted cpu cycles, although the
performance gain is still small (about 4%). However, this way will hurt
batch processing in uncharge(). Maybe there exist a better way...

diff --git a/mm/swap.c b/mm/swap.c
index e8c9dc6d0377..8a947f8d0aaa 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -960,8 +960,16 @@ void release_pages(struct page **pages, int nr)
 		if (PageLRU(page)) {
 			struct lruvec *prev_lruvec = lruvec;
 
-			lruvec = folio_lruvec_relock_irqsave(folio, lruvec,
+			lruvec = folio_lruvec_tryrelock_irqsave(folio, lruvec,
 									&flags);
+			if (!lruvec) {
+				mem_cgroup_uncharge_list(&pages_to_free);
+				free_unref_page_list(&pages_to_free);
+				INIT_LIST_HEAD(&pages_to_free);
+				lruvec = folio_lruvec_relock_irqsave(folio,
+							lruvec, &flags);
+			}
+
 			if (prev_lruvec != lruvec)
 				lock_batch = 0;
