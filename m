From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/7] memcg: immigrate charges only when a threadgroup
 leader is moved
Date: Mon, 25 May 2015 18:06:26 +0200
Message-ID: <20150525160626.GC19389@dhcp22.suse.cz>
References: <20150519212754.GO24861@htj.duckdns.org>
 <20150520131044.GA28678@dhcp22.suse.cz>
 <20150520132158.GB28678@dhcp22.suse.cz>
 <20150520175302.GA7287@redhat.com>
 <20150520202221.GD14256@dhcp22.suse.cz>
 <20150521192716.GA21304@redhat.com>
 <20150522093639.GE5109@dhcp22.suse.cz>
 <20150522162900.GA8955@redhat.com>
 <20150522165734.GH5109@dhcp22.suse.cz>
 <20150522183042.GF26770@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150522183042.GF26770-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 22-05-15 20:30:42, Oleg Nesterov wrote:
> On 05/22, Michal Hocko wrote:
> >
> > On Fri 22-05-15 18:29:00, Oleg Nesterov wrote:
> > >
> > > In the likely case (if CLONE_VM without CLONE_THREAD was not used) the
> > > last for_each_process() in mm_update_next_owner() will find another thread
> > > from the same group.
> >
> > My understanding was that for_each_process will iterate only over
> > processes (represented by the thread group leaders).
> 
> Yes. But note the inner for_each_thread() loop. And note that we
> we need this loop exactly because the leader can be zombie.

I was too vague, sorry about that. What I meant was that
for_each_process would pick up a group leader and the inner
for_each_thread will return it as the first element in the list. As the
leader waits for other threads then it should stay on the thread_node
list as well. But I might be easily wrong here because the whole thing
is really quite confusing to be honest.
-- 
Michal Hocko
SUSE Labs
