From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/8] cgroups: pull up res counter charge failure interpretation to caller
Date: Fri, 13 Jan 2012 19:13:56 +0100
Message-ID: <1326478441-3048-13-git-send-email-fweisbec@gmail.com>
References: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=x1WEEJihZ3iBgV1nfHdZOxS+yrLnFWz1yK6/mqSKWB4=;
        b=fi8DW4YT7BYfeoRWIzJswIKMmOpmCFlKVmq0hWOZULrzPbtIVsGNebzO9FvAILd3xD
         iI2E8EuhQruw1zPxGeaID/NM+eEeVFOHeUpNgKBxhBYCj/PJYFxIT9LV5Y6nqeXi82Lf
         s6crw6RboGqUr4Z5NutK8YPIGHzETNhRX8q74=
In-Reply-To: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Daniel J Walsh <dwalsh@redhat.com>, "Daniel P. Berrange" <berrange@redhat.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Max Kellermann <mk@cm4all.com>, Mandeep Singh Baines <msb@chromium.org>, Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>

res_counter_charge() always returns -ENOMEM when the limit is reached and
the charge thus can't happen.

However it's up to the caller to interpret this failure and return the
appropriate error value.  The task counter subsystem will need to report
the user that a fork() has been cancelled because of some limit reached,
not because we are too short on memory.

Fix this by returning -1 when res_counter_charge() fails.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 Documentation/cgroups/resource_counter.txt |    2 ++
 kernel/res_counter.c                       |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/resource_counter.txt b/Documentation/cgroups/resource_counter.txt
index a2cd05b..24ec61c 100644
--- a/Documentation/cgroups/resource_counter.txt
+++ b/Documentation/cgroups/resource_counter.txt
@@ -76,6 +76,8 @@ to work with it.
 	limit_fail_at parameter is set to the particular res_counter element
 	where the charging failed.
 
+	It returns 0 on success and -1 on failure.
+
  d. int res_counter_charge_locked
 			(struct res_counter *rc, unsigned long val)
 
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 644898a..8f47ac6 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -26,7 +26,7 @@ int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
 {
 	if (counter->usage + val > counter->limit) {
 		counter->failcnt++;
-		return -ENOMEM;
+		return -1;
 	}
 
 	counter->usage += val;
-- 
1.7.5.4
