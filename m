From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: add RCU locking around
 css_for_each_descendant_pre() in memcg_offline_kmem()
Date: Tue, 31 May 2016 11:33:51 +0200
Message-ID: <20160531093351.GG26128@dhcp22.suse.cz>
References: <20160526203018.GG23194@mtj.duckdns.org>
 <20160526140202.077d611dbe0926ce290b4e53@linux-foundation.org>
 <20160527153124.GT27686@dhcp22.suse.cz>
 <20160527155140.GN23194@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160527155140.GN23194-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Sorry for a late response.

On Fri 27-05-16 11:51:40, Tejun Heo wrote:
> On Fri, May 27, 2016 at 05:31:24PM +0200, Michal Hocko wrote:
> > On Thu 26-05-16 14:02:02, Andrew Morton wrote:
> > > On Thu, 26 May 2016 16:30:18 -0400 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > 
> > > > memcg_offline_kmem() may be called from memcg_free_kmem() after a css
> > > > init failure.  memcg_free_kmem() is a ->css_free callback which is
> > > > called without cgroup_mutex and memcg_offline_kmem() ends up using
> > > > css_for_each_descendant_pre() without any locking.  Fix it by adding
> > > > rcu read locking around it.
> > > > 
> > > >  mkdir: cannot create directory ___65530___: No space left on device
> > > >  [  527.241361] ===============================
> > > >  [  527.241845] [ INFO: suspicious RCU usage. ]
> > > >  [  527.242367] 4.6.0-work+ #321 Not tainted
> > > >  [  527.242730] -------------------------------
> > > >  [  527.243220] kernel/cgroup.c:4008 cgroup_mutex or RCU read lock required!
> > > 
> > > cc:stable?
> > 
> > Also which kernel versions would be affected? I have tried to look and
> > got lost in the indirection of the css_free path.
> 
> I think it's actually from 0b8f73e10428 ("mm: memcontrol: clean up
> alloc, online, offline, free functions") which got merged during this
> cycle, so no need for -stable.

yes you are right! memcg_free_kmem didn't call memcg_offline_kmem before
that commit. Thanks for the clarification.

Anyway
$ git describe --contains 0b8f73e10428
v4.5-rc1~30^2~11

So it would be stable # 4.5+
-- 
Michal Hocko
SUSE Labs
