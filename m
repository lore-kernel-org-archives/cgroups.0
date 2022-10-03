From: Alexander Fedorov <halcien-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Possible race in obj_stock_flush_required() vs drain_obj_stock()
Date: Mon, 3 Oct 2022 15:47:10 +0300
Message-ID: <d3cf9c69-19a1-53f9-cf97-5d40ce5cda44@gmail.com>
References: <1664546131660.1777662787.1655319815@gmail.com>
 <Yzc0yZwDB8GG+4t7@P9FQF9L96D.corp.robot.car>
 <b91e75f4-b09c-85aa-c6ad-2364dab9af92@gmail.com>
 <Yzm5cukBe6IfyAs7@P9FQF9L96D.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=bbW48lF7w7dqMd3ew4lAUYrRQXOK7chMR3ZlI/inaU4=;
        b=NGoUgbYfYtHEEYsy9dCs1A9gSkbNIQg2VSZnphma6IT1DMIuVPaEqNzqy37pZE9kvf
         B3h0E1O4KOfYhRvqwo0TMWPWdCo3ZYSNABgDYaOfhNSmhPfbKa0t9aVmQQFMO7/mnT7K
         fpUG2XHFQYIyeE8Nob6/UpNH7j/i/9XBYqsfsk0Elum5w90fFoCQLjcTMgtZybM/ByWo
         R2wGU5eW037JUB4mfk6j7/LezcpdYINK3+5dCPf4Edi7t8YLg+s1qpK39i94feFj65br
         R6HnacVAvceG4G3eBlnK2VAE7KVwAAWc8F6mXIcy9BojiZDLzbccZqISrA74KAG6rS7u
         f83A==
In-Reply-To: <Yzm5cukBe6IfyAs7-+xijCwNIfdq8QK5Xt2JBmg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 02.10.2022 19:16, Roman Gushchin wrote:
> On Sat, Oct 01, 2022 at 03:38:43PM +0300, Alexander Fedorov wrote:
>> Tested READ_ONCE() patch and it works.
> 
> Thank you!
> 
>> But are rcu primitives an overkill?
>> For me they are documenting how actually complex is synchronization here.
> 
> I agree, however rcu primitives will add unnecessary barriers on hot paths.
> In this particular case most accesses to stock->cached_objcg are done from
> a local cpu, so no rcu primitives are needed. So in my opinion using a
> READ_ONCE() is preferred.

Understood, then here is patch that besides READ_ONCE() also fixes mentioned
use-after-free that exists in 5.10.  In mainline the drain_obj_stock() part
of the patch should be skipped.

Should probably be also Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
but I am not sure if I have rights to add that :)


    mm/memcg: fix race in obj_stock_flush_required() vs drain_obj_stock()
    
    When obj_stock_flush_required() is called from drain_all_stock() it
    reads the `memcg_stock->cached_objcg` field twice for another CPU's
    per-cpu variable, leading to TOCTTOU race: another CPU can
    simultaneously enter drain_obj_stock() and clear its own instance of
    `memcg_stock->cached_objcg`.
    
    Another problem is in drain_obj_stock() which sets `cached_objcg` to
    NULL after freeing which might lead to use-after-free.
    
    To fix it use READ_ONCE() for TOCTTOU problem and also clear the
    `cached_objcg` pointer earlier in drain_obj_stock() for use-after-free
    problem.

Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Alexander Fedorov <halcien-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c1152f8747..56bd5ea6d3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3197,17 +3197,30 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
 		stock->nr_bytes = 0;
 	}
 
-	obj_cgroup_put(old);
+	/*
+	 * Clear pointer before freeing memory so that
+	 * drain_all_stock() -> obj_stock_flush_required()
+	 * does not see a freed pointer.
+	 */
 	stock->cached_objcg = NULL;
+	obj_cgroup_put(old);
 }
 
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg)
 {
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 
-	if (stock->cached_objcg) {
-		memcg = obj_cgroup_memcg(stock->cached_objcg);
+	/*
+	 * stock->cached_objcg can be changed asynchronously, so read
+	 * it using READ_ONCE(). The objcg can't go away though because
+	 * obj_stock_flush_required() is called from within a rcu read
+	 * section.
+	 */
+	objcg = READ_ONCE(stock->cached_objcg);
+	if (objcg) {
+		memcg = obj_cgroup_memcg(objcg);
 		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
 			return true;
 	}
