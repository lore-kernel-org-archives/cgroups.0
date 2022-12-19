From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 06/10] docs: cgroup-v1: move hierarchy of accounting caption
Date: Mon, 19 Dec 2022 11:22:05 +0700
Message-ID: <20221219042209.22898-7-bagasdotme@gmail.com>
References: <20221219042209.22898-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4bkaFHH9828XqB+keHudWE3HrJtGvwGZpCKERfRezL4=;
        b=UIKz0INgkJM01u8DImabW8vV0MXUcqTEWZ6ucIGfJpJGp3Ik7KfefxrEs5exBi19qf
         XOlxIyF1jrI3Sq8Uxn+VtjhXJOy7+fB74CPXeuahB4jkAnrIaxlbygXxHDuIt7YxoZRY
         SEKriY2DNUbP0Dz1n2r3FsmrLK38p9D0i4yJyz1BoG8JXNOnHiXiBS+fb6ScQ8dmQxU2
         /b1NwJV6ZymcsU+LSeAsDigeFh1FLNZTKynWuqlRIdJHw9djnkAV9Cncv1Kb1fH9oh8Y
         Ajg8/GvAGXhcsO/P7JDzYZlwUAH3vmMR7bOyjo8yFrMnt++B2ZI2h4gWSuOJlPi8fT9b
         Ppjw==
In-Reply-To: <20221219042209.22898-1-bagasdotme@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1218; i=bagasdotme@gmail.com; h=from:subject; bh=WY+LE4Uwh5JcjEow4gYNYbipiHLpv95jOJMY0+5U34E=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnzn71fJaiww7539/HXxqIn3C+/eS/vd6Yu/Gpqw6WMPKkb bl4ZHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZjIXheG/wnKDwPkTj3+u7Lw195Dd6 /bbN29cslWj9BNfq5itgw1HA6MDCeeahssk5yXulP18q5tq2oS7uZ/8lmlmDfpCae0vWLIOhYA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Linux Memory Management List <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Bagas Sanjaya <bagasdotme@gmail.com>

The caption for hierarchy of accounting figure is in the code block,
which is quite odd. Move the caption into :caption: option of
code-block:: directive instead.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 642ef0bb20380a..3b365a72996be5 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -149,7 +149,8 @@ specific data structure (mem_cgroup) associated with it.
 2.2. Accounting
 ---------------
 
-::
+.. code-block::
+   :caption: Figure 1: Hierarchy of Accounting
 
 		+--------------------+
 		|  mem_cgroup        |
@@ -169,7 +170,6 @@ specific data structure (mem_cgroup) associated with it.
            |               |           |               |
            +---------------+           +---------------+
 
-             (Figure 1: Hierarchy of Accounting)
 
 
 Figure 1 shows the important aspects of the controller
-- 
An old man doll... just what I always wanted! - Clara

