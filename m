From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 5/9] memcg: use css_get/put when charging/uncharging kmem
Date: Thu, 30 May 2013 17:12:20 +0200
Message-ID: <20130530151220.GB18155@dhcp22.suse.cz>
References: <5195D5F8.7000609@huawei.com>
 <5195D666.6030408@huawei.com>
 <20130517180822.GC12632@mtj.dyndns.org>
 <519C838B.9060609@huawei.com>
 <20130524075420.GA24813@dhcp22.suse.cz>
 <20130530054852.GA9305@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XYItylFmWQi7p277cTyHdDk1HUIngQSJDiwVKJlvuG0=;
        b=jBxAJ3TuN36vsTn+CmyvDLH+tDNC1SN4F01agaoepbIXKZ5UOGSRhuhqKIQRrSwwNd
         hnYpeFtmlFJvQFCJQnVioEQmhvGHPBLAFbWUKkrdE4+Gvmi4nrPzRWO3L3wmyLlglG+V
         VY3tuTBdN330j9mSgjt1UdZiNE42N290paL2PEQSaq1z8uy4GSzGKha4BjNbU1gzRERM
         XdrG8sxwmKcQKZcgHmu2mJsw+NiP+pbXrf7fjj1IGasvvEKQE/0N/bLbPE1S3G1QhmCH
         xImF6nYWpg9JyT7kLMYdjALaIZr3pB08mCcnBGKkf68IekeRNqxbyJX8FaL3zX42TAlP
         9XZA==
Content-Disposition: inline
In-Reply-To: <20130530054852.GA9305-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu 30-05-13 14:48:52, Tejun Heo wrote:
> Hello,
> 
> Sorry about the delay.  Have been and still am traveling.
> 
> On Fri, May 24, 2013 at 09:54:20AM +0200, Michal Hocko wrote:
> > > > On Fri, May 17, 2013 at 03:04:06PM +0800, Li Zefan wrote:
> > > >> +	/*
> > > >> +	 * Releases a reference taken in kmem_cgroup_css_offline in case
> > > >> +	 * this last uncharge is racing with the offlining code or it is
> > > >> +	 * outliving the memcg existence.
> > > >> +	 *
> > > >> +	 * The memory barrier imposed by test&clear is paired with the
> > > >> +	 * explicit one in kmem_cgroup_css_offline.
> > > > 
> > > > Paired with the wmb to achieve what?
> > 
> > https://lkml.org/lkml/2013/4/4/190
> > "
> > ! > +	css_get(&memcg->css);
> > ! I think that you need a write memory barrier here because css_get
> > ! nor memcg_kmem_mark_dead implies it. memcg_uncharge_kmem uses
> > ! memcg_kmem_test_and_clear_dead which imply a full memory barrier but it
> > ! should see the elevated reference count. No?
> > ! 
> > ! > +	/*
> > ! > +	 * We need to call css_get() first, because memcg_uncharge_kmem()
> > ! > +	 * will call css_put() if it sees the memcg is dead.
> > ! > +	 */
> > ! >  	memcg_kmem_mark_dead(memcg);
> > "
> > 
> > Does it make sense to you Tejun?
> 
> Yeah, you're right.  We need them.  It's still a bummer that mark_dead
> has the appearance of proper encapsulation while not really taking
> care of synchronization. 

No objection to put barrier there. You are right it is more natural.

> I think it'd make more sense for mark_dead to have the barrier (which
> BTW should probably be smp_wmb() instead of wmb())

Yes, smp_wmb sounds like a better fit.

> inside it or for the function to be just open-coded.  More on this
> topic later.
>
> > > The comment is wrong. I'll fix it.
> > 
> > Ohh, right. "Althouth this might sound strange as this path is called from
> > css_offline when the reference might have dropped down to 0 and shouldn't ..."
> > 
> > Sounds better?
> 
> Yeap.
> 
> > > I don't quite like adding a lock not to protect data but just ensure code
> > > orders.
> > 
> > Agreed.
> > 
> > > Michal, what's your preference? I want to be sure that everyone is happy
> > > so the next version will hopefully be the last version.
> > 
> > I still do not see why the barrier is not needed and the lock seems too
> > big hammer.
> 
> Yes, the barrier is necessary but I still think it's unnecessarily
> elaborate.  Among the locking constructs, the barriesr are the worst -
> they don't enforce any structures, people often misunderstand / make
> mistakes about them, bugs from misusages are extremely difficult to
> trigger and reproduce especially on x86.  It's a horrible construct
> and should only be used if no other options can meet the performance
> requirements required for the path.

I am all for simplifying the code. I guess it deserves a separate patch
though and it is a bit unrelated to the scope of the series.

-- 
Michal Hocko
SUSE Labs
