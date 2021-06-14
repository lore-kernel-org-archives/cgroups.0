From: Kir Kolyshkin <kolyshkin@gmail.com>
Subject: [PATCH v2] docs: block/bfq: describe per-device weight
Date: Mon, 14 Jun 2021 14:01:38 -0700
Message-ID: <20210614210137.204155-1-kolyshkin@gmail.com>
References: <8735tlbbml.fsf@meer.lwn.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Rtw5MlcGm2N9I0P0R9oyIB7YsHFMJaGufsNXGeoAHQ=;
        b=RayZuXENOAZnm24AQT0DNbpM6rBhKla7akSUfMcirF4R7gibXGuEBq42JYYqFNRp0W
         2/FqT+A1bG+PM4Z8A7M8Tm+NfzZtarGac17BqpelaVOAGYA0jhEb0wJzgEXDrcQyTpaH
         H89WH1mXOvrH/t0OSv/LwChGa1eYFM94Ni8qWSPDwHYvvLhEJJqvC4kKV/IrClTnjOf8
         Kua/6RtnEeTxG52d+yL+jiyjsOURY1HmkpxhSZJDeArstjPrYDF9p6icm764G+ixFBSt
         31IyOSnzFZJuRbHRPsaYoFI0qQbrVtZM3iZiNoz39qS7Tjd8V4j438kku+Jw5iZ2MKmr
         wmZw==
In-Reply-To: <8735tlbbml.fsf@meer.lwn.net>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, cgroups@vger.kernel.org, Kir Kolyshkin <kolyshkin@gmail.com>

The functionality of setting per-device weight for BFQ was added
in v5.4 (commit 795fe54c2a828099), but the documentation was never
updated.

While at it, improve formatting a bit.

Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
---
 Documentation/block/bfq-iosched.rst | 38 ++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/Documentation/block/bfq-iosched.rst b/Documentation/block/bfq-iosched.rst
index 66c5a4e54130..7200152c461e 100644
--- a/Documentation/block/bfq-iosched.rst
+++ b/Documentation/block/bfq-iosched.rst
@@ -553,20 +553,36 @@ throughput sustainable with bfq, because updating the blkio.bfq.*
 stats is rather costly, especially for some of the stats enabled by
 CONFIG_BFQ_CGROUP_DEBUG.
 
-Parameters to set
------------------
+Parameters
+----------
 
-For each group, there is only the following parameter to set.
+For each group, the following parameters cat be set:
 
-weight (namely blkio.bfq.weight or io.bfq-weight): the weight of the
-group inside its parent. Available values: 1..1000 (default 100). The
-linear mapping between ioprio and weights, described at the beginning
-of the tunable section, is still valid, but all weights higher than
-IOPRIO_BE_NR*10 are mapped to ioprio 0.
+  weight
+        This specifies the default weight for the cgroup inside its parent.
+        Available values: 1..1000 (default: 100).
 
-Recall that, if low-latency is set, then BFQ automatically raises the
-weight of the queues associated with interactive and soft real-time
-applications. Unset this tunable if you need/want to control weights.
+        For cgroup v1, it is set by writing the value to `blkio.bfq.weight`.
+
+        For cgroup v2, it is set by writing the value to `io.bfq.weight`.
+        (with an optional prefix of `default` and a space).
+
+        The linear mapping between ioprio and weights, described at the beginning
+        of the tunable section, is still valid, but all weights higher than
+        IOPRIO_BE_NR*10 are mapped to ioprio 0.
+
+        Recall that, if low-latency is set, then BFQ automatically raises the
+        weight of the queues associated with interactive and soft real-time
+        applications. Unset this tunable if you need/want to control weights.
+
+  weight_device
+        This specifies a per-device weight for the cgroup. The syntax is
+        `minor:major weight`. A weight of `0` may be used to reset to the default
+        weight.
+
+        For cgroup v1, it is set by writing the value to `blkio.bfq.weight_device`.
+
+        For cgroup v2, the file name is `io.bfq.weight`.
 
 
 [1]
-- 
2.31.1

