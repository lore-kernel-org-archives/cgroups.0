From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/8] cgroups: add res counter common ancestor searching
Date: Fri, 13 Jan 2012 19:13:52 +0100
Message-ID: <1326478441-3048-9-git-send-email-fweisbec@gmail.com>
References: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=ae76N6JD4qcJGgd3Vsd0nMRFGpZheRFw/I0XW8AEbiI=;
        b=G0Ez4xabbGT7khQpPDQmZ9rn6B5s/UlwkprHLV615RxOD5uqxenOQcl3S79oiqhcfk
         xKaIRgfjwNcfyo7syclxmnSETmuY4djLcV7Nzy1q0kl8f326EuaGCNayxOteJNc8yuIZ
         J4N/sv3n0mKOKH3pXozk/KRPcaDGyCoAen2aU=
In-Reply-To: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Daniel J Walsh <dwalsh@redhat.com>, "Daniel P. Berrange" <berrange@redhat.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Max Kellermann <mk@cm4all.com>, Mandeep Singh Baines <msb@chromium.org>, Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>, Johannes Weiner <hannes@cmpxchg.org>, Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>

From: "Kirill A. Shutemov" <kirill@shutemov.name>

Add a new API to find the common ancestor between two resource counters.
This includes the passed resource counter themselves.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/res_counter.h |    3 +++
 kernel/res_counter.c        |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index de4ba29..558f39b 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -147,6 +147,9 @@ static inline void res_counter_uncharge(struct res_counter *counter,
 	res_counter_uncharge_until(counter, NULL, val);
 }
 
+struct res_counter *res_counter_common_ancestor(struct res_counter *l,
+						struct res_counter *r);
+
 /**
  * res_counter_margin - calculate chargeable space of a counter
  * @cnt: the counter
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 8ef09a4..86d72b8 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -91,6 +91,39 @@ void res_counter_uncharge_until(struct res_counter *counter,
 	local_irq_restore(flags);
 }
 
+/*
+ * Walk through r1 and r2 parents and try to find the closest common one
+ * between both. If none is found, it returns NULL.
+ */
+struct res_counter *
+res_counter_common_ancestor(struct res_counter *r1, struct res_counter *r2)
+{
+	struct res_counter *iter;
+	int r1_depth = 0, r2_depth = 0;
+
+	for (iter = r1; iter; iter = iter->parent)
+		r1_depth++;
+
+	for (iter = r2; iter; iter = iter->parent)
+		r2_depth++;
+
+	while (r1_depth > r2_depth) {
+		r1 = r1->parent;
+		r1_depth--;
+	}
+
+	while (r2_depth > r1_depth) {
+		r2 = r2->parent;
+		r2_depth--;
+	}
+
+	while (r1 != r2) {
+		r1 = r1->parent;
+		r2 = r2->parent;
+	}
+
+	return r1;
+}
 
 static inline unsigned long long *
 res_counter_member(struct res_counter *counter, int member)
-- 
1.7.5.4
