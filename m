From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.15] cgroup: mark @cgrp __maybe_unused in
 cpu_stat_show()
Date: Mon, 30 Oct 2017 08:16:31 -0700
Message-ID: <20171030151631.GF3252168@devbig577.frc2.facebook.com>
References: <201710270642.JXcfWPVR%fengguang.wu@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IXxr4ShUuOGTjwagqrfpS5f+DEX+FPiHs3EtpVwlxWM=;
        b=fCg3iXY6FMunrh5yLZB9aByYmnsdgVa3bTChfKCkqBALdgdJ14NmYbT/VxcWx1VdkL
         1j8tjziM6NVp/I6DlmylIWS4yI3Bx6pQNPEkcjxKIhg2KhzaBkzB5j1aOH5qz1cl86kA
         8D1qmPSG7w6flRBdl21xujXEAXgb0pnhkdQO1GbHB94+dYfq7un53fWETuDb/nlIt63I
         ebT5TE1eF5IEgVHZvNuu59BC2Nf8UeYQ/QPEJSOip9YfoJ5um2JSctksxfcH77uEQLL9
         KehGzCHg++dtukN/Jhi5sFyMQUaIJDXQnmtcEXBYN0eFn9Hf02xAeGwGbZc2ZIDFOzpA
         hizA==
Content-Disposition: inline
In-Reply-To: <201710270642.JXcfWPVR%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From c3ba13298709f46e72b22d087d0aa02bd012e4b0 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 30 Oct 2017 08:13:14 -0700

The local variable @cgrp isn't used if !CONFIG_CGROUP_SCHED.  Mark the
variable with __maybe_unused to avoid a compile warning.

Reported-by: "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Applied to cgroup/for-4.15.

Thanks.

 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d9773e4..d6ed725 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3357,7 +3357,7 @@ static int __maybe_unused cgroup_extra_stat_show(struct seq_file *seq,
 
 static int cpu_stat_show(struct seq_file *seq, void *v)
 {
-	struct cgroup *cgrp = seq_css(seq)->cgroup;
+	struct cgroup __maybe_unused *cgrp = seq_css(seq)->cgroup;
 	int ret = 0;
 
 	cgroup_stat_show_cputime(seq);
-- 
2.9.5
