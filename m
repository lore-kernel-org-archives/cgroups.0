From: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/10] docs: cgroup-v1: fix footnotes
Date: Mon, 19 Dec 2022 11:22:04 +0700
Message-ID: <20221219042209.22898-6-bagasdotme@gmail.com>
References: <20221219042209.22898-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QEwa20X9A+wyrh3eoohiFgEbSAwTbPLRyuDyRq0+iJI=;
        b=II0wTtuXbBN9IR3zSvAIoImZqLWv0Oeuf04Gufnq1MigHIf67TLDV0jn7TB8epZsFl
         3sobPQazNVCSNREFsj+waKJmepN4RKRGv5jKhGOO8xQ3FeFMzjxswnj+wJX6zJuVVKtD
         vRlBDOOCXf+uqa8v4WjUjVsV5efjC6QCtCju7xnXLNyCWjRxDOx84+zksXWKn2HTT2Hc
         VEhTup0H5OoAJZe17tUKAxcqCseN4njXFE8lC38/Jk2FkFYYKlooS+tYXbKC8MZgXjKQ
         bg0846Fhh86noJjama1Be+g7Al4PFbe0WtzrpNcNqNgtBIbwrZHUf37b32x+NPmZMMOX
         0zeg==
In-Reply-To: <20221219042209.22898-1-bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=4564; i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; h=from:subject; bh=JPQvjZYEry5PAqc04yDM29al0BTsUtfNTgHs2tjYRDY=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnzn713s2ALYv7Qur7Z8OQ8xUPaUbXSj7TzHyttWtb8Zc7r WimDjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAEyk8gHDP8uTjBf7tATssl9F6ut+mL 3WS/eK9VIWiadnj+7WDqq+JsHIcEb+29LkV/o8IVzfVV5WSz7+2/dD1uj8A4E/ce+mWqx1ZAIA
X-Developer-Key: i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The documentation contains external references, which some of them are
marked as footnotes. Fix the syntax for them to be properly rendered as
such.

Non-footnote references aren't affected since the text for these is
aligned the same to the footnotes.

Signed-off-by: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 .../admin-guide/cgroup-v1/memory.rst          | 36 ++++++++++---------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index c21ce0b906059f..642ef0bb20380a 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -23,7 +23,7 @@ Benefits and Purpose of the memory controller
 =============================================
 
 The memory controller isolates the memory behaviour of a group of tasks
-from the rest of the system. The article on LWN [12] mentions some probable
+from the rest of the system. The article on LWN [12]_ mentions some probable
 uses of the memory controller. The memory controller can be used to
 
 a. Isolate an application or a group of applications
@@ -109,16 +109,16 @@ Brief summary of control files.
 ==========
 
 The memory controller has a long history. A request for comments for the memory
-controller was posted by Balbir Singh [1]. At the time the RFC was posted
+controller was posted by Balbir Singh [1]_. At the time the RFC was posted
 there were several implementations for memory control. The goal of the
 RFC was to build consensus and agreement for the minimal features required
-for memory control. The first RSS controller was posted by Balbir Singh[2]
-in Feb 2007. Pavel Emelianov [3][4][5] has since posted three versions of the
-RSS controller. At OLS, at the resource management BoF, everyone suggested
-that we handle both page cache and RSS together. Another request was raised
-to allow user space handling of OOM. The current memory controller is
+for memory control. The first RSS controller was posted by Balbir Singh [2]_
+in Feb 2007. Pavel Emelianov [3]_ [4]_ [5]_ has since posted three versions
+of the RSS controller. At OLS, at the resource management BoF, everyone
+suggested that we handle both page cache and RSS together. Another request was
+raised to allow user space handling of OOM. The current memory controller is
 at version 6; it combines both mapped (RSS) and unmapped Page
-Cache Control [11].
+Cache Control [11]_.
 
 2. Memory Control
 =================
@@ -971,15 +971,16 @@ commented and discussed quite extensively in the community.
 References
 ==========
 
-1. Singh, Balbir. RFC: Memory Controller, http://lwn.net/Articles/206697/
-2. Singh, Balbir. Memory Controller (RSS Control),
+.. [1] Singh, Balbir. RFC: Memory Controller, http://lwn.net/Articles/206697/
+.. [2] Singh, Balbir. Memory Controller (RSS Control),
    http://lwn.net/Articles/222762/
-3. Emelianov, Pavel. Resource controllers based on process cgroups
+.. [3] Emelianov, Pavel. Resource controllers based on process cgroups
    https://lore.kernel.org/r/45ED7DEC.7010403-3ImXcnM4P+0@public.gmane.org
-4. Emelianov, Pavel. RSS controller based on process cgroups (v2)
+.. [4] Emelianov, Pavel. RSS controller based on process cgroups (v2)
    https://lore.kernel.org/r/461A3010.90403-3ImXcnM4P+0@public.gmane.org
-5. Emelianov, Pavel. RSS controller based on process cgroups (v3)
+.. [5] Emelianov, Pavel. RSS controller based on process cgroups (v3)
    https://lore.kernel.org/r/465D9739.8070209-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
+
 6. Menage, Paul. Control Groups v10, http://lwn.net/Articles/236032/
 7. Vaidyanathan, Srinivasan, Control Groups: Pagecache accounting and control
    subsystem (v3), http://lwn.net/Articles/235534/
@@ -989,7 +990,8 @@ References
    https://lore.kernel.org/r/464D267A.50107-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
 10. Singh, Balbir. Memory controller v6 test results,
     https://lore.kernel.org/r/20070819094658.654.84837.sendpatchset@balbir-laptop
-11. Singh, Balbir. Memory controller introduction (v6),
-    https://lore.kernel.org/r/20070817084228.26003.12568.sendpatchset@balbir-laptop
-12. Corbet, Jonathan, Controlling memory use in cgroups,
-    http://lwn.net/Articles/243795/
+
+.. [11] Singh, Balbir. Memory controller introduction (v6),
+   https://lore.kernel.org/r/20070817084228.26003.12568.sendpatchset@balbir-laptop
+.. [12] Corbet, Jonathan, Controlling memory use in cgroups,
+   http://lwn.net/Articles/243795/
-- 
An old man doll... just what I always wanted! - Clara

