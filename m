From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 4/8] mm: memcg: push !mm handling out to page cache
 charge function
Date: Wed, 12 Mar 2014 14:11:52 +0100
Message-ID: <20140312131152.GC11831@dhcp22.suse.cz>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
 <1394587714-6966-5-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1394587714-6966-5-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 11-03-14 21:28:30, Johannes Weiner wrote:
[...]
> @@ -4070,6 +4061,12 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
>  		return 0;
>  
>  	if (!PageSwapCache(page)) {
> +		/*
> +		 * Page cache insertions can happen without an actual
> +		 * task context, e.g. during disk probing on boot.

We read a page cache during disk probing? I have tried to find such a
code path but failed. Could you point me to such a path, please?
I thought that such probing is done from udev context but I am not
familiar with this area TBH.

Thanks!

> +		 */
> +		if (!mm)
> +			memcg = root_mem_cgroup;
>  		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
>  		if (ret != -ENOMEM)
>  			__mem_cgroup_commit_charge(memcg, page, 1, type, false);
> -- 
> 1.9.0
> 

-- 
Michal Hocko
SUSE Labs
