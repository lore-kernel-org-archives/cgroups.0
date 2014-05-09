From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] cgroup: update and fix parsing of "cgroup.subtree_control"
Date: Fri,  9 May 2014 15:32:52 -0400
Message-ID: <1399663975-315-5-git-send-email-tj@kernel.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FPYVH4T9dy++51uAaLSWQ5n+Ft7a58zIcJdTW3iPQIQ=;
        b=0cCTF8FxhSyiESoHZXdYeQxStnjFn1GMqRFCcDCJDlNQRk2+xLm3M8t4fPVvKfY7eD
         kFBVS/Hy485XkpjP0xGMjPMcPh+U42e1zFVIi7M2exQE8jnDdALFzGQ6iexSl0G+oSys
         KT2Ax8w9jEiEUkoi6uKdoE0Nl5bhz2I4CRbQrPYDkfaruGuGvmkhhvwI3iG9QMO2i43e
         QWUton51yGolanQkC6ziJEp4RSQ9GhXNKBOk9cnMStN7zsv2h6Prj0lMHoj92kgq21IW
         cMb3akiUZMKeU0u6An1qQ2dPhuXF8UHDDfCvJwheE4vVlimpCVHxEOZuMwGrtJCNyXJK
         MPtA==
In-Reply-To: <1399663975-315-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

I was confused that strsep() was equivalent to strtok_r() in skipping
over consecutive delimiters.  strsep() just splits at the first
occurrence of one of the delimiters which makes the parsing very
inflexible, which makes allowing multiple whitespace chars as
delimters kinda moot.  Let's just be consistently strict and require
list of tokens separated by spaces.  This is what
Documentation/cgroups/unified-hierarchy.txt describes too.

Also, parsing may access beyond the end of the string if the string
ends with spaces or is zero-length.  Make sure it skips zero-length
tokens.  Note that this also ensures that the parser doesn't puke on
multiple consecutive spaces.

v2: Add zero-length token skipping.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 35daf89..b81e7c0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2542,11 +2542,13 @@ static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
 	int ssid, ret;
 
 	/*
-	 * Parse input - white space separated list of subsystem names
-	 * prefixed with either + or -.
+	 * Parse input - space separated list of subsystem names prefixed
+	 * with either + or -.
 	 */
 	p = buffer;
-	while ((tok = strsep(&p, " \t\n"))) {
+	while ((tok = strsep(&p, " "))) {
+		if (tok[0] =='\0')
+			continue;
 		for_each_subsys(ss, ssid) {
 			if (ss->disabled || strcmp(tok + 1, ss->name))
 				continue;
-- 
1.9.0
