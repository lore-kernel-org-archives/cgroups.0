From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [Resend PATCH 1/6] mm/memcg: warning on !memcg after readahead
 page charged
Date: Tue, 25 Aug 2020 07:14:39 +0800
Message-ID: <3003ffb6-f527-ae33-60f2-50cd25316fdd@linux.alibaba.com>
References: <1597144232-11370-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200820145850.GA4622@lca.pw> <20200824145201.GB4337@lca.pw>
 <20200824151045.GC3415@dhcp22.suse.cz>
 <20200825090054.3c5dd68a@canb.auug.org.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200825090054.3c5dd68a-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



在 2020/8/25 上午7:00, Stephen Rothwell 写道:
>>>> This will trigger,  
>>> Andrew, Stephen, can you drop this series for now? I did manage to trigger this
>>> warning on all arches, powerpc, x86 and arm64 (below).  
>> Yes, I do agree. See http://lkml.kernel.org/r/20200824151013.GB3415-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org
> OK, I have removed the following from linux-next for today:
> 
>   c443db77c9f3 ("mm/thp: narrow lru locking")
>   18bafefba73d ("mm/thp: remove code path which never got into")
>   5fb6c0683017 ("mm/thp: clean up lru_add_page_tail")
>   9d1d568727a8 ("mm/thp: move lru_add_page_tail func to huge_memory.c")
>   47eb331560ff ("mm/memcg: bail out early from swap accounting when memcg is disabled")
>   4b0d99a64d78 ("mm/memcg: warning on !memcg after readahead page charged")

The first patch 4b0d99a64d78 ("mm/memcg: warning on !memcg after readahead page charged")
reveals the hugetlb out of lru on some unexpected path. At least comments are helpful.

All other are good and functional.

Thanks
Alex
