Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86F3509F17
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 23:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790377388; cv=none; b=MxG8ErsNxoxIVNgaR4fZTgiHAq4Q57+jTJ8NvubATyPS5OjtaiilqrG+HUuEbZ+osnK245+61j3u9C9V/JDWsImKOaYw9EVnA7zZ+xeJsfTB6IF/0YNKBKUTQV0hFlc3O9gfs1UwHmRmWQVexIPmWY83l7IX4wsadGu55Yy1tMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790377388; c=relaxed/simple;
	bh=jandskfkITyjC7rvkXLAEoCYbYIdJkGLy5tzhgU6M4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DAKFaKRBImzcYhi6GmjUBGxEmTrJuQkj3NHMMIBSmGajeC4SOT5HBi43NSCi1aozTuc21lQ6GojbkT+6DYZS0+TpxjjE9AwCqb20sDXnvDkMp2kUfdhhXp3LlhbEuRrHuzBz1LXidAXBxVREwBST22QdCqc1N+R/gAaO9dD4E94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=A94lZouv; arc=none smtp.client-ip=74.125.230.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="A94lZouv"
Received: by mail-qk2-f42.google.com with SMTP id af79cd13be357-93bd580489dso134066885a.1
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 16:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790377383; x=1790982183; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PiEVC1BfM3JbJHmz6IrQSpeOS1QFhfgMFnl3j26Htjk=;
        b=A94lZouvKAzEKsqSL/a6UzMxCA9GzIsQbusgbX18VD/4DwKuWyDb6CLr8AdemoenTW
         617YC8IOvzTvhVbOpq/AGAEAVnxLR1trNp2nuOZ/gQBf0n9rM6+fp0sRgPpsvGPcpU14
         Us49emjjkXz5t8Ymv5sPiXC+LvBbNpDFTRl0f6Qt5SJepfum1T4JRhrSTH28n/2XHWkL
         vyz8ZZaHH/XKcZ9yTKCQOZrjW/5wXNTizOddw0dBQfLNqN+LKKjdHZ11eGj3uy6l4U6a
         i8Ca67ZUXj09625YduPLfKVCsBCTuVPUvbAoNa63euPMbiJmP4dYz6vSluHidDJcvTQL
         5XCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790377383; x=1790982183;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PiEVC1BfM3JbJHmz6IrQSpeOS1QFhfgMFnl3j26Htjk=;
        b=SjnJWzYuaJlKBPxrmWQerb34YFv063I2Tts5auZPKTbcoqklwj79s1SM9+4pojygqE
         FQsal6ApVn6JwphAo7lWyi+507H4vutkRgTqT5zEGeUvOEeLngfMiqp/TS0G6JIabbbY
         rddAK2W1jA5+k7uSXe8Khp796teZ9Re2W5rObEmD91bDTn0Kt194V2N9L8Uomx2TyB7+
         VNvPfmWpkrVxvYTqIL75JhSBWFGbjnSYT3aod6z39VBRHCbVR6G9D1VU/a0tlh96+cz+
         Es5z/5OQWwFaPYOft4Fxv3AVrYPc824KmgFrGzu8jWulgNgxJu8lOf3sDcYOZdDMYsi2
         +R0A==
X-Forwarded-Encrypted: i=1; AKwUvBxYpFQ7aqLAWGlpiB3X1jb0XjkeISTcEZFpPaSB7MeFFAAOrTskFUB8x9n+C9sHsiv0yvjO2Fa3@vger.kernel.org
X-Gm-Message-State: AFuF++kU2u7hL+Sz8hM6f1CYT8C/FyWqY9jQcAJZQNBmN+d6SRw4ds0q
	xT4p7AHDMzg0Bey84yFvEJyLMCFuaUeJsAIXfME9toSqybY5qd0rDbFU1IAmmxDAd5c=
