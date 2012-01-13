From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/8] cgroups: add res_counter_write_u64() API
Date: Fri, 13 Jan 2012 19:13:46 +0100
Message-ID: <1326478441-3048-3-git-send-email-fweisbec@gmail.com>
References: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=3ioVye9l6bpPStYWkl5doq/2soKH6p8EJ9IeqAUvDmQ=;
        b=c+pjhbkV90PpVbBlayGUxsWQiwJs/Y4ozhKV/lnLe5B+P6fG4JFvY/XkkSuSWx0k26
         GZugf5mlBWn4PNiNDSkIgh6tdONTwy3BuysNLhfi4+L8SOwWTAHR1mBf6ge063qiu1/j
         ifs47e9VeDozNnFHMONdJO9wFtKciYTak7POA=
In-Reply-To: <1326478441-3048-1-git-send-email-fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Daniel J Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Max Kellermann <mk-xMchvyqCc6DQT0dZR+AlfA@public.gmane.org>, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Extend the resource counter API with a mirror of res_counter_read_u64() to
make it handy to update a resource counter value from a cgroup subsystem
u64 value file.

Signed-off-by: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Cc: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
 include/linux/res_counter.h |    2 ++
 kernel/res_counter.c        |   25 +++++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index c9d625c..1b3fe05 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -82,6 +82,8 @@ int res_counter_memparse_write_strategy(const char *buf,
 int res_counter_write(struct res_counter *counter, int member,
 		      const char *buffer, write_strategy_fn write_strategy);
 
+void res_counter_write_u64(struct res_counter *counter, int member, u64 val);
+
 /*
  * the field descriptors. one for each member of res_counter
  */
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 6d269cc..58ae85e 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -167,12 +167,26 @@ int res_counter_memparse_write_strategy(const char *buf,
 	return 0;
 }
 
+void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
+{
+	unsigned long long *target;
+	unsigned long flags;
+
+	/*
+	 * We need the lock to protect against concurrent add/dec on 32 bits.
+	 * No need to ifdef it's seldom used.
+	 */
+	spin_lock_irqsave(&counter->lock, flags);
+	target = res_counter_member(counter, member);
+	*target = val;
+	spin_unlock_irqrestore(&counter->lock, flags);
+}
+
 int res_counter_write(struct res_counter *counter, int member,
 		      const char *buf, write_strategy_fn write_strategy)
 {
 	char *end;
-	unsigned long flags;
-	unsigned long long tmp, *val;
+	unsigned long long tmp;
 
 	if (write_strategy) {
 		if (write_strategy(buf, &tmp))
@@ -182,9 +196,8 @@ int res_counter_write(struct res_counter *counter, int member,
 		if (*end != '\0')
 			return -EINVAL;
 	}
-	spin_lock_irqsave(&counter->lock, flags);
-	val = res_counter_member(counter, member);
-	*val = tmp;
-	spin_unlock_irqrestore(&counter->lock, flags);
+
+	res_counter_write_u64(counter, member, tmp);
+
 	return 0;
 }
-- 
1.7.5.4
