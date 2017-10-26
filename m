From: David Rientjes <rientjes@google.com>
Subject: Re: [RESEND v12 0/6] cgroup-aware OOM killer
Date: Thu, 26 Oct 2017 14:03:41 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1710261359550.75887@chino.kir.corp.google.com>
References: <20171019185218.12663-1-guro@fb.com> <20171019194534.GA5502@cmpxchg.org> <alpine.DEB.2.10.1710221715010.70210@chino.kir.corp.google.com> <20171026142445.GA21147@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=eKPExV0bjD3O9rI8PZy7ZARpE8vKAprxiqshK1oPjF8=;
        b=pghizsjrbyPmsDfDrVhHaEz0XyafzMo52AN46abJHw/Gzki4t7hHgjrz+eQAOEJ/ST
         GQoP/xJcJfoS+40clXLcmw/+7IP1mm5P+v1xQN3E+nrFs4yztX5DO1tAtK35vsqXI9BL
         Z7rYcCyfQ+QFlgo9TSUQvztZG9mckVECJP3xD3xXtJRnV2/baPCTZqnUrFtfL/Rm1uI7
         FCCGaBvPwXFH0S6XT4hNhIldhBrgWKcOBhlaMJO4HleDwLiLXsWamV9KnLX+8olhhUZU
         XwbN0JAgvTzR/jNIOS/XPGtBTgizH+1t59tPSRL68oORshWgUf51ArDQyKYxrqCPOebw
         kYrw==
In-Reply-To: <20171026142445.GA21147@cmpxchg.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On Thu, 26 Oct 2017, Johannes Weiner wrote:

> > The nack is for three reasons:
> > 
> >  (1) unfair comparison of root mem cgroup usage to bias against that mem 
> >      cgroup from oom kill in system oom conditions,
> > 
> >  (2) the ability of users to completely evade the oom killer by attaching
> >      all processes to child cgroups either purposefully or unpurposefully,
> >      and
> > 
> >  (3) the inability of userspace to effectively control oom victim  
> >      selection.
> 
> My apologies if my summary was too reductionist.
> 
> That being said, the arguments you repeat here have come up in
> previous threads and been responded to. This doesn't change my
> conclusion that your NAK is bogus.
> 

They actually haven't been responded to, Roman was working through v11 and 
made a change on how the root mem cgroup usage was calculated that was 
better than previous iterations but still not an apples to apples 
comparison with other cgroups.  The problem is that it the calculation for 
leaf cgroups includes additional memory classes, so it biases against 
processes that are moved to non-root mem cgroups.  Simply creating mem 
cgroups and attaching processes should not independently cause them to 
become more preferred: it should be a fair comparison between the root mem 
cgroup and the set of leaf mem cgroups as implemented.  That is very 
trivial to do with hierarchical oom cgroup scoring.

Since the ability of userspace to control oom victim selection is not 
addressed whatsoever by this patchset, and the suggested method cannot be 
implemented on top of this patchset as you have argued because it requires 
a change to the heuristic itself, the patchset needs to become complete 
before being mergeable.
