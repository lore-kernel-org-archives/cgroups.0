From: Greg Thelen <gthelen@google.com>
Subject: [PATCH 2/2] cgroups: fix cgroup_event_listener error handling
Date: Fri,  4 Jan 2013 13:05:18 -0800
Message-ID: <1357333518-28899-2-git-send-email-gthelen@google.com>
References: <1357333518-28899-1-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references:mime-version:content-type:content-transfer-encoding;
        bh=qPFyE/qeZ/DBCZVJO6CT3n4NPlxON4SONpsZOu//jcE=;
        b=J8hD1b8FtdlbWLw+fOURq1NNVV8TmH4ItE0oEYqnlnCPMDi8otmRW89aJ/o5Y0+Uzm
         nAi19V3b06wfx/1qnAMj69EP4VfIqccVHS4OtFSpGsf5ePwuZf81Dok28tf8EPbZx7A7
         cYSToGA7KLbEGa3IfQH+J6iLMQaq4rzd0b3R8hm/tTl9mNiHJTFfooWyj61+KU8m2ewB
         CeayyfMXRQ9yaZiq4NaFU+uUxFZpTuWfmd/3EEm+y9r8dUvFxWm2fT3gnEUySao9gPUE
         fosd9QZb/ttgnZgf5t0QHxfpCiGiOwbGsClb7pkdsiQ6jufrOEQqoh1NpKnZ+LypMu91
         5jMQ==
In-Reply-To: <1357333518-28899-1-git-send-email-gthelen@google.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>

If the <absolute-path-to-control-file> command line parameter cannot
be opened, then cgroup_event_listener prints an error message and
tries to return an error.  However, due to an uninitialized variable
the return value was undefined.

With this patch such failures always return non-zero error.

Compiler warning found this:
  $ gcc -Wall -O2 cgroup_event_listener.c
  cgroup_event_listener.c: In function =E2=80=98main=E2=80=99:
  cgroup_event_listener.c:109:2: warning: =E2=80=98ret=E2=80=99 may be =
used uninitialized in this function [-Wuninitialized]

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 tools/cgroup/cgroup_event_listener.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/cgroup/cgroup_event_listener.c b/tools/cgroup/cgroup=
_event_listener.c
index 3e082f9..a70f00c 100644
--- a/tools/cgroup/cgroup_event_listener.c
+++ b/tools/cgroup/cgroup_event_listener.c
@@ -35,7 +35,7 @@ int main(int argc, char **argv)
 	if (cfd =3D=3D -1) {
 		fprintf(stderr, "Cannot open %s: %s\n", argv[1],
 				strerror(errno));
-		goto out;
+		return 1;
 	}
=20
 	ret =3D snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_contr=
ol",
--=20
1.7.7.3

