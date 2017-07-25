From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH] mm, memcg: reset low limit during memcg offlining
Date: Tue, 25 Jul 2017 15:05:37 +0300
Message-ID: <20170725120537.o4kgzjhcjcjmopzc@esperanza>
References: <20170725114047.4073-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TT/N27Fo53oEDUocUTBO2TKm8H6OdAv3Z5DJmlAAgCA=;
        b=ftO7rOcvpvYrlykUAHd/EEmbJKdSMDTJ8kVd7FeL+yDGAQGe3DaZd9trAKPD/hlyoc
         XBS3WLX7L/9LH71PH9RTZhSGNyD5aVSY06gAEDMLhWZ4S+ZmQR4F9aW3ul/0bD6oYsVb
         Aaxe46HRUXeKm2Io1a2cOWf9StR3nCo6ei0sjKUr6WAtsY70BiyIh5Tn+G7CitMypOx8
         /AjK83VuJ3194PXsITm/e70zbrBnAHp7okFzXowZ8BAaE4ok8Vtti5PM/zJPzh1x1tFY
         sQm5Ch1z4VYCtQALO/0OETvuiIVGw8kk2YSBU+a5J+bb5rC38ul8Q453U6LTulRbFT3m
         w6fg==
Content-Disposition: inline
In-Reply-To: <20170725114047.4073-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 25, 2017 at 12:40:47PM +0100, Roman Gushchin wrote:
> A removed memory cgroup with a defined low limit and some belonging
> pagecache has very low chances to be freed.
> 
> If a cgroup has been removed, there is likely no memory pressure inside
> the cgroup, and the pagecache is protected from the external pressure
> by the defined low limit. The cgroup will be freed only after
> the reclaim of all belonging pages. And it will not happen until
> there are any reclaimable memory in the system. That means,
> there is a good chance, that a cold pagecache will reside
> in the memory for an undefined amount of time, wasting
> system resources.
> 
> Fix this issue by zeroing memcg->low during memcg offlining.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: kernel-team@fb.com
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index aed11b2d0251..2aa204b8f9fd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4300,6 +4300,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  	}
>  	spin_unlock(&memcg->event_list_lock);
>  
> +	memcg->low = 0;
> +
>  	memcg_offline_kmem(memcg);
>  	wb_memcg_offline(memcg);
>  

We already have that - see mem_cgroup_css_reset().
