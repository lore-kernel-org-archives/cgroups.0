From: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: [PATCH 1/4] cpumask: un-inline cpulist_parse for SMP; prepare for ascii helpers
Date: Mon,  9 Nov 2020 23:07:22 -0500
Message-ID: <20201110040725.1478297-2-paul.gortmaker@windriver.com>
References: <20201110040725.1478297-1-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JSSphesTb40yiOoxATbxgdKTgj+bWwkRQo82fq+wEQ=;
 b=WF80hWKRC/CAt1yhYaOS9SRcTZRFY8oFMY8GUUVZBPEXWp3PjqJtwP7OQr0ijjQ1SRtr49fKK0OOF7InWcpZcHYGgRzYYiYFf/Dzbcu2x1I9JiLSjSwBuo6uEtYnYkriFMC5WWQfyr8eHPBDD5CuVUnZ/M4kB/nmAXeVuVhwlNM=
In-Reply-To: <20201110040725.1478297-1-paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>

In order to support convenience tokens like "all", and "none" and
"last" in CPU lists, we'll have to use string operations and expand
on what is currently a simple wrapper around the underlying bitmap
function call.

Rather than add header dependencies to cpumask.h and code more complex
operations not really appropriate for a header file, we prepare by
simply un-inlining it here and move it to the lib dir alongside the
other more complex cpumask functions.

Since lib/cpumask.c is built conditionally on CONFIG_SMP, and there
are non-SMP callers, we leave the one-line stub behind for that case.
If they want to check "0-0" is a valid range, they can still do it.
In the meantime, we can add the ascii helpers for CONFIG_SMP users.
The use of NR_CPUS vs. CONFIG_SMP is consistent with the existing file.

Aside from an additional exported symbol in the SMP case, no functional
changes are anticipated with this move.

Signed-off-by: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
---
 include/linux/cpumask.h |  8 ++++++++
 lib/cpumask.c           | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index f0d895d6ac39..d2e370c5ce99 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -679,11 +679,19 @@ static inline int cpumask_parse(const char *buf, struct cpumask *dstp)
  * @dstp: the cpumask to set.
  *
  * Returns -errno, or 0 for success.
+ *
+ * There are instances of non-SMP callers of this, and the easiest way
+ * to remain 100% runtime compatible is to let them continue to have the
+ * one-line stub, while the SMP version in lib/cpumask.c gets improved.
  */
+#if NR_CPUS == 1
 static inline int cpulist_parse(const char *buf, struct cpumask *dstp)
 {
 	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpumask_bits);
 }
+#else
+int cpulist_parse(const char *buf, struct cpumask *dstp);
+#endif
 
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

