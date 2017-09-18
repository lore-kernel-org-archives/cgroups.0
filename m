From: Roman Gushchin <guro@fb.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Mon, 18 Sep 2017 08:02:54 -0700
Message-ID: <20170918150254.GA24257@castle.DHCP.thefacebook.com>
References: <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
 <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz>
 <20170913215607.GA19259@castle>
 <20170914134014.wqemev2kgychv7m5@dhcp22.suse.cz>
 <20170914160548.GA30441@castle>
 <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz>
 <20170915152301.GA29379@castle>
 <alpine.DEB.2.10.1709151249290.76069@chino.kir.corp.google.com>
 <20170915210807.GA5238@castle>
 <20170918062045.kcfsboxvfmlg2wjo@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=hXzptZLiYGkUonFA79cDvUld0RJSbj2WzD2gcTEVlfE=;
 b=WhsIUjAc+n7stHuUfve1ggF6v8IgpuSbihUfVAWVvK44P6cTZFCxsb5/030BEgaJH+oV
 jPikSdkvkTQLkrgL4r81vRCzqvwkOdt0ZdYw4vfXBSdAOhA24+Pgb9SNHdom/OTNhUVs
 CmmZmcYWGZYIJs88QDP9wSQWOxonzRAPQsE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=hXzptZLiYGkUonFA79cDvUld0RJSbj2WzD2gcTEVlfE=;
 b=H4VElPfPfZd3Obfiv15fB/SpparH+iIL/prHaj48OW6EAN+fXXGf66AvkckpeLaV7rIUskCN7vkwShbduBQ02MUP7lp+qxpsIaah9gVxvHC5+x7AkXve6hJO87IEbTWvysN4v2QSiJH91hRPwbRJltxH4eM0sYS4LOFQE/DCwl0=
Content-Disposition: inline
In-Reply-To: <20170918062045.kcfsboxvfmlg2wjo@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Sep 18, 2017 at 08:20:45AM +0200, Michal Hocko wrote:
> On Fri 15-09-17 14:08:07, Roman Gushchin wrote:
> > On Fri, Sep 15, 2017 at 12:55:55PM -0700, David Rientjes wrote:
> > > On Fri, 15 Sep 2017, Roman Gushchin wrote:
> > > 
> > > > > But then you just enforce a structural restriction on your configuration
> > > > > because
> > > > > 	root
> > > > >         /  \
> > > > >        A    D
> > > > >       /\   
> > > > >      B  C
> > > > > 
> > > > > is a different thing than
> > > > > 	root
> > > > >         / | \
> > > > >        B  C  D
> > > > >
> > > > 
> > > > I actually don't have a strong argument against an approach to select
> > > > largest leaf or kill-all-set memcg. I think, in practice there will be
> > > > no much difference.
> > > > 
> > > > The only real concern I have is that then we have to do the same with
> > > > oom_priorities (select largest priority tree-wide), and this will limit
> > > > an ability to enforce the priority by parent cgroup.
> > > > 
> > > 
> > > Yes, oom_priority cannot select the largest priority tree-wide for exactly 
> > > that reason.  We need the ability to control from which subtree the kill 
> > > occurs in ancestor cgroups.  If multiple jobs are allocated their own 
> > > cgroups and they can own memory.oom_priority for their own subcontainers, 
> > > this becomes quite powerful so they can define their own oom priorities.   
> > > Otherwise, they can easily override the oom priorities of other cgroups.
> > 
> > I believe, it's a solvable problem: we can require CAP_SYS_RESOURCE to set
> > the oom_priority below parent's value, or something like this.
> 
> As said in other email. We can make priorities hierarchical (in the same
> sense as hard limit or others) so that children cannot override their
> parent.

You mean they can set the knob to any value, but parent's value is enforced,
if it's greater than child's value?

If so, this sounds logical to me. Then we have size-based comparison and
priority-based comparison with similar rules, and all use cases are covered.

Ok, can we stick with this design?
Then I'll return oom_priorities in place, and post a (hopefully) final version.

Thanks!
