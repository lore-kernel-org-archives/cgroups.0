From: Tejun Heo <tj@kernel.org>
Subject: [HEADSUP] conflicts between cgroup/for-3.12 and memcg
Date: Thu, 8 Aug 2013 20:34:02 -0400
Message-ID: <20130809003402.GC13427@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=xb0K65Pna8nEqU6z2JUOraHEoihDWmL7ilMCsT3YLCQ=;
        b=lSrgcTJjxwWcIU63Rmo0f6Hs/8g2u7rJ2EtaklVKr/wVigCim+9h4zi0OxOW+/KGqY
         arUiptqhxlBXEt2ocuOMnJB4LhoTOhOVHXWmDEnC6JXxV13OkrLllm3FnYhWOvSER3E+
         Yl9LQdjKkfIRQgMhLKM6WGHZ9YcIJY4YX8yeP27SdYz0knSnKJ18wkbWwEbJvZejCXzp
         xu0wfw33gofsqMaQ/tTbR0alMsSEWCHsWNikS/zxvFLAHnJQ0uKMCmu6KmBDw0htwt22
         W86VwmRdNwsmHV6oRD9+qKqtEio1IYNI6OBxFvFXdnNr3mITerObgPIvMbW4JdOWo2Uo
         gMCA==
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org

Hello, Stephen, Andrew.

I just applied rather invasive API update to cgroup/for-3.12, which
led to conflicts in two files - include/net/netprio_cgroup.h and
mm/memcontrol.c.  The former is trivial context conflict and the two
changes conflicting are independent.  The latter contains several
conflicts and unfortunately isn't trivial, especially the iterator
update and the memcg patches should probably be rebased.

I can hold back pushing for-3.12 into for-next until the memcg patches
are rebased.  Would that work?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
