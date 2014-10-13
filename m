From: Heena Sirwani <heenasirwani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v5 1/2] cpuset: Replace all instances of time_t with time64_t
Date: Mon, 13 Oct 2014 10:21:09 +0530
Message-ID: <43cb8df7f4dec3c13c77aa38c8e6b15bc8b8da09.1413174804.git.heenasirwani@gmail.com>
References: <cover.1413174804.git.heenasirwani@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pq7sMpLLThsTwcW1e8ihX+tCyF6FkQUrQAr39B8RhfU=;
        b=RNb5WHKK8k/KCDKmReukcfLa3lW0BsrC1hzzU5mp8uwLfHGwp/3nFHA8dA22gRUfX7
         uMKSN/KDKv49tbBXugDchy7cLIeryOoW3gvTC2WxDCaGMLu7JsTNG0CdJ88f+1cYxl5+
         ag/CgpI3U/sTZAyHYjaV6HdH94Fe/dU+w/lP1lPXJLRV4NjaMC9sBAlpfzWqYTLnx87V
         IUiAUpc++cqGzNTwgGW1rak7wMVlHnw7zFZ6rHORrxBgzTb54mCFNYl1BKgZrm6piuvo
         pFhvMgHrCTzgXZmDLykDgOVoHgo+Pk/qPd89jvMhptkiEejiHakYxmY5G49yqQrG+wXn
         JX8g==
Content-Disposition: inline
In-Reply-To: <cover.1413174804.git.heenasirwani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: opw-kernel-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: arnd-r2nGTMty4D4@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The following patch replaces all instances of time_t with time64_t i.e.
change the type used for representing time from 32-bit to 64-bit. All
32-bit kernels to date use a signed 32-bit time_t type, which can only
represent time until January 2038. Since embedded systems running 32-bit
Linux are going to survive beyond that date, we have to change all
current uses, in a backwards compatible way.

The patch also changes the function get_seconds() that returns a 32-bit
integer to ktime_get_real_ts64() that returns a struct of type timespec64
and use the tv_sec part which is 64-bit.

The patch changes the type of ticks from time_t to u32. We keep ticks as
32-bits as the function uses 32-bit arithmetic which would prove less
expensive than 64-bit arithmetic and the function is expected to be called
atleast once every 32 seconds.

Signed-off-by: Heena Sirwani <heenasirwani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cpuset.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 52cb04c..c3e3aac 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -51,6 +51,7 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/time.h>
+#include <linux/time64.h>
 #include <linux/backing-dev.h>
 #include <linux/sort.h>
 
@@ -68,7 +69,7 @@ struct static_key cpusets_enabled_key __read_mostly = STATIC_KEY_INIT_FALSE;
 struct fmeter {
 	int cnt;		/* unprocessed events count */
 	int val;		/* most recent output value */
-	time_t time;		/* clock (secs) when val computed */
+	time64_t time;		/* clock (secs) when val computed */
 	spinlock_t lock;	/* guards read or write of above */
 };
 
@@ -1355,7 +1356,7 @@ out:
  */
 
 #define FM_COEF 933		/* coefficient for half-life of 10 secs */
-#define FM_MAXTICKS ((time_t)99) /* useless computing more ticks than this */
+#define FM_MAXTICKS ((u32)99)	/* useless computing more ticks than this */
 #define FM_MAXCNT 1000000	/* limit cnt to avoid overflow */
 #define FM_SCALE 1000		/* faux fixed point scale */
 
@@ -1371,8 +1372,14 @@ static void fmeter_init(struct fmeter *fmp)
 /* Internal meter update - process cnt events and update value */
 static void fmeter_update(struct fmeter *fmp)
 {
-	time_t now = get_seconds();
-	time_t ticks = now - fmp->time;
+	struct timespec64 timespec;
+	time64_t now;
+	u32 ticks;
+
+	/* One should probably use get_seconds64().*/
+	ktime_get_real_ts64(&timespec);		
+	now = timespec.tv_sec;
+	ticks = now - fmp->time;
 
 	if (ticks == 0)
 		return;
-- 
1.9.1
