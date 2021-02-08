From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: remove rcu_read_lock from
 get_mem_cgroup_from_page
Date: Mon, 8 Feb 2021 10:50:29 +0100
Message-ID: <YCEJZWJkPpvYa9Xq@dhcp22.suse.cz>
References: <20210205062719.74431-1-songmuchun@bytedance.com>
 <YB0DnAlCaQza4Uf9@dhcp22.suse.cz>
 <CAMZfGtVhBrwgkJVwiah6eDsppSf8fYp+uZ=tZmHBLDFeTmQX3w@mail.gmail.com>
 <YB0euLiMU+T/9bMK@dhcp22.suse.cz>
 <YB2LTIeTPN72Xrxj@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612777831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DBsRDf6sKqoMXs8BxrjoloByzTHcZkFKh1qcJfej7kE=;
        b=RxLdmpgIP2mi8IiqRZ8SAFMocjqnRTOjFH2a8wzNNG3Zam8FkcECpEIB1U0+xH5owzyP7q
        S0kfhi3+LbYmQib6RH4JkfgEhk+vEl1tKs105T7c8HR6vUAB8vci4uGyHYxqjjLNg47t0d
        Nq8qNK2qyrr65vSyHTHMbjBYjVWP6Vo=
Content-Disposition: inline
In-Reply-To: <YB2LTIeTPN72Xrxj-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri 05-02-21 13:15:40, Johannes Weiner wrote:
> On Fri, Feb 05, 2021 at 11:32:24AM +0100, Michal Hocko wrote:
> > On Fri 05-02-21 17:14:30, Muchun Song wrote:
> > > On Fri, Feb 5, 2021 at 4:36 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > >
> > > > On Fri 05-02-21 14:27:19, Muchun Song wrote:
> > > > > The get_mem_cgroup_from_page() is called under page lock, so the page
> > > > > memcg cannot be changed under us.
> > > >
> > > > Where is the page lock enforced?
> > > 
> > > Because it is called from alloc_page_buffers(). This path is under
> > > page lock.
> > 
> > I do not see any page lock enforecement there. There is not even a
> > comment requiring that. Can we grow more users where this is not the
> > case? There is no actual relation between alloc_page_buffers and
> > get_mem_cgroup_from_page except that the former is the only _current_
> > existing user. I would be careful to dictate locking based solely on
> > that.
> 
> Since alloc_page_buffers() holds the page lock throughout the entire
> time it uses the memcg, there is no actual reason for it to use RCU or
> even acquire an additional reference on the css. We know it's pinned,
> the charge pins it, and the page lock pins the charge. It can neither
> move to a different cgroup nor be uncharged.
> 
> So what do you say we switch alloc_page_buffers() to page_memcg()?
> 
> And because that removes the last user of get_mem_cgroup_from_page(),
> we can kill it off and worry about a good interface once a consumer
> materializes for it.

Yes, this makes much more sense than impose a weird locking rules to a
more general purpose helper. Thanks!
-- 
Michal Hocko
SUSE Labs
