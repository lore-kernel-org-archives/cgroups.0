From: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Subject: [RFC v0 4/4] net: Allow updating sk_class id to 0
Date: Mon, 16 Apr 2012 17:35:06 +0200
Message-ID: <1334590506-19462-5-git-send-email-wagi@monom.org>
References: <1334590506-19462-1-git-send-email-wagi@monom.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334590506-19462-1-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>

task_cls_classid() used to return 0 when the now removed
in_interrtup() check was true.

Signed-off-by: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
CC: Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>
CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 net/core/sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 03dfaac..b464c67 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1184,7 +1184,7 @@ void sock_update_classid(struct sock *sk)
 		return;
 
 	classid = task_cls_classid(current);
-	if (classid && classid != sk->sk_classid)
+	if (classid != sk->sk_classid)
 		sk->sk_classid = classid;
 }
 EXPORT_SYMBOL(sock_update_classid);
-- 
1.7.10.130.g36e6c
