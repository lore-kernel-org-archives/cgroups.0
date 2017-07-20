From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET for-4.14] cgroup, sched: cgroup2 interface for CPU controller
Date: Thu, 20 Jul 2017 14:48:06 -0400
Message-ID: <20170720184808.1433868-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=xPLzQW1hzwJnhdYJxCOwJ/ETE4+zJAKOhyt/ag9QdJo=;
        b=DqssSepwC7gWJSwXup4+B5j6Wc+eoNRknbG2ZgsPg4YSKAnKHAGCen4aTJX19UHAuK
         8TH+xhcEcl7Xphgi+NZcFbUEE8T8frZ1IX9MCnJt/Me31WbQr83u/Iy0+mxjzqeWK37V
         /hJmyPdcM6XYKkt/pdrTTDPubOkAX75xtwt36fZKHHKqwSlhb7onYeeKG48dzwmBwWG7
         WPZyrmg9INuhLj1sPt0KFZh/3TUitcuG47elQfUarO3d2dih7hQvHEWBVaDBJGYdi6e4
         CIg6fIRcy80GpVIbNSizGw2b/cVaJnBWlFyIQqNkr2bMXtoGRT8IFMqPts2bgsGrSUHX
         pLBg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello,

These are two patches to implement the cgroup2 CPU controller
interface.  It's separated from the [L] previous version of combined
cgroup2 threaded mode + CPU controller patchset.

* "cpu.weight.nice" added which allows reading and setting weights
  using nice values so that it's easier to configure when threaded
  cgroups are competing against threads.

* Doc and other misc updates.

 0001-sched-Misc-preps-for-cgroup-unified-hierarchy-interf.patch
 0002-sched-Implement-interface-for-cgroup-unified-hierarc.patch

The patchset is on top of "cgroup: implement cgroup2 thread mode, v4"
patchset [T] and also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-cpu-on-v4

 Documentation/cgroup-v2.txt |   36 ++------
 kernel/sched/core.c         |  186 +++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/cpuacct.c      |   53 +++++++++---
 kernel/sched/cpuacct.h      |    5 +
 4 files changed, 241 insertions(+), 39 deletions(-)

--
tejun

[L] http://lkml.kernel.org/r/20170610140351.10703-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[T] http://lkml.kernel.org/r/20170719194439.2915602-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
