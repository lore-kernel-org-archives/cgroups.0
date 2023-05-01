From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 05/40] prandom: Remove unused include
Date: Mon,  1 May 2023 09:54:15 -0700
Message-ID: <20230501165450.15352-6-surenb@google.com>
References: <20230501165450.15352-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682960119; x=1685552119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Am8x4T/C3ER6nwTMzq8wqC7nUn5OpA8nmjjdL2Y+IyA=;
        b=WPj8roryRwAmmVOt/f6DiF72YfWfvTwfrhdft0wjazxPvIpRZjMIBwQEDTYgaFjL40
         EYH/Obl5jlfmohNQjk6ksHyCvogtUr2FLXSqo8imf9pH+Av5pbwlM01Z0VPnzvuHFHvS
         sJJApW1h4nytu2oRGIJAzX1ILNXit4lP55uwJk+oNrWKlXyEZFC9xWXVli4TIY3SK85U
         B99AfIcgd6WX1rUTcNtVjahhym0hUSbpRJ8MlMIviR2dEnrK9LO4e6TK4pMF6ElbNOxK
         BqCNggeEEuUJjuE4WJ/nJF98lgK/t0MR2oB5re4JYDKTxZxL1IcsVMbdtZa5WL37TB8E
         NhaA==
In-Reply-To: <20230501165450.15352-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chromium.org

From: Kent Overstreet <kent.overstreet@linux.dev>

prandom.h doesn't use percpu.h - this fixes some circular header issues.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/prandom.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index f2ed5b72b3d6..f7f1e5251c67 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -10,7 +10,6 @@
 
 #include <linux/types.h>
 #include <linux/once.h>
-#include <linux/percpu.h>
 #include <linux/random.h>
 
 struct rnd_state {
-- 
2.40.1.495.gc816e09b53d-goog

