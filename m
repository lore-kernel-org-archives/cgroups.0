From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 2/2] ipc: use kmalloc for msg_queue and shmid_kernel
Date: Mon, 26 Apr 2021 13:18:14 +0300
Message-ID: <b0845b85-f4fe-601d-3328-d707d7db27f5@virtuozzo.com>
References: <e67f2a95-4b01-9db2-fe47-0b2210f0b138@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=nREANoRbtawbykcWnTWer/HrY0mwvKlgG2/7PjUlgwk=; b=Oum5pEMzGrsiSDza6ZQ
        7JTwCmjOgZp0rQeK/7W1bmcTNGFpsAJDQhYa5JAc8V/mdviSrK8xYbysFhTmSLoovi95xIs8Kc7Dd
        pn4wisWsBXl5yqsQOiRa29OfzszY2MgJy+MuDXwLq0+4pvR+yMXIPY7LGbEv9dLvaXODoglD3eE=
In-Reply-To: <e67f2a95-4b01-9db2-fe47-0b2210f0b138-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

msg_queue and shmid_kernel are quite small objects, no need to use
kvmalloc for them.
Previously these objects was allocated via ipc_alloc/ipc_rcu_alloc(),
common function for several ipc objects. It had kvmalloc call inside().
Later, this function went away and was finally replaced by direct
kvmalloc call, and now we can use more suitable kmalloc/kfree for them.

Reported-by: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 ipc/msg.c | 6 +++---
 ipc/shm.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 87898cb..79c6625 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -130,7 +130,7 @@ static void msg_rcu_free(struct rcu_head *head)
 	struct msg_queue *msq = container_of(p, struct msg_queue, q_perm);
 
 	security_msg_queue_free(&msq->q_perm);
-	kvfree(msq);
+	kfree(msq);
 }
 
 /**
@@ -147,7 +147,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 	key_t key = params->key;
 	int msgflg = params->flg;
 
-	msq = kvmalloc(sizeof(*msq), GFP_KERNEL_ACCOUNT);
+	msq = kmalloc(sizeof(*msq), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!msq))
 		return -ENOMEM;
 
@@ -157,7 +157,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 	msq->q_perm.security = NULL;
 	retval = security_msg_queue_alloc(&msq->q_perm);
 	if (retval) {
-		kvfree(msq);
+		kfree(msq);
 		return retval;
 	}
 
diff --git a/ipc/shm.c b/ipc/shm.c
index 7632d72..85da060 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -222,7 +222,7 @@ static void shm_rcu_free(struct rcu_head *head)
 	struct shmid_kernel *shp = container_of(ptr, struct shmid_kernel,
 							shm_perm);
 	security_shm_free(&shp->shm_perm);
-	kvfree(shp);
+	kfree(shp);
 }
 
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
@@ -619,7 +619,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
 
-	shp = kvmalloc(sizeof(*shp), GFP_KERNEL_ACCOUNT);
+	shp = kmalloc(sizeof(*shp), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!shp))
 		return -ENOMEM;
 
@@ -630,7 +630,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	shp->shm_perm.security = NULL;
 	error = security_shm_alloc(&shp->shm_perm);
 	if (error) {
-		kvfree(shp);
+		kfree(shp);
 		return error;
 	}
 
-- 
1.8.3.1

