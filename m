From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [Resend PATCH 1/6] mm/memcg: warning on !memcg after readahead
 page charged
Date: Tue, 25 Aug 2020 09:25:01 +0800
Message-ID: <12425e06-38ce-7ff4-28ce-b0418353fc67@linux.alibaba.com>
References: <1597144232-11370-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200820145850.GA4622@lca.pw> <20200821080127.GD32537@dhcp22.suse.cz>
 <20200821123934.GA4314@lca.pw> <20200821134842.GF32537@dhcp22.suse.cz>
 <20200824151013.GB3415@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200824151013.GB3415-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nao.horiguchi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org

reproduce using our linux-mm random bug collection on NUMA systems.
>>
>> OK, I must have missed that this was on ppc. The order makes more sense
>> now. I will have a look at this next week.
> 
> OK, so I've had a look and I know what's going on there. The
> move_pages12 is migrating hugetlb pages. Those are not charged to any
> memcg. We have completely missed this case. There are two ways going
> around that. Drop the warning and update the comment so that we do not
> forget about that or special case hugetlb pages.
> 
> I think the first option is better.
> 


Hi Michal,

Compare to ignore the warning which is designed to give, seems addressing
the hugetlb out of charge issue is a better solution, otherwise the memcg
memory usage is out of control on hugetlb, is that right?

Thanks
Alex 
