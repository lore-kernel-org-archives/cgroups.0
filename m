From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 1/2] mm/memcontrol: return 1 from cgroup.memory __setup() handler
Date: Mon, 21 Feb 2022 16:58:11 -0800
Message-ID: <20220222005811.10672-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=8esseIxDpLtfYeuDOxlgY2S2IYHgIucCVCH5cskkgTA=; b=e8GRw2szGsP7BHFrxqnu8hgp0U
        eHuIFbnwm1NqL4cQmzR+z+YyWME7r9ni5PhqX4+kq/MgbvpdBh0J9Pr3pid8yVd+scwjJ6lr2hjwL
        p+QL4WRESqpCExgkZXPYDElcbTO6C6FDDfhTJWyWdV0SWmaafdf/MkVakntciclj0fCS+XhjoL8kH
        3FezNFiDO7YqM6Z6zUcPUGaWGlJjxWM0t8QhwAyaId0XSJtsVb5t1qyapLViB/xfcZZBOvUotY9ng
        eBaEb3sWRU+5ofLBZiibMbLNXfUm4GwfDSqyT340kY/GJUXO/e4zAxJylnpXZ7hWW36NgRMTGTLGw
        BuIG9AEA==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Igor Zhbanov <i.zhbanov-4G3FwjhnV40EXkLx5dDeUA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

__setup() handlers should return 1 if the command line option is handled
and 0 if not (or maybe never return 0; it just pollutes init's environment).

The only reason that this particular __setup handler does not pollute
init's environment is that the setup string contains a '.', as in
"cgroup.memory". This causes init/main.c::unknown_boottoption() to
consider it to be an "Unused module parameter" and ignore it. (This is
for parsing of loadable module parameters any time after kernel init.)
Otherwise the string "cgroup.memory=whatever" would be added to init's
environment strings.

Instead of relying on this '.' quirk, just return 1 to indicate that
the boot option has been handled.

Note that there is no warning message if someone enters:
	cgroup.memory=anything_invalid

Fixes: f7e1cb6ec51b0 ("mm: memcontrol: account socket memory in unified hierarchy memory controller")
Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Reported-by: Igor Zhbanov <i.zhbanov-4G3FwjhnV40EXkLx5dDeUA@public.gmane.org>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3-4G3FwjhnV40EXkLx5dDeUA@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20220217.orig/mm/memcontrol.c
+++ linux-next-20220217/mm/memcontrol.c
@@ -7044,7 +7044,7 @@ static int __init cgroup_memory(char *s)
 		if (!strcmp(token, "nokmem"))
 			cgroup_memory_nokmem = true;
 	}
-	return 0;
+	return 1;
 }
 __setup("cgroup.memory=", cgroup_memory);
 
