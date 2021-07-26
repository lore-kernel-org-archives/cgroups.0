From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v6 06/16] memcg: enable accounting for scm_fp_list objects
Date: Mon, 26 Jul 2021 22:00:41 +0300
Message-ID: <2c28fbdb-ba7f-9c88-00b1-2d441a473513@virtuozzo.com>
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
 <cover.1627321321.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=UZrH4BVKP7hsH0Ef9AbThzsAu5M7Nu3PE7kKwMt/YWY=; b=uC8zlExsQUKKXnZz1Nx
        Wwqa9pD35ll/mymk6l0hVKaJTMkR/GbrbRlhhW5ZxlaGt7mkIV/Cgdsmmcogi4WgejBoi1cW8X8In
        fbE4sAv5GFmKvJmxKivhXYUv+QyqcNptrYYezXVNOF7SHyqJumf6nGSyO3EVPpbIrJWO7yILJYk=;
In-Reply-To: <cover.1627321321.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

unix sockets allows to send file descriptors via SCM_RIGHTS type messages.
Each such send call forces kernel to allocate up to 2Kb memory for
struct scm_fp_list.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 net/core/scm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index ae3085d..5c356f0 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -79,7 +79,7 @@ static int scm_fp_copy(struct cmsghdr *cmsg, struct scm_fp_list **fplp)
 
 	if (!fpl)
 	{
-		fpl = kmalloc(sizeof(struct scm_fp_list), GFP_KERNEL);
+		fpl = kmalloc(sizeof(struct scm_fp_list), GFP_KERNEL_ACCOUNT);
 		if (!fpl)
 			return -ENOMEM;
 		*fplp = fpl;
@@ -355,7 +355,7 @@ struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl)
 		return NULL;
 
 	new_fpl = kmemdup(fpl, offsetof(struct scm_fp_list, fp[fpl->count]),
-			  GFP_KERNEL);
+			  GFP_KERNEL_ACCOUNT);
 	if (new_fpl) {
 		for (i = 0; i < fpl->count; i++)
 			get_file(fpl->fp[i]);
-- 
1.8.3.1

