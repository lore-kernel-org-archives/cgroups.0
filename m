From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 03/10] docs: cgroup-v1: wrap remaining admonitions in admonition blocks
Date: Mon, 19 Dec 2022 11:22:02 +0700
Message-ID: <20221219042209.22898-4-bagasdotme@gmail.com>
References: <20221219042209.22898-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dm3StokzlT7Szh+BiWvCYI/X474BbeHVmllPMqNHQFs=;
        b=CivmBZcjEkCkLhyVLzlphxvDMwl6nheUGKlegj1hnyWxPXopZtrKelMJg4NLztp6Ei
         19ap32V2lPltBGqPJjF1yBiq+0421am0efG9yS/XctjfSJMUHJPg2KbY+drosobdJh7n
         gghu6w/mHGHBlxzAbFf/3ky8O7nGUoI16/HmaFoXCTM60F0g6N/aa3HWSmyxvZZBroOs
         0IUlMvIpvPq9EUVRd08Us5p8bQ/ETvUMY7+aK58/0yKxoewBuKFZb0FIc8vWRY1rerdg
         ofnz3i0Kc4V+CwnzTxo9fb0DS9JoKTh94ENhKF8b6RzRqJ5RcsZp2hXo25O5OqXf7Mgo
         1soA==
In-Reply-To: <20221219042209.22898-1-bagasdotme@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2573; i=bagasdotme@gmail.com; h=from:subject; bh=lpUMV2xz23OWCWVLnriwcRj5xPuoIGRu0Ewl15SLIFA=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnzn71z7D2sLB/nI+epfmjX8TWbYy0vZXxnNyt0vbLVJ3OP 3IINHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZjInU0M/2PY0lqe7C6p53qqp9STtv jzwfmNq/u1OK6wh/Gr3U9V1WD4w7ObbfXhP2dvCXbryN/+9eeUl0qKzZdN71um3rpuJn59MhsA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Linux Memory Management List <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Bagas Sanjaya <bagasdotme@gmail.com>

Wrap two other admonitions in appropriate blocks in order for readers to
pay more attention to block contents:

  * hint:: for editor's note
  * warning:: for move charges deprecation

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 .../admin-guide/cgroup-v1/memory.rst          | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index ec99bcbd55c2e7..f828db2a671be4 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -13,11 +13,11 @@ Memory Resource Controller
       memory controller in this document. Do not confuse memory controller
       used here with the memory controller that is used in hardware.
 
-(For editors) In this document:
-      When we mention a cgroup (cgroupfs's directory) with memory controller,
-      we call it "memory cgroup". When you see git-log and source code, you'll
-      see patch's title and function names tend to use "memcg".
-      In this document, we avoid using it.
+.. hint::
+      (For editors) In this document, when we mention a cgroup (cgroupfs's
+      directory) with memory controller, we call it "memory cgroup". When you
+      see git-log and source code, you'll see patch's title and function names
+      tend to use "memcg". In this document, we avoid using it.
 
 Benefits and Purpose of the memory controller
 =============================================
@@ -723,12 +723,14 @@ If we want to change this to 1G, we can at any time use::
 8. Move charges at task migration (DEPRECATED!)
 ===============================================
 
-THIS IS DEPRECATED!
+.. warning::
 
-It's expensive and unreliable! It's better practice to launch workload
-tasks directly from inside their target cgroup. Use dedicated workload
-cgroups to allow fine-grained policy adjustments without having to
-move physical pages between control domains.
+   THIS IS DEPRECATED!
+
+   It's expensive and unreliable! It's better practice to launch workload
+   tasks directly from inside their target cgroup. Use dedicated workload
+   cgroups to allow fine-grained policy adjustments without having to
+   move physical pages between control domains.
 
 Users can move charges associated with a task along with task migration, that
 is, uncharge task's pages from the old cgroup and charge them to the new cgroup.
-- 
An old man doll... just what I always wanted! - Clara

