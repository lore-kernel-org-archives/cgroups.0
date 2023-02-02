From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/2] cgroup/cpuset: Make hotplug code more efficient
Date: Thu,  2 Feb 2023 09:31:58 -0500
Message-ID: <20230202143200.128753-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675348337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rb40jJZP+p+46lzXWGfp2d9j5iJL9Oz8USeC7Urj69w=;
        b=Vm9cLRazNKGQMQfq1ZEAQokeeLYVmA/ICs8BoVvba1e+WF4HZLs/xSq/Pl/+GpoKSFRcdq
        sdNrvQf1NE6JIgt6t0ieTFJAP9CrZjA1KyKZsKvKfwRFcFHm1Dzy8wfdE6khVbCcM3HY04
        eSRxjZ7eNgXZSILNcpBWwUw3gMsQSdg=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v2:
  - It turns out it works around the v1 cpuset missing offline cpu
    problem better than I originally thought. So the patch description
    is updated accordingly.

This small patch series makes the cpuset hotplug a bit more efficient
by eliminating unnecessary task iteration and cpu/node masks update
when a cpu hotplug event (online/offline) happens.

It can also largely work around the known problem of missing previously
offlined cpus in v1 cpuset with some exceptions.

Waiman Long (2):
  cgroup/cpuset: Skip task update if hotplug doesn't affect current
    cpuset
  cgroup/cpuset: Don't update tasks' cpumasks for cpu offline events

 kernel/cgroup/cpuset.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

-- 
2.31.1

