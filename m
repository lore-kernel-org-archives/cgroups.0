From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Thu, 30 Apr 2020 10:17:16 -0700
Message-ID: <20200430171716.GB339283@carbon.dhcp.thefacebook.com>
References: <cover.1588092152.git.chris@chrisdown.name>
 <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
 <20200429101510.GA28637@dhcp22.suse.cz>
 <20200429140330.GA5054@cmpxchg.org>
 <20200429150414.GI28637@dhcp22.suse.cz>
 <20200429165627.GA24768@cmpxchg.org>
 <20200430145721.GF12655@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=a7sxeF2d5y5y2WLPeH6+YxlwtfDmnaRPsZHXN9Zo3ns=;
 b=UwYx/u+0fh241hUNcZgGKqHL5V4ELty2RWpCdqgMT0ZBbPxqdU0Fhqfi75w7nViPe61G
 /nslJTapzyDzqKfO/nu764IjVrHPiMp/1mdYpj8Q9fEtvtKTcah9+yEP1LcTi4GYvg/d
 A6pRWbpmk0PJe6L3ND12b3RmWUold9m26TU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7sxeF2d5y5y2WLPeH6+YxlwtfDmnaRPsZHXN9Zo3ns=;
 b=IiYRJSAG8ViIvXxNl8nEmF22Bx8P+m9axmITxNB/qM9OFs7hvByoOT9FvSDdCWa/m7mU2YiC7sGwOFAXwneX1d+M2K+Z1vVdL+p+HEjTvuA6qLq4WzWaVuQW9TlG3Lx61ZcuaZBuDUwENC2n9j9aQWaM3wVVMa1zVd3uyJ/26m8=
Content-Disposition: inline
In-Reply-To: <20200430145721.GF12655@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Yafang Shao <laoar.shao@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Apr 30, 2020 at 04:57:21PM +0200, Michal Hocko wrote:
> On Wed 29-04-20 12:56:27, Johannes Weiner wrote:
> [...]
> > I think to address this, we need a more comprehensive solution and
> > introduce some form of serialization. I'm not sure yet how that would
> > look like yet.
> 
> Yeah, that is what I've tried to express earlier and that is why I would
> rather go with an uglier workaround for now and think about a more
> robust effective values calculation on top.
>  
> > I'm still not sure it's worth having a somewhat ugly workaround in
> > mem_cgroup_protection() to protect against half of the bug. If you
> > think so, the full problem should at least be documented and marked
> > XXX or something.
> 
> Yes, this makes sense to me. What about the following?
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 1b4150ff64be..50ffbc17cdd8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -350,6 +350,42 @@ static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
>  	if (mem_cgroup_disabled())
>  		return 0;
>  
> +	/*
> +	 * There is no reclaim protection applied to a targeted reclaim.
> +	 * We are special casing this specific case here because
> +	 * mem_cgroup_protected calculation is not robust enough to keep
> +	 * the protection invariant for calculated effective values for
> +	 * parallel reclaimers with different reclaim target. This is
> +	 * especially a problem for tail memcgs (as they have pages on LRU)
> +	 * which would want to have effective values 0 for targeted reclaim
> +	 * but a different value for external reclaim.
> +	 *
> +	 * Example
> +	 * Let's have global and A's reclaim in parallel:
> +	 *  |
> +	 *  A (low=2G, usage = 3G, max = 3G, children_low_usage = 1.5G)
> +	 *  |\
> +	 *  | C (low = 1G, usage = 2.5G)
> +	 *  B (low = 1G, usage = 0.5G)
> +	 *
> +	 * For the global reclaim
> +	 * A.elow = A.low
> +	 * B.elow = min(B.usage, B.low) because children_low_usage <= A.elow
> +	 * C.elow = min(C.usage, C.low)
> +	 *
> +	 * With the effective values resetting we have A reclaim
> +	 * A.elow = 0
> +	 * B.elow = B.low
> +	 * C.elow = C.low
> +	 *
> +	 * If the global reclaim races with A's reclaim then
> +	 * B.elow = C.elow = 0 because children_low_usage > A.elow)
> +	 * is possible and reclaiming B would be violating the protection.
> +	 *
> +	 */
> +	if (memcg == root)
> +		return 0;
> +
>  	if (in_low_reclaim)
>  		return READ_ONCE(memcg->memory.emin);
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 05b4ec2c6499..df88a22f09bc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6385,6 +6385,14 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>  
>  	if (!root)
>  		root = root_mem_cgroup;
> +
> +	/*
> +	 * Effective values of the reclaim targets are ignored so they
> +	 * can be stale. Have a look at mem_cgroup_protection for more
> +	 * details.
> +	 * TODO: calculation should be more robust so that we do not need
> +	 * that special casing.
> +	 */
>  	if (memcg == root)
>  		return MEMCG_PROT_NONE;

Acked-by: Roman Gushchin <guro@fb.com>

Thanks!
