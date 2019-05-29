From: Odin Ugedal <odin@ugedal.com>
Subject: [PATCH] docs cgroups: add another example size for hugetlb
Date: Thu, 30 May 2019 00:24:25 +0200
Message-ID: <20190529222425.30879-1-odin@ugedal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DK/ogr6pZZUphW9lU4h1f+fFgOabCak3KXyja9ZoLt0=;
        b=EtEkBupWZk2J/O72xoPMmoNFOSLqen/od3RSkObixQLiBW0S7B4LBoMgiN1OJs5lTI
         7eQsLP01PJJoMg2Rx3TXT2fHK9oKRyTMsSxuM14Bv/AhGUfZbEp+jOWiJjg08NWOPWIn
         60jXRmoCOn7ULv9kGZ6Qa3BukeR4KLALFfbLjl+hFFUdKHdpARIjb7oq/IA0fCdMe6Jw
         CGumH0h5cYi/VpKQ+Q0RElMr9yUgKn5Qljab6cDKdX0txp1pFfhPYKT+HwcU8Rt1cCYS
         WLSjSr5B2qq/nQyorb4FdVBSJC+ONV8G5I9EocBK2BtkSCoIadihUFJo7fO60LGyljtK
         4pKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: odin@ugedal.com
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

Add another example to clarify that HugePages smaller than 1MB will
be displayed using "KB", with an uppercased K (eg. 20KB), and not the
normal SI prefix kilo (small k).

Because of a misunderstanding/copy-paste error inside runc
(see https://github.com/opencontainers/runc/pull/2065), it tried
accessing the cgroup control file of a 64kB HugePage using
"hugetlb.64kB._____" instead of the correct "hugetlb.64KB._____".

Adding a new example will make it clear how sizes smaller than 1MB are
handled.

Signed-off-by: Odin Ugedal <odin@ugedal.com>
---
 Documentation/cgroup-v1/hugetlb.txt | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/Documentation/cgroup-v1/hugetlb.txt b/Documentation/cgroup-v1/hugetlb.txt
index 106245c3aecc..1260e5369b9b 100644
--- a/Documentation/cgroup-v1/hugetlb.txt
+++ b/Documentation/cgroup-v1/hugetlb.txt
@@ -32,14 +32,18 @@ Brief summary of control files
  hugetlb.<hugepagesize>.usage_in_bytes     # show current usage for "hugepagesize" hugetlb
  hugetlb.<hugepagesize>.failcnt		   # show the number of allocation failure due to HugeTLB limit
 
-For a system supporting two hugepage size (16M and 16G) the control
+For a system supporting three hugepage sizes (64k, 32M and 1G), the control
 files include:
 
-hugetlb.16GB.limit_in_bytes
-hugetlb.16GB.max_usage_in_bytes
-hugetlb.16GB.usage_in_bytes
-hugetlb.16GB.failcnt
-hugetlb.16MB.limit_in_bytes
-hugetlb.16MB.max_usage_in_bytes
-hugetlb.16MB.usage_in_bytes
-hugetlb.16MB.failcnt
+hugetlb.1GB.limit_in_bytes
+hugetlb.1GB.max_usage_in_bytes
+hugetlb.1GB.usage_in_bytes
+hugetlb.1GB.failcnt
+hugetlb.64KB.limit_in_bytes
+hugetlb.64KB.max_usage_in_bytes
+hugetlb.64KB.usage_in_bytes
+hugetlb.64KB.failcnt
+hugetlb.32MB.limit_in_bytes
+hugetlb.32MB.max_usage_in_bytes
+hugetlb.32MB.usage_in_bytes
+hugetlb.32MB.failcnt
-- 
2.21.0

