From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH] mm/memcg: Add a comment regarding the release `obj'.
Date: Fri, 25 Feb 2022 16:15:07 +0100
Message-ID: <Yhjye3LaBB8q55bg@linutronix.de>
References: <20220221182540.380526-1-bigeasy@linutronix.de>
 <20220221182540.380526-6-bigeasy@linutronix.de>
 <YhSyXbxaMcgBJJtT@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645802108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XQcCIB/BgIE3sYYr7FuCBw/IBoiYy9McFWIhbMjd23A=;
        b=TPyOgGka+Lps9k5E+/jHWNhaZZwxy03gDgZXCKFuV7nhaovdqsmi07aQaWn0w96W6tRYfF
        1ode+DMVEUaS37UAHb+4ZjmZjpTF6F/64wjprv2lczIHOEPo4pEBEKNzNUvzgU0RftB1cJ
        wMyJFfLdi4LiL+/pZNd5aGR6KeFl1eIv/aSLuXP07J2VE6/Vbp5TaJZqkWj/cC+1wgvHys
        sT3Ud7dyKaTdUEpDdCPWtL5RwudTCXuX4wvgs+TgdN/xf1+2DBUK9D0nmB2FgsbmA7z8jc
        +k12ARhogh/cJHr/eSPPYzcBdUlqOKQ3dKP85asV0d7PHzknSkUtmTxFWTtoIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645802108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XQcCIB/BgIE3sYYr7FuCBw/IBoiYy9McFWIhbMjd23A=;
        b=bcZAp0a9QQrLodeqKB/SipBFgBZK9tos1qlPjD8FH6TcYEFaip5a0lOPCQqezBwlZ39WdE
        4y/SYKbqCjt0J3CQ==
Content-Disposition: inline
In-Reply-To: <YhSyXbxaMcgBJJtT-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Please fold into
    mm/memcg: Protect memcg_stock with a local_lock_t

Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 mm/memcontrol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7883e2f2af3e8..19d4f9297b0c6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3245,6 +3245,10 @@ static struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock)
 	}
 
 	stock->cached_objcg = NULL;
+	/*
+	 * The `old' objects needs to be released by the caller via
+	 * obj_cgroup_put() outside of memcg_stock_pcp::stock_lock.
+	 */
 	return old;
 }
 
-- 
2.35.1

