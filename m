From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: PROBLEM: BUG when using memory.kmem.limit_in_bytes
Date: Fri, 22 Jan 2016 19:33:24 +0300
Message-ID: <20160122163324.GH26192@esperanza>
References: <CAKB58ikDkzc8REt31WBkD99+hxNzjK4+FBmhkgS+NVrC9vjMSg@mail.gmail.com>
 <20160122135042.GF26192@esperanza>
 <20160122144854.GA14432@cmpxchg.org>
 <20160122155104.GG32380@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160122155104.GG32380-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Brian Christiansen <brian.o.christiansen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Jan 22, 2016 at 10:51:04AM -0500, Tejun Heo wrote:
> On Fri, Jan 22, 2016 at 09:48:54AM -0500, Johannes Weiner wrote:
> > On Fri, Jan 22, 2016 at 04:50:42PM +0300, Vladimir Davydov wrote:
> > > From first glance, it looks like the bug was triggered, because
> > > mem_cgroup_css_offline was run for a child cgroup earlier than for its
> > > parent. This couldn't happen for sure before the cgroup was switched to
> > > percpu_ref, because cgroup_destroy_wq has always had max_active == 1.
> > > Now, however, it looks like this is perfectly possible for
> > > css_killed_ref_fn is called from an rcu callback - see kill_css ->
> > > percpu_ref_kill_and_confirm. This breaks kmemcg assumptions.
> > > 
> > > I'll take a look what can be done about that.
> > 
> > It's an acknowledged problem in the cgroup core then, and not an issue
> > with kmemcg. Tejun sent a fix to correct the offlining order here:
> > 
> > https://www.mail-archive.com/linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg1056544.html
> 
> Patche descriptions updated and applied to cgroup/for-4.5-fixes.
> 
>  http://lkml.kernel.org/g/20160122154503.GD32380-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org
>  http://lkml.kernel.org/g/20160122154552.GE32380-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org

I couldn't reproduce the issue with the two patches applied. Looks like
they fix it.

Thanks,
Vladimir
