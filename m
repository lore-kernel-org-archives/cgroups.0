From: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] perf: Use css_tryget to avoid propping up css refcount.
Date: Thu, 14 Jun 2012 15:31:09 -0700
Message-ID: <20120614223108.1025.2503.stgit@dungbeetle.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=subject:to:from:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        bh=K8wMh1cSVgyViK6qOW9At9E7N7Qo3o1qxUOJj0240PQ=;
        b=fpaW0T/I8UmJd+zaKQSvWepLCDrqqsx9ULlJFrLFwN7qfO+HIA0oIH95ZBAhEXrQXQ
         Q9fzFlR6Dmc6pm3gfptzOwd7ppAtuV/uzSvoaOXmq7GGwV8WSAK+S0aaUTPTZPtf1Vd3
         VRcjyHo3HvTxXrzGtGRBVFaG5r7pz9rXv4Dvi+0OY/7LnSqFiCorNfbWz0U1N/cCcdjH
         Ftm1Sqfs6piwmuCaHZv5hVfsNDiIRPAgZpUejeJH9Ot6PoZGsRHjNzZHFh+Agjl5EpbN
         UMj1CvfuWVHWu3zUNBHC9DmFyDkMr4W4awg6O/cn0YEhhiujCPYrrtuyoksNS927UCk7
         exGw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

An rmdir pushes css's ref count to zero.  However, if the associated
directory is open at the time, the dentry ref count is non-zero.  If
the fd for this directory is then passed into perf_event_open, it
does a css_get().  This bounces the ref count back up from zero.  This
is a problem by itself.  But what makes it turn into a crash is the
fact that we end up doing an extra dput, since we perform a dput
when css_put sees the ref count go down to zero.

css_tryget does not fall into that trap. So, we use that instead.

Reproduction case for the bug:

#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/unistd.h>
#include <linux/perf_event.h>
#include <string.h>
#include <errno.h>
#include <stdio.h>

#define PERF_FLAG_PID_CGROUP    (1U << 2)

int perf_event_open(struct perf_event_attr *hw_event_uptr,
                    pid_t pid, int cpu, int group_fd, unsigned long flags) {
  return syscall(__NR_perf_event_open,hw_event_uptr, pid, cpu,
                 group_fd, flags);
}

/* Directly poke at the perf_event bug, since it's proving hard to repro
 * depending on where in the kernel tree.  what moved?
 */
int main(int argc, char **argv)
{
        int fd;
        struct perf_event_attr attr;
        memset(&attr, 0, sizeof(attr));
        attr.exclude_kernel = 1;
        attr.size = sizeof(attr);
        mkdir("/dev/cgroup/perf_event/blah", 0777);
        fd = open("/dev/cgroup/perf_event/blah", O_RDONLY);
        perror("open");
        rmdir("/dev/cgroup/perf_event/blah");
        sleep(2);
        perf_event_open(&attr, fd, 0, -1,  PERF_FLAG_PID_CGROUP);
        perror("perf_event_open");
        close(fd);
        return 0;
}

Signed-off-by: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/events/core.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f85c015..d7d71d6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -253,9 +253,9 @@ perf_cgroup_match(struct perf_event *event)
 	return !event->cgrp || event->cgrp == cpuctx->cgrp;
 }
 
-static inline void perf_get_cgroup(struct perf_event *event)
+static inline bool perf_tryget_cgroup(struct perf_event *event)
 {
-	css_get(&event->cgrp->css);
+	return css_tryget(&event->cgrp->css);
 }
 
 static inline void perf_put_cgroup(struct perf_event *event)
@@ -484,7 +484,11 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 	event->cgrp = cgrp;
 
 	/* must be done before we fput() the file */
-	perf_get_cgroup(event);
+	if (!perf_tryget_cgroup(event)) {
+		event->cgrp = NULL;
+		ret = -ENOENT;
+		goto out;
+	}
 
 	/*
 	 * all events in a group must monitor
