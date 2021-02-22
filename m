From: Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 01/20] cgroup: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:12 +0100
Message-ID: <20210222151231.22572-2-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-20781-glkh-kernel-hardening=m.gmane-mx.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <cgroups.vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P+jxf/c6aKxBtKoS9ZDFkjl+nA7mB7wt86sqHcoIgnU=;
        b=Igj+NEPkPWJoijrkRrH/caY1E5NfYkZDCZBhzVHmscEXfl+nAU78Fds4ChKT5iDrNC
         3Re67QcqVO7PVhLnnkmbHNIeb4QyzO5LpMQ4CZh3L5ljZOXZ9UxWRynfgTwVM+sUAJz5
         klfGDgvY+/fw5TX3ymZqTbgFogQvObV/nXFCkcasHwi372vovAHjSr/7Kasiuj3uHNm+
         jYyltTXRnnMePNacdNKWXGIGVEiOdKvLF5ZfEGDiQsT7/511k9S7wlrFXMT5o10kLEz1
         AUdPF2xJqw9I/8FJ1VAcA1OHMF/rlP127zcAuRQ/pTd7Nj+AR1jK/ld7mx5nqdHC6ElF
         QPKg==
In-Reply-To: <20210222151231.22572-1-romain.perier@gmail.com>
Content-Type: text/plain; charset="us-ascii"
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Romain Perier <romain.perier@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

The strlcpy() reads the entire source buffer first, it is dangerous if
the source buffer lenght is unbounded or possibility non NULL-terminated.
It can lead to linear read overflows, crashes, etc...

As recommended in the deprecated interfaces [1], it should be replaced
by strscpy.

This commit replaces all calls to strlcpy that handle the return values
by the corresponding strscpy calls with new handling of the return
values (as it is quite different between the two functions).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 kernel/cgroup/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1ea995f801ec..bac0dc2ff8ad 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2265,7 +2265,7 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 		ret = cgroup_path_ns_locked(cgrp, buf, buflen, &init_cgroup_ns);
 	} else {
 		/* if no hierarchy exists, everyone is in "/" */
-		ret = strlcpy(buf, "/", buflen);
+		ret = strscpy(buf, "/", buflen);
 	}
 
 	spin_unlock_irq(&css_set_lock);

