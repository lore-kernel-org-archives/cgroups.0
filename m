From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] iocost_monitor: exit successfully if interval is zero
Date: Mon, 13 Apr 2020 12:27:57 -0400
Message-ID: <20200413162758.97252-4-tj@kernel.org>
References: <20200413162758.97252-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IVee5LEPnYY6zF34ZuR4jFCQhJmfapbvjjnOL4aQYjw=;
        b=Hot53CJtn2fBB2y8DyRmzWibMmNk9ZIIP9y86sAKCSgqmJRIirb7rq/rg9vVFHnIyo
         sGfhoI7DFFRLH49s/i6ZBGxgN9cU8CP3sIam6U57heTNuHtE6eu57i83Q/cMpPPgMUH3
         t4W7ZyclBAcEs7wR7DokFFMkT/QQZ0R82M0sgxt0X04FRNhUQVgAVsrfUeM7//RUt1WK
         vlCFv+UR/M4mB8KVZ6MRvJfNaKEnuqr/496K+TXk/zeglyn27a3M38gm74aKp51oPdOx
         WQYfkSoqQ91xCveNYnKuabqx7uksKGngDPt6EYC3tj1VTLrYCuwID+nggxy2DUlBqQTl
         +MSA==
In-Reply-To: <20200413162758.97252-1-tj@kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, newella@fb.com, josef@toxicpanda.com, asml.silence@gmail.com, ming.lei@redhat.com, bvanassche@acm.org, Tejun Heo <tj@kernel.org>

This is to help external tools to decide whether iocost_monitor has all its
requirements met or not based on the exit status of an -i0 run.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 tools/cgroup/iocost_monitor.py | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/cgroup/iocost_monitor.py b/tools/cgroup/iocost_monitor.py
index 7427a5ee761b..eb2363b868c5 100644
--- a/tools/cgroup/iocost_monitor.py
+++ b/tools/cgroup/iocost_monitor.py
@@ -28,7 +28,8 @@ parser.add_argument('devname', metavar='DEV',
 parser.add_argument('--cgroup', action='append', metavar='REGEX',
                     help='Regex for target cgroups, ')
 parser.add_argument('--interval', '-i', metavar='SECONDS', type=float, default=1,
-                    help='Monitoring interval in seconds')
+                    help='Monitoring interval in seconds (0 exits immediately '
+                    'after checking requirements)')
 parser.add_argument('--json', action='store_true',
                     help='Output in json')
 args = parser.parse_args()
@@ -243,6 +244,9 @@ ioc = None
 if ioc is None:
     err(f'Could not find ioc for {devname}');
 
+if interval == 0:
+    sys.exit(0)
+
 # Keep printing
 while True:
     now = time.time()
-- 
2.25.2

