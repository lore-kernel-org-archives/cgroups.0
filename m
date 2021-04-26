From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 1/2] ipc sem: use kvmalloc for sem_undo allocation
Date: Mon, 26 Apr 2021 13:18:09 +0300
Message-ID: <722774d8-d46b-f8a6-a88e-3c56b4968622@virtuozzo.com>
References: <e67f2a95-4b01-9db2-fe47-0b2210f0b138@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=T0+LqvdgHd7x+YycdlcPm1T661YqsM0zUWN47J/hkmc=; b=V2sCQr//YE4MCNzJ8Vj
        hfSArDKNlnFmUYt6BHEsr5RZ0cd7uFq/AqdcdFNvGrSPpNxWRaeJWrWU6USF9Kw/0e4SPnqUez9K6
        JxJlQfCVAsU/UM9LMT4wQ262qNalMDfhbMyNsCUuHHQbkh+e1AHCrgFbbi1DHrnhSaRC/O9UIXI=
In-Reply-To: <e67f2a95-4b01-9db2-fe47-0b2210f0b138-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

size of sem_undo can exceed one page and with the maximum possible
nsems = 32000 it can grow up to 64Kb. Let's switch its allocation
to kvmalloc to avoid user-triggered disruptive actions like OOM killer
in case of high-order memory shortage.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 ipc/sem.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 52a6599..93088d6 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1152,7 +1152,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 		un->semid = -1;
 		list_del_rcu(&un->list_proc);
 		spin_unlock(&un->ulp->lock);
-		kfree_rcu(un, rcu);
+		kvfree_rcu(un, rcu);
 	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
@@ -1935,7 +1935,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	rcu_read_unlock();
 
 	/* step 2: allocate new undo structure */
-	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems,
+	new = kvzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems,
 		      GFP_KERNEL_ACCOUNT);
 	if (!new) {
 		ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
@@ -1948,7 +1948,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	if (!ipc_valid_object(&sma->sem_perm)) {
 		sem_unlock(sma, -1);
 		rcu_read_unlock();
-		kfree(new);
+		kvfree(new);
 		un = ERR_PTR(-EIDRM);
 		goto out;
 	}
@@ -1959,7 +1959,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	 */
 	un = lookup_undo(ulp, semid);
 	if (un) {
-		kfree(new);
+		kvfree(new);
 		goto success;
 	}
 	/* step 5: initialize & link new undo structure */
@@ -2420,7 +2420,7 @@ void exit_sem(struct task_struct *tsk)
 		rcu_read_unlock();
 		wake_up_q(&wake_q);
 
-		kfree_rcu(un, rcu);
+		kvfree_rcu(un, rcu);
 	}
 	kfree(ulp);
 }
-- 
1.8.3.1

