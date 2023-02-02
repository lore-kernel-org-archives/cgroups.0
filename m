From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] cgroup/cpuset: Make hotplug code more efficient
Date: Wed,  1 Feb 2023 22:17:47 -0500
Message-ID: <20230202031749.118146-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675307903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TnLYuETykZ3l9f+iMHZlyv3/ZWGHek1M/oMz9w9vUAU=;
        b=YhJIYZEhl26hfGZbnwwScqHnrmxPa1OA4vimfBineB7VltzgVwVYCDwkbGRensiCFI9Fzt
        uZ8/ojcTml7AXF/MTKoogZv5wF17sewNKcnnbUVO1uDbURATE8BCixaYqKHxRN0AdfdMUW
        vJlsGM26mHf/5lRxNGnBcnEo7bQggGY=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This small patch series makes the cpuset hotplug a bit more efficient
by eliminating unnecessary task iteration and cpu/node masks update
when an hotplug event (online/offline) happens.

These patches can also avoid the known problem of missing a previously
gone offline cpu in v1 cpuset after a single cpu offline and online
sequence.

Waiman Long (2):
  cgroup/cpuset: Skip task update if hotplug doesn't affect current
    cpuset
  cgroup/cpuset: Don't update tasks' cpumasks for cpu offline events

 kernel/cgroup/cpuset.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

-- 
2.31.1

