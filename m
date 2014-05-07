From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 4/9] mm: memcontrol: catch root bypass in move precharge
Date: Wed, 7 May 2014 16:55:53 +0200
Message-ID: <20140507145553.GJ9489@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-5-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1398889543-23671-5-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 30-04-14 16:25:38, Johannes Weiner wrote:
[...]
> @@ -6546,8 +6546,9 @@ one_by_one:
>  			cond_resched();
>  		}
>  		ret = mem_cgroup_try_charge(memcg, GFP_KERNEL, 1, false);
> +		if (ret == -EINTR)
> +			__mem_cgroup_cancel_charge(root_mem_cgroup, 1);
>  		if (ret)
> -			/* mem_cgroup_clear_mc() will do uncharge later */

I would prefer to keep the comment and explain that we will loose return
code on the way and that is why cancel on root has to be done here.

>  			return ret;
>  		mc.precharge++;
>  	}
> -- 
> 1.9.2
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
