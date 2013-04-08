From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/8] cgroup: implement cgroup_is_ancestor()
Date: Mon, 8 Apr 2013 14:36:46 -0700
Message-ID: <20130408213646.GB17159@mtj.dyndns.org>
References: <51627DA9.7020507@huawei.com>
 <51627DBB.5050005@huawei.com>
 <20130408144750.GK17178@dhcp22.suse.cz>
 <20130408180335.GA22512@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=MQXdkpiI85xkCMUgbe7/qDTbt5BZ+XZBuxNpKKQluLM=;
        b=YhcKApzzE8HC1edK+WjrUdSfm+qhVmVqkDfBOeWIQ/WpjeVy4ThPm6L19JyuKRakoX
         nqGdHFVaS+QU8c48NduieuIJo9aFwl4cfgk5Kzh0L/DOP2wZQATnVJurg0DSThNSQGeZ
         O3l21d3QL1p/MhULOoxcgW5vLtgmsHzotEgfxWB7nD54jMBL1ZluPWXBZZiaR5YR+SV/
         b+ICd18QU+LZ/rJhz6Vc1fwQzWDKJ2pSsHiRn7v/RlO3gqxxqlAbPIoBzYbCRJQoXkFS
         PlLWg+uIXqFe5kBtV6vs/9NQfheYqpJCLF70kVqy32YtH4Osq1pd6a/fcVn98Z1QumYK
         1MNw==
Content-Disposition: inline
In-Reply-To: <20130408180335.GA22512@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Mon, Apr 08, 2013 at 08:03:44PM +0200, Michal Hocko wrote:
> __mem_cgroup_same_or_subtree relies on css_is_ancestor if hierarchy is
> enabled for ages. This, however, is not correct because use_hierarchy
> doesn't need to be true all the way up the cgroup hierarchy. Consider
> the following example:
> root (use_hierarchy=0)
>  \
>   A (use_hierarchy=0)
>    \
>     B (use_hierarchy=1)
>      \
>       C (use_hierarchy=1)
> 
> __mem_cgroup_same_or_subtree(A, C) would return true even though C is
> not from the same hierarchy subtree. The bug shouldn't be critical but
> at least dump_tasks might print unrelated tasks (via
> task_in_mem_cgroup).

Huh?  Isn't that avoided by the !root_memcg->use_hierarchy test?

> @@ -1470,9 +1470,12 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
>  {
>  	if (root_memcg == memcg)
>  		return true;
> -	if (!root_memcg->use_hierarchy || !memcg)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^
> +	if (!memcg)
>  		return false;
> -	return css_is_ancestor(&memcg->css, &root_memcg->css);
> +	while ((memcg = parent_mem_cgroup(memcg)))
> +		if (memcg == root_memcg)
> +			return true;
> +	return false;
>  }
>  
>  static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
> -- 
> 1.7.10.4
> 
> -- 
> Michal Hocko
> SUSE Labs

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
