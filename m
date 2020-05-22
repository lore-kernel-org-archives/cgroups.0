From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH v3 2/2] mm, memcg: Decouple e{low,min} state mutations
 from protection checks
Date: Fri, 22 May 2020 12:45:44 +0100
Message-ID: <20200522114544.GA1112005@chrisdown.name>
References: <20200505084127.12923-1-laoar.shao@gmail.com>
 <20200505084127.12923-3-laoar.shao@gmail.com>
 <CA+G9fYseWc_7yq0M5Onju_HxbFid6DbuuaEFf-KUpqfxdF-QTg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ISPO3IWCguXmyabv5FXXISc8kopDXlzx6J+miu4ZHGA=;
        b=ibYojR7IUChRwwkGUFV8Ix7J3R87H9BNieXyiLNiM/Jz7JprAb6YKZQHsaIEWubbA+
         8KftKi894Ums2p9lR0f4LDfzaWCiUTYYYE2BV0WeoplnmONhzmzzbuk+WCmS86LPo7F0
         PnqBigiKz8mhyR1JCC5EWyOY4Av7pNmTwJS+Y=
Content-Disposition: inline
In-Reply-To: <CA+G9fYseWc_7yq0M5Onju_HxbFid6DbuuaEFf-KUpqfxdF-QTg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkft-triage-cunTk1MwBs8s++Sfvej+rw@public.gmane.org

Naresh Kamboju writes:
>This patch is causing oom-killer while running mkfs -t ext4 on i386 kernel
>running on x86_64 machine version linux-next 5.7.0-rc6-next-20200521.

I think I see what's wrong here -- if we bail out early, memory.e{min,low} 
might be uninitialised.

Does this patch fix it, by any chance?

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d3b23c57bed4..aa902b9cbb79 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5046,6 +5046,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
  			memory_cgrp_subsys.broken_hierarchy = true;
  	}
  
+	memcg->memory.emin = 0;
+	memcg->memory.elow = 0;
+
  	/* The following stuff does not apply to the root */
  	if (!parent) {
  #ifdef CONFIG_MEMCG_KMEM
-- 
2.26.2

