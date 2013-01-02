From: "Warren Turkal" <wt-9DuzFfiB15PQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Fix typo in blkio cgroup doc.
Date: Wed,  2 Jan 2013 19:52:12 +0000
Message-ID: <1357156332-63289-4-git-send-email-wt@ooyala.com>
References: <1357156332-63289-1-git-send-email-wt@ooyala.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ooyala.com; s=google;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=aunhdtpZrgEO1VxoZOeVmnsZa2EfWu79C4M1QwssbTU=;
        b=aBZpFA15U0H0PU1si+GqNxcwUXHbm4TwbqYvrTg2tYWXh2OmD4kYsDcPeDRKn0UxKp
         5q9xfXSU5LY2eLZkdVdgrcWSVPKd/7pQpkAjlagvy+aJM2qqrnXDV0UzImIAVeHMtRLo
         Iwsb/CIe+EAewaEb6U+u7Lj03E4udUC8tvrnA=
In-Reply-To: <1357156332-63289-1-git-send-email-wt-9DuzFfiB15PQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Warren Turkal <wt-9DuzFfiB15PQT0dZR+AlfA@public.gmane.org>

From: Warren Turkal <wt-9DuzFfiB15PQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Warren Turkal <wt-9DuzFfiB15PQT0dZR+AlfA@public.gmane.org>
---
 Documentation/cgroups/blkio-controller.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index b4b1fb3..a794ce9 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -75,7 +75,7 @@ Throttling/Upper Limit policy
         mount -t cgroup -o blkio none /sys/fs/cgroup/blkio
 
 - Specify a bandwidth rate on particular device for root group. The format
-  for policy is "<major>:<minor>  <byes_per_second>".
+  for policy is "<major>:<minor>  <bytes_per_second>".
 
         echo "8:16  1048576" > /sys/fs/cgroup/blkio/blkio.throttle.read_bps_device
 
-- 
1.7.0.4
