From: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 9/9] docs: cgroup-v1: use numbered lists for user interface setup
Date: Thu,  5 Jan 2023 20:16:34 +0700
Message-ID: <20230105131633.553574-10-bagasdotme@gmail.com>
References: <20230105131633.553574-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8J8qW+Vq8pd6T9oMP3SU6TUuvWLiPg70zvs+kZ90og=;
        b=iCXg4LXUCBckmKqWrrrxIf26SHrZFmi22auf4ZaicKRigcxRH4J1pPKSfOGqGrx+70
         2Dz9hHlbyfiE4Ej5uw8WLiINWCrDAzbB2ANP3+/gbqzdOwBY6PAVA7BUZTzjTjN9cnpk
         w7tPekaV9ZL3vtm3yJhU/niRomQUa/kb4CWyJH8y8iuAh/qLPl6JCDrc6ste8rMI94Vb
         txsfBlJ+2NXRQscx4WGe5FgfV4qryQy/us+G8v74ohmJ9dZ1/1Yydjnm5pMDR4CGIFWd
         rFyAaog+Q+WI+4vFL84NNY7n+NkZ1tRC3x6sboqGdsT7/ikXBHb5637YYaiNJOQxgOy1
         wIXQ==
In-Reply-To: <20230105131633.553574-1-bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=3017; i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; h=from:subject; bh=nysWUkfThi/UCTzfZAv3ZXQWTYDkn/SrXnv8ebwTGco=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnbzm5cWtCq0ng04TEHZ7mB8SLVvBOR8ztZH9yf/zX6aJlM um9YRykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACbibcPwT83d3Ur0YVzhzYLHnCdO+i /VN2/wf6tmmSycLGTr8LlwKsN/L4kJ/ZbNi2Kc+F4s8DBN49CYLV1rXfH+fJz40j4rB2VOAA==
X-Developer-Key: i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux CGroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Documentation <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Setup instructions for memory resource controller UI uses a mix of
section headings and normal paragraphs, whereas numbered lists are
better fit for this purpose.

While at it, also slightly reword the instructions and add reference to
"Why are cgroups needed?" in the main cgroups documentation.

Signed-off-by: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 .../admin-guide/cgroup-v1/cgroups.rst         |  2 ++
 .../admin-guide/cgroup-v1/memory.rst          | 26 ++++++++-----------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/cgroups.rst b/Documentation/admin-guide/cgroup-v1/cgroups.rst
index b0688011ed06de..9343148ee99366 100644
--- a/Documentation/admin-guide/cgroup-v1/cgroups.rst
+++ b/Documentation/admin-guide/cgroup-v1/cgroups.rst
@@ -80,6 +80,8 @@ access. For example, cpusets (see Documentation/admin-guide/cgroup-v1/cpusets.rs
 you to associate a set of CPUs and a set of memory nodes with the
 tasks in each cgroup.
 
+.. _cgroups-why-needed:
+
 1.2 Why are cgroups needed ?
 ----------------------------
 
diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 16d938abe69f81..27d89495ac880a 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -387,30 +387,30 @@ U != 0, K >= U:
 3. User Interface
 =================
 
-3.0. Configuration
-------------------
+To use the user interface:
 
-a. Enable CONFIG_CGROUPS
-b. Enable CONFIG_MEMCG
-
-3.1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
--------------------------------------------------------------------
-
-::
+1. Enable CONFIG_CGROUPS and CONFIG_MEMCG options
+2. Prepare the cgroups (see :ref:`Why are cgroups needed?
+   <cgroups-why-needed>` for the background information)::
 
 	# mount -t tmpfs none /sys/fs/cgroup
 	# mkdir /sys/fs/cgroup/memory
 	# mount -t cgroup none /sys/fs/cgroup/memory -o memory
 
-3.2. Make the new group and move bash into it::
+3. Make the new group and move bash into it::
 
 	# mkdir /sys/fs/cgroup/memory/0
 	# echo $$ > /sys/fs/cgroup/memory/0/tasks
 
-Since now we're in the 0 cgroup, we can alter the memory limit::
+4. Since now we're in the 0 cgroup, we can alter the memory limit::
 
 	# echo 4M > /sys/fs/cgroup/memory/0/memory.limit_in_bytes
 
+   The limit can now be queried::
+
+	# cat /sys/fs/cgroup/memory/0/memory.limit_in_bytes
+	4194304
+
 .. note::
    We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
    mega or gigabytes. (Here, Kilo, Mega, Giga are Kibibytes, Mebibytes,
@@ -422,10 +422,6 @@ Since now we're in the 0 cgroup, we can alter the memory limit::
 .. note::
    We cannot set limits on the root cgroup any more.
 
-::
-
-  # cat /sys/fs/cgroup/memory/0/memory.limit_in_bytes
-  4194304
 
 We can check the usage::
 
-- 
An old man doll... just what I always wanted! - Clara

