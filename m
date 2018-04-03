From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: general protection fault in __mem_cgroup_free
Date: Tue, 3 Apr 2018 14:18:00 +0300
Message-ID: <a91a520d-f56d-56bf-d784-89fb4562ef3c@virtuozzo.com>
References: <001a113fe4c0a623b10568bb75ea@google.com>
 <20180403093733.GI5501@dhcp22.suse.cz> <20180403094329.GJ5501@dhcp22.suse.cz>
 <20180403105048.GK5501@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NiNrjjCg8x47UCMb7eRLULtt2ACktKXlJTBJLnHZgRc=;
 b=bO8lv8Mz3doaMA8aZBaswnnK9z0wE8QfPmAUnuBVtVKD+v4n7hVJx/sMzMoD6APBAZ/faL/KE2B/TASvGitKFUrWaiB4CZq26fFhGVP+nVLRQwuWq2H75xI2ptE/44eCE3camNeMRwm9XRfJ/BXGhcfbjFCzCsu1CK0mup6yE3Y=
In-Reply-To: <20180403105048.GK5501@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>, syzbot <syzbot+8a5de3cce7cdc70e9ebe@syzkaller.appspotmail.com>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com

On 04/03/2018 01:50 PM, Michal Hocko wrote:
> Here we go
> 
> From 38f0f08a3f9f19c106ae53350e43dc97e2e3a4d8 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.com>
> Date: Tue, 3 Apr 2018 12:40:41 +0200
> Subject: [PATCH] memcg: fix per_node_info cleanup
> 
> syzbot has triggered a NULL ptr dereference when allocation fault
> injection enforces a failure and alloc_mem_cgroup_per_node_info
> initializes memcg->nodeinfo only half way through. __mem_cgroup_free
> still tries to free all per-node data and dereferences pn->lruvec_stat_cpu
> unconditioanlly even if the specific per-node data hasn't been
> initialized.
> 
> The bug is quite unlikely to hit because small allocations do not fail
> and we would need quite some numa nodes to make struct mem_cgroup_per_node
> large enough to cross the costly order.
> 
> Reported-by: syzbot+8a5de3cce7cdc70e9ebe@syzkaller.appspotmail.com
> Fixes: 00f3ca2c2d66 ("mm: memcontrol: per-lruvec stats infrastructure")
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>

> ---
>  mm/memcontrol.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e3d5a0a7917f..0a9c4d5194f3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4340,6 +4340,9 @@ static void free_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
>  {
>  	struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
>  
> +	if (!pn)
> +		return;
> +
>  	free_percpu(pn->lruvec_stat_cpu);
>  	kfree(pn);
>  }
> 