X-Gm-Gg: AYBFou2LugkXENSo+uX+FX+cRKkgXEwmQE2GN9nUWs3C0DC5u+3eFQmU7ulTPlyyic6
	dFR/JPagZTdE58RirOpumhJwj1FB4uMfsxH8lJGMxZfBx7th+WC896UUQhq8jFG+jTpnbq9zgqm
	rCjjgpxvWxRIMYoVNmIJY0EKWiErv+ic1wds864Z8RA2tPOBqSWZQhsUPCNiPkL9L0ykgHnSkaq
	zhKGNsJQ7Y5E/Q2EoupZQj1eBVwZgxECOqwrf4Xe3hb93whryccoIuNVyhgTVMRaZMZeuI4rR+8
	nrxJNDE5huO6POCEKQiVl4xfkWKR0/w0+JXSuSI8yiMVj3VB6HC0vt4tI7XmAp3MIgpcJr022JO
	ehDNnlaO1z8uoP+xpW1toW9IlPJKt4/u6kAUYLHTA/pJArMojaZssShbVYXgS8qKcX1AiNpbe3I
	zr30hr40fMuh4SMqFdzNlVhaGYqHllZWOteuyRQkKPYPVBiCCAXchapaGgcH86fUWdCVwcrjkrR
	tlCTRPM8xyapvllak/uoqbvboEIGnQyvsITjyV/0+l3Bac/9mG9Fvc=
X-Received: by 2002:a05:620a:2614:b0:93a:2bdc:cd57 with SMTP id af79cd13be357-93c43b7f72amr755724385a.2.1790377382584;
        Fri, 25 Sep 2026 16:03:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c4493af29sm290317085a.28.2026.09.25.16.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 16:03:02 -0700 (PDT)
Date: Fri, 25 Sep 2026 19:02:59 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com, arun.george@samsung.com, balbirs@nvidia.com, 
	brendan.jackman@linux.dev, yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com, 
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <arb0mV23QmRVDtB3@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>

On Mon, Jul 20, 2026 at 03:33:54PM -0400, Gregory Price wrote:
> This series introduces the concept of "Private Memory Nodes", which
> are opted into two basic functionalities by default:
>   - page allocation (mm/page_alloc.c)
>   - OOM killing
> 

All, I wanted to preface v6 with an update, I probably won't be sending
it out on-list before LPC (i've been a bit noisey as it is, I'll give
it a rest).


But I would like to give you the highlights for those interested.

The latest working branch can be found here:
https://github.com/gourryinverse/linux/tree/scratch/gourry/managed_nodes/rfc6-nonuma

You will find the following:

- There is no depedency on exported alloc_flags (willy, i found a way),
  but there is a need for `folio_alloc_private()` to explicitly ask
  for the ALLOC_ZONELIST_PRIVATE.

- feature bits have been converted to node_state[] bits

- N_MEMORY_COMMON was added to mean "common memory" - i.e. the existing
  N_MEMORY set.  A private node is now defined as !N_MEMORY_COMMON.

- opt-out sites no longer check for !N_MEMORY_PRIVATE, they instead
  iterate over node_state[N_MEMORY_COMMON].  This is *much* cleaner.

- opt-in sites get to define bits in terms of their own service, e.g.

  /* for each reclaimable node */
  for_each_node_mask_state(..., N_MEMORY_RECLAIM) {
     ...
  }

  Or maybe even:

  for_each_reclaimable_node()    :)


- There are only 2 node features in the base set:

  N_MEMORY_RECLAIM    -  generic reclaim runs on the node
  N_MEMORY_COMPACTION -  compaction will run on the node

  You'll notice there's no userland numa control support, more on this
  in a moment.

  This is all you need to have functional device-private coherent
  memory that uses the page allocator.

  Disabling N_MEMORY_RECLAIM does not necessarily mean you're prevented
  from using vmscan.c and the LRU - it just means we'd need to expose an
  interface for a !N_MEMORY_RECLAIM node to explicitly ask for reclaim
  to operate on it.

  Tiering (Demotion) *to* a node is not supported.  We can probably
  debate whether this should mean tiering *from* a node should be
  supported or not as well.  This is easy to change.


- The working branch also includes a minimal compressed-ram service
  that only supports anonymous memory.

  Supporting file-backed memory (and shmem) is a whole different can
  of worms that deserves its own discussion.

  I will post this as a separate RFC from the base set, but it is
  available to play with on my working branch.


- I ship a basic dax driver for the base series, `anondax` which allows
  existing devices to online a private node with both compaction and
  reclaim support for testing.  This enables this use case:

  fd = open(/dev/my_device, ..., O_DIRECT);
  buf = mmap(fd, ..., MAP_SHARED)
  my_file = open(myfile, ...);
  read(buf, myfile); /* fault directly onto device memory */

  With swap (and no tiering), this gives you a private over-commitable
  node for which aspiring drivers can use to implement their own
  mmu_notifier callback stream to manage device page tables and such.


