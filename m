From: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 8/9] docs: cgroup-v1: add internal cross-references
Date: Thu,  5 Jan 2023 20:16:33 +0700
Message-ID: <20230105131633.553574-9-bagasdotme@gmail.com>
References: <20230105131633.553574-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZ9GcmF0SnvXW339uzqqW2SQ7HsUGzXwW7yu3PaudLI=;
        b=U+VJkAFNPjKrvuGxUMG5FdK9BV2Zgpcr6N9Kl5CPf4JeKfIn3KcOiVA/VaAvD/v8AY
         wf3WOuiW7daaqG5zzM3ETBToqjQQZz9HO5Ch4s0bANKwqUGuYM7mpR1Cit+3+7OZR8uG
         llwNqAVYDTx6gKxaENyWQWVdcNTdJRTlLX60QpIfRnldj8L8WzvSzhjOj4O/IkchuzPD
         +TfEUpebH94+kSE9jQgYutOw6TAh6iS7on3MOT/qMSBjURg0Wv27l73QYTWa7630M7Gf
         rOUrmvszK+8FStFKklPRi7svReL6kUOvahUeFEAq5VlPPUv7TglqIuiXRXh4AmBCFf7C
         2Qog==
In-Reply-To: <20230105131633.553574-1-bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=5899; i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; h=from:subject; bh=6uN0MOlYSzf0LERTdXFXUxc79s1bXfuIBUJ4wZga1/E=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnbzm7kiZI55vd7j6d/afRKneXuDXeknm37tFqhQ/HExAdm qs3mHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZhIQDjDfy9DU701t9w8MvWV1knpfg /1duwtYk6KsO957npefGftNEaGhx8mMzp0blnuy3c24tG8i2UlhjYSPofTMvU4p7jpLArlAAA=
X-Developer-Key: i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux CGroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Documentation <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The documentation contains references to other sections in the doc
(internal). Add cross-references for them so that these can be accessed
without having to manually search for them.

Signed-off-by: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 .../admin-guide/cgroup-v1/memory.rst          | 43 +++++++++++++------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 0e583a6f783955..16d938abe69f81 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -55,7 +55,8 @@ Features:
  - Root cgroup has no limit controls.
 
  Kernel memory support is a work in progress, and the current version provides
- basically functionality. (See Section 2.7)
+ basically functionality. (See :ref:`section 2.7
+ <cgroup-v1-memory-kernel-extension>`)
 
 Brief summary of control files.
 
@@ -221,8 +222,9 @@ behind this approach is that a cgroup that aggressively uses a shared
 page will eventually get charged for it (once it is uncharged from
 the cgroup that brought it in -- this will happen on memory pressure).
 
-But see section 8.2: when moving a task to another cgroup, its pages may
-be recharged to the new cgroup, if move_charge_at_immigrate has been chosen.
+But see :ref:`section 8.2 <cgroup-v1-memory-movable-charges>` when moving a
+task to another cgroup, its pages may be recharged to the new cgroup, if
+move_charge_at_immigrate has been chosen.
 
 2.4 Swap Extension
 --------------------------------------
@@ -270,7 +272,7 @@ global VM. When a cgroup goes over its limit, we first try
 to reclaim memory from the cgroup so as to make space for the new
 pages that the cgroup has touched. If the reclaim is unsuccessful,
 an OOM routine is invoked to select and kill the bulkiest task in the
-cgroup. (See 10. OOM Control below.)
+cgroup. (See :ref:`10. OOM Control <cgroup-v1-memory-oom-control>` below.)
 
 The reclaim algorithm has not been modified for cgroups, except that
 pages that are selected for reclaiming come from the per-cgroup LRU
@@ -284,7 +286,7 @@ list.
    When panic_on_oom is set to "2", the whole system will panic.
 
 When oom event notifier is registered, event will be delivered.
-(See oom_control section)
+(See :ref:`oom_control <cgroup-v1-memory-oom-control>` section)
 
 2.6 Locking
 -----------
@@ -301,6 +303,8 @@ Per-node-per-memcgroup LRU (cgroup's private LRU) is guarded by
 lruvec->lru_lock; PG_lru bit of page->flags is cleared before
 isolating a page from its LRU under lruvec->lru_lock.
 
+.. _cgroup-v1-memory-kernel-extension:
+
 2.7 Kernel Memory Extension
 -----------------------------------------------
 
@@ -460,6 +464,8 @@ test because it has noise of shared objects/status.
 But the above two are testing extreme situations.
 Trying usual test under memory controller is always helpful.
 
+.. _cgroup-v1-memory-test-troubleshoot:
+
 4.1 Troubleshooting
 -------------------
 
@@ -472,8 +478,11 @@ terminated by the OOM killer. There are several causes for this:
 A sync followed by echo 1 > /proc/sys/vm/drop_caches will help get rid of
 some of the pages cached in the cgroup (page cache pages).
 
-To know what happens, disabling OOM_Kill as per "10. OOM Control" (below) and
-seeing what happens will be helpful.
+To know what happens, disabling OOM_Kill as per :ref:`"10. OOM Control"
+<cgroup-v1-memory-oom-control>` (below) and seeing what happens will be
+helpful.
+
+.. _cgroup-v1-memory-test-task-migration:
 
 4.2 Task migration
 ------------------
@@ -484,15 +493,16 @@ remain charged to it, the charge is dropped when the page is freed or
 reclaimed.
 
 You can move charges of a task along with task migration.
-See 8. "Move charges at task migration"
+See :ref:`8. "Move charges at task migration" <cgroup-v1-memory-move-charges>`
 
 4.3 Removing a cgroup
 ---------------------
 
-A cgroup can be removed by rmdir, but as discussed in sections 4.1 and 4.2, a
-cgroup might have some charge associated with it, even though all
-tasks have migrated away from it. (because we charge against pages, not
-against tasks.)
+A cgroup can be removed by rmdir, but as discussed in :ref:`sections 4.1
+<cgroup-v1-memory-test-troubleshoot>` and :ref:`4.2
+<cgroup-v1-memory-test-task-migration>`, a cgroup might have some charge
+associated with it, even though all tasks have migrated away from it. (because
+we charge against pages, not against tasks.)
 
 We move the stats to parent, and no change on the charge except uncharging
 from the child.
@@ -719,6 +729,8 @@ If we want to change this to 1G, we can at any time use::
        It is recommended to set the soft limit always below the hard limit,
        otherwise the hard limit will take precedence.
 
+.. _cgroup-v1-memory-move-charges:
+
 8. Move charges at task migration
 =================================
 
@@ -739,7 +751,8 @@ If you want to enable it::
 
 .. note::
       Each bits of move_charge_at_immigrate has its own meaning about what type
-      of charges should be moved. See 8.2 for details.
+      of charges should be moved. See :ref:`section 8.2
+      <cgroup-v1-memory-movable-charges>` for details.
 
 .. note::
       Charges are moved only when you move mm->owner, in other words,
@@ -757,6 +770,8 @@ And if you want disable it again::
 
 	# echo 0 > memory.move_charge_at_immigrate
 
+.. _cgroup-v1-memory-movable-charges:
+
 8.2 Type of charges which can be moved
 --------------------------------------
 
@@ -806,6 +821,8 @@ threshold in any direction.
 
 It's applicable for root and non-root cgroup.
 
+.. _cgroup-v1-memory-oom-control:
+
 10. OOM Control
 ===============
 
-- 
An old man doll... just what I always wanted! - Clara

