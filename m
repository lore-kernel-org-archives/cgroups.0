From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: fix kmem_account_flags check in memcg_can_account_kmem()
Date: Fri, 29 Nov 2013 14:09:18 +0400
Message-ID: <529867CE.4040004@parallels.com>
References: <1385567162-14973-1-git-send-email-vdavydov@parallels.com> <20131129094502.GD25893@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131129094502.GD25893-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On 11/29/2013 01:45 PM, Michal Hocko wrote:
> On Wed 27-11-13 19:46:01, Vladimir Davydov wrote:
>> We should start kmem accounting for a memory cgroup only after both its
>> kmem limit is set (KMEM_ACCOUNTED_ACTIVE) and related call sites are
>> patched (KMEM_ACCOUNTED_ACTIVATED).
> This should be vice-versa, no? ACTIVE is set after
> static_key_slow_inc(&memcg_kmem_enabled_key) AFAICS.
>
>> Currently memcg_can_account_kmem() allows kmem accounting even if only
>> one of the conditions is true.
>> Fix it.
> It would be nice to describe, what is the actual problem here. I assume
> this is a charge vs. enable race. Let me try
>
> So we have KMEM_ACCOUNTED_ACTIVATED (set by memcg_update_cache_sizes)
> but the static key is not enabled yet (so KMEM_ACCOUNTED_ACTIVE is not
> set yet). memcg_can_account_kmem is called from 2 contexts during charge
> 	- memcg_kmem_get_cache via __memcg_kmem_get_cache
> 	- memcg_kmem_newpage_charge via __memcg_kmem_newpage_charge
>
> both of them start by checking memcg_kmem_enabled which is our
> static key before memcg_can_account_kmem. This would suggest that
> static_key+ACTIVE check memcg_can_account_kmem is sufficient. No?

Yes, I guess you're perfectly right and we don't need the ACTIVATED bit 
at all. I'll look at this deeper and send a patch removing it if it 
doesn't break something.

Thanks.
