From: Kir Kolyshkin <kolyshkin@gmail.com>
Subject: [PATCH 3/3] docs/cgroup-v1/blkio: update for 5.x kernels
Date: Thu, 10 Jun 2021 20:07:37 -0700
Message-ID: <20210611030737.1984343-4-kolyshkin@gmail.com>
References: <20210611030737.1984343-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EeiiZk029aDgyJMHooCPOqX+d9TplBH+7i69WXM5i/M=;
        b=WT2aoFBdPydSDmrn1yO0fHAUPDEAYD8a9mHe8XjvtW9fLhxMHmjcnM+pkx9v0Xrpv5
         jDd7sTd3hYf4vh0OkgSUC2lxL0buxzs1POSItzfLDAVmy0v2DUSoJuCzlt9Kx7iFY6YJ
         pM76Wuo1vpzDqz1fDOuXgnCo+QOtu9SHZjKLdajyiUC5awhBBWp770RNdKB3AJbsz6lN
         BMYCG33ggxjCA83y++ONGSN589hWNiijlte7NIODvsKcMaWXkT0foYWIDy+PsLMprEq2
         nTkbho5+jOD+ddNi9FlhfP6c2SsgZF2a6Hfl3vvqgp6NiiKiZkp9ToALMj0+fd+OJe8v
         8HNg==
In-Reply-To: <20210611030737.1984343-1-kolyshkin@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-doc@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, cgroups@vger.kernel.org, Kir Kolyshkin <kolyshkin@gmail.com>

Commit bf382fb0bcef4 ("block: remove legacy IO schedulers", Oct 12 2018)
removes the CFQ scheduler, together with blkio.weight and
blkio.weight_device described in cgroup v1 documentation. Users are
supposed to use the BFQ scheduler, which cgroup file for setting weight
is blkio.bfq.weight, but there is no way to set per-device weight.

Later, commit 795fe54c2a8 per-device weights for BFQ, meaning that
blkio.bfq.weight and blkio.bfq.weight_device can be used in a way
similar to the old CFQ cgroup interface.

Yet, the cgroup v1 docs were never updated. Fix this:
 - use the new file names;
 - fix the range for weight (used to be 10..1000, now 1..1000);
 - link to BFQ scheduler docs.

Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
---
 .../cgroup-v1/blkio-controller.rst            | 31 ++++++++++---------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/blkio-controller.rst b/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
index 8101dcba381d..16253eda192e 100644
--- a/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
+++ b/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
@@ -97,40 +97,41 @@ Details of cgroup files
 Proportional weight policy files
 --------------------------------
 
-  blkio.weight
+  blkio.bfq.weight
 	  Specifies per cgroup weight. This is default weight of the group
-	  on all the devices until and unless overridden by per device rule.
-	  (See blkio.weight_device).
-	  Currently allowed range of weights is from 10 to 1000.
+	  on all the devices until and unless overridden by per device rule
+	  (see `blkio.bfq.weight_device` below).
 
-  blkio.weight_device
-	  One can specify per cgroup per device rules using this interface.
-	  These rules override the default value of group weight as specified
-	  by blkio.weight.
+	  Currently allowed range of weights is from 1 to 1000. For more details,
+          see Documentation/block/bfq-iosched.rst.
+
+  blkio.bfq.weight_device
+          Specifes per cgroup per device weights, overriding the default group
+          weight. For more details, see Documentation/block/bfq-iosched.rst.
 
 	  Following is the format::
 
-	    # echo dev_maj:dev_minor weight > blkio.weight_device
+	    # echo dev_maj:dev_minor weight > blkio.bfq.weight_device
 
 	  Configure weight=300 on /dev/sdb (8:16) in this cgroup::
 
-	    # echo 8:16 300 > blkio.weight_device
-	    # cat blkio.weight_device
+	    # echo 8:16 300 > blkio.bfq.weight_device
+	    # cat blkio.bfq.weight_device
 	    dev     weight
 	    8:16    300
 
 	  Configure weight=500 on /dev/sda (8:0) in this cgroup::
 
-	    # echo 8:0 500 > blkio.weight_device
-	    # cat blkio.weight_device
+	    # echo 8:0 500 > blkio.bfq.weight_device
+	    # cat blkio.bfq.weight_device
 	    dev     weight
 	    8:0     500
 	    8:16    300
 
 	  Remove specific weight for /dev/sda in this cgroup::
 
-	    # echo 8:0 0 > blkio.weight_device
-	    # cat blkio.weight_device
+	    # echo 8:0 0 > blkio.bfq.weight_device
+	    # cat blkio.bfq.weight_device
 	    dev     weight
 	    8:16    300
 
-- 
2.31.1

