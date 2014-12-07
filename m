From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: memcontrol: Skip test_mem_cgroup_node_reclaimable()
 when no MAX_NUMNODES or not more than 1
Date: Sun, 7 Dec 2014 11:33:10 +0100
Message-ID: <20141207103310.GJ15892@dhcp22.suse.cz>
References: <5482316D.607@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=AV687cHudfdZjlXK9h1hml1YBnoI/D1WIZyWGZRKowg=;
        b=IL/r7Xnn/RNva16fsE+sdzsH5Su+TX4qLVB1Q+NvKmlAWq6SDNI2X8iMyMsoEi+vdn
         YwkKfQ7wsomadXwggxBshDbLfHFWm6EM/+67FBAZ05346WhOgjxTZVceWZ5VHPm5HDws
         URzDGgtVqmbyMfZ620G+7wLEhJk39HEgdd//RDhljwXeA6C5ykMnG7aBuUzPTnBZ5jwm
         7PKW8epBsCO9p7Z7xA2RyxCTafNnkOAA4lyrFgcPtzKZjd3CtHHrq2FLGAlKjhiJfu3P
         nALU65EjBFMcbFceZo8ntoQM0EykA5ozFd9MPo5vWL77NWxN75/N+sC5a9yijh2PS7/O
         N7iA==
Content-Disposition: inline
In-Reply-To: <5482316D.607@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: hannes@cmpxchg.org, cgroups@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org

Hi,
this has been fixed last week already
http://marc.info/?l=linux-mm&m=141751847710864&w=2

On Sat 06-12-14 06:27:57, Chen Gang wrote:
> test_mem_cgroup_node_reclaimable() is only used when "MAX_NUMNODES > 1",
> so move it into related quote.
> 
> The related warning (with allmodconfig under parisc):
> 
>     CC      mm/memcontrol.o
>   mm/memcontrol.c:1629:13: warning: 'test_mem_cgroup_node_reclaimable' defined but not used [-Wunused-function]
>    static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
>                ^
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c6ac50e..d538b08 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1616,6 +1616,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  			 NULL, "Memory cgroup out of memory");
>  }
>  
> +#if MAX_NUMNODES > 1
>  /**
>   * test_mem_cgroup_node_reclaimable
>   * @memcg: the target memcg
> @@ -1638,7 +1639,6 @@ static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
>  	return false;
>  
>  }
> -#if MAX_NUMNODES > 1
>  
>  /*
>   * Always updating the nodemask is not very good - even if we have an empty
> -- 
> 1.9.3

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
