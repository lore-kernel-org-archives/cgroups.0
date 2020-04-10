From: Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>
Subject: [PATCH] clone.2: Document CLONE_INTO_CGROUP
Date: Fri, 10 Apr 2020 12:41:32 +0200
Message-ID: <20200410104132.294639-1-christian@brauner.io>
References: <CAKgNAkhL0zCj11LS9vfae872YVeRsxdz20sZWuXdi+UjH21=0g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6QLdzKbUmCzenyVGneMFCV9bfKtlfDEGB2GO2r8hJWg=;
        b=RlDv/0oQA02ldjND6rBeHExH4DYeBwroQFO6VsXB7oPjn82aw7DE07jOJwamw79Dfw
         1QDYIJHtvE/Jz7D2sYlCZbKWpcYNbC66gpHtKKIgkZmE2trjcI6BzQZWIoMOCaFgEANN
         JFDUF2l696jXsGCPituOu4pCIg5LhTtzHohm0yYuQQ9niuDn0FTSOu0L2PJuM8kOtNs2
         glB3izUnxmDMea8RJxv2VXkUHVwUjLJei9XBOhihEWGkWvDFwvcJrZmlYEUaV5S3JQlp
         xy4spya55b7BFw5sZB+h11dt4sMgBOadYNHoGxRXu4dwA1jAq/nFyot69yPGoXllofPl
         Ky8g==
In-Reply-To: <CAKgNAkhL0zCj11LS9vfae872YVeRsxdz20sZWuXdi+UjH21=0g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 man2/clone.2 | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/man2/clone.2 b/man2/clone.2
index 39cec4c86..8d9aa9f99 100644
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
@@ -448,6 +449,25 @@ Specifying this flag together with
 .B CLONE_SIGHAND
 is nonsensical and disallowed.
 .TP
+.BR CLONE_INTO_CGROUP " (since Linux 5.7)"
+.\" commit ef2c41cf38a7559bbf91af42d5b6a4429db8fc68
+By default, the child process will belong to the same cgroup as its parent.
+If this flag is specified the child process will be created in a
+different cgroup than its parent.
+
+When using
+.RB clone3 ()
+the target cgroup can be specified by setting the
+.I cl_args.cgroup
+member to the file descriptor of the target cgroup. The cgroup file
+descriptor must refer to a cgroup in a cgroup v2 hierarchy
+(see
+.BR cgroup (2)).
+
+Note that all usual cgroup v2 process migration restrictions apply. See
+.BR cgroup (2)
+for detailed information.
+.TP
 .BR CLONE_DETACHED " (historical)"
 For a while (during the Linux 2.5 development series)
 .\" added in 2.5.32; removed in 2.6.0-test4

base-commit: ff5de6ecc4338f4b62c3459c99bd1a3a75ee2808
-- 
2.26.0

