From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm/memcontrol: fix defined but not used compiler warning
Date: Tue, 2 Dec 2014 12:48:27 +0100
Message-ID: <20141202114827.GE27014@dhcp22.suse.cz>
References: <20141202110752.GA11327@powerline.azcom-win.it>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=s0Qwg+ym6MFodGk3SCpE4Nl9Faul7tr3k4aQvln46ew=;
        b=xBM9xLsMvPsMZd9uh/qLarh5HLDiVNhTvGwPPMco7zAC4l2quJwhTekqmopqC/8VGk
         G0L4Rt0/41xCLHxiplSOyWCt/jOHEnlV0U3nlDZEk5fGT1ySASetP00iCsg/aFkmvXHr
         ZwIv1BodbiTeeOIHRtfpHFsgCW5NWWvf1M9xQJDxyb+klVG0joJzHD8kmzwSazQ14wmW
         sG2B/xwVrGaOIQSG6wpHEac3jfeBdLhTOFOC+ES514YY+jyeD+ePe1zR8tfkrTgDx1Dx
         sSJkR9T2EGv5Xk9N0X7wJJPTUlPezDeiKIiT3UwMfsw+Oa+auSRNG1uZ9Sikld/9dcWF
         F3kQ==
Content-Disposition: inline
In-Reply-To: <20141202110752.GA11327@powerline.azcom-win.it>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michele Curti <michele.curti@gmail.com>
Cc: hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue 02-12-14 12:07:52, Michele Curti wrote:
> test_mem_cgroup_node_reclaimable is used only when MAX_NUMNODES > 1,
> so move it into the compiler if statement
> 
> Signed-off-by: Michele Curti <michele.curti@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c6ac50e..84531a9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1615,6 +1615,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
>  			 NULL, "Memory cgroup out of memory");
>  }
> +#if MAX_NUMNODES > 1
>  
>  /**
>   * test_mem_cgroup_node_reclaimable
> @@ -1638,7 +1639,6 @@ static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
>  	return false;
>  
>  }
> -#if MAX_NUMNODES > 1
>  
>  /*
>   * Always updating the nodemask is not very good - even if we have an empty
> -- 
> 2.1.3
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
