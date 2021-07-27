From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v7 06/10] memcg: enable accounting of ipc resources
Date: Tue, 27 Jul 2021 08:33:49 +0300
Message-ID: <d6507b06-4df6-78f8-6c54-3ae86e3b5339@virtuozzo.com>
References: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
 <cover.1627362057.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=Ccnjp3FPBm3dwMYx93pYsjJGsGokrnefzYE+aVs2CiQ=; b=WXgzNJqRyFnTttzoofe
        d4P7vC9W0gQbiS6nR4CVy3UoYa6pTl7ahSrdbumBs6s8tlydy7091IuygBP2k/qIOZBOG7fdhywyR
        VuKNYNe7mjVmGvm8wdHLafrZmOD2UTtBYLIifsJL8FHr1quyGUj5xhTW+4MsX0Svjmb3YYzJSfo=;
In-Reply-To: <cover.1627362057.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When user creates IPC objects it forces kernel to allocate memory for
these long-living objects.

It makes sense to account them to restrict the host's memory consumption
from inside the memcg-limited container.

This patch enables accounting for IPC shared memory segments, messages
semaphores and semaphore's undo lists.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 ipc/msg.c | 2 +-
 ipc/sem.c | 9 +++++----
 ipc/shm.c | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 6810276..a0d0577 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -147,7 +147,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 	key_t key = params->key;
 	int msgflg = params->flg;
 
-	msq = kmalloc(sizeof(*msq), GFP_KERNEL);
+	msq = kmalloc(sizeof(*msq), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!msq))
 		return -ENOMEM;
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 971e75d..1a8b9f0 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -514,7 +514,7 @@ static struct sem_array *sem_alloc(size_t nsems)
 	if (nsems > (INT_MAX - sizeof(*sma)) / sizeof(sma->sems[0]))
 		return NULL;
 
-	sma = kvzalloc(struct_size(sma, sems, nsems), GFP_KERNEL);
+	sma = kvzalloc(struct_size(sma, sems, nsems), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!sma))
 		return NULL;
 
@@ -1855,7 +1855,7 @@ static inline int get_undo_list(struct sem_undo_list **undo_listp)
 
 	undo_list = current->sysvsem.undo_list;
 	if (!undo_list) {
-		undo_list = kzalloc(sizeof(*undo_list), GFP_KERNEL);
+		undo_list = kzalloc(sizeof(*undo_list), GFP_KERNEL_ACCOUNT);
 		if (undo_list == NULL)
 			return -ENOMEM;
 		spin_lock_init(&undo_list->lock);
@@ -1941,7 +1941,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 
 	/* step 2: allocate new undo structure */
 	new = kvzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems,
-		       GFP_KERNEL);
+		       GFP_KERNEL_ACCOUNT);
 	if (!new) {
 		ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 		return ERR_PTR(-ENOMEM);
@@ -2005,7 +2005,8 @@ static long do_semtimedop(int semid, struct sembuf __user *tsops,
 	if (nsops > ns->sc_semopm)
 		return -E2BIG;
 	if (nsops > SEMOPM_FAST) {
-		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL);
+		sops = kvmalloc_array(nsops, sizeof(*sops),
+				      GFP_KERNEL_ACCOUNT);
 		if (sops == NULL)
 			return -ENOMEM;
 	}
diff --git a/ipc/shm.c b/ipc/shm.c
index 748933e..ab749be 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -619,7 +619,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
 
-	shp = kmalloc(sizeof(*shp), GFP_KERNEL);
+	shp = kmalloc(sizeof(*shp), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!shp))
 		return -ENOMEM;
 
-- 
1.8.3.1

