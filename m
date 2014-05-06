From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 2/9] cgroup: update and fix parsing of
 "cgroup.subtree_control"
Date: Tue, 6 May 2014 09:22:14 -0400
Message-ID: <20140506132214.GC27738@htj.dyndns.org>
References: <1399377044-29873-1-git-send-email-tj@kernel.org>
 <1399377044-29873-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RLntWb22u7TdnXMO1OqXaOHCapRG7IWHxJGiWnOdkTQ=;
        b=J5Ol/QfdrGXjrh/390oCJx8f6kvbv4axdDqeg/Jk28HmtJIwGUQTOEXiAvLeoNcmU2
         yi6Bp4iRbSQRSBgFiB/Pyf6U3QTFwnw+6gi3wFTbYNt/1NTIZtb7lO1BxH1UFc60B6SD
         +THJPrBcuww7cawCW9VbG7iiMLSHhB4Wm2rlrLSp7JaPAYp71lpwVVPi9+uJ6cDIdHQe
         byjT+T4R1VUv8NdxMRJ4SK0ReKyTWJu4TxtOCdyFxOnVAtuvPb/coMzcjx/5aa32SdIf
         U7TIK2SMfALYdn5RzfaOpFGjhQsqS/dLMRTZdfvfTJs77TNoTFOEfh2QCiHWjbDqhx+u
         URqA==
Content-Disposition: inline
In-Reply-To: <1399377044-29873-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 54fd12d..9e6b4ac 100644
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
