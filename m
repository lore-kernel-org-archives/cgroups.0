From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] iocost_monitor: Report debt
Date: Wed,  4 Sep 2019 12:45:56 -0700
Message-ID: <20190904194556.2984857-6-tj@kernel.org>
References: <20190904194556.2984857-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jL4d81pypGq7ODywNqxdQtdPeeIUOLBTqveh64eDASc=;
        b=Z0oBR0eUEqPyun6hEblYCICjdKNvWRr+b29/35hl2k9IPCpnLWYk0YRY/8L5vtThT9
         rqb7sJxaWR3X8K4fC+O5IkrzkOK1cnraVOQlHpbAUryTpGEd8x1V2MF9f4AKzgabbPN4
         RURLEtu/yEDEf+b64CY/JEYDCcpg0DIRHptVcP+sl4fVElmdNupPsKEc1YTszbljredC
         6QJXBlhEqOK2ua2rUmzwgc0UOAFR/+1fjYgDmuwXttlJgNlzx8QdHsY1mQ6Iq345qlJM
         /UXcMmB/pCl4//OeGXfgwloUyMdpYFvINjlHOxBwvbqzG6c++Nio0VNFmvhBGqoSgXN2
         FXyQ==
In-Reply-To: <20190904194556.2984857-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@vger.kernel.org, cgroups@vger.kernel.org, newella@fb.com, Tejun Heo <tj@kernel.org>

Report debt and rename del_ms row to delay for consistency.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c             | 6 +++---
 tools/cgroup/iocost_monitor.py | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 6000ce9b10bb..f0c5bfd4b4a8 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -161,9 +161,9 @@
  * https://github.com/osandov/drgn.  The ouput looks like the following.
  *
  *  sdb RUN   per=300ms cur_per=234.218:v203.695 busy= +1 vrate= 62.12%
- *                 active      weight      hweight% inflt% del_ms usages%
- *  test/a              *    50/   50  33.33/ 33.33  27.65  0*041 033:033:033
- *  test/b              *   100/  100  66.67/ 66.67  17.56  0*000 066:079:077
+ *                 active      weight      hweight% inflt% dbt  delay usages%
+ *  test/a              *    50/   50  33.33/ 33.33  27.65   2  0*041 033:033:033
+ *  test/b              *   100/  100  66.67/ 66.67  17.56   0  0*000 066:079:077
  *
  * - per	: Timer period
  * - cur_per	: Internal wall and device vtime clock
diff --git a/tools/cgroup/iocost_monitor.py b/tools/cgroup/iocost_monitor.py
index 5d8bac603ffa..f79b23582a1d 100644
--- a/tools/cgroup/iocost_monitor.py
+++ b/tools/cgroup/iocost_monitor.py
@@ -135,7 +135,7 @@ autop_names = {
 
     def table_header_str(self):
         return f'{"":25} active {"weight":>9} {"hweight%":>13} {"inflt%":>6} ' \
-               f'{"del_ms":>6} {"usages%"}'
+               f'{"dbt":>3} {"delay":>6} {"usages%"}'
 
 class IocgStat:
     def __init__(self, iocg):
@@ -159,6 +159,7 @@ autop_names = {
         else:
             self.inflight_pct = 0
 
+        self.debt_ms = iocg.abs_vdebt.counter.value_() / VTIME_PER_USEC / 1000
         self.use_delay = blkg.use_delay.counter.value_()
         self.delay_ms = blkg.delay_nsec.counter.value_() / 1_000_000
 
@@ -181,6 +182,7 @@ autop_names = {
                 'hweight_active_pct'    : str(self.hwa_pct),
                 'hweight_inuse_pct'     : str(self.hwi_pct),
                 'inflight_pct'          : str(self.inflight_pct),
+                'debt_ms'               : str(self.debt_ms),
                 'use_delay'             : str(self.use_delay),
                 'delay_ms'              : str(self.delay_ms),
                 'usage_pct'             : str(self.usage),
@@ -195,6 +197,7 @@ autop_names = {
               f'{self.inuse:5}/{self.active:5} ' \
               f'{self.hwi_pct:6.2f}/{self.hwa_pct:6.2f} ' \
               f'{self.inflight_pct:6.2f} ' \
+              f'{min(math.ceil(self.debt_ms), 999):3} ' \
               f'{min(self.use_delay, 99):2}*'\
               f'{min(math.ceil(self.delay_ms), 999):03} '
         for u in self.usages:
-- 
2.17.1

