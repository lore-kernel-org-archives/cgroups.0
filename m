From: Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH 1/4] mm/memcg: use NUMA_NO_NODE to indicate allocation
 from unspecified node
Date: Mon, 31 Jan 2022 01:47:42 +0000
Message-ID: <20220131014742.oxcrctcg6sqwvzij@master>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GkhcVI15gZvcXdR5pviGmh2yWHBWlCX9+d8RaY4e+NM=;
        b=PfyBxdltlF5w8FdwbosIkSlZzhAS88lLwzicvgGmn7xMF0OiLXyFp7jBJ+KYSOI8tr
         NbPMvTbcV4JbZNNp20xGFl3AMeb/E+EMXetLXJwImVXPbXX1kWO6/DDtB7T2mDRL3cyp
         4WgU+haILaHGlh+fgujO8pp7nejO5xH8eEnak74PC/dNK6jU8ClUnq7oO4M3AeM0exEH
         ZOvXBdgV7hP7WUEUXXxJ0TaXCPNbO2iCYVuxqGSjBA234DinG1NHNrZ7t2sV1Pkwi58t
         DTDDI4UG3KN/ephUzZ/QvJEDWEbtuY/qVcNiXhKuWk2Tf673dInDX8sgdpMUTh4VNO58
         6TFg==
Content-Disposition: inline
In-Reply-To: <20220111010302.8864-1-richard.weiyang@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, vbabka@suse.cz, willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com, surenb@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

Hi, Andrew

Would you pick up this patch set, or prefer me to send a v2?

On Tue, Jan 11, 2022 at 01:02:59AM +0000, Wei Yang wrote:
>Instead of use "-1", let's use NUMA_NO_NODE for consistency.
>
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>---
> mm/memcontrol.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>index 2ed5f2a0879d..11715f7323c0 100644
>--- a/mm/memcontrol.c
>+++ b/mm/memcontrol.c
>@@ -5054,7 +5054,7 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
> 	 *       function.
> 	 */
> 	if (!node_state(node, N_NORMAL_MEMORY))
>-		tmp = -1;
>+		tmp = NUMA_NO_NODE;
> 	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
> 	if (!pn)
> 		return 1;
>-- 
>2.33.1

-- 
Wei Yang
Help you, Help me
