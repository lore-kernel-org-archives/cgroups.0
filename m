From: David Rientjes <rientjes@google.com>
Subject: Re: [patch v2] mm, memcg: do not retry precharge charges
Date: Fri, 13 Jan 2017 02:09:53 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1701130208510.69402@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1701112031250.94269@chino.kir.corp.google.com> <alpine.DEB.2.10.1701121446130.12738@chino.kir.corp.google.com> <20170113084014.GB25212@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=4fxP14oAC2QqjTbPz63gS3/Gm7CshUhk/e0qb852LEQ=;
        b=bOYfI35v9BAs3E6kI47BIn6kjezpOgl9Tkmuoe30TIaP5No/kj1a+ku4O46M/WTaTI
         fszgfQ7z4HNoKFb3Q8qNbRtrRRFJWU7+5h55jmYbkvcyjdySseYwnsflszAUcqdJMvDh
         Xyt3a8hKlvYRLiN8FAvFaixTh9+Pgh4lDd7BOdzcZSxViOsKEBSoIHgrk2t8rtJo8oey
         Cz1+d2/48tM/tXmFk1vBNrTLGchcfHixnpkX/QNrjvr443pEFFYazBvB1O1uOp6i3NPK
         +zUjsKZkKRrFSdx/VLBgvLVsC9C4hBRSUCmK6AniQsxJKYwdp0vf3etbZrpkYNRTVBN/
         QIXg==
In-Reply-To: <20170113084014.GB25212@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

When memory.move_charge_at_immigrate is enabled and precharges are
depleted during move, mem_cgroup_move_charge_pte_range() will attempt to
increase the size of the precharge.

Prevent precharges from ever looping by setting __GFP_NORETRY.  This was
probably the intention of the GFP_KERNEL & ~__GFP_NORETRY, which is
pointless as written.

Fixes: 0029e19ebf84 ("mm: memcontrol: remove explicit OOM parameter in charge path")
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4353,9 +4353,9 @@ static int mem_cgroup_do_precharge(unsigned long count)
 		return ret;
 	}
 
-	/* Try charges one by one with reclaim */
+	/* Try charges one by one with reclaim, but do not retry */
 	while (count--) {
-		ret = try_charge(mc.to, GFP_KERNEL & ~__GFP_NORETRY, 1);
+		ret = try_charge(mc.to, GFP_KERNEL | __GFP_NORETRY, 1);
 		if (ret)
 			return ret;
 		mc.precharge++;

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
