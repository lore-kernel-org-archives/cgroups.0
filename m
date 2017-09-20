From: Roman Gushchin <guro@fb.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Wed, 20 Sep 2017 15:24:03 -0700
Message-ID: <20170920222403.GA4729@castle>
References: <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
 <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz>
 <20170913215607.GA19259@castle>
 <20170914134014.wqemev2kgychv7m5@dhcp22.suse.cz>
 <20170914160548.GA30441@castle>
 <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz>
 <20170915152301.GA29379@castle>
 <alpine.DEB.2.10.1709151249290.76069@chino.kir.corp.google.com>
 <20170915210807.GA5238@castle>
 <alpine.DEB.2.10.1709191351330.7458@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=+BisoRYvT0/gaESSfH0U0su6dVV8fWSm1D4VM19nyn4=;
 b=fHNlstatV0Y5ABqVlPOF3KHDmKou5/4Ua/cy+3zWvU4JQucQ4b0thAROV+TD+u8nNWGL
 flVnFv+qS+EC/DplQOmSvTEiaN/sm5mpnam1EFX9ruQYGYmBbPz9qWVxjAS5Q6A6CMbO
 KRhlyaTiYTKlBw2rke04E1jqULeTslWl7Xg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+BisoRYvT0/gaESSfH0U0su6dVV8fWSm1D4VM19nyn4=;
 b=FEfFTOz+QAbcHD6F3+B1PTeO6C9ZttnDEljl2pn+iwOLD9hFiW8VaGAYbySVOhXHKark9AkQrJA1qMAjjNq1iKaIxSNP+Ot5JlsWRUR8X4H9dMjAihh8XTub5wARuvoc7obxFEXqvQmlxAOrJxauDYichzJtoVLBXV3Mx6lhIbk=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1709191351330.7458@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Sep 19, 2017 at 01:54:48PM -0700, David Rientjes wrote:
> On Fri, 15 Sep 2017, Roman Gushchin wrote:
> 
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
> > 
> > But it looks more complex, and I'm not sure there are real examples,
> > when we have to compare memcgs, which are on different levels
> > (or in different subtrees).
> > 
> 
> It's actually much more complex because in our environment we'd need an 
> "activity manager" with CAP_SYS_RESOURCE to control oom priorities of user 
> subcontainers when today it need only be concerned with top-level memory 
> cgroups.  Users can create their own hierarchies with their own oom 
> priorities at will, it doesn't alter the selection heuristic for another 
> other user running on the same system and gives them full control over the 
> selection in their own subtree.  We shouldn't need to have a system-wide 
> daemon with CAP_SYS_RESOURCE be required to manage subcontainers when 
> nothing else requires it.  I believe it's also much easier to document: 
> oom_priority is considered for all sibling cgroups at each level of the 
> hierarchy and the cgroup with the lowest priority value gets iterated.

I do agree actually. System-wide OOM priorities make no sense.

Always compare sibling cgroups, either by priority or size, seems to be
simple, clear and powerful enough for all reasonable use cases. Am I right,
that it's exactly what you've used internally? This is a perfect confirmation,
I believe.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
