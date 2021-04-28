From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v4 06/16] memcg: enable accounting for scm_fp_list objects
Date: Wed, 28 Apr 2021 09:52:23 +0300
Message-ID: <a979f2a8-21ba-704f-fa12-bf57e9cf3e60@virtuozzo.com>
References: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=SkoUid64jfWnCkxDzH08xkMfbWx02U1lgMhR2hvrunE=; b=GCzcIZi0eDzeq0ZbegH
        iERufDLHLjssGvo/t8qr90tulNdqAY5tC9zzRrxP3GXb7/tx1XDm1wWUttJGFLWc+R6l+W5VH4/h9
        9zQsmctC8mirothvNwKqpdOEtHLmNVElDEAi6oo7aKlttk0vWFApIhLLH499gPwpavCXSMVjwHM=
In-Reply-To: <8664122a-99d3-7199-869a-781b21b7e712-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
index 8156d4f..e837e4f 100644
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
@@ -348,7 +348,7 @@ struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl)
 		return NULL;
 
 	new_fpl = kmemdup(fpl, offsetof(struct scm_fp_list, fp[fpl->count]),
-			  GFP_KERNEL);
+			  GFP_KERNEL_ACCOUNT);
 	if (new_fpl) {
 		for (i = 0; i < fpl->count; i++)
 			get_file(fpl->fp[i]);
-- 
1.8.3.1

