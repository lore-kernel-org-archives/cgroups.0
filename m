From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 04/10] docs: cgroup-v1: use code block for locking order schema
Date: Mon, 19 Dec 2022 11:22:03 +0700
Message-ID: <20221219042209.22898-5-bagasdotme@gmail.com>
References: <20221219042209.22898-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/nm7j4zp8S75Gf6ZgO/l+49FQ5Ia2zwvn+/ND79+AHM=;
        b=RehRdEZifLMG395ppV/7LVvRdnCDdwl9Hfk5Mmn0sswBZr2pNnW1dWd6YtLlfrIL0K
         oqFZJeTpgIBe4v9P3jAHQ9dobxEbwfP4nRMw0pL4/19ifX9Wwh5VebaXq3G0TckKJT5Q
         3kqZoZbODRk6hDbPJJd4GFJwl9htH2bxOx75GIbhK2rZIKB2c/2H7a6LVwPUGFKq6dG/
         voKaNBAD4+uMB8PRT0gAzEa0OtrUnuL4iaXuxFPQ2hzvgPrPfj6mx/ywyY5yaaXZ/NLt
         mBvHQKq1T/lpaZO+0hDhimJVesG6NF/drKn9yloFBkV8jzeDVvtTEOdeCDnZ9BCUi30G
         zz1A==
In-Reply-To: <20221219042209.22898-1-bagasdotme@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=903; i=bagasdotme@gmail.com; h=from:subject; bh=myLqQWWL5ny5cfaM/c1+RVILw8UoUUmH9P1+d/iRWF8=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnzn70zn9QX8TP45KkeoY/d0cnefcv2Fi8TMpOtTxa/U5hk vTWwo5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABOZvInhn/En+655Kw+EtDmba0gcLq 3akbQju8Am0mHuv99/CyRu6DIyTCuP1Cr+cCL9uti17M/FphdjK1O0XvOHHklgXN1wLpWNAwA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Linux Memory Management List <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Bagas Sanjaya <bagasdotme@gmail.com>

The locking order schema is a figure (like diagram), which should have
been formatted with literal code block for consistency with other
figures.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index f828db2a671be4..c21ce0b906059f 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -289,7 +289,7 @@ When oom event notifier is registered, event will be delivered.
 2.6 Locking
 -----------
 
-Lock order is as follows:
+Lock order is as follows::
 
   Page lock (PG_locked bit of page->flags)
     mm->page_table_lock or split pte_lock
-- 
An old man doll... just what I always wanted! - Clara

