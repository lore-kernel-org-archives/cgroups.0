From: David Rientjes <rientjes@google.com>
Subject: Re: [v5 4/4] mm, oom, docs: describe the cgroup-aware OOM killer
Date: Sun, 20 Aug 2017 17:41:25 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708201740140.117182@chino.kir.corp.google.com>
References: <20170814183213.12319-1-guro@fb.com> <20170814183213.12319-5-guro@fb.com> <alpine.DEB.2.10.1708141544280.63207@chino.kir.corp.google.com> <20170815141350.GA4510@castle.DHCP.thefacebook.com> <alpine.DEB.2.10.1708151349280.104516@chino.kir.corp.google.com>
 <20170817121647.GA26107@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=TMhJ4CUUwROksm2f+dk8qEb3jHIC9FleeiwOw0jD3c0=;
        b=Yc6zqRz7F0WkXeZaXjJZeMjCPOEF4cNcPqKRoQClh5nvDvAJlQRRJJtYUTm0SPUoO7
         jhk7Daqb5/tUORVmRGzdyneo4XLrt/mM2L7hY5oTCshOknL1Wk4cEwOrQ4MzV15RrEU6
         ILElpp8wZYlxiMoqtVbjtF4EhPP+VN7WvgonmuW5Bprz6rN6rVRujXWRtP/cYUoRP0Uh
         byi40xcy0dlWAgG8nduv2QQaq2sXC8vIT7auccyY0nGFgcX2rAz2ZhrZpHzd3qFogmZ1
         Nz4wOJEBxIMS4tgsuDPrykUQaE2Ltjeh1oxZTRuimn6o4aG74yGrddpY5pgpRJ1x5UrO
         iilg==
In-Reply-To: <20170817121647.GA26107@castle.DHCP.thefacebook.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 17 Aug 2017, Roman Gushchin wrote:

> Hi David!
> 
> Please, find an updated version of docs patch below.
> 

Looks much better, thanks!  I think the only pending issue is discussing 
the relationship of memory.oom_kill_all_tasks with /proc/pid/oom_score_adj 
== OOM_SCORE_ADJ_MIN.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
