From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2] block, bfq: Accept symmetric weight adjustments
Date: Fri, 15 Oct 2021 15:53:52 +0200
Message-ID: <20211015135352.57245-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634306037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XLIhjbHS5OiUN2tPtH3NIRpzLe/6U1/ST92qVeetz/4=;
        b=rOkY2K6gg6owgwal/7TXs6RGXwq1PYGkmAjpkaD9iETBaLrvfuru3wXmMKFqf+p6mQSdkF
        ctkhYybZn4cqr/jB4QaV7b+NEc4+Bg8DPlaTyHg8ELXZoveeJ8ado41WGYVCpFrVGSI0BY
        wEmmc5S6eQx70C8jbFDjs8UZFsuJgD0=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The allowed range for BFQ weights is currently 1..1000 with 100 being
the default. There is no apparent reason to not accept weight
adjustments of same ratio on both sides of the default. This change
makes the attribute domain consistent with other cgroup (v2) knobs with
the weight semantics.

This extension of the range does not restrict existing configurations
(quite the opposite). This may affect setups where weights >1000 were
attempted to be set but failed with the default 100. Such cgroups would
attain their intended weight now. This is a changed behavior but it
rectifies the situation (similar intention to the
commit 69d7fde5909b ("blkcg: use CGROUP_WEIGHT_* scale for io.weight on
the unified hierarchy") for CFQ formerly (and v2 only)).

Additionally, the changed range does not imply all IO workloads can be
really controlled to achieve the widest possible ratio 1:10^4.

Signed-off-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v1/blkio-controller.rst | 2 +-
 Documentation/block/bfq-iosched.rst                      | 2 +-
 block/bfq-iosched.h                                      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


Changes since v1 https://lore.kernel.org/r/20210826131212.GE4520-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org/
- collect acks, reformat commit message
- effectively a resend

Given the length of addressee list from get_maintainers.pl, I'd break
possible tie (if there are no objections) by asking this being routed
via Jens's/linux-block tree.

Thanks,
Michal


diff --git a/Documentation/admin-guide/cgroup-v1/blkio-controller.rst b/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
index 16253eda192e..48559541c9d8 100644
--- a/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
+++ b/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
@@ -102,7 +102,7 @@ Proportional weight policy files
 	  on all the devices until and unless overridden by per device rule
 	  (see `blkio.bfq.weight_device` below).
 
-	  Currently allowed range of weights is from 1 to 1000. For more details,
+	  Currently allowed range of weights is from 1 to 10000. For more details,
           see Documentation/block/bfq-iosched.rst.
 
   blkio.bfq.weight_device
diff --git a/Documentation/block/bfq-iosched.rst b/Documentation/block/bfq-iosched.rst
index df3a8a47f58c..88b5251734ce 100644
--- a/Documentation/block/bfq-iosched.rst
+++ b/Documentation/block/bfq-iosched.rst
@@ -560,7 +560,7 @@ For each group, the following parameters can be set:
 
   weight
         This specifies the default weight for the cgroup inside its parent.
-        Available values: 1..1000 (default: 100).
+        Available values: 1..10000 (default: 100).
 
         For cgroup v1, it is set by writing the value to `blkio.bfq.weight`.
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index a73488eec8a4..f1abb8b90091 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -16,7 +16,7 @@
 #define BFQ_CL_IDLE_TIMEOUT	(HZ/5)
 
 #define BFQ_MIN_WEIGHT			1
-#define BFQ_MAX_WEIGHT			1000
+#define BFQ_MAX_WEIGHT			10000
 #define BFQ_WEIGHT_CONVERSION_COEFF	10
 
 #define BFQ_DEFAULT_QUEUE_IOPRIO	4
-- 
2.33.0