- The reason mempolicy (and user numa in general) is not supported is a
  critical relationship between the OOM killer and page allocator.

  In trivial scenarios, if a consumer of a private node overshoots and
  causes an OOM - it will be the largest consumer and be chosen as the
  victim.

  If there are many consumers - what actually happens in practice is the
  oom killer attempts to select a victim based on *task* policy... which
  makes every task a candidate.  This leads to, among other things,
  either an OOM storm and/or a full blown panic because a victim cannot
  be located (depending on the constraints).

  I've concluded that as-is, this is not tractable. But also, it is not
  actually needed if the devices provide their own chardev to provide
  a basic wrapper around folio_alloc_private().

  This unfortunately means potential users like guest_memfd are unlikely
  to be able to use the nodes without hard-coding the allocator
  interface, as opposed to a mempolicy.

  I think it's possible instead to *maybe* add N_MEMORY_USER_MIGRATION
  and allow for explicit movement between nodes, but not full blown
  mempolicies.

  The relationship between page_alloc, cpuset, mempolicy, and the oom
  killer is just too tight to allow allocations without the use of
  __GFP_THISNODE - which the private allocation interface will enforce.


As it stands, the series has been heavily minimized in both line count
and patch number.

The base series is ~22 commits with the scary diffstat below, but many
of the core mm/ patches are similar to the patch below - with nearly
all of the real complexity happening in reclaim and memory hotplug.

despite the branch name, I intend to drop RFC from here-on, everything
else required for the base series is in mm-new.


See you at LPC
~Gregory

-------

diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f8..cd61566b44fa1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2266,7 +2266,7 @@ static int __add_folio_for_migration(struct folio *folio, int node,
        if (is_zero_folio(folio) || is_huge_zero_folio(folio))
                return -EFAULT;

-       if (folio_is_zone_device(folio))
+       if (!folio_is_common_memory(folio))
                return -ENOENT;

        if (folio_nid(folio) == node)
@@ -2390,7 +2390,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
                err = -ENODEV;
                if (node < 0 || node >= MAX_NUMNODES)
                        goto out_flush;
-               if (!node_state(node, N_MEMORY))
+               if (!node_state(node, N_MEMORY_COMMON))
                        goto out_flush;

                err = -EACCES;
@@ -2475,7 +2475,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
                if (folio) {
                        if (is_zero_folio(folio) || is_huge_zero_folio(folio))
                                err = -EFAULT;
-                       else if (folio_is_zone_device(folio))
+                       else if (!folio_is_common_memory(folio))
                                err = -ENOENT;
                        else
                                err = folio_nid(folio);


 Documentation/ABI/stable/sysfs-devices-node |  21 +++++++++++++++++
 Documentation/admin-guide/cgroup-v2.rst     |   7 ++++++
 Documentation/mm/physical_memory.rst        |  15 ++++++++++++-
 drivers/base/node.c                         |  67 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/dax/kmem.c                          |   2 +-
 include/linux/gfp.h                         |   6 +++++
 include/linux/memory_hotplug.h              |   2 +-
 include/linux/mmzone.h                      |  45 +++++++++++++++++++++++++++++++++++++
 include/linux/node.h                        |  12 ++++++++++
 include/linux/nodemask.h                    |  53 ++++++++++++++++++++++++++++++++++++++++++-
 kernel/cgroup/cpuset.c                      |  39 ++++++++++++++++++++++++++------
 kernel/sched/fair.c                         |   6 ++---
 mm/compaction.c                             |  21 +++++++++++------
 mm/damon/ops-common.c                       |  15 ++++++++-----
 mm/damon/vaddr.c                            |  20 +++++++++++++----
 mm/huge_memory.c                            |   2 +-
 mm/internal.h                               |  22 ++++++++++++++++++
 mm/khugepaged.c                             |   9 ++++++--
 mm/ksm.c                                    |   8 ++++---
 mm/madvise.c                                |   6 ++---
 mm/memory-tiers.c                           |  25 +++++++++++----------
 mm/memory_hotplug.c                         | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------
 mm/mempolicy.c                              |  51 +++++++++++++++++++++++++-----------------
 mm/migrate.c                                |   6 ++---
 mm/mm_init.c                                |  22 +++++++++---------
 mm/page_alloc.c                             | 115 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 mm/page_alloc.h                             |   5 +++++
 mm/vmscan.c                                 |  31 +++++++++++++++-----------
 28 files changed, 585 insertions(+), 157 deletions(-)
