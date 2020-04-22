From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH 15/18] mm: memcontrol: make swap tracking an integral part
 of memory control
Date: Wed, 22 Apr 2020 11:14:40 +0800
Message-ID: <2721c508-9b32-d0e7-454d-386129bfda1b@linux.alibaba.com>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-16-hannes@cmpxchg.org>
 <e9d58c82-d746-dcd0-d9e3-6322014a3b03@linux.alibaba.com>
 <20200421143923.GC341682@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200421143923.GC341682-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org



在 2020/4/21 下午10:39, Johannes Weiner 写道:
> Hi Alex,
> 
> thanks for your quick review so far, I'll add the tags to the patches.
> 
> On Tue, Apr 21, 2020 at 05:27:30PM +0800, Alex Shi wrote:
>>
>>
>> 在 2020/4/21 上午6:11, Johannes Weiner 写道:
>>> The swapaccount=0 boot option will continue to exist, and it will
>>> eliminate the page_counter overhead and hide the swap control files,
>>> but it won't disable swap slot ownership tracking.
>>
>> May we add extra explanation for this change to user? and the default
>> memsw limitations?
> 
> Can you elaborate what you think is missing and where you would like
> to see it documented?
> 
Maybe the following doc change is better after whole patchset? 
Guess users would would happy to know details of this change.

Also as to the RSS account name change, I don't know if it's good to polish
them in docs.

Thanks
Alex

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 0ae4f564c2d6..1fd0878089fe 100644
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

@@ -230,10 +230,10 @@ caller of swapoff rather than the users of shmem.
 2.4 Swap Extension (CONFIG_MEMCG_SWAP)
 --------------------------------------

-Swap Extension allows you to record charge for swap. A swapped-in page is
-charged back to original page allocator if possible.
+Swap usage is always recorded for each of cgroup. Swap Extension allows you to
+read and limit it.

-When swap is accounted, following files are added.
+When swap is limited, following files are added.

  - memory.memsw.usage_in_bytes.
  - memory.memsw.limit_in_bytes.

> From a semantics POV, nothing changes with this patch. The memsw limit
> defaults to "max", so it doesn't exert any control per default. The
> only difference is whether we maintain swap records or not.
> 
