From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: Fix rootcg cpu.stat guest double counting
Date: Thu, 28 Oct 2021 15:15:27 -0700
Message-ID: <20211028221528.2174284-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CE76jWMeyxCY5I/qaaAbgmKw1EMykfKV4BEuJDaHL6g=;
        b=bC5SbaUerEviaszA0wT3TsZ+ctvQ/QnSXU7T7i7Fy6GxjbipoH+8sKTQiCIJfzRUSs
         ovm57fVyR0Cxx+fiJP1BuUI/ZaqfOCMANrxpU9SYDCxLRI5tmCJTltM2I/sGr2/Q4ZC4
         OK/KF/Ynq17jKFTkQWmmnSX5aW/JbZfmyYOIkn7ByKOju2mAb4iMZkEhe05yhUS9h/GQ
         cTLiXhEevJw8JsJxvA1tEfsVxMY/XQqddtwKcOvDn9F8USO6FAVFlday3CS6fXnTYFIK
         fNYN1JjbWPnZfqKsVhiu465bq9SDnAQvZqf141HWdEvURrdf3PdfVr0oatCtxJ+GOUdX
         Ushg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>, "open list:CONTROL GROUP CGROUP" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

In account_guest_time in kernel/sched/cputime.c guest time is
attributed to both CPUTIME_NICE and CPUTIME_USER in addition to
CPUTIME_GUEST_NICE and CPUTIME_GUEST respectively. Therefore, adding
both to calculate usage results in double counting any guest time at
the rootcg.

Fixes: 936f2a70f207 ("cgroup: add cpu.stat file to root cgroup")
Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/rstat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index b264ab5652ba..1486768f2318 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -433,8 +433,6 @@ static void root_cgroup_cputime(struct task_cputime *cputime)
 		cputime->sum_exec_runtime += user;
 		cputime->sum_exec_runtime += sys;
 		cputime->sum_exec_runtime += cpustat[CPUTIME_STEAL];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST_NICE];
 	}
 }
 
-- 
2.30.2

