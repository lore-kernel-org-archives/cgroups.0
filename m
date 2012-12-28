From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 18.5/24] blkcg: export __blkg_prfill_rwstat() take#2
Date: Fri, 28 Dec 2012 18:18:18 -0500
Message-ID: <20121228231818.GL3062@mtj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=BqSXY/jPtnFj9p+/TEIi0BN3sncPWNynFM9esa24Wcw=;
        b=eMNkw8aqpBiVlakGr3Re38JAvuziLuUQyJOjH6hfhRh+D1tPxFMKBzbnVw4sB/vetg
         MKJCsevQad5oh4RwSQwPhO515SkQwNh3ojrOtQzVZaeWM9O1tgv7S81MxDFQupjj1c+z
         Y5qTAMWdL9ACL9qvEIQu2Hy1ebudWzN1aU2fUQAivIn+p4/KtvOkb/X1alT9igHW/aoV
         wlezZx45rDQzxm2J894DmLY0NaXcDQIISQw9zjF+uXAM7ptaGHSYyM4ic9i2Dp4L2wjC
         CsgxB7FtLTIqYAB+4uxFm9RBVKXZKekjQCkZpd1YkJq7TezRcz9Xlt9pAcEO8ajJQsSx
         AUMQ==
Content-Disposition: inline
In-Reply-To: <1356726946-26037-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hierarchical stats for cfq-iosched will need __blkg_prfill_rwstat().
Export it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Fengguang's build test discovered that cfq now uses
__blkg_prfill_rwstat() which isn't exported leading to build failures
when cfq is built as a module.  Export it.  This doesn't affect
!module builds.  Git branch updated accordingly.

Thanks.

 block/blk-cgroup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -552,6 +552,7 @@ u64 __blkg_prfill_rwstat(struct seq_file
 	seq_printf(sf, "%s Total %llu\n", dname, (unsigned long long)v);
 	return v;
 }
+EXPORT_SYMBOL_GPL(__blkg_prfill_rwstat);
 
 /**
  * blkg_prfill_stat - prfill callback for blkg_stat
