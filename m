From: Elijah Conners <business@elijahpepe.com>
Subject: [PATCH] iocost_monitor: reorder BlkgIterator
Date: Tue, 30 Aug 2022 07:38:27 -0700
Message-ID: <182ef30785e.c6f6f47035469.3423320276766255135@elijahpepe.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe <axboe@kernel.dk>
Cc: linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>, josef <josef@toxicpanda.com>, asmlsilence <asml.silence@gmail.com>, minglei <ming.lei@redhat.com>, bvanassche <bvanassche@acm.org>

In order to comply with PEP 8, the first parameter of a class should be
__init__.

Signed-off-by: Elijah Conners <business@elijahpepe.com> 
---
 tools/cgroup/iocost_monitor.py                |  10 +-
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/cgroup/iocost_monitor.py b/tools/cgroup/iocost_monitor.py
index c4ff907c078b..0dbbc67400fc 100644
--- a/tools/cgroup/iocost_monitor.py
+++ b/tools/cgroup/iocost_monitor.py
@@ -61,6 +61,11 @@ autop_names = {
 }

 class BlkgIterator:
+    def __init__(self, root_blkcg, q_id, include_dying=False):
+        self.include_dying = include_dying
+        self.blkgs = []
+        self.walk(root_blkcg, q_id, '')
+
     def blkcg_name(blkcg):
         return blkcg.css.cgroup.kn.name.string_().decode('utf-8')

@@ -82,11 +87,6 @@ class BlkgIterator:
                                      blkcg.css.children.address_of_(), 'css.sibling'):
             self.walk(c, q_id, path)

-    def __init__(self, root_blkcg, q_id, include_dying=False):
-        self.include_dying = include_dying
-        self.blkgs = []
-        self.walk(root_blkcg, q_id, '')
-
     def __iter__(self):
         return iter(self.blkgs)

--
2.25.1
