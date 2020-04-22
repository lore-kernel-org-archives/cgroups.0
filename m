From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 15/18] mm: memcontrol: make swap tracking an integral
 part of memory control
Date: Wed, 22 Apr 2020 09:30:01 -0400
Message-ID: <20200422133001.GE358439@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-16-hannes@cmpxchg.org>
 <e9d58c82-d746-dcd0-d9e3-6322014a3b03@linux.alibaba.com>
 <20200421143923.GC341682@cmpxchg.org>
 <2721c508-9b32-d0e7-454d-386129bfda1b@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=chsAA4zyl1YPFqGtfiwU7PFfqVuSOELGokqTvQTOwpY=;
        b=ryTWe4zYa0wqpywa20hGmZ5UhE9d4qB5vX4YCnD9vlJUAHekQcP/Xs5IuyWY64vmU3
         06wbWvSe7zfL8eU/19YZb/9DoD4Ndak8N3S8q7hkMLbR7LjpsSb78dlwwwGIocC5+WXx
         lalqwQ/GXib655ulKpereqvWthxeYlSjFV7icp27njo9mdQQE7IVz3FHVjFy65MkeeMW
         z9XwtQA2u9/g/te+NNkiFqdJx1oqOrIo1xstSpKZNFj319mN2AEGDyzeSBqSb6TltMrb
         C6ZZov9OETmmP7E83EE/KvMRWox8jtvqAx5kczuJgJ3mB4Fg/3mObRbzQZ8jl0r7OjmK
         16gw==
Content-Disposition: inline
In-Reply-To: <2721c508-9b32-d0e7-454d-386129bfda1b-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Apr 22, 2020 at 11:14:40AM +0800, Alex Shi wrote:
> 
> 
> 在 2020/4/21 下午10:39, Johannes Weiner 写道:
> > Hi Alex,
> > 
> > thanks for your quick review so far, I'll add the tags to the patches.
> > 
> > On Tue, Apr 21, 2020 at 05:27:30PM +0800, Alex Shi wrote:
> >>
> >>
> >> 在 2020/4/21 上午6:11, Johannes Weiner 写道:
> >>> The swapaccount=0 boot option will continue to exist, and it will
> >>> eliminate the page_counter overhead and hide the swap control files,
> >>> but it won't disable swap slot ownership tracking.
> >>
> >> May we add extra explanation for this change to user? and the default
> >> memsw limitations?
> > 
> > Can you elaborate what you think is missing and where you would like
> > to see it documented?
> > 
> Maybe the following doc change is better after whole patchset? 
> Guess users would would happy to know details of this change.

Thanks, I stole your patch and extended/tweaked it a little. Would you
mind providing your Signed-off-by:?

From 589d3c1b505e6671b4a9b424436c9eda88a0b08c Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Date: Wed, 22 Apr 2020 11:14:40 +0800
Subject: [PATCH] mm: memcontrol: document the new swap control behavior

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 .../admin-guide/cgroup-v1/memory.rst          | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 0ae4f564c2d6..12757e63b26c 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -199,11 +199,11 @@ An RSS page is unaccounted when it's fully unmapped. A PageCache page is
 unaccounted when it's removed from radix-tree. Even if RSS pages are fully
 unmapped (by kswapd), they may exist as SwapCache in the system until they
 are really freed. Such SwapCaches are also accounted.
-A swapped-in page is not accounted until it's mapped.
+A swapped-in page is accounted after adding into swapcache.
 
 Note: The kernel does swapin-readahead and reads multiple swaps at once.
-This means swapped-in pages may contain pages for other tasks than a task
-causing page fault. So, we avoid accounting at swap-in I/O.
+Since page's memcg recorded into swap whatever memsw enabled, the page will
+be accounted after swapin.
 
 At page migration, accounting information is kept.
 
@@ -222,18 +222,13 @@ the cgroup that brought it in -- this will happen on memory pressure).
 But see section 8.2: when moving a task to another cgroup, its pages may
 be recharged to the new cgroup, if move_charge_at_immigrate has been chosen.
 
-Exception: If CONFIG_MEMCG_SWAP is not used.
-When you do swapoff and make swapped-out pages of shmem(tmpfs) to
-be backed into memory in force, charges for pages are accounted against the
-caller of swapoff rather than the users of shmem.
-
-2.4 Swap Extension (CONFIG_MEMCG_SWAP)
+2.4 Swap Extension
 --------------------------------------
 
-Swap Extension allows you to record charge for swap. A swapped-in page is
-charged back to original page allocator if possible.
+Swap usage is always recorded for each of cgroup. Swap Extension allows you to
+read and limit it.
 
-When swap is accounted, following files are added.
+When CONFIG_SWAP is enabled, following files are added.
 
  - memory.memsw.usage_in_bytes.
  - memory.memsw.limit_in_bytes.
-- 



> Also as to the RSS account name change, I don't know if it's good to polish
> them in docs.

I didn't actually change anything user-visible, just the internal name
of the counters:

static const unsigned int memcg1_stats[] = {
	NR_FILE_PAGES,		/* was MEMCG_CACHE */
	NR_ANON_MAPPED,		/* was MEMCG_RSS */
	NR_ANON_THPS,		/* was MEMCG_RSS_HUGE */
	NR_SHMEM,
	NR_FILE_MAPPED,
	NR_FILE_DIRTY,
	NR_WRITEBACK,
	MEMCG_SWAP,
};

static const char *const memcg1_stat_names[] = {
	"cache",
	"rss",
	"rss_huge",
	"shmem",
	"mapped_file",
	"dirty",
	"writeback",
	"swap",
};

Or did you refer to something else?
