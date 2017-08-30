From: David Rientjes <rientjes@google.com>
Subject: Re: [v6 2/4] mm, oom: cgroup-aware OOM killer
Date: Wed, 30 Aug 2017 13:56:22 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708301349130.79465@chino.kir.corp.google.com>
References: <20170823165201.24086-1-guro@fb.com> <20170823165201.24086-3-guro@fb.com> <20170824114706.GG5943@dhcp22.suse.cz> <20170824122846.GA15916@castle.DHCP.thefacebook.com> <20170824125811.GK5943@dhcp22.suse.cz> <20170824135842.GA21167@castle.DHCP.thefacebook.com>
 <20170824141336.GP5943@dhcp22.suse.cz> <20170824145801.GA23457@castle.DHCP.thefacebook.com> <20170825081402.GG25498@dhcp22.suse.cz> <20170830112240.GA4751@castle.dhcp.TheFacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=2nBlU/gqSCfzi8ScMWfy1X1LghUSTcSFc/vibJje3Sw=;
        b=YBqt0WMhBUEA4su9vyZnJk4URGSig9DQB69YB+9F6mULpBezL81RPafmrXg7VcrOXu
         Xo3FdCy451ZQeCeW3QmQNKtBFmdZcIQGCJQSoOCvv9TmZYpqfD7zKPwCZB8MDSNts50w
         9ePr56vK6PnqnwDNKGJMiVsiyS1cayy8OUImAxytY7GrdgVaT3qEnq3rxLUGuaB7lMAj
         MCPp/szjknCeo7PYL27zV4u0eUdMsuJTJjXyhwPuC88wtp9DwQ1UzpyXs/hEg1OOqMS3
         LX9XYelom7NtcXA5ezgSc8VO1BE6KSlzlBZ/juhkPpMfyDFw2dGabPrsNgjcSoG+JEEM
         pCsA==
In-Reply-To: <20170830112240.GA4751@castle.dhcp.TheFacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 30 Aug 2017, Roman Gushchin wrote:

> I've spent some time to implement such a version.
> 
> It really became shorter and more existing code were reused,
> howewer I've met a couple of serious issues:
> 
> 1) Simple summing of per-task oom_score doesn't make sense.
>    First, we calculate oom_score per-task, while should sum per-process values,
>    or, better, per-mm struct. We can take only threa-group leader's score
>    into account, but it's also not 100% accurate.
>    And, again, we have a question what to do with per-task oom_score_adj,
>    if we don't task the task's oom_score into account.
> 
>    Using memcg stats still looks to me as a more accurate and consistent
>    way of estimating memcg memory footprint.
> 

The patchset is introducing a new methodology for selecting oom victims so 
you can define how cgroups are compared vs other cgroups with your own 
"badness" calculation.  I think your implementation based heavily on anon 
and unevictable lrus and unreclaimable slab is fine and you can describe 
that detail in the documentation (along with the caveat that it is only 
calculated for nodes in the allocation's mempolicy).  With 
memory.oom_priority, the user has full ability to change that selection.  
Process selection heuristics have changed over time themselves, it's not 
something that must be backwards compatibile and trying to sum the usage 
from each of the cgroup's mm_struct's and respect oom_score_adj is 
unnecessarily complex.
