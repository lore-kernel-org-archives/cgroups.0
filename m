From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Access rules for current->memcg
Date: Thu, 16 Jul 2015 16:59:02 +0200
Message-ID: <20150716145902.GA10758@dhcp22.suse.cz>
References: <55A7B2D0.1030506@siteground.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55A7B2D0.1030506-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 16-07-15 16:34:08, Nikolay Borisov wrote:
> Hello,
> 
> I'd like to ask what are the locking rules when using
> mem_cgroup_from_task(current)? Currently I'm doing this under
> rcu_read_lock which I believe is sufficient. However, I've seen patches
> where reference is obtained via mem_cgroup_from_task and then
> css_tryget_online is used on the resulting cgroup?

RCU will guarantee that the memcg will not go away. The rest depends on
what you want to do with it. If you want to use it outside of RCU you
have to take a reference. And then it depends what the memcg is used
for - some operations can be done also on the offline memcg.

Btw. mem_cgroup_from_task is not the proper interface for you. You
really want to do
memcg = get_mem_cgroup_from_mm(current->mm)
[...]
css_put(&memcg)

> Looking at the context of css_tryget_online it seems it will only
> succeed if the cgroup isn't being terminated (cgroup_destroy_locked
> isn't being invoked). Judging from this then if a css_tryget_online
> succeeds this means the caller can be sure they are working with a live
> cgroup, however, what happens if the process of acuiqring a reference on
> css is skipped AND the caller is under RCU read lock?

The memcg will not get freed. It still might be offline.

> They are
> guaranteed to succeed, but after the rcu read lock is released the
> cgroup might go away ?

Yes it might go away.
 
> Essentially my use case is to obtain a reference to a memcg for the
> current process and query some counter values IOW - just reading from
> the memcg. Do I need to acquire a CSS reference in this case?

I would strongly recommend using get_mem_cgroup_from_mm as shown above.
-- 
Michal Hocko
SUSE Labs
