From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] iocost_monitor: Always use strings for json values
Date: Wed,  4 Sep 2019 12:45:54 -0700
Message-ID: <20190904194556.2984857-4-tj@kernel.org>
References: <20190904194556.2984857-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TRsIsTqTTaD4KvJ5qqrHTq3GaA09a3g8vTgRyaRa+1g=;
        b=Cy/rW5q/7uBhRpjIRkte/wVsq531S30qrwpCgl8Fl8aWv8B9RYhNXyyRJUdYJFVqZ1
         hQZurp7uO2Ep5E4LHaqNjkNXCVTnByOGz+o/2DwqUkKkljYGXsxPdQu5Upwnr+mCe/Vr
         Dgpu0m62CwYkw9XgXFso9Q5d1PsdjZmqklzoyxyaSzR3Guh1bx2usmf0HSL0D/ZAaHZL
         jMxtBEzmlq/mwV41VVXfRowouGAC/lMkxV+Jq/Ra1kqJbmcyVpk8oFHX0miW/qm2Q1Do
         bqrEjPahv/I/K/sCSnaYdVBmWT4K4rug7ZkIbuuOzvCOF0Xy0I2Mh/YomkF5TTHovzXk
         rFng==
In-Reply-To: <20190904194556.2984857-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@vger.kernel.org, cgroups@vger.kernel.org, newella@fb.com, Tejun Heo <tj@kernel.org>

Json has limited accuracy for numbers and can silently truncate 64bit
values, which can be extremely confusing.  Let's consistently use
string encapsulated values for json output.

While at it, convert an unnecesary f-string to str().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 tools/cgroup/iocost_monitor.py | 40 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/tools/cgroup/iocost_monitor.py b/tools/cgroup/iocost_monitor.py
index 2c9445e966d8..8f6b4ac377bd 100644
--- a/tools/cgroup/iocost_monitor.py
+++ b/tools/cgroup/iocost_monitor.py
@@ -111,14 +111,14 @@ autop_names = {
 
     def dict(self, now):
         return { 'device'               : devname,
-                 'timestamp'            : now,
-                 'enabled'              : self.enabled,
-                 'running'              : self.running,
-                 'period_ms'            : self.period_ms,
-                 'period_at'            : self.period_at,
-                 'period_vtime_at'      : self.vperiod_at,
-                 'busy_level'           : self.busy_level,
-                 'vrate_pct'            : self.vrate_pct, }
+                 'timestamp'            : str(now),
+                 'enabled'              : str(int(self.enabled)),
+                 'running'              : str(int(self.running)),
+                 'period_ms'            : str(self.period_ms),
+                 'period_at'            : str(self.period_at),
+                 'period_vtime_at'      : str(self.vperiod_at),
+                 'busy_level'           : str(self.busy_level),
+                 'vrate_pct'            : str(self.vrate_pct), }
 
     def table_preamble_str(self):
         state = ('RUN' if self.running else 'IDLE') if self.enabled else 'OFF'
@@ -171,19 +171,19 @@ autop_names = {
 
     def dict(self, now, path):
         out = { 'cgroup'                : path,
-                'timestamp'             : now,
-                'is_active'             : self.is_active,
-                'weight'                : self.weight,
-                'weight_active'         : self.active,
-                'weight_inuse'          : self.inuse,
-                'hweight_active_pct'    : self.hwa_pct,
-                'hweight_inuse_pct'     : self.hwi_pct,
-                'inflight_pct'          : self.inflight_pct,
-                'use_delay'             : self.use_delay,
-                'delay_ms'              : self.delay_ms,
-                'usage_pct'             : self.usage }
+                'timestamp'             : str(now),
+                'is_active'             : str(int(self.is_active)),
+                'weight'                : str(self.weight),
+                'weight_active'         : str(self.active),
+                'weight_inuse'          : str(self.inuse),
+                'hweight_active_pct'    : str(self.hwa_pct),
+                'hweight_inuse_pct'     : str(self.hwi_pct),
+                'inflight_pct'          : str(self.inflight_pct),
+                'use_delay'             : str(self.use_delay),
+                'delay_ms'              : str(self.delay_ms),
+                'usage_pct'             : str(self.usage) }
         for i in range(len(self.usages)):
-            out[f'usage_pct_{i}'] = f'{self.usages[i]}'
+            out[f'usage_pct_{i}'] = str(self.usages[i])
         return out
 
     def table_row_str(self, path):
-- 
2.17.1

