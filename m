From: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 4/9] docs: cgroup-v1: fix footnotes
Date: Thu,  5 Jan 2023 20:16:29 +0700
Message-ID: <20230105131633.553574-5-bagasdotme@gmail.com>
References: <20230105131633.553574-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WcgLa2dNrRbbB5gOhzfJxjnV71pkRRr18/tvuPVFK50=;
        b=keDd3AgPUHBkhQi+rsF5VDBfEFxkbSMl3Vqw0PYwH/URI1zS8RogSrFV/8SHOT2rcb
         I133BM/nD4wJ1EadTEgtSEDHDPrcig04g3dNQ4nfkqx1gvITJcygp7HgRmME0VppT5i5
         8g7EWVT/saKRIoUp1ZIB7M2O49HAmxkadDEdEUWyUhIldVpmt2TD6k1XYn5vN+l4y0t+
         w5uhh7NvkckKzoRXRBq2lpxu28RhgpVqRYPd9uRQhoPdfLt59iM9m5mpmZVpxojBFHUU
         kKNdT2f3FiEZjnlOWzwCzGTfAEwvYMLKN2ON1apQj+lEfgkbpdE1RfunoE+Bbj/ZZ3aU
         1R0g==
In-Reply-To: <20230105131633.553574-1-bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=4564; i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; h=from:subject; bh=Li+17qbQJgnbNb0Pbpw9z8Zmcq62SZTQcF9sfN0MfPE=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnbzq6P9OrLP7vybP+GlXoHvU8ZyVxYFBl27qn5hBWm9b4h Kzo1O0pZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjCRl/4M/4wTt0d1cuy3W33uwGLZ0q yehNM3tp7XkOpxUg0Ofe9xdicjQ2d5hGC1K1+WwIaTC+q3+EedWJbbzfbB321yw8oapQW9bAA=
X-Developer-Key: i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux CGroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Documentation <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
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
index 2b807fc128c662..8d1cedcf44f6ea 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -23,7 +23,7 @@ Benefits and Purpose of the memory controller
 =============================================
 
 The memory controller isolates the memory behaviour of a group of tasks
-from the rest of the system. The article on LWN [12] mentions some probable
+from the rest of the system. The article on LWN [12]_ mentions some probable
 uses of the memory controller. The memory controller can be used to
 
 a. Isolate an application or a group of applications
@@ -107,16 +107,16 @@ Brief summary of control files.
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
@@ -960,15 +960,16 @@ commented and discussed quite extensively in the community.
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
@@ -978,7 +979,8 @@ References
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

