From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH v2 07/17] cgroup: Prevent kill_css() from being called more than once
Date: Mon, 15 May 2017 09:34:06 -0400
Message-ID: <1494855256-12558-8-git-send-email-longman@redhat.com>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 18B414E338
In-Reply-To: <1494855256-12558-1-git-send-email-longman@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, longman@redhat.com

The kill_css() function may be called more than once under the condition
that the css was killed but not physically removed yet followed by the
removal of the cgroup that is hosting the css. This patch prevents any
harmm from being done when that happens.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/cgroup-defs.h | 1 +
 kernel/cgroup/cgroup.c      | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index e8d0cfc..b123afc 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -48,6 +48,7 @@ enum {
 	CSS_ONLINE	= (1 << 1), /* between ->css_online() and ->css_offline() */
 	CSS_RELEASED	= (1 << 2), /* refcnt reached zero, released */
 	CSS_VISIBLE	= (1 << 3), /* css is visible to userland */
+	CSS_DYING	= (1 << 4), /* css is dying */
 };
 
 /* bits in struct cgroup flags field */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f14deca..7b085d5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4630,6 +4630,11 @@ static void kill_css(struct cgroup_subsys_state *css)
 {
 	lockdep_assert_held(&cgroup_mutex);
 
+	if (css->flags & CSS_DYING)
+		return;
+
+	css->flags |= CSS_DYING;
+
 	/*
 	 * This must happen before css is disassociated with its cgroup.
 	 * See seq_css() for details.
-- 
1.8.3.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
