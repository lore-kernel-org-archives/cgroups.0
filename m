From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 3/6] mm: Kconfig: group swap, slab, hotplug and thp
 options into submenus
Date: Wed, 11 May 2022 12:28:57 -0400
Message-ID: <YnvkSVivfnT57Vwh@cmpxchg.org>
References: <20220510152847.230957-1-hannes@cmpxchg.org>
 <20220510152847.230957-4-hannes@cmpxchg.org>
 <20220510154037.c7916ee9d7de90eedd12f92c@linux-foundation.org>
 <YnvU0hwCfQ11P8Ce@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vjtbfzb3XfQBK49vkLU2ME+zLfRrW3PO/4LCqkSQxEo=;
        b=4rjytAOgIXa9oPL4+JvWFQPgZx54vdMfMIxW8eljWagpDYXPTR81+XelntW9epHwlY
         DPldjGntjh0a7rjeBqYQVVoujjL/MVQo0nqpIkvAXLC4NlYfuPZdMHZOpF6tz7nxW5x0
         UbHP9qf1gRsOxHo/D6Xrwrt3Q1NPgnfJR50weL9kafzWEeHl1RdJeCc220fvKfdufkVk
         qCmDi88pFnxUC9Hy9C85YGx0KIpbiun+O79f7ude563WJnH2cUkwsB4uCDnUwW3xtpbR
         zIIuXu9o6qjwbfRwtpqi7ZvCHEdEjbASF/jD9PiRkM5GKbJ0F/ZmqKvgO2zwKVfDmVEt
         xQMA==
Content-Disposition: inline
In-Reply-To: <YnvU0hwCfQ11P8Ce-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, May 11, 2022 at 11:22:59AM -0400, Johannes Weiner wrote:
> On Tue, May 10, 2022 at 03:40:37PM -0700, Andrew Morton wrote:
> > On Tue, 10 May 2022 11:28:44 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > 
> > > There are several clusters of related config options spread throughout
> > > the mostly flat MM submenu. Group them together and put specialization
> > > options into further subdirectories to make the MM submenu a bit more
> > > organized and easier to navigate.
> > 
> > Causes
> > 
> > hp2:/usr/src/25> make allnoconfig
> 
> My bad. I'll respin those on top of the others and add allnoconfig
> builds to my testing routine. Thanks.

Actually, this is rather straight-forward to fix in place. This delta
for 3/6 takes care of both warnings:

---
From 2b5fcaed2714584b40c7d7f76bdda250aa94b48f Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date: Wed, 11 May 2022 12:12:37 -0400
Subject: [PATCH] mm: Kconfig: group swap, slab, hotplug and thp options into
 submenus fix

WARNING: unmet direct dependencies detected for ARCH_WANT_GENERAL_HUGETLB
  Depends on [n]: TRANSPARENT_HUGEPAGE [=n]
  Selected by [y]:
  - X86 [=y]

WARNING: unmet direct dependencies detected for ARCH_WANTS_THP_SWAP
  Depends on [n]: TRANSPARENT_HUGEPAGE [=n]
  Selected by [y]:
  - X86 [=y] && X86_64 [=y]

The ARCH_WANT* symbols are selected by the arch to communicate
requests to THP if enabled. Those mustn't be inside the 'if THP' block
for user-visible THP options of course. Move them back out.

Reported-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 2c5935a28edf..c2f4a547ab00 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -692,6 +692,12 @@ config NOMMU_INITIAL_TRIM_EXCESS
 
 	  See Documentation/admin-guide/mm/nommu-mmap.rst for more information.
 
+config ARCH_WANT_GENERAL_HUGETLB
+	bool
+
+config ARCH_WANTS_THP_SWAP
+	def_bool n
+
 menuconfig TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
 	depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE && !PREEMPT_RT
@@ -733,12 +739,6 @@ choice
 	  benefit.
 endchoice
 
-config ARCH_WANT_GENERAL_HUGETLB
-	bool
-
-config ARCH_WANTS_THP_SWAP
-	def_bool n
-
 config THP_SWAP
 	def_bool y
 	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP && SWAP
-- 
2.35.3
