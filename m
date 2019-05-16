From: Roman Gushchin <guro@fb.com>
Subject: [PATCH RESEND] signal: unconditionally leave the frozen state in ptrace_stop()
Date: Thu, 16 May 2019 10:38:21 -0700
Message-ID: <20190516173821.1498807-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=B2SIJpPp/mlOGynEQLUWe5A/4Aq03L0X3tl4w90B9Gw=;
 b=U/xGWQ3ojU2JxIog44PXNp5LPf2/Ycypw+1r8vLEJyLqAzCnHVyC3zvrKUvVZK0XoAwZ
 DN0Y0n3NAKzNROT8Uh7Ecr++ixHJ9xnPfvBycVuQZ4gX7kxv3Xr0Nkf9WT4+yhJtCOo+
 rJF8OhLSP4zv0YuxXkQW0bS/JN7M9+GwNnU= 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Alex Xu <alex_y_xu@yahoo.ca>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

Alex Xu reported a regression in strace, caused by the introduction of
the cgroup v2 freezer. The regression can be reproduced by stracing
the following simple program:

  #include <unistd.h>

  int main() {
      write(1, "a", 1);
      return 0;
  }

An attempt to run strace ./a.out leads to the infinite loop:
  [ pre-main omitted ]
  write(1, "a", 1)                        = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
  write(1, "a", 1)                        = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
  write(1, "a", 1)                        = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
  write(1, "a", 1)                        = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
  write(1, "a", 1)                        = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
  write(1, "a", 1)                        = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
  [ repeats forever ]

The problem occurs because the traced task leaves ptrace_stop()
(and the signal handling loop) with the frozen bit set. So let's
call cgroup_leave_frozen(true) unconditionally after sleeping
in ptrace_stop().

With this patch applied, strace works as expected:
  [ pre-main omitted ]
  write(1, "a", 1)                        = 1
  exit_group(0)                           = ?
  +++ exited with 0 +++

Reported-by: Alex Xu <alex_y_xu@yahoo.ca>
Fixes: 76f969e8948d ("cgroup: cgroup v2 freezer")
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
---
 kernel/signal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8607b11ff936..565ba14d89d5 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2112,6 +2112,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, kernel_siginfo_t
 		preempt_enable_no_resched();
 		cgroup_enter_frozen();
 		freezable_schedule();
+		cgroup_leave_frozen(true);
 	} else {
 		/*
 		 * By the time we got the lock, our tracer went away.
-- 
2.20.1

