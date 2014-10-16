From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 3/3] kernel: res_counter: remove the unused API
Date: Thu, 16 Oct 2014 13:20:21 +0200
Message-ID: <20141016112021.GC338@dhcp22.suse.cz>
References: <1413251163-8517-1-git-send-email-hannes@cmpxchg.org>
 <1413251163-8517-4-git-send-email-hannes@cmpxchg.org>
 <1413444034.2128.27.camel@x220>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1413444034.2128.27.camel@x220>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Paul Bolle <pebolle@tiscali.nl>, Valentin Rothberg <valentinrothberg@gmail.com>, Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu 16-10-14 09:20:34, Paul Bolle wrote:
> On Mon, 2014-10-13 at 21:46 -0400, Johannes Weiner wrote:
> > All memory accounting and limiting has been switched over to the
> > lockless page counters.  Bye, res_counter!
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > Acked-by: Vladimir Davydov <vdavydov@parallels.com>
> > Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> This patch landed in today's linux-next (ie, next 20141016).
> 
> >  Documentation/cgroups/resource_counter.txt | 197 -------------------------
> >  include/linux/res_counter.h                | 223 -----------------------------
> >  init/Kconfig                               |   6 -
> >  kernel/Makefile                            |   1 -
> >  kernel/res_counter.c                       | 211 ---------------------------
> >  5 files changed, 638 deletions(-)
> >  delete mode 100644 Documentation/cgroups/resource_counter.txt
> >  delete mode 100644 include/linux/res_counter.h
> >  delete mode 100644 kernel/res_counter.c
> 
> There's a last reference to CONFIG_RESOURCE_COUNTERS in
> Documentation/cgroups/memory.txt. That reference could be dropped too,
> couldn't it?
---
From a54e375e85c814199f480cb4ee7a133a395c5a00 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 16 Oct 2014 13:15:24 +0200
Subject: [PATCH] kernel-res_counter-remove-the-unused-api-fix

ditch the last remainings of res_counter

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/cgroups/memory.txt | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index f624727ab404..67613ff0270c 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -116,16 +116,16 @@ The memory controller is the first controller developed.
 
 2.1. Design
 
-The core of the design is a counter called the res_counter. The res_counter
-tracks the current memory usage and limit of the group of processes associated
-with the controller. Each cgroup has a memory controller specific data
-structure (mem_cgroup) associated with it.
+The core of the design is a counter called the page_counter. The
+page_counter tracks the current memory usage and limit of the group of
+processes associated with the controller. Each cgroup has a memory controller
+specific data structure (mem_cgroup) associated with it.
 
 2.2. Accounting
 
 		+--------------------+
-		|  mem_cgroup     |
-		|  (res_counter)     |
+		|  mem_cgroup        |
+		|  (page_counter)    |
 		+--------------------+
 		 /            ^      \
 		/             |       \
@@ -352,9 +352,8 @@ set:
 0. Configuration
 
 a. Enable CONFIG_CGROUPS
-b. Enable CONFIG_RESOURCE_COUNTERS
-c. Enable CONFIG_MEMCG
-d. Enable CONFIG_MEMCG_SWAP (to use swap extension)
+b. Enable CONFIG_MEMCG
+c. Enable CONFIG_MEMCG_SWAP (to use swap extension)
 d. Enable CONFIG_MEMCG_KMEM (to use kmem extension)
 
 1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
-- 
2.1.1

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
