From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Set the correct memcg swappiness
 restriction
Date: Tue, 3 Aug 2021 23:45:20 +0800
Message-ID: <02826fde-43a8-e20d-37f5-55416ba0c773@linux.alibaba.com>
References: <d77469b90c45c49953ccbc51e54a1d465bc18f70.1627626255.git.baolin.wang@linux.alibaba.com>
 <YQOekWWgtZUfim4M@dhcp22.suse.cz>
 <6e6570d2-44a2-1da1-6c2a-38766786c40c@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6e6570d2-44a2-1da1-6c2a-38766786c40c-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2021/8/3 23:20, Vlastimil Babka wrote:
> On 7/30/21 8:39 AM, Michal Hocko wrote:
>> On Fri 30-07-21 14:26:35, Baolin Wang wrote:
>>> Since commit c843966c556d ("mm: allow swappiness that prefers reclaiming
>>> anon over the file workingset") has expended the swappiness value to
>>> make swap to be preferred in some systems. We should also change the
>>> memcg swappiness restriction to allow memcg swap-preferred.
>>>
>>> Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
>>
>> Yes, this looks like an omission. It doesn't really make sense to have
>> two different constrains on the value.
>>
>> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> 
> So, also Fixes: c843966c556d ("mm: allow swappiness that prefers reclaiming anon
> over the file workingset")
> ?

Sure. Andrew, do I need resend it with adding fixes tag, or you can help 
to add it? Thanks.
