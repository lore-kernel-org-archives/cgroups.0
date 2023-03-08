From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3, 0/4] mm, memcg: cgroup v1 and v2 tunable load/store
 tearing fixes
Date: Wed, 8 Mar 2023 18:40:09 +0100
Message-ID: <ZAjIeTBKteZaYEEb@dhcp22.suse.cz>
References: <20230308162555.14195-1-findns94@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678297210; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D9P/n6kZ5Q42EKXa8PVA9CYX9cXV/BCKYA1HMGowUvU=;
        b=TajgrPEobbOD2m/LLJL6XBEDwW6tdq+0QP5iqSO+RuA2fAwvLYQ7gx7qQdHzR8kp+Li8gW
        9TRsofHeCFFXiAmfGUiiyg/rm2bGogkP8mMs3B16HmVTvTDdZsbBy1NHcS+9xV4bZTXuNT
        3moocNhZ6CmjPjO+4b2T7MJmH2Cla04=
Content-Disposition: inline
In-Reply-To: <20230308162555.14195-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu 09-03-23 00:25:51, Yue Zhao wrote:
> This patch series helps to prevent load/store tearing in
> several cgroup knobs.
> 
> As kindly pointed out by Michal Hocko, we should add 
> [WRITE|READ]_ONCE for all occurrences of memcg->oom_kill_disable,
> memcg->swappiness and memcg->soft_limit.
> 
> v3:
> - Add [WRITE|READ]_ONCE for all occurrences of
> memcg->oom_kill_disable, memcg->swappiness and memcg->soft_limit
> v2:
> - Rephrase changelog
> - Add [WRITE|READ]_ONCE for memcg->oom_kill_disable,
>  memcg->swappiness, vm_swappiness and memcg->soft_limit
> v1:
> - Add [WRITE|READ]_ONCE for memcg->oom_group
> 
> Past patches:
> V2: https://lore.kernel.org/linux-mm/20230306154138.3775-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/
> V1: https://lore.kernel.org/linux-mm/20230220151638.1371-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/
> 
> Yue Zhao (4):
>   mm, memcg: Prevent memory.oom.group load/store tearing
>   mm, memcg: Prevent memory.swappiness load/store tearing
>   mm, memcg: Prevent memory.oom_control load/store tearing
>   mm, memcg: Prevent memory.soft_limit_in_bytes load/store tearing
> 
>  include/linux/swap.h |  8 ++++----
>  mm/memcontrol.c      | 30 +++++++++++++++---------------
>  2 files changed, 19 insertions(+), 19 deletions(-)

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Btw. you could have preserved acks for patches you haven't changed from
the previous version.

-- 
Michal Hocko
SUSE Labs
