From: David Rientjes <rientjes@google.com>
Subject: Re: [RESEND v12 0/6] cgroup-aware OOM killer
Date: Mon, 30 Oct 2017 14:36:39 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1710301430170.105449@chino.kir.corp.google.com>
References: <20171019185218.12663-1-guro@fb.com> <20171019194534.GA5502@cmpxchg.org> <alpine.DEB.2.10.1710221715010.70210@chino.kir.corp.google.com> <20171026142445.GA21147@cmpxchg.org> <alpine.DEB.2.10.1710261359550.75887@chino.kir.corp.google.com>
 <20171027093107.GA29492@castle.dhcp.TheFacebook.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=FRWbjVY9rQuBbN0HjoWMB8OURTfYkHjpN6wqWN9ox+g=;
        b=igV+hRlK3fDzgC+d1ev2d5W8A0soYA4TaKSVJXRyZ2hdJWVEKiiDvVBQEUiGmTHkfb
         DgH7majet46+K5nXtziGdNINp25GftD3W2wHxfK6VnzdSNq/+3fPPpVhqHc8Io11/3mH
         rGtnX4Zf/KH5jS6ZYmFz0V1W354sHKJTMQcUpSatkrnxXBtFgMkcNC512u9ZaiutvMOL
         jhL5vYlsj08FlywHxHMiBM0eE/lLRfRgNbQClI61i71cd+sWwjMra8ZWHuKI54iM5OZ2
         HlCFlBFBtqAjudhhkGM1omDBNCpoHjh4Y+oN+DdJEAoJXZFladiKQCjVZl0W+yS2wEHc
         REig==
In-Reply-To: <20171027093107.GA29492@castle.dhcp.TheFacebook.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 27 Oct 2017, Roman Gushchin wrote:

> The thing is that the hierarchical approach (as in v8), which are you pushing,
> has it's own limitations, which we've discussed in details earlier. There are
> reasons why v12 is different, and we can't really simple go back. I mean if
> there are better ideas how to resolve concerns raised in discussions around v8,
> let me know, but ignoring them is not an option.
> 

I'm not ignoring them, I have stated that we need the ability to protect 
important cgroups on the system without oom disabling all attached 
processes.  If that is implemented as a memory.oom_score_adj with the same 
semantics as /proc/pid/oom_score_adj, i.e. a proportion of available 
memory (the limit), it can also address the issues pointed out with the 
hierarchical approach in v8.  If this is not the case, could you elaborate 
on what your exact concern is and why we do not care that users can 
completely circumvent victim selection by creating child cgroups for other 
controllers?

Since the ability to protect important cgroups on the system may require a 
heuristic change, I think it should be solved now rather than constantly 
insisting that we can make this patchset complete later and in the 
meantime force the user to set all attached processes to be oom disabled.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
