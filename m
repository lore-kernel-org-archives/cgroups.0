From: Roman Gushchin <guro@fb.com>
Subject: Re: [RESEND v12 0/6] cgroup-aware OOM killer
Date: Fri, 27 Oct 2017 10:31:16 +0100
Message-ID: <20171027093107.GA29492@castle.dhcp.TheFacebook.com>
References: <20171019185218.12663-1-guro@fb.com>
 <20171019194534.GA5502@cmpxchg.org>
 <alpine.DEB.2.10.1710221715010.70210@chino.kir.corp.google.com>
 <20171026142445.GA21147@cmpxchg.org>
 <alpine.DEB.2.10.1710261359550.75887@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=6YL+hpi3UVrQLvVrlpjtK4UlGRgKiiYR1J9/RhUyRLs=;
 b=FSj+fLccuR1N0Rel0W++yvvp7+yyDWBQuU0HnjM1PS/Kke4PIx0OyXLIndtkVhE8eatx
 1Qf2U2SNuuAenmiY1EJFjX8/I59kdRWTudgDfGw8toYS7/edP9GB5XmqB47Hl5aO4UTw
 Vf8WdUj8N5dJlgBS0PoYEYDXyB/CeUFE1RI= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6YL+hpi3UVrQLvVrlpjtK4UlGRgKiiYR1J9/RhUyRLs=;
 b=UleCvyWYuXRxo1pxfp9pfuIX/36jNeWvWv9eQ5Fa6Ou8dXUIbzt+0R9+kRva9SrsDPLfS9Crq3UM6yesqQbTIf3yMzTtTZsDjjB90BZIvs46pV2cMpYI8Kaq4hLvidY8jDLNpfPfqGP4f9gLljnVbUvM1nsZHgYbBxPBoJiTHv0=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1710261359550.75887@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Oct 26, 2017 at 02:03:41PM -0700, David Rientjes wrote:
> On Thu, 26 Oct 2017, Johannes Weiner wrote:
> 
> > > The nack is for three reasons:
> > > 
> > >  (1) unfair comparison of root mem cgroup usage to bias against that mem 
> > >      cgroup from oom kill in system oom conditions,
> > > 
> > >  (2) the ability of users to completely evade the oom killer by attaching
> > >      all processes to child cgroups either purposefully or unpurposefully,
> > >      and
> > > 
> > >  (3) the inability of userspace to effectively control oom victim  
> > >      selection.
> > 
> > My apologies if my summary was too reductionist.
> > 
> > That being said, the arguments you repeat here have come up in
> > previous threads and been responded to. This doesn't change my
> > conclusion that your NAK is bogus.
> > 
> 
> They actually haven't been responded to, Roman was working through v11 and 
> made a change on how the root mem cgroup usage was calculated that was 
> better than previous iterations but still not an apples to apples 
> comparison with other cgroups.  The problem is that it the calculation for 
> leaf cgroups includes additional memory classes, so it biases against 
> processes that are moved to non-root mem cgroups.  Simply creating mem 
> cgroups and attaching processes should not independently cause them to 
> become more preferred: it should be a fair comparison between the root mem 
> cgroup and the set of leaf mem cgroups as implemented.  That is very 
> trivial to do with hierarchical oom cgroup scoring.
> 
> Since the ability of userspace to control oom victim selection is not 
> addressed whatsoever by this patchset, and the suggested method cannot be 
> implemented on top of this patchset as you have argued because it requires 
> a change to the heuristic itself, the patchset needs to become complete 
> before being mergeable.

Hi David!

The thing is that the hierarchical approach (as in v8), which are you pushing,
has it's own limitations, which we've discussed in details earlier. There are
reasons why v12 is different, and we can't really simple go back. I mean if
there are better ideas how to resolve concerns raised in discussions around v8,
let me know, but ignoring them is not an option.

From my point of view, an idea of selecting the biggest memcg tree-wide is
perfectly fine, as far as it possible to group memcgs in OOM domains.
As in v12, it can be done by setting the memory.oom_group knob.
It's perfectly possible to extend this by adding an ability to continue OOM
victim selection in the selected memcg instead of killing all belonging tasks,
as far as a practical need arises.

The way how we evaluate the root memory cgroup isn't as important as the
question how we compare cgroups in the hierarchy. So even if the hierarchical
approach allows to implement fairer comparison, it's not a reason to choose it.
Just because there are more serious concerns, discussed earlier.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
