From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/4] cpumask: un-inline cpulist_parse; prepare for ascii helpers
Date: Sun,  8 Nov 2020 11:08:13 -0500
Message-ID: <20201108160816.896881-2-paul.gortmaker@windriver.com>
References: <20201108160816.896881-1-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbGv485UyrW7cjxqwewbTE6kA1TMdSQnkaCXAHlPqhA=;
 b=qAZmdGYjO2tL9SZV3DH+j+iNg4Y7ww6/7yCwUlcduKpnKvHE0Am+IIHwsQmqZdxsOJCJkvMgIdT2jJ4CqdZxVx7gD3TOsAAAIFbiPIlDaWsTdMWY4Bz5o5MFhf1n9tDIxDnWcgjUGO6YqVthmaaNYph49V9vA55flMUj5iqzMfQ=
In-Reply-To: <20201108160816.896881-1-paul.gortmaker@windriver.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Paul Gortmaker <paul.gortmaker@windriver.com>

In order to support convenience tokens like "all", and "none" and
"last" in CPU lists, we'll have to use string operations and expand on
what is currently a simple wrapper around the underlying bitmap
function call.

Rather than add header dependencies to cpumask.h and code more complex
operations not really appropriate for a header file, we prepare by
simply un-inlining it here and move it to the lib dir alongside the
other more complex cpumask functions.

Aside from an additional exported symbol, no functional changes are
anticipated with this move.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/cpumask.h | 12 +-----------
 lib/cpumask.c           | 13 +++++++++++++
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index f0d895d6ac39..6656019cce0f 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -673,17 +673,7 @@ static inline int cpumask_parse(const char *buf, struct cpumask *dstp)
 	return bitmap_parse(buf, UINT_MAX, cpumask_bits(dstp), nr_cpumask_bits);
 }
 
-/**
- * cpulist_parse - extract a cpumask from a user string of ranges
- * @buf: the buffer to extract from
- * @dstp: the cpumask to set.
- *
- * Returns -errno, or 0 for success.
- */
-static inline int cpulist_parse(const char *buf, struct cpumask *dstp)
-{
-	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpumask_bits);
-}
+int cpulist_parse(const char *buf, struct cpumask *dstp);
 
 /**
  * cpumask_size - size to allocate for a 'struct cpumask' in bytes
diff --git a/lib/cpumask.c b/lib/cpumask.c
index 85da6ab4fbb5..5eb002237404 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -95,6 +95,19 @@ int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool wrap)
 }
 EXPORT_SYMBOL(cpumask_next_wrap);
 
+/**
+ * cpulist_parse - extract a cpumask from a user string of ranges
+ * @buf: the buffer to extract from
+ * @dstp: the cpumask to set.
+ *
+ * Returns -errno, or 0 for success.
+ */
+int cpulist_parse(const char *buf, struct cpumask *dstp)
+{
+	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpumask_bits);
+}
+EXPORT_SYMBOL(cpulist_parse);
+
 /* These are not inline because of header tangles. */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 /**
-- 
2.25.1

