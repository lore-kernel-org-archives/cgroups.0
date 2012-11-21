From: David Rientjes <rientjes@google.com>
Subject: [patch] mm, memcg: avoid unnecessary function call when memcg is
 disabled fix
Date: Tue, 20 Nov 2012 18:48:52 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1211201847450.2278@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com> <20121120134932.055bc192.akpm@linux-foundation.org> <50AC282A.4070309@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=1wwqERykzeFaO92T6l28rUhXeu1p90F/lUivAaC8O34=;
        b=LDTzhqeHRtcxVqkhAurctFhnyBg8TlrN71vP9LUXyxFrTQ8RYJvaE0raeYU3iaLP0D
         S9DLrVGTW1op3EDa82txQa6oyK/QxKyebWWmNyhDLkWtz1+6UfTPKI0f+CDOGtJ9z/72
         Z4kX++WGyzX3uV1iWFDFHYPLst6AIBG0BI7H52hlSmizze1NtBxJet1MZGLh3ItnaNK/
         LPwQMTxCiMhl9TDoT01lsS161GM9omp6tfilZp4hiKnvHGXIpkfBYNGiChruFEUMEZQF
         VM/RI6wiW/lQSlGW5RwrU7M72tdYjdOBJUr8OEuPOaccdIa9nm33bUUzUQziXHLgzOzU
         Tihw==
In-Reply-To: <50AC282A.4070309@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

Move the check for !mm out of line as suggested by Andrew.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/memcontrol.h |    2 +-
 mm/memcontrol.c            |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -185,7 +185,7 @@ void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
 					     enum vm_event_item idx)
 {
-	if (mem_cgroup_disabled() || !mm)
+	if (mem_cgroup_disabled())
 		return;
 	__mem_cgroup_count_vm_event(mm, idx);
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1021,6 +1021,9 @@ void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 {
 	struct mem_cgroup *memcg;
 
+	if (!mm)
+		return;
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	if (unlikely(!memcg))

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
