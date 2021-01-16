From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: [PATCH v2 2/2] cgroup: update PSI file description in docs
Date: Sat, 16 Jan 2021 18:36:34 +0100
Message-ID: <20210116173634.1615875-3-odin@uged.al>
References: <20210116173634.1615875-1-odin@uged.al>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RXhQCLR7kJ8wXIoAGktxHEJsN7Fs/rfacZeAYDKFmIs=;
        b=sdBAnkXLZiSEhGYam1qUuWzP56Niue66DVFgEdt1Rz43y1S6IdNFkfCnwls9cXBoRu
         H7Mnh4NEeCcFDxV/x+NRCPo572ISiOPh2+Ui0cn3wJesaGBeK2/nAQPu7QM/UfEsE1ps
         9fcwB7f1eBXAxTylN12jvL0Ey7MioXV1IipxMvuY78uF7QVVq68JWJ/eBgv2qjDpGueo
         k2Gej1o/CGHMjBTgKXsb/V0+efCE+YjLhpZvBazc6WFgZGVl/X8yPhswVTWPdp7BS3Ts
         358Nhh/NuyKi85UnNoyDdLoB08blefdiCKCKwkCzcWQAElNQcFcIej5wktZ0dgdw+cT5
         JPaw==
In-Reply-To: <20210116173634.1615875-1-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dschatzberg-b10kYP2dOMg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>

Update PSI file description in cgroup-v2 docs to reflect the current
implementation.

Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 63521cd36ce5..f638c9d3d9f2 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1029,7 +1029,7 @@ All time durations are in microseconds.
 	one number is written, $MAX is updated.
 
   cpu.pressure
-	A read-only nested-key file which exists on non-root cgroups.
+	A read-only nested-keyed file.
 
 	Shows pressure stall information for CPU. See
 	:ref:`Documentation/accounting/psi.rst <psi>` for details.
@@ -1475,7 +1475,7 @@ PAGE_SIZE multiple when read back.
 	reduces the impact on the workload and memory management.
 
   memory.pressure
-	A read-only nested-key file which exists on non-root cgroups.
+	A read-only nested-keyed file.
 
 	Shows pressure stall information for memory. See
 	:ref:`Documentation/accounting/psi.rst <psi>` for details.
@@ -1714,7 +1714,7 @@ IO Interface Files
 	  8:16 rbps=2097152 wbps=max riops=max wiops=max
 
   io.pressure
-	A read-only nested-key file which exists on non-root cgroups.
+	A read-only nested-keyed file.
 
 	Shows pressure stall information for IO. See
 	:ref:`Documentation/accounting/psi.rst <psi>` for details.
-- 
2.30.0

