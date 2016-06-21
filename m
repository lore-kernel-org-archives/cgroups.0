From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Use lld instead of ld when printing pids
 controller events_limit
Date: Tue, 21 Jun 2016 15:09:33 -0400
Message-ID: <20160621190933.GS3262@mtj.duckdns.org>
References: <1466535335-3715145-1-git-send-email-kennyyu@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aSKdJZ5b1wkpIfpa4aWaG3xTdee1NTliCBA1P4kuU88=;
        b=w9GMES++8AcueFzcY642LFB0GNj/NpYkbo+JxZ/OQl4vqhhrpLFv5mFca4Iykm6SMR
         SlRwUQ/xdix158OM14GkVxSSkAirCxEZCDAuAsGaUyiPPgpeOiSsHq9vE5NRMfsZ26gW
         HBqdHLer8cATeqg3eYNyH/67CSwMyju1VFZmbSc+AHw0cFa8ZTxo1bpY2BatbVIIfSlA
         HNNjgtKQP53pwgY1pJ+uIoruhEJ7Nj0IHt2DMUoxNBJWpu3/SPdYiMGq0uX5DhOCw62q
         2iBALNNSdnP3dgTpkY5SpO+RIGfPqSyjyi57Qn3X6La0snhN9o/nFpCJ3VYE/D0IpOb6
         0joQ==
Content-Disposition: inline
In-Reply-To: <1466535335-3715145-1-git-send-email-kennyyu-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

Added (s64) cast because atomic64 switches between l and ll.  No idea
why it doesn't just use s64.

Thanks.

------ 8< ------
From 9f6870dd9790dd87da1d0cf9e43e60113f3a278d Mon Sep 17 00:00:00 2001
From: Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>
Date: Tue, 21 Jun 2016 11:55:35 -0700
Subject: [PATCH] cgroup: Use lld instead of ld when printing pids controller
 events_limit

The `events_limit` variable needs to be formatted with %lld and not %ld.
This fixes the following warning discovered by kbuild test robot:

   kernel/cgroup_pids.c: In function 'pids_events_show':
   kernel/cgroup_pids.c:313:24: warning: format '%ld' expects argument of type
   'long int', but argument 3 has type 'long long int' [-Wformat=]
        seq_printf(sf, "max %ld\n", atomic64_read(&pids->events_limit));
                                   ^

tj: Added explicit (s64) cast as atomic64 switches between long long
    and long depending on 32 or 64.

Signed-off-by: Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup_pids.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index 9740ea6..2bd6737 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -310,7 +310,7 @@ static int pids_events_show(struct seq_file *sf, void *v)
 {
 	struct pids_cgroup *pids = css_pids(seq_css(sf));
 
-	seq_printf(sf, "max %ld\n", atomic64_read(&pids->events_limit));
+	seq_printf(sf, "max %lld\n", (s64)atomic64_read(&pids->events_limit));
 	return 0;
 }
 
-- 
2.7.4
