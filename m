From: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Subject: [PATCH] docs: cgroup-v1/cpusets: update libcgroup project link
Date: Fri, 14 Apr 2023 11:18:49 +0530
Message-ID: <20230414054849.320414-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=OsOBWYvu/Lm1pD1VvzZJTfdgLTp7Ke02iEezDWNfZ7A=;
 b=a4HqpPhskuLwya015YsqoJ038Vyck71G9OZ6m3QcB4kvw4Tv8yc+Ux3sU4b6oD6oDock
 f5Ar3Mo8uXCRKtEZU840k5ba8637zXtsm1HXhqzLUQ8iIz3eFLBTveInYlx46WKTjK0a
 wCruRy2pHWX1Wpfca9oPRtQ7wUmyvOO/EKvJFQ2BFdYHkMuIiPmLMF2Db19LlBRnbBil
 8xMK8o7u46kmwN/0sl5YalXiE/dj5L0IASGLLlZzKjEKmM1hs3I/63NjYpmPPbigyYZw
 Ap2I6zpknVfXGEvaVQRMbvDmYRdJEkxQalzNZ+EQOMFulPk3W/hMW/Z2GUyE02mFE13c HQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsOBWYvu/Lm1pD1VvzZJTfdgLTp7Ke02iEezDWNfZ7A=;
 b=bFp3leX24EidrRMY75GwDhxyf0di0p8aY+BYJV8oEZA8Jj259TA3RG7NGizJrpbg6lxOOHvoEX4TUtfuwxLzvLh5fDUhFcimvQcbXVP4JpERuGB7K0NCYvcIwUN1VJWvJJxwjBGj308Ug+aT8QVLm28ioIrki5/XOBiIG6IUrPE=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Tom Hromatka <tom.hromatka@oracle.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Update the libcgroup project link, in the cgroup v1/cpusets
documentation.

Signed-off-by: Kamalesh Babulal <kamalesh.babulal@oracle.com>
---
 Documentation/admin-guide/cgroup-v1/cpusets.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v1/cpusets.rst b/Documentation/admin-guide/cgroup-v1/cpusets.rst
index 5d844ed4df69..ae646d621a8a 100644
--- a/Documentation/admin-guide/cgroup-v1/cpusets.rst
+++ b/Documentation/admin-guide/cgroup-v1/cpusets.rst
@@ -719,7 +719,7 @@ There are ways to query or modify cpusets:
    cat, rmdir commands from the shell, or their equivalent from C.
  - via the C library libcpuset.
  - via the C library libcgroup.
-   (http://sourceforge.net/projects/libcg/)
+   (https://github.com/libcgroup/libcgroup/)
  - via the python application cset.
    (http://code.google.com/p/cpuset/)
 
-- 
2.34.3

