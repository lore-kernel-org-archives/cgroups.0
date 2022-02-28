From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2] memcg: enable accounting for tty-related objects
Date: Mon, 28 Feb 2022 12:13:54 +0300
Message-ID: <5d4bca06-7d4f-a905-e518-12981ebca1b3@virtuozzo.com>
References: <afbaec7c-1872-d43a-1240-e077adc0d6d9@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0X0kPE7F453qZwFgdByilAR9MhxrSvmXaauHX/m9ag=;
 b=peuQb13Xo2zvilLfUddZUDT/bFA56Wy+dp3g/T+YT5FQ7Ndf7Mmlb4FHvVO49ftyGWLX/yCsj2augkX1xMAGVK6DDesGenL1d67i7VKAuxrXo0Ev1HnOMKjORob3Z0AzT0NgD6h6H+togjiKYXqOkON0AoVHeHKmHRD01os8sk4=
Content-Language: en-US
In-Reply-To: <afbaec7c-1872-d43a-1240-e077adc0d6d9@virtuozzo.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jirislaby@kernel.org>, linux-kernel@vger.kernel.org, kernel@openvz.org

At each login the user forces the kernel to create a new terminal and
allocate up to ~1Kb memory for the tty-related structures.

By default it's allowed to create up to 4096 ptys with 1024 reserve for
initial mount namespace only and the settings are controlled by host admin.

Though this default is not enough for hosters with thousands
of containers per node. Host admin can be forced to increase it
up to NR_UNIX98_PTY_MAX = 1<<20.

By default container is restricted by pty mount_opt.max = 1024,
but admin inside container can change it via remount. As a result,
one container can consume almost all allowed ptys
and allocate up to 1Gb of unaccounted memory.

It is not enough per-se to trigger OOM on host, however anyway, it allows
to significantly exceed the assigned memcg limit and leads to troubles
on the over-committed node.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

v2: removed hunk patched tty_save_termios()
Jiri Slaby pointed that termios are not saved for PTYs and for other
terminals used inside containers. Therefore accounting for saved
termios have near to zero impact in real life scenarios.
v1 patch version was dropped due to noticed issue,
however hunk patched alloc_tty_struct is still actual.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
  drivers/tty/tty_io.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 7e8b3bd59c7b..8fec1d8648f5 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3088,7 +3088,7 @@ struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx)
  {
  	struct tty_struct *tty;
  
-	tty = kzalloc(sizeof(*tty), GFP_KERNEL);
+	tty = kzalloc(sizeof(*tty), GFP_KERNEL_ACCOUNT);
  	if (!tty)
  		return NULL;
  
-- 
2.25.1

