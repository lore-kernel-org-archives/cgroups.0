From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 06/40] lib/string.c: strsep_no_empty()
Date: Mon,  1 May 2023 09:54:16 -0700
Message-ID: <20230501165450.15352-7-surenb@google.com>
References: <20230501165450.15352-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682960122; x=1685552122;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AsvePdIIpK1hSWiMR4JNg9vJpL7RbQEpCCaVPwkxl+U=;
        b=FUEHKTcj/6Oaa/jf/hG74LwWnPzMzDXETDPC/OZPn9YmdSr3Je1dLjqI5qQFH1sW3q
         Bq/alOSo7JqKEqD9rgKcyUF43rVJZUIyQmx1G3PllnLeg5Yg39a7Bnek6w/Qmd8uXbJK
         EsGaYT+egztrqXkT7lGAkap+Gl5GwKP4LRCOjo5ZnVALaZHiuOt5sB/2YrOa8QMVBMrC
         FKm9pwPXa7lut/5XYzJLVlhPqGzsdKvhEJFlIIbig8wN8WeEjVJtPWgEipfIbTn79FXC
         wbTQc/DXAGa8hfnAWPDItUw4SLFFckirBkUuGFld0u0/pGt++nX/qQJEblW72Hij4gvi
         rVdg==
In-Reply-To: <20230501165450.15352-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chromium.org

From: Kent Overstreet <kent.overstreet@linux.dev>

This adds a new helper which is like strsep, except that it skips empty
tokens.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/string.h |  1 +
 lib/string.c           | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index c062c581a98b..6cd5451c262c 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -96,6 +96,7 @@ extern char * strpbrk(const char *,const char *);
 #ifndef __HAVE_ARCH_STRSEP
 extern char * strsep(char **,const char *);
 #endif
+extern char *strsep_no_empty(char **, const char *);
 #ifndef __HAVE_ARCH_STRSPN
 extern __kernel_size_t strspn(const char *,const char *);
 #endif
diff --git a/lib/string.c b/lib/string.c
index 3d55ef890106..dd4914baf45a 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -520,6 +520,25 @@ char *strsep(char **s, const char *ct)
 EXPORT_SYMBOL(strsep);
 #endif
 
+/**
+ * strsep_no_empt - Split a string into tokens, but don't return empty tokens
+ * @s: The string to be searched
+ * @ct: The characters to search for
+ *
+ * strsep() updates @s to point after the token, ready for the next call.
+ */
+char *strsep_no_empty(char **s, const char *ct)
+{
+	char *ret;
+
+	do {
+		ret = strsep(s, ct);
+	} while (ret && !*ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(strsep_no_empty);
+
 #ifndef __HAVE_ARCH_MEMSET
 /**
  * memset - Fill a region of memory with the given value
-- 
2.40.1.495.gc816e09b53d-goog

