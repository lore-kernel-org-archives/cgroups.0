From: Waiman Long <longman@redhat.com>
Subject: [PATCH v5 1/4] lib/vsprintf: Avoid redundant work with 0 size
Date: Mon,  7 Feb 2022 19:05:29 -0500
Message-ID: <20220208000532.1054311-2-longman@redhat.com>
References: <20220208000532.1054311-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644278765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EpG/a8UGSgxQkJKVhwJeqMQ36JzcPE9kOn8DL2mEYFQ=;
        b=T4M3f8zni9eTM5JJIhhkFXkcc2N0gpLPm8vJaAWffQgPxW+Da8LtUQ7NdJw9D9Z2vyuPhV
        U2Fs4ZxROqWQKm+EJa8V63HdXhpOw2f55RggckP4R2B4WqctdlMNpfXTIVWqIN2Ie/BGWp
        5At/h9hqvISgIHHWAkMUUfpfrRrJQgQ=
In-Reply-To: <20220208000532.1054311-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>, Mike Rapoport <rppt@kernel.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <guro@fb.com>, Rafael Aquini <aquini@redhat.com>, Waiman Long <longman@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>

For *scnprintf(), vsnprintf() is always called even if the input size is
0. That is a waste of time, so just return 0 in this case.

Note that vsnprintf() will never return -1 to indicate an error. So
skipping the call to vsnprintf() when size is 0 will have no functional
impact at all.

Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
---
 lib/vsprintf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3b8129dd374c..d419154b47bb 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2895,13 +2895,15 @@ int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
 	int i;
 
+	if (unlikely(!size))
+		return 0;
+
 	i = vsnprintf(buf, size, fmt, args);
 
 	if (likely(i < size))
 		return i;
-	if (size != 0)
-		return size - 1;
-	return 0;
+
+	return size - 1;
 }
 EXPORT_SYMBOL(vscnprintf);
 
-- 
2.27.0

