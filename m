From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 3/4] mm, oom: add cgroup v2 mount option for cgroup-aware
 OOM killer
Date: Tue, 12 Sep 2017 13:23:00 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709121319040.62551@chino.kir.corp.google.com>
References: <20170911131742.16482-1-guro@fb.com> <20170911131742.16482-4-guro@fb.com> <alpine.DEB.2.10.1709111345320.102819@chino.kir.corp.google.com> <20170912200115.GA25218@castle>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=tc7boOPME6lmWhry2dRJEgNgdB55AVbIXkUQC7Ot4uM=;
        b=iTk5KPrqxUAHMQ1+TPRgTzOKY5FvAs6/6B/WUw916/nlLdPBRFuuIgkZ+8+80etfQC
         X2U7rAtXjaxLSSECb4+FGMwi8YALOnIvlNHiw29H2fx7iabtR0LOLqRIYkT9bizuqV/i
         5eFXSaFCOOOwALhzL1R8NKewjUltx6DLZEA2skmJQ3ZfcYYOVCJT/ZbOMhMrTrxjJ9Tz
         0tU8gNQX+mC8923ZS4yNAPNHp8TtQLJgTjwK/DRvxjZrTdKE2EyN1sydo2t69/zFwfRn
         Z367Syp+k4EHV44NgeamkHUJ7zo0n+9bmtAkhy65PaLyouaMEZ599YTwuYZHQNs0ttmP
         McHQ==
In-Reply-To: <20170912200115.GA25218@castle>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 12 Sep 2017, Roman Gushchin wrote:

> > I can't imagine that Tejun would be happy with a new mount option, 
> > especially when it's not required.
> > 
> > OOM behavior does not need to be defined at mount time and for the entire 
> > hierarchy.  It's possible to very easily implement a tunable as part of 
> > mem cgroup that is propagated to descendants and controls the oom scoring 
> > behavior for that hierarchy.  It does not need to be system wide and 
> > affect scoring of all processes based on which mem cgroup they are 
> > attached to at any given time.
> 
> No, I don't think that mixing per-cgroup and per-process OOM selection
> algorithms is a good idea.
> 
> So, there are 3 reasonable options:
> 1) boot option
> 2) sysctl
> 3) cgroup mount option
> 
> I believe, 3) is better, because it allows changing the behavior dynamically,
> and explicitly depends on v2 (what sysctl lacks).
> 
> So, the only question is should it be opt-in or opt-out option.
> Personally, I would prefer opt-out, but Michal has a very strong opinion here.
> 

If it absolutely must be a mount option, then I would agree it should be 
opt-in so that it's known what is being changed rather than changing how 
selection was done in the past and requiring legacy users to now mount in 
a new way.

I'd be interested to hear Tejun's comments, however, about whether we want 
to add controller specific mount options like this instead of a tunable at 
the root level, for instance, that controls victim selection and would be 
isolated to the memory cgroup controller as opposed to polluting mount 
options.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
