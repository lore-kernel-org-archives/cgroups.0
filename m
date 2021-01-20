From: Kir Kolyshkin <kolyshkin@gmail.com>
Subject: [PATCH 02/10] docs/scheduler/sched-design-CFS: formatting fix
Date: Tue, 19 Jan 2021 16:18:16 -0800
Message-ID: <20210120001824.385168-3-kolyshkin@gmail.com>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ds7LbWxzhg+PnTvKnERBaZN4CXWnLXd13Bbn6mXPVrs=;
        b=MHD5vUTu8gJAqj4AhIxwlTGrc3vUszPT28BiOkxTmEossnViyHWk9uCptCJKUsSw73
         kO6E9k93ZTY/7fEdNZErxnjRvohFOinV1nbCq8oWrNey+a3q4CpgzZoMwrYINk5IXd7V
         tekXOPN2kSxpagU4SRKxMbvsBuOOrItVehziAa/yBv14SboQfyeeacj4/IsUYAF7zQsr
         6Fn8j7wii9fvl8zrF+LWd7OqFIIf2hIlhGaanFzFS19YyuXjAozUYfjPGiFZ2jgzCh2v
         1CkII2PaiKdeD8z9qfg8nP7wcy8eBXQX9OoWf6gM0Z8VnLjYMEDzNhEw4TYPXD2XbpwS
         dfAw==
In-Reply-To: <20210120001824.385168-1-kolyshkin@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: corbet@lwn.net
Cc: linux-doc@vger.kernel.org, cgroups@vger.kernel.org, Kir Kolyshkin <kolyshkin@gmail.com>

Fix the rendering of the paragraph. Before the fix, the first line is
rendered in bold (I'm not quite sure why) and is also separated from the
rest of the paragraph, which is rendered with an indent.

Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
---
 Documentation/scheduler/sched-design-CFS.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/scheduler/sched-design-CFS.rst b/Documentation/scheduler/sched-design-CFS.rst
index a96c72651877..59b2d1fb4dc4 100644
--- a/Documentation/scheduler/sched-design-CFS.rst
+++ b/Documentation/scheduler/sched-design-CFS.rst
@@ -34,9 +34,9 @@ In CFS the virtual runtime is expressed and tracked via the per-task
 p->se.vruntime (nanosec-unit) value.  This way, it's possible to accurately
 timestamp and measure the "expected CPU time" a task should have gotten.
 
-[ small detail: on "ideal" hardware, at any time all tasks would have the same
-  p->se.vruntime value --- i.e., tasks would execute simultaneously and no task
-  would ever get "out of balance" from the "ideal" share of CPU time.  ]
+   Small detail: on "ideal" hardware, at any time all tasks would have the same
+   p->se.vruntime value --- i.e., tasks would execute simultaneously and no task
+   would ever get "out of balance" from the "ideal" share of CPU time.
 
 CFS's task picking logic is based on this p->se.vruntime value and it is thus
 very simple: it always tries to run the task with the smallest p->se.vruntime
-- 
2.29.2

