From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v4 17/18] Docs/x86/sgx: Add description for cgroup support
Date: Tue, 12 Sep 2023 21:06:34 -0700
Message-ID: <20230913040635.28815-18-haitao.huang@linux.intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694578140; x=1726114140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hEu3sY0L0Zm8yUMNRt51Y+KGZj58gXXJpRMwbPXfe14=;
  b=gaqSnY94y3UF2pguqjfrkbYW5gdGM8xzqQbZFSOGj65LIVAJpmBpZgxA
   u06VPICdNuNON9OBvhyD32NIOePuqpf1TVpvHJ6PfAqdFt1J9G8Zvt/H1
   QMGBDU6D5MXdsq6tBfpYrdk2ySg7KNGqVm9bk4UO0aTvEU8XYC1El9P8H
   FCkyPaRlwWjCZtF7gB1QvMqzT7PlDJrtSbRVe0zpYeqlxl+6NxvcWSZ+R
   IyDlTLMd/yhpn5LTolwJTuc6+BX+WkRvSDy8rgnO3i1Thze04pWDU7mNJ
   jGx9Q6BJeGxuHUfSvtc4yAZ3vu6VUtRMMTsRBIpp2lNJlBZd66RGHviVL
   A==;
In-Reply-To: <20230913040635.28815-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Add initial documentation of how to regulate the distribution of
SGX Enclave Page Cache (EPC) memory via the Miscellaneous cgroup
controller.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang<haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
V4:
- Fix indentation (Randy)
- Change misc.events file to be read-only
- Fix a typo for 'subsystem'
- Add behavior when VMM overcommit EPC with a cgroup (Mikko)
---
 Documentation/arch/x86/sgx.rst | 82 ++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/Documentation/arch/x86/sgx.rst b/Documentation/arch/x86/sgx.rst
index d90796adc2ec..65c211bd5342 100644
--- a/Documentation/arch/x86/sgx.rst
+++ b/Documentation/arch/x86/sgx.rst
@@ -300,3 +300,85 @@ to expected failures and handle them as follows:
    first call.  It indicates a bug in the kernel or the userspace client
    if any of the second round of ``SGX_IOC_VEPC_REMOVE_ALL`` calls has
    a return code other than 0.
+
+
+Cgroup Support
+==============
+
+The "sgx_epc" resource within the Miscellaneous cgroup controller regulates
+distribution of SGX EPC memory, which is a subset of system RAM that
+is used to provide SGX-enabled applications with protected memory,
+and is otherwise inaccessible, i.e. shows up as reserved in
+/proc/iomem and cannot be read/written outside of an SGX enclave.
+
+Although current systems implement EPC by stealing memory from RAM,
+for all intents and purposes the EPC is independent from normal system
+memory, e.g. must be reserved at boot from RAM and cannot be converted
+between EPC and normal memory while the system is running.  The EPC is
+managed by the SGX subsystem and is not accounted by the memory
+controller.  Note that this is true only for EPC memory itself, i.e.
+normal memory allocations related to SGX and EPC memory, e.g. the
+backing memory for evicted EPC pages, are accounted, limited and
+protected by the memory controller.
+
+Much like normal system memory, EPC memory can be overcommitted via
+virtual memory techniques and pages can be swapped out of the EPC
+to their backing store (normal system memory allocated via shmem).
+The SGX EPC subsystem is analogous to the memory subsystem, and
+it implements limit and protection models for EPC memory.
+
+SGX EPC Interface Files
+-----------------------
+
+For a generic description of the Miscellaneous controller interface
+files, please see Documentation/admin-guide/cgroup-v2.rst
+
+All SGX EPC memory amounts are in bytes unless explicitly stated
+otherwise.  If a value which is not PAGE_SIZE aligned is written,
+the actual value used by the controller will be rounded down to
+the closest PAGE_SIZE multiple.
+
+  misc.capacity
+        A read-only flat-keyed file shown only in the root cgroup.
+        The sgx_epc resource will show the total amount of EPC
+        memory available on the platform.
+
+  misc.current
+        A read-only flat-keyed file shown in the non-root cgroups.
+        The sgx_epc resource will show the current active EPC memory
+        usage of the cgroup and its descendants. EPC pages that are
+        swapped out to backing RAM are not included in the current count.
+
+  misc.max
+        A read-write single value file which exists on non-root
+        cgroups. The sgx_epc resource will show the EPC usage
+        hard limit. The default is "max".
+
+        If a cgroup's EPC usage reaches this limit, EPC allocations,
+        e.g. for page fault handling, will be blocked until EPC can
+        be reclaimed from the cgroup.  If EPC cannot be reclaimed in
+        a timely manner, reclaim will be forced, e.g. by ignoring LRU.
+
+        The EPC pages allocated for KVM guests by the virtual EPC driver
+        are not reclaimable by the host kernel SGX reclaimers. If a VMM
+        tries to start a VM within a cgroup whose EPC usage reaches this
+        limit, the virtual EPC driver will stop allocating more EPC for the
+        VM, and return SIGBUS to the VMM which would abort the VM launch.
+
+  misc.events
+        A read-only flat-keyed file which exists on non-root cgroups.
+        A value change in this file generates a file modified event.
+
+          max
+                The number of times the cgroup has triggered a reclaim
+                due to its EPC usage approaching (or exceeding) its max
+                EPC boundary.
+
+Migration
+---------
+
+Once an EPC page is charged to a cgroup (during allocation), it
+remains charged to the original cgroup until the page is released
+or reclaimed.  Migrating a process to a different cgroup doesn't
+move the EPC charges that it incurred while in the previous cgroup
+to its new cgroup.
-- 
2.25.1

