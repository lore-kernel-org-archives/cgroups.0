From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Resend PATCH 2/6] mm/memcg: remove useless check on
 page->mem_cgroup
Date: Thu, 13 Aug 2020 13:01:02 +0200
Message-ID: <20200813110102.GF9477@dhcp22.suse.cz>
References: <1597144232-11370-1-git-send-email-alex.shi@linux.alibaba.com>
 <1597144232-11370-2-git-send-email-alex.shi@linux.alibaba.com>
 <20200811113008.GK4793@dhcp22.suse.cz>
 <776b0e6f-4129-9fb9-0f66-47757cf320d5@linux.alibaba.com>
 <20200811135626.GL4793@dhcp22.suse.cz>
 <0b5e1ac3-c9c7-35e9-2661-b58430314d0a@linux.alibaba.com>
 <20200813062049.GA9477@dhcp22.suse.cz>
 <abd9276b-31f8-a51d-43d6-6c8ae93237dc@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <abd9276b-31f8-a51d-43d6-6c8ae93237dc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 13-08-20 17:45:19, Alex Shi wrote:
> 
> 
> 在 2020/8/13 下午2:20, Michal Hocko 写道:
> > On Wed 12-08-20 11:25:53, Alex Shi wrote:
> >> >From 999b0fe5fc65865c3b59ff28500d45572a4a9570 Mon Sep 17 00:00:00 2001
> >> From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> >> Date: Wed, 5 Aug 2020 21:02:30 +0800
> >> Subject: [PATCH 2/6] mm/memcg: bail out early from swap accounting when memcg
> >>  is disabled
> >>
> >> If we disabled memcg by cgroup_disable=memory, page->memcg will be NULL
> >> and so the charge is skipped and that will trigger a warning like below.
> >> Let's return from the funcs earlier.
> >>
> >>  ---[ end trace f1f34bfc3b32ed2f ]---
> >>  anon flags:0x5005b48008000d(locked|uptodate|dirty|swapbacked)
> >>  raw: 005005b48008000d dead000000000100 dead000000000122 ffff8897c7c76ad1
> >>  raw: 0000000000000022 0000000000000000 0000000200000000 0000000000000000
> >>  page dumped because: VM_WARN_ON_ONCE_PAGE(!memcg)
> > 
> > Yes this is better. It would be even more informative if you added the
> > backtrace.
> 
> The stack is a bit long.

This doesn't matter. It is informative and potentially useful for future
reference.

Thanks!
-- 
Michal Hocko
SUSE Labs
