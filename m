From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH] docs: cgroup-v1: wrap charge moving deprecation in warning block
Date: Fri,  6 Jan 2023 10:48:37 +0700
Message-ID: <20230106034836.23708-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fekH72sui9GdebDgVNk2XaNYCf3hMj26CpPd65HWWNo=;
        b=UiHZc4xPgz9riLMU7jZRFdpYBA/tSzUNwC2BWiIfW76JQV7qvDnZ5YFgaBwl9muFhb
         nAkOig3bzP5SUcRFGALvqIyPdhKwyNXxWrdL9D84b0uOtZaZPFbVrf5kQzVd/o7OBkXu
         z6f2FNtKYhJqWr/Xndmg2e/SuFt9Fy/yogCm8unBMDoDabAFe+n8z4lp47ALzRkkQCSZ
         oxmtpgTEH7TmsJjYV1pYx4dJ90trVyNrmkZGKcXoBVSNzk42OHhEXYxdFGiQEkojlIfy
         SzRBhKd/owMzJFmNo5AZZdxNmsCZtH2WIhpIGtVELwEteObfco0sQVwvAoyw3CcOcJba
         2t0w==
X-Developer-Signature: v=1; a=openpgp-sha256; l=1985; i=bagasdotme@gmail.com; h=from:subject; bh=KgCM3g5FsiytA4vmbQIOX+Rd86PUGBjozHPoOarnvsU=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnbZwnsfhJW03XnxmSRtsDcZWFZB88eW7hWrdvL9bXnM5+Z d5av7ShlYRDjYpAVU2SZlMjXdHqXkciF9rWOMHNYmUCGMHBxCsBENJ4y/He4lXBqP09p/boMlhvr/y 585c/It8Tzxvk+4yxNVfa3K8MZGb5oOmfr2SyO3zdhwoR9+hn7BQ8yvnZceueQmbWi7I2NxXwA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux CGroups <cgroups@vger.kernel.org>, Linux Documentation <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Bagas Sanjaya <bagasdotme@gmail.com>

Commit 4ddb1a2aa1a3c4 ("docs: cgroup-v1: wrap remaining admonitions in
admonition blocks") in cgroups tree states that it also wraps charge
moving deprecation notice in admonition block (specifically warning).
However, the notice isn't in cgroups tree when the v2 of formatting
improv series [1] is submitted (and then applied), but rather in mm tree
instead.

Wrap the notice to fulfill the intention of referred commit.

Link: https://lore.kernel.org/linux-doc/20230105131633.553574-1-bagasdotme@gmail.com/ # [1]
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 258e45cc3b2db1..b73eb174735556 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -722,12 +722,14 @@ NOTE2:
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

base-commit: dd5c3ba990ae67409bc058051efcd40c3689d01d
-- 
An old man doll... just what I always wanted! - Clara

