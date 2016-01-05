From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET REPOST] sched, cgroup: implement cgroup v2 interface for
 cpu controller
Date: Tue, 5 Jan 2016 11:47:58 -0500
Message-ID: <20160105164758.GD5995@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=OTVP/noURTNbjWRNPVfbOExvTxFFaRxSeq9pttvppcM=;
        b=NaUWW/aKzGNbBAJT5IDacL/MD3GWuliLy1AGjDpGvhmMJN+ZhCfZx4MlyAzrMOiThN
         cJyhEzkuoVXv76iKsdu5ynaSo82NHEGjSc5RiENYVt8l9lSHK5ufBIdB6yWiTG9LERUP
         8svfyyD2e+HiKKImc0IfHo9oBeIUIr0cuhEGN18xAMbvhTWfG27kmH5oP6C+FKivus5b
         UOjeYFSqWgJ6lZDgH19e3sGZASrXjwXs9AVI1GCHtJ3VfvOvtnsNybHB7OqWcUsWmnKT
         hagxIntQkd36OWcAtkciVnwfzUlSNLncKGP616cGbgkHaQcOOi9ofL6YoJiIgaio92u6
         gKdA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

This patchset implements cgroup v2 interface for cpu controller and a
repost of the following.

 http://lkml.kernel.org/g/1438641689-14655-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

The first patch is folded and applied into v2 documentation.  The
second patch is unchanged.  The third is unchanged from the posted v2.

The patchset got blocked by discussion on in-process hierarchical
resource contorl.  The following message is to restart the discussion.

 http://lkml.kernel.org/g/20160105154503.GC5995-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org

While the conclusion hasn't been reached, none of the issues being
debated affects the system level interface and there's no technical
reason to hold off these patches especially given that cgroup v2 is
being released in the coming merge window for memory and io
controllers.

Can we please go ahead with these?

diffstat follows.

 kernel/sched/core.c    |  149 +++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/cpuacct.c |   57 ++++++++++++------
 kernel/sched/cpuacct.h |    5 +
 3 files changed, 189 insertions(+), 22 deletions(-)

Thanks.

-- 
tejun
