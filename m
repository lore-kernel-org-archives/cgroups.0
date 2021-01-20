From: Kir Kolyshkin <kolyshkin@gmail.com>
Subject: [PATCH 03/10] docs/scheduler/sched-bwc: fix note rendering
Date: Tue, 19 Jan 2021 16:18:17 -0800
Message-ID: <20210120001824.385168-4-kolyshkin@gmail.com>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dy2pnLpsAFKq7islomu6TWMlHm9Rk82D2CDlsTBcWI0=;
        b=naT/XIXtZwh8ZhNEUBOxM8iuEh6mYxXK9rhpLpkUwFQaJXd1hSq+CA3foBsUkzleFV
         HoqnOX/dxdtx5f797wfPcjH906lQi8ZS4PZkSkHe/8aPui88Ma02tblQhJLHsayUOVPn
         QrchhKnV0M5ofcTlzMN9WWPCff1rSo+QJ5p4YzV2frY1hswimH+FZgY/ANikY6H2iN3p
         DgmXwXPdlGU2VsTfQKDjQEju3/TD8QXfP2P5ijIwbtzHbq6uY473o0RpJcI+V6BK6OGs
         VW4pDqMD5fAUjtoTEtXPUIN1TPP6LIr9N0efRNa99bFHpxbloaGNQw4nZW9bS+uay36X
         bNMw==
In-Reply-To: <20210120001824.385168-1-kolyshkin@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: corbet@lwn.net
Cc: linux-doc@vger.kernel.org, cgroups@vger.kernel.org, Kir Kolyshkin <kolyshkin@gmail.com>

Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
---
 Documentation/scheduler/sched-bwc.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/scheduler/sched-bwc.rst b/Documentation/scheduler/sched-bwc.rst
index 4af4ee1f3600..a44860d33ffc 100644
--- a/Documentation/scheduler/sched-bwc.rst
+++ b/Documentation/scheduler/sched-bwc.rst
@@ -2,8 +2,9 @@
 CFS Bandwidth Control
 =====================
 
-[ This document only discusses CPU bandwidth control for SCHED_NORMAL.
-  The SCHED_RT case is covered in Documentation/scheduler/sched-rt-group.rst ]
+.. note::
+   This document only discusses CPU bandwidth control for SCHED_NORMAL.
+   The SCHED_RT case is covered in Documentation/scheduler/sched-rt-group.rst
 
 CFS bandwidth control is a CONFIG_FAIR_GROUP_SCHED extension which allows the
 specification of the maximum CPU bandwidth available to a group or hierarchy.
-- 
2.29.2

