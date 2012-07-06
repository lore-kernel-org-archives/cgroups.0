From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/memcg: complete documentation for tcp memcg files
Date: Fri,  6 Jul 2012 17:15:48 +0800
Message-ID: <1341566148-10198-1-git-send-email-liwp.linux@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=15WDwpktPnJfDcwbbrWyxM+GP9+Eu5PL7TVHGcVP7Gk=;
        b=j9P/rUqPij2xcHQsvehHG49TWpJhym9+f8HeFfXE9rDkHrNxDOVWLfi4icw6cnesX0
         Whtuncij+grLWS3IXgcnulamKwSgmJvyfZ9gHxkdaySkS9ky4i936nEqHr4EfYf6pKL0
         BOnf2zI5GQXxs1oQqLKewQ4QZjhEkNWacBTuX/j6DNpjL1QICZQhWY2kJ06aQ+7l5ICv
         x1hhDKlbthjqLMzgS9FuR0BfQPc/pY6yOyPu+s/LaiBwZ5aP7ZStElij//oPyByG6t2j
         l+c0yk25RV9WDN/18w56FicbXatgDIOygjDXhGGcI43QAuZmD8+oDoTDX4kxaOclxwm9
         bxaA==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 Documentation/cgroups/memory.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index dd88540..b388e4a 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -73,6 +73,8 @@ Brief summary of control files.
 
  memory.kmem.tcp.limit_in_bytes  # set/show hard limit for tcp buf memory
  memory.kmem.tcp.usage_in_bytes  # show current tcp buf memory allocation
+ memory.kmem.tcp.failcnt            # show the number of tcp buf memory usage hits limits
+ memory.kmem.tcp.max_usage_in_bytes # show max tcp buf memory usage recorded
 
 1. History
 
-- 
1.7.5.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
