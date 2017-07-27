From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcg: fix css double put in mem_cgroup_iter
Date: Thu, 27 Jul 2017 08:53:15 +0200
Message-ID: <20170727065314.GC20970@dhcp22.suse.cz>
References: <20170726130742.5976-1-wenwei.tww@gmail.com>
 <20170726134451.GR2981@dhcp22.suse.cz>
 <CAEYKbkR6WRtD3G83RUqe12TQqEO618B2Ybhr4XbhsuPqCEYySQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAEYKbkR6WRtD3G83RUqe12TQqEO618B2Ybhr4XbhsuPqCEYySQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wenwei Tao <wenwei.tww-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, yuwang.yuwang-gPhfCIXyaqCqndwCJWfcng@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wenwei Tao <wenwei.tww-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>

On Thu 27-07-17 11:30:50, Wenwei Tao wrote:
> 2017-07-26 21:44 GMT+08:00 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> > On Wed 26-07-17 21:07:42, Wenwei Tao wrote:
[...]
> >> I think there is a css double put in mem_cgroup_iter. Under reclaim,
> >> we call mem_cgroup_iter the first time with prev == NULL, and we get
> >> last_visited memcg from per zone's reclaim_iter then call __mem_cgroup_iter_next
> >> try to get next alive memcg, __mem_cgroup_iter_next could return NULL
> >> if last_visited is already the last one so we put the last_visited's
> >> memcg css and continue to the next while loop, this time we might not
> >> do css_tryget(&last_visited->css) if the dead_count is changed, but
> >> we still do css_put(&last_visited->css), we put it twice, this could
> >> trigger the BUG_ON at kernel/cgroup.c:893.
> >
> > Yes, I guess your are right and I suspect that this has been silently
> > fixed by 519ebea3bf6d ("mm: memcontrol: factor out reclaim iterator
> > loading and updating"). I think a more appropriate fix is would be.
> > Are you able to reproduce and re-test it?
> > ---
> 
> Yes, I think this commit can fix this issue, and I backport this
> commit to 3.10.107 kernel and cannot reproduce this issue. I guess
> this commit might need to be backported to 3.10.y stable kernel.

Please send it to the kernel-stable mailing list. 3.10 seems to be still
maintained.

-- 
Michal Hocko
SUSE Labs
