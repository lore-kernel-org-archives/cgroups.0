From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 6/9] mm: Mark function as static in memcontrol.c
Date: Fri, 7 Feb 2014 17:40:06 +0530
Message-ID: <0dbbc0fe4360069993ef8a9ca179f30482610270.1391167128.git.rashika.kheria@gmail.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=fH3OUlG6UdJnTNhJliWSUwTy6SeOWmup+1DghFpSS+Q=;
        b=TZOUTklkfT387Ug6WREY44KLngCB1zQPLwEA31k++DoKijg6utoPIgzoJF9KRLQJQk
         v85wF18MV0v0DMPxMKTdIgappiPm5HqO41jUVVNwq7gajoWu3+foYVGJ8AIWbc8frvFA
         xV48C60RetUYU53pc+mRCudJEzsLe3UxxHGcFJ+ttqyscx3GLxKpgdKq98rpvoSC1Q8W
         apbNFTom0fkw0vcuJJ+ypShWKQyHfPdXwc1y0iZ/zDrBcNPxljEZx7KJkHnZAbY3e3TW
         4MEkAe6S3uF6dGRE6yedduC/E5Oou/sv1ziz/BUxzK39SzHihrmzAQWv1iavaEqS9AEt
         AJDw==
Content-Disposition: inline
In-Reply-To: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, josh@joshtriplett.org

Mark function as static in memcontrol.c because it is not used outside
this file.

This also eliminates the following warning in memcontrol.c:
mm/memcontrol.c:3089:5: warning: no previous prototype for =E2=80=98memcg=
_update_cache_sizes=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bf5e894..fbec2a5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3086,7 +3086,7 @@ int memcg_cache_id(struct mem_cgroup *memcg)
  * But when we create a new cache, we can call this as well if its paren=
t
  * is kmem-limited. That will have to hold set_limit_mutex as well.
  */
-int memcg_update_cache_sizes(struct mem_cgroup *memcg)
+static int memcg_update_cache_sizes(struct mem_cgroup *memcg)
 {
 	int num, ret;
=20
--=20
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
