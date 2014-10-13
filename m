From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv1 2/8] sched: new clone flag CLONE_NEWCGROUP for cgroup
	namespace
Date: Mon, 13 Oct 2014 14:23:44 -0700
Message-ID: <1413235430-22944-3-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
	<1413235430-22944-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20120113;
	h=from:to:cc:subject:date:message-id:in-reply-to:references;
	bh=9XQPGmL+YCS1LA/oO4HAxAO/Rzhzu9mgQtU9Qc666cw=;
	b=keCa8JgGHTwTwd3oZ3Av1qoAG5lwXvUilAUjbN8SrWX6Tmq07tgvlru1qUhF+l7mFh
	i789c173wxsSYHPbc7VgJxzSGjpqgj6JvirQKH1fAXFW+L9yiiNuGjo3/jz5Ef+PzGU2
	+B8WvtvNIjwofVkRJal1iPSCJGuFjhdef4k+e/X4co78YLhGszhMn60fcIpSQeWaT3UG
	3LjW68m5arnZXqspgZEDyd/4nWHIkqttHWY4sUL4s1isMv9R7aAfU4WTWj+9XDHWnVar
	TnsKA6MvwIDHRk6N+pJx6/MTc/SGRE+dixIehmrE3txYCNPsUYLEm+nRtW0fDbVABECA
	+vTg==
In-Reply-To: <1413235430-22944-1-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

CLONE_NEWCGROUP will be used to create new cgroup namespace.

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/sched.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 34f9d73..2f90d00 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -21,8 +21,7 @@
 #define CLONE_DETACHED		0x00400000	/* Unused, ignored */
 #define CLONE_UNTRACED		0x00800000	/* set if the tracing process can't force CLONE_PTRACE on this clone */
 #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
-/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
-   and is now available for re-use. */
+#define CLONE_NEWCGROUP		0x02000000	/* New cgroup namespace */
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
-- 
2.1.0.rc2.206.gedb03e5
