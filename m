From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup
 cgroup]
Date: Wed, 27 Jun 2012 16:02:30 -0700
Message-ID: <20120627230230.GT15811@google.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
 <20120627182903.GP15811@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=cNdIi+XGR2adaE9sd621UAKaK9bu88bAZxhJagXeYII=;
        b=oIAdJkY7Mraa021AHtQowl83p4lDkGNBRrcasgBVrXTWzcPe2d5wPhcuRSO9gBjWkz
         Z0tEda9P0JTuKFizk8T2M/b52LVBtF6HKslku+YhofkDSRBRcy82A7SuvUQ4yYhTgbwO
         fEPxDdvGyrDomTJZiYy606DmTn5DhdPcPdJh4HyCg0OgqNRoeIvYjf9wEnKP0fNPh9Yx
         w38XFCW0csNriLbqwFUCGqo4lp//nlrZ2LeQTVWwzSQsYFX8e8RfPNDM8ZlINZ8jfJ3H
         vzupPeHT6zk2sSIT6R37Jo+OWYHncgKftVw9S7cWi1O69O+ZizicRi0NgQFQ3iwy2Va6
         yWWQ==
Content-Disposition: inline
In-Reply-To: <20120627182903.GP15811-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello,

Does the following patch make the problem go away?

Thank you.

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2097684..f9556cf 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3644,6 +3644,7 @@ static void cgroup_event_remove(struct work_struct *work)
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
 	dput(cgrp->dentry);
+	deactivate_super(cgrp->root->sb);
 }
 
 /*
@@ -3770,6 +3771,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 	 * destroying subsystem state objects. Let's take reference to cgroup
 	 * directory dentry to do that.
 	 */
+	atomic_inc(&cgrp->root->sb->s_active);
 	dget(cgrp->dentry);
 
 	spin_lock(&cgrp->event_list_lock);
