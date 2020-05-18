From: Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>
Subject: [PATCH v2] clone.2: Document CLONE_INTO_CGROUP
Date: Mon, 18 May 2020 19:55:49 +0200
Message-ID: <20200518175549.3400948-1-christian@brauner.io>
References: <CAKgNAkhL0zCj11LS9vfae872YVeRsxdz20sZWuXdi+UjH21=0g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bAdNBlANOE194kXAkMzs8wkwLbdmMZKVzS7nRAabSx0=;
        b=gzTIjf10gpIkG8zPGdhSboUtjnxE2wdlyz+lcTb6y+vDqZANzuEWOloXv/+55QJx3P
         Id/QaiwCpZNSFbDSLMi750vq3rM4sB7FtcXIFBDjtjy2r6amW5caSDAaO74p9eR7GQ4V
         GKPquEbSy/LdmHP89ioSUV5vzb6Sx6k0weZMRoHrJJpQ+llJ5Nud8Qh6SaKzJ7h9yO+h
         23wERq3aVksJk/PoeACaB0WtZD5CFPVObYqaIq/xe2qq7LPHezjXlfY7Y0i6AwqnFFCK
         zrwJkcM1+rgKkMNnGz6K9tIQrvurV+dMIBStlFk8C1ucRIddZurStfA/ui5OL38PkMQN
         CSTw==
In-Reply-To: <CAKgNAkhL0zCj11LS9vfae872YVeRsxdz20sZWuXdi+UjH21=0g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
/* v2 */
- Michael Kerrisk (man-pages) <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
  - Fix various types and add examples and how to specify the file
    descriptor.
---
 man2/clone.2 | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/man2/clone.2 b/man2/clone.2
index 8b70b78a4..33594ddc5 100644
--- a/man2/clone.2
+++ b/man2/clone.2
@@ -197,6 +197,7 @@ struct clone_args {
     u64 tls;          /* Location of new TLS */
     u64 set_tid;      /* Pointer to a \fIpid_t\fP array */
     u64 set_tid_size; /* Number of elements in \fIset_tid\fP */
+    u64 cgroup;       /* Target cgroup file descriptor for the child process */
 };
 .EE
 .in
@@ -448,6 +449,48 @@ Specifying this flag together with
 .B CLONE_SIGHAND
 is nonsensical and disallowed.
 .TP
+.BR CLONE_INTO_CGROUP " (since Linux 5.7)"
+.\" commit ef2c41cf38a7559bbf91af42d5b6a4429db8fc68
+By default, the child process will be placed in the same version 2
+cgroup as its parent.
+If this flag is specified the child process will be created in a
+different cgroup than its parent.
+Note, that
+.BR CLONE_INTO_CGROUP
+is limited to version 2 cgroups. To use this feature, callers
+need to raise
+.BR CLONE_INTO_CGROUP
+in
+.I cl_args.flags
+and pass a directory file descriptor (see the
+.BR O_DIRECTORY
+flag for the
+.BR open (2)
+syscall) in the
+.I cl_args.cgroup.
+The caller may also pass an
+.BR O_PATH
+(see
+.BR open (2))
+file descriptor for the target cgroup.
+Note, that all usual version 2 cgroup migration restrictions (see
+.BR cgroups (7)
+for details) apply.
+
+Spawning a process into a cgroup different from the parent's cgroup
+makes it possible for a service manager to directly spawn new
+services into dedicated cgroups. This allows eliminating accounting
+jitter which would be caused by the new process living in the
+parent's cgroup for a short amount of time before being
+moved into the target cgroup. This flag also allows the creation of
+frozen child process by spawning them into a frozen cgroup (see
+.BR cgroups (7)
+for a description of the freezer feature in version 2 cgroups).
+For threaded applications or even thread implementations which
+make use of cgroups to limit individual threads it is possible to
+establish a fixed cgroup layout before spawning each thread
+directly into its target cgroup.
+.TP
 .BR CLONE_DETACHED " (historical)"
 For a while (during the Linux 2.5 development series)
 .\" added in 2.5.32; removed in 2.6.0-test4

base-commit: aa02339ca45030711b42a1af12e3ee3405c1c5c7
-- 
2.26.2

