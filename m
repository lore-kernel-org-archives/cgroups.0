From: Hui Su <sh_def@163.com>
Subject: [PATCH] Docs/cgroup: update the cgroup-v1 docs
Date: Mon, 2 Nov 2020 23:21:16 +0800
Message-ID: <20201102152116.GA186491@rlk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=bxxfv
        9QsqkbmxwfyzAF36u41WO4BWk6RMHqGjFs9RGQ=; b=HpXpF1IuLg/Mi8dh/7JI7
        7aGzPE2LKjcW4yJgWKsL99ALbK0+q0SC14WqttzUxN+SV1RpxbYbWfzrAEXKhcNT
        tPylUlog14dyU8munfrzMxs3d9qYR6CuNVTbe7kEOTufkNDZohoDxvbscB/3m/QZ
        lJIZNb5+sxE53BeirmBtn8=
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sh_def@163.com

Since 'commit 69d0206c793a ("cgroup: bring some sanity to
naming around cg_cgroup_link")', 'cg_cgroup_link' has been
changed to 'cgrp_cset_link'.
so as its element 'cgrp_link_list' and 'cg_link_list'.

Since commit 47cfcd092245 ("cgroup: kill cgroup_[un]lock()"),
cgroup_lock/cgroup_unlock have been killed.

So update the cgroup-v1 Docs.

Signed-off-by: Hui Su <sh_def@163.com>
---
 Documentation/admin-guide/cgroup-v1/cgroups.rst | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/cgroups.rst b/Documentation/admin-guide/cgroup-v1/cgroups.rst
index b0688011ed06..c28316a7dd28 100644
--- a/Documentation/admin-guide/cgroup-v1/cgroups.rst
+++ b/Documentation/admin-guide/cgroup-v1/cgroups.rst
@@ -270,10 +270,10 @@ css_set is allocated. The appropriate existing css_set is located by
 looking into a hash table.
 
 To allow access from a cgroup to the css_sets (and hence tasks)
-that comprise it, a set of cg_cgroup_link objects form a lattice;
-each cg_cgroup_link is linked into a list of cg_cgroup_links for
-a single cgroup on its cgrp_link_list field, and a list of
-cg_cgroup_links for a single css_set on its cg_link_list.
+that comprise it, a set of cgrp_cset_link objects form a lattice;
+each cgrp_cset_link is linked into a list of cgrp_cset_links for
+a single cgroup on its cset_link field, and a list of
+cgrp_cset_links for a single css_set on its cgrp_link.
 
 Thus the set of tasks in a cgroup can be listed by iterating over
 each css_set that references the cgroup, and sub-iterating over
@@ -523,10 +523,7 @@ cgroup. It may also be taken to prevent cgroups from being
 modified, but more specific locks may be more appropriate in that
 situation.
 
-See kernel/cgroup.c for more details.
-
-Subsystems can take/release the cgroup_mutex via the functions
-cgroup_lock()/cgroup_unlock().
+See kernel/cgroup/cgroup.c for more details.
 
 Accessing a task's cgroup pointer may be done in the following ways:
 - while holding cgroup_mutex
-- 
2.29.0


