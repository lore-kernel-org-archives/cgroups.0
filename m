From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/5] iocost_monitor: exit successfully if interval is zero
Date: Wed,  8 Apr 2020 16:14:49 -0400
Message-ID: <20200408201450.3959560-5-tj@kernel.org>
References: <20200408201450.3959560-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vrEanY8wxDtok+RTWBGcNDaSQ4QB8ANJ03cLIKdV4tg=;
        b=ex4iZHeH4DOVQuYBmfQMJJYYtzF1WGnnyQk5oSf5kQrIww5/9iaUeRu+xrFcO35QBm
         uTEZUmfC8pKrLoa6CIk++HA89Fr1LmqClmiDzN9WbnfFagMGE44s/rkrv9pp8Ez3VOaL
         rYDsmvOpo6L1AUjud8ciac302OSNuwwlHqWUmgAYPehNYqfBKvjNUkRh79ZIcW0cr/xP
         HGSpOuYozYntvjo/7Wq4Pa/GI11OHsXmIQa2eLRaJ23D16kgN/GmYDGXACIPyUzyQsme
         mWTyM2ehCqgLfRKNhKnyQWWwhUhCsgWwlUjpZX6XpYvz3DKyIhCmpO6sSDNjZB6RGAb5
         HCVg==
In-Reply-To: <20200408201450.3959560-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

This is to help external tools to decide whether iocost_monitor has all its
requirements met or not based on the exit status of an -i0 run.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
2.25.1

