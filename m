From: David Rientjes <rientjes@google.com>
Subject: Re: [v4 2/4] mm, oom: cgroup-aware OOM killer
Date: Tue, 8 Aug 2017 16:06:38 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708081559001.54505@chino.kir.corp.google.com>
References: <20170726132718.14806-1-guro@fb.com> <20170726132718.14806-3-guro@fb.com> <20170801145435.GN15774@dhcp22.suse.cz> <20170801152548.GA29502@castle.dhcp.TheFacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=CyULeCf2+WADd4J2zZdQlppcKHYg8KlRNIUHe7L9abQ=;
        b=cu+OscLMc1/rUF8jQlgtf21BR+4OAxOJHSSpB0tgAjKM7FRP5qXCIDI4iQwnAk3WA2
         a5D4BgPEicNwjbqc/sMEZ4oCymtW9vKcpdx11LXcw8zuVCEsvhgvxF7ImzXBjRuS8OGN
         3jbX95wDEjnBVkt+7z9d6KdWe9FGjmx00o89wBuErCt0nvvua5WTCwe9wyzlBBQDnSuw
         b96GKuX9Y4oFCCXYQvpasPnJkKeN3kmQVR83h+Kvrf5354jUHbCGCzQQ+I5dexMdT2ka
         28HJSgts35USJyrPEQW+pKuyYaFftSlpFRG7T1c6DxieqNIwAwKYk+zNQ43xv9F4BN+E
         dshQ==
In-Reply-To: <20170801152548.GA29502@castle.dhcp.TheFacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 1 Aug 2017, Roman Gushchin wrote:

> > To the rest of the patch. I have to say I do not quite like how it is
> > implemented. I was hoping for something much simpler which would hook
> > into oom_evaluate_task. If a task belongs to a memcg with kill-all flag
> > then we would update the cumulative memcg badness (more specifically the
> > badness of the topmost parent with kill-all flag). Memcg will then
> > compete with existing self contained tasks (oom_badness will have to
> > tell whether points belong to a task or a memcg to allow the caller to
> > deal with it). But it shouldn't be much more complex than that.
> 
> I'm not sure, it will be any simpler. Basically I'm doing the same:
> the difference is that you want to iterate over tasks and for each
> task traverse the memcg tree, update per-cgroup oom score and find
> the corresponding memcg(s) with the kill-all flag. I'm doing the opposite:
> traverse the cgroup tree, and for each leaf cgroup iterate over processes.
> 
> Also, please note, that even without the kill-all flag the decision is made
> on per-cgroup level (except tasks in the root cgroup).
> 

I think your implementation is preferred and is actually quite simple to 
follow, and I would encourage you to follow through with it.  It has a 
similar implementation to what we have done for years to kill a process 
from a leaf memcg.

I did notice that oom_kill_memcg_victim() calls directly into 
__oom_kill_process(), however, so we lack the traditional oom killer 
output that shows memcg usage and potential tasklist.  I think we should 
still be dumping this information to the kernel log so that we can see a 
breakdown of charged memory.
