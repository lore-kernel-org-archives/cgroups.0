From: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: [PATCH 3/4] cpumask: add a "none" alias to complement "all"
Date: Sun,  8 Nov 2020 11:08:15 -0500
Message-ID: <20201108160816.896881-4-paul.gortmaker@windriver.com>
References: <20201108160816.896881-1-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JEJ9GSK90PQQnTECfuTh4QZmvo5Nm6q52rlJOv2lK8=;
 b=PecqzqNZmc7zhBIgRnQz8FvBlVXbVjjEuSKOvDtSf75Rpbm4T2VpyOhieHXwKEyQvkbDUOIDBRe8xUAQ28lXFmRxiDPFurpZOtuKPvFkmmpE0qjkrr/Lm7PTAjKpAYS5/eledK4dxEmr+QkmE+GfFuv3ru8QAwjJX8wu1sQMMOs=
In-Reply-To: <20201108160816.896881-1-paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>

With global support for a CPU list alias of "all", it seems to just make
sense to also trivially extend support for an opposite "none" specifier.

Signed-off-by: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
---
 Documentation/admin-guide/kernel-parameters.rst | 6 ++++++
 lib/cpumask.c                                   | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.rst b/Documentation/admin-guide/kernel-parameters.rst
index ef98ca700946..9e1c4522e1f0 100644
--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -76,6 +76,12 @@ is equivalent to "foo_cpus=0-N" -- where "N" is the numerically last CPU on
 the system, thus avoiding looking up the value in "/sys/devices/system/cpu"
 in advance on each deployed system.
 
+        foo_cpus=none
+
+will provide an empty/cleared cpu mask for the associated boot argument.
+
+Note that "all" and "none" are not necessarily valid/sensible input values
+for each available parameter expecting a CPU list.
 
 This document may not be entirely up to date and comprehensive. The command
 "modinfo -p ${modulename}" shows a current list of all parameters of a loadable
diff --git a/lib/cpumask.c b/lib/cpumask.c
index 15599cdf5db6..eb8b1c92501e 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -110,6 +110,11 @@ int cpulist_parse(const char *buf, struct cpumask *dstp)
 		return 0;
 	}
 
+	if (!strcmp(buf, "none")) {
+		cpumask_clear(dstp);
+		return 0;
+	}
+
 	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpumask_bits);
 }
 EXPORT_SYMBOL(cpulist_parse);
-- 
2.25.1

