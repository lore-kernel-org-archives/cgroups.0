From: David Rientjes <rientjes@google.com>
Subject: [patch 1/8] fork: collapse copy_flags into copy_process
Date: Tue, 3 Dec 2013 21:19:52 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz> <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=VzloP3D/M3nODCERnlNHtcMKTjO4mJrEX9ZWoI/ZVgM=;
        b=TSd4m4dvhGGIc5Z1ta5iUQlQuWmm0pU72k/p31/6QFl4NHV7psyYbuKHVD+UeXCuJf
         EQAZEau6nhrbYMgtI6YMuScJ7+tzbQ9WMFBL4tKPy2NRQcgcS8XJf9nOMrPcGJSVTrWo
         4HHmF6Xhjrd7wd0u1/yNzugFGhhz4GL8mJen/FaaO6rX+fN9ioJeikD6rImXp8TyR27x
         GiAcXDvNfMp7rXk9HbJEi7w2O5HT2uVK3GJ9GtVnpEvpLkIpTSMnedqXUYrwdT+i02E4
         FmEFkVi4T588OJ5x70xzODM96YuEaBwAFlNhQ6oIqQFPTS/f9SvvJE0/W/5KCA/wbT1O
         IXEQ==
In-Reply-To: <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

copy_flags() does not use the clone_flags formal and can be collapsed
into copy_process() for cleaner code.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/fork.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1066,15 +1066,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	return 0;
 }
 
-static void copy_flags(unsigned long clone_flags, struct task_struct *p)
-{
-	unsigned long new_flags = p->flags;
-
-	new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
-	new_flags |= PF_FORKNOEXEC;
-	p->flags = new_flags;
-}
-
 SYSCALL_DEFINE1(set_tid_address, int __user *, tidptr)
 {
 	current->clear_child_tid = tidptr;
@@ -1223,7 +1214,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	p->did_exec = 0;
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
-	copy_flags(clone_flags, p);
+	p->flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
+	p->flags |= PF_FORKNOEXEC;
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
 	rcu_copy_process(p);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
