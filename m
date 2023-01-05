From: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 5/9] docs: cgroup-v1: move hierarchy of accounting caption
Date: Thu,  5 Jan 2023 20:16:30 +0700
Message-ID: <20230105131633.553574-6-bagasdotme@gmail.com>
References: <20230105131633.553574-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wkiZx8G6kdpCzam2vHq1Krq/P436bxFUUtcX4wR/YOk=;
        b=BAV6F8Yry5m7pE15IbeDN664RrsiJsNm9vbYob0JFJ2Ju/wOA0FWzzb/8xhmm9hA7C
         v/izEcjV1ZWW0M0eYpLFDCeiib6kON4L2EJObpomid/HgCPtHZuwpF/MZbVzgOOMVBxA
         2eQ/j3CEQDk9/feT47ZDi8n0VmyCnOLONMBO9N6B87pyCEjB3dZEEQGjkaaTnHQVfsB1
         9iSMexDvgOSQsSASKop+FTY3ugsqALhgHQCstrTJtedG0BviKysorT5ivSoL2VR9qTuN
         r2nMIplNNT4c3bC9AXof2DUjXncmHxPhxjzVUz8sHd3mIA/hwGrQAcq953i+u4hITGhc
         hlaA==
In-Reply-To: <20230105131633.553574-1-bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1218; i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; h=from:subject; bh=TtcaCybTo5E7/N6tLTMu/WowHmwrmC15HAxU0Etkee0=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnbzm6QcbE4K32OSZZjtpvtW73vYXYp6j8ub5d/5Jc/icVt 0/PJHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZjIoiCG/67NdXrclae/rl4qPj1HKP 1KjaXzB8dJLA0uxtGtGaKxdxgZHjisMcn4dnP232h9H7YC7h1W0yar8uexCGecca19c8yFCwA=
X-Developer-Key: i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux CGroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Documentation <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The caption for hierarchy of accounting figure is in the code block,
which is quite odd. Move the caption into :caption: option of
code-block:: directive instead.

Signed-off-by: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 8d1cedcf44f6ea..4d96a5bbbfcfdc 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -147,7 +147,8 @@ specific data structure (mem_cgroup) associated with it.
 2.2. Accounting
 ---------------
 
-::
+.. code-block::
+   :caption: Figure 1: Hierarchy of Accounting
 
 		+--------------------+
 		|  mem_cgroup        |
@@ -167,7 +168,6 @@ specific data structure (mem_cgroup) associated with it.
            |               |           |               |
            +---------------+           +---------------+
 
-             (Figure 1: Hierarchy of Accounting)
 
 
 Figure 1 shows the important aspects of the controller
-- 
An old man doll... just what I always wanted! - Clara

