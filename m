From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] iocost_monitor: drop string wrap around numbers when outputting json
Date: Wed,  8 Apr 2020 16:14:50 -0400
Message-ID: <20200408201450.3959560-6-tj@kernel.org>
References: <20200408201450.3959560-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+BQj1JBsSqI5aXq/pqViTsj/4QvWCDvVD92VTzp4arE=;
        b=qKboPNy2/dnjhxkRbRhKQPht9hywFpKyf4i8CXsAR9zg0nhM5XrScSCIvpHz7F0eji
         41v6ZqceIMREH0c+nwCHi/waR3Ax0Z7sTe6ayepIgXW86yw+orBD/g82g9KzmM/mt7Yj
         m0ZW8Z3YolR7v0+IcLE06O2273fnL6vM0Hx/8bihQL47lmFAqRRjUELts2RQ99MA9z0/
         bIcqmVBOHyjQcf56HDHd/4w3zJzm29ZiAxwDKFbiPTJCKLXgWyTAraN3q7jQekCPAror
         cvCUcZxY2v+v7Vi4wuY70fic7qGswgC1yMzn9eLdmP4ah89UPOUE/XZU96WuffzSkn9E
         tn9g==
In-Reply-To: <20200408201450.3959560-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@vger.kernel.org, cgroups@vger.kernel.org, newella@fb.com, josef@toxicpanda.com, Tejun Heo <tj@kernel.org>

Wrapping numbers in strings is used by some to work around bit-width issues in
some enviroments. The problem isn't innate to json and the workaround seems to
cause more integration problems than help. Let's drop the string wrapping.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 tools/cgroup/iocost_monitor.py | 42 +++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/cgroup/iocost_monitor.py b/tools/cgroup/iocost_monitor.py
index eb2363b868c5..188b3379b9a1 100644
--- a/tools/cgroup/iocost_monitor.py
+++ b/tools/cgroup/iocost_monitor.py
@@ -113,14 +113,14 @@ autop_names = {
 
     def dict(self, now):
         return { 'device'               : devname,
-                 'timestamp'            : str(now),
-                 'enabled'              : str(int(self.enabled)),
-                 'running'              : str(int(self.running)),
-                 'period_ms'            : str(self.period_ms),
-                 'period_at'            : str(self.period_at),
-                 'period_vtime_at'      : str(self.vperiod_at),
-                 'busy_level'           : str(self.busy_level),
-                 'vrate_pct'            : str(self.vrate_pct), }
+                 'timestamp'            : now,
+                 'enabled'              : self.enabled,
+                 'running'              : self.running,
+                 'period_ms'            : self.period_ms,
+                 'period_at'            : self.period_at,
+                 'period_vtime_at'      : self.vperiod_at,
+                 'busy_level'           : self.busy_level,
+                 'vrate_pct'            : self.vrate_pct, }
 
     def table_preamble_str(self):
         state = ('RUN' if self.running else 'IDLE') if self.enabled else 'OFF'
@@ -175,19 +175,19 @@ autop_names = {
 
     def dict(self, now, path):
         out = { 'cgroup'                : path,
-                'timestamp'             : str(now),
-                'is_active'             : str(int(self.is_active)),
-                'weight'                : str(self.weight),
-                'weight_active'         : str(self.active),
-                'weight_inuse'          : str(self.inuse),
-                'hweight_active_pct'    : str(self.hwa_pct),
-                'hweight_inuse_pct'     : str(self.hwi_pct),
-                'inflight_pct'          : str(self.inflight_pct),
-                'debt_ms'               : str(self.debt_ms),
-                'use_delay'             : str(self.use_delay),
-                'delay_ms'              : str(self.delay_ms),
-                'usage_pct'             : str(self.usage),
-                'address'               : str(hex(self.address)) }
+                'timestamp'             : now,
+                'is_active'             : self.is_active,
+                'weight'                : self.weight,
+                'weight_active'         : self.active,
+                'weight_inuse'          : self.inuse,
+                'hweight_active_pct'    : self.hwa_pct,
+                'hweight_inuse_pct'     : self.hwi_pct,
+                'inflight_pct'          : self.inflight_pct,
+                'debt_ms'               : self.debt_ms,
+                'use_delay'             : self.use_delay,
+                'delay_ms'              : self.delay_ms,
+                'usage_pct'             : self.usage,
+                'address'               : self.address }
         for i in range(len(self.usages)):
             out[f'usage_pct_{i}'] = str(self.usages[i])
         return out
-- 
2.25.1

