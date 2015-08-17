From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v4.2-rc7
Date: Mon, 17 Aug 2015 15:42:04 -0400
Message-ID: <20150817194204.GA21075@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=N0C+E4Sa/y8AFvcv5b32lQWm4shkmyAI+NQSN2c3OMw=;
        b=hxIrXKN8kjuPthW71/wuaqbnYsNWEn/P3gl4KnyRjVCN5N8s4iYlef9ExMyQQLeJdJ
         JsyiJebRlVakUaDihQlIU+8X4qTSPiaLPdwNx70U6OM6tY5xJkvLfNorsm5hFO/+27/X
         YKEPI21Q0XE7RCtEP4W+Yyua5kGlmRlEwvodwiGPSpkDfrHmmUE89LPL3GIxYxEtiRrp
         kI3s4jjds1Z4nbJZyonp51UuR9tm4EQoLu7rBpnUNocVWFueg2IK7A2zqE7s2579g2Pp
         6k0p8B2vr1SGm+zbbuhsKtpDyR9Wf+YGLcprJ7gGxIjkcxHrEbFfRWIk51A6oE15Mf3H
         Poxw==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

This pull request contains the fix for a subtle bug introduced back
during 3.17 cycle which interferes with setting configurations under
specific conditions.

Thanks.

The following changes since commit d770e558e21961ad6cfdf0ff7df0eb5d7d4f0754:

  Linux 4.2-rc1 (2015-07-05 11:01:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.2-fixes

for you to fetch changes up to 24ee3cf89bef04e8bc23788aca4e029a3f0f06d9:

  cpuset: use trialcs->mems_allowed as a temp variable (2015-08-10 11:18:41 -0400)

----------------------------------------------------------------
Alban Crequy (1):
      cpuset: use trialcs->mems_allowed as a temp variable

 kernel/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ee14e3a..f0acff0 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1223,7 +1223,7 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 	spin_unlock_irq(&callback_lock);
 
 	/* use trialcs->mems_allowed as a temp variable */
-	update_nodemasks_hier(cs, &cs->mems_allowed);
+	update_nodemasks_hier(cs, &trialcs->mems_allowed);
 done:
 	return retval;
 }
