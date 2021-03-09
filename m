From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 8/9] memcg: accounting for tty_struct objects
Date: Tue, 9 Mar 2021 11:04:47 +0300
Message-ID: <d205d15f-7694-7940-a534-66743f452833@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvOGfhU67Ne0x55U1mi/eYx3RQi6tluzUKRhpEayLOQ=;
 b=DoOD/d2xRXZgq6ijyDzejbWsDTKzgy+BN6kj4WqlAqakaRvL6hjpP/ysI0/aIQCTA4qqCsmJrYCGEQle/STjhDD1D5iXQB7Kz8H+frxGHtEbY84YIkVZFYjRlDhastTkGPPJZncc2PcnrR75dwidXtX+1VPaMKeK63H1sVqu8gs=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Objects can be created from memcg-limited tasks
but its misuse may lead to host OOM.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 drivers/tty/tty_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 74733ec..a3b881b 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1503,7 +1503,7 @@ void tty_save_termios(struct tty_struct *tty)
 	/* Stash the termios data */
 	tp = tty->driver->termios[idx];
 	if (tp == NULL) {
-		tp = kmalloc(sizeof(*tp), GFP_KERNEL);
+		tp = kmalloc(sizeof(*tp), GFP_KERNEL_ACCOUNT);
 		if (tp == NULL)
 			return;
 		tty->driver->termios[idx] = tp;
@@ -3128,7 +3128,7 @@ struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx)
 {
 	struct tty_struct *tty;
 
-	tty = kzalloc(sizeof(*tty), GFP_KERNEL);
+	tty = kzalloc(sizeof(*tty), GFP_KERNEL_ACCOUNT);
 	if (!tty)
 		return NULL;
 
-- 
1.8.3.1

