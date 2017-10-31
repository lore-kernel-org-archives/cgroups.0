From: David Rientjes <rientjes@google.com>
Subject: Re: [RESEND v12 0/6] cgroup-aware OOM killer
Date: Tue, 31 Oct 2017 15:21:23 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1710311513590.123444@chino.kir.corp.google.com>
References: <20171019185218.12663-1-guro@fb.com> <20171019194534.GA5502@cmpxchg.org> <alpine.DEB.2.10.1710221715010.70210@chino.kir.corp.google.com> <20171026142445.GA21147@cmpxchg.org> <alpine.DEB.2.10.1710261359550.75887@chino.kir.corp.google.com>
 <20171027093107.GA29492@castle.dhcp.TheFacebook.com> <alpine.DEB.2.10.1710301430170.105449@chino.kir.corp.google.com> <20171031075408.67au22uk6dkpu7vv@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=yk+m70hDKqKasx/xoC1mSR70eK+wF753AV2mYUMws9o=;
        b=jkiE40ag2EWSsMhdp4y7nbejq90en9H0g1eGSu5owgTymFFdhAXecbkNKiyQg8yZb5
         EeDl2XLOWNJwL6Y2CnC6mpMJsUGRzZ8zgujJkXID4s6rjzRJkf8fVK236UiurbLNCWAS
         APvRwCTYmGJQ/GIAE1Stcv1bDeCK13hJCuFgjBhUnvleIrVwS6wJEQSVdWlw27pWEKw6
         OM69D6ITbEj8uY5A4ounhtbk5tzzk/mQvlt8zSVFDYoaF2mODZ0hud8UruQQsM1ytHSk
         LFtQXph+1DbiNwsTJdgCG60wYtlVvwK8uVhQ2hPDyq/8Af2WgrfI1IXGU95btsmRFvtB
         uy9w==
In-Reply-To: <20171031075408.67au22uk6dkpu7vv@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 31 Oct 2017, Michal Hocko wrote:

> > I'm not ignoring them, I have stated that we need the ability to protect 
> > important cgroups on the system without oom disabling all attached 
> > processes.  If that is implemented as a memory.oom_score_adj with the same 
> > semantics as /proc/pid/oom_score_adj, i.e. a proportion of available 
> > memory (the limit), it can also address the issues pointed out with the 
> > hierarchical approach in v8.
> 
> No it cannot and it would be a terrible interface to have as well. You
> do not want to permanently tune oom_score_adj to compensate for
> structural restrictions on the hierarchy.
> 

memory.oom_score_adj would never need to be permanently tuned, just as 
/proc/pid/oom_score_adj need never be permanently tuned.  My response was 
an answer to Roman's concern that "v8 has it's own limitations," but I 
haven't seen a concrete example where the oom killer is forced to kill 
from the non-preferred cgroup while the user has power of biasing against 
certain cgroups with memory.oom_score_adj.  Do you have such a concrete 
example that we can work with?

> I believe, and Roman has pointed that out as well already, that further
> improvements can be implemented without changing user visible behavior
> as and add-on. If you disagree then you better come with a solid proof
> that all of us wrong and reasonable semantic cannot be achieved that
> way.

We simply cannot determine if improvements can be implemented in the 
future without user-visible changes if those improvements are unknown or 
undecided at this time.  It may require hierarchical accounting when 
making a choice between siblings, as suggested with oom_score_adj.  The 
only thing that we need to agree on is that userspace needs to have some 
kind of influence over victim selection: the oom killer killing an 
important user process is an extremely sensitive thing.  If the patchset 
lacks the ability to have that influence, and such an ability would impact 
the heuristic overall, it's better to introduce that together as a 
complete patchset rather than merging an incomplete feature when it's 
known the user needs some control, asking the user to workaround it by 
setting all processes to oom disabled in a preferred mem cgroup, and then 
changing the heuristic again.
