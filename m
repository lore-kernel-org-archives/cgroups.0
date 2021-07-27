From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH TTY] memcg: drop GFP_KERNEL_ACCOUNT use in tty_save_termios()
Date: Tue, 27 Jul 2021 12:26:12 +0300
Message-ID: <afbaec7c-1872-d43a-1240-e077adc0d6d9@virtuozzo.com>
References: <d42bd2a3-74a0-163f-6e3a-ad702f6d2817@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=aA4OKvIJX54mPh9QQGvJAgE1NSRLlK28/A5Ft+jS4wk=; b=jEfB9MJFSdPNiqdCXAZ
        3Z62IS2ffQzJuMY15RKM/nZj2NYL3YFhbyT+VsHbbsPTdRe+NwSfHQGgrtyYhaB99zj3vqsE9f1If
        Spm8IT/7BVz3qp2ClvJzlF10US7VmxGpWgxtKo3esF27NAaRlPfO6ZBAwV4PiZMazGttnQltqCg=;
In-Reply-To: <d42bd2a3-74a0-163f-6e3a-ad702f6d2817-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Jiri Slaby pointed that termios are not saved for PTYs and for other
terminals used inside containers. Therefore accounting for saved
termios have near to zero impact in real life scenarios.

Cc: Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: 854dd8a572a0 ("memcg: enable accounting for tty-related objects")
Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 drivers/tty/tty_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index e787f6f..a6230b2 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1493,7 +1493,7 @@ void tty_save_termios(struct tty_struct *tty)
 	/* Stash the termios data */
 	tp = tty->driver->termios[idx];
 	if (tp == NULL) {
-		tp = kmalloc(sizeof(*tp), GFP_KERNEL_ACCOUNT);
+		tp = kmalloc(sizeof(*tp), GFP_KERNEL);
 		if (tp == NULL)
 			return;
 		tty->driver->termios[idx] = tp;
-- 
1.8.3.1

