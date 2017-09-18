From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Mon, 18 Sep 2017 08:14:05 +0200
Message-ID: <20170918061405.pcrf5vauvul4c2nr@dhcp22.suse.cz>
References: <20170911131742.16482-1-guro@fb.com>
 <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
 <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz>
 <20170913215607.GA19259@castle>
 <20170914134014.wqemev2kgychv7m5@dhcp22.suse.cz>
 <20170914160548.GA30441@castle>
 <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz>
 <20170915152301.GA29379@castle>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170915152301.GA29379@castle>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri 15-09-17 08:23:01, Roman Gushchin wrote:
> On Fri, Sep 15, 2017 at 12:58:26PM +0200, Michal Hocko wrote:
> > On Thu 14-09-17 09:05:48, Roman Gushchin wrote:
> > > On Thu, Sep 14, 2017 at 03:40:14PM +0200, Michal Hocko wrote:
> > > > On Wed 13-09-17 14:56:07, Roman Gushchin wrote:
> > > > > On Wed, Sep 13, 2017 at 02:29:14PM +0200, Michal Hocko wrote:
> > > > [...]
> > > > > > I strongly believe that comparing only leaf memcgs
> > > > > > is more straightforward and it doesn't lead to unexpected results as
> > > > > > mentioned before (kill a small memcg which is a part of the larger
> > > > > > sub-hierarchy).
> > > > > 
> > > > > One of two main goals of this patchset is to introduce cgroup-level
> > > > > fairness: bigger cgroups should be affected more than smaller,
> > > > > despite the size of tasks inside. I believe the same principle
> > > > > should be used for cgroups.
> > > > 
> > > > Yes bigger cgroups should be preferred but I fail to see why bigger
> > > > hierarchies should be considered as well if they are not kill-all. And
> > > > whether non-leaf memcgs should allow kill-all is not entirely clear to
> > > > me. What would be the usecase?
> > > 
> > > We definitely want to support kill-all for non-leaf cgroups.
> > > A workload can consist of several cgroups and we want to clean up
> > > the whole thing on OOM.
> > 
> > Could you be more specific about such a workload? E.g. how can be such a
> > hierarchy handled consistently when its sub-tree gets killed due to
> > internal memory pressure?
> 
> Or just system-wide OOM.
> 
> > Or do you expect that none of the subtree will
> > have hard limit configured?
> 
> And this can also be a case: the whole workload may have hard limit
> configured, while internal memcgs have only memory.low set for "soft"
> prioritization.
> 
> > 
> > But then you just enforce a structural restriction on your configuration
> > because
> > 	root
> >         /  \
> >        A    D
> >       /\   
> >      B  C
> > 
> > is a different thing than
> > 	root
> >         / | \
> >        B  C  D
> >
> 
> I actually don't have a strong argument against an approach to select
> largest leaf or kill-all-set memcg. I think, in practice there will be
> no much difference.

Well, I am worried that the difference will come unexpected when a
deeper hierarchy is needed because of the structural needs.

-- 
Michal Hocko
SUSE Labs
