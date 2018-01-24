From: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm 3/4] mm, memcg: replace memory.oom_group with policy
 tunable
Date: Wed, 24 Jan 2018 13:44:02 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1801241340310.24330@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com> <alpine.DEB.2.10.1801161814130.28198@chino.kir.corp.google.com> <20180117154155.GU3460072@devbig577.frc2.facebook.com> <alpine.DEB.2.10.1801171348190.86895@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1801191251080.177541@chino.kir.corp.google.com> <20180120123251.GB1096857@devbig577.frc2.facebook.com> <alpine.DEB.2.10.1801221420120.16871@chino.kir.corp.google.com> <20180123155301.GS1526@dhcp22.suse.cz> <alpine.DEB.2.10.1801231416330.254281@chino.kir.corp.google.com>
 <20180124082041.GD1526@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=D4UCetG6rH+thaJMEw8WsMiiKNoobWb1DOndeO4CyWU=;
        b=sraJv6ImDbnW11XERv9l90h4t2vJTCqKq7NEc98Wd19++ChUl+KTGrOy57dC0OW7+p
         TNvuMmZTx6mLOQzVgiygq5sExgGiREBy6CQRIPPUA72M4dZOMJJJZGuYbIM4ygmHeixd
         C+gW4q2fy+OWQt2lGrpIltYgt6KS90ZdP6e/O/Df7u6ENvuVyCJtJvCxmNa8sKxWRgR4
         M7W8LEVGLbjwGOSqp/MZBoQABsSUwO3BFSH/I9/eHmpTyS3GSrlhPb0LufJsSnkIqc0c
         44Ey5CmsY4zFF2vuJkUz9d3/eAl8l0vgz/XPS7Bh8p3A1PS8siFbCu+Yq6knQh1fJPfC
         zOrw==
In-Reply-To: <20180124082041.GD1526@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Wed, 24 Jan 2018, Michal Hocko wrote:

> > The current implementation of memory.oom_group is based on top of a 
> > selection implementation that is broken in three ways I have listed for 
> > months:
> 
> This doesn't lead to anywhere. You are not presenting any new arguments
> and you are ignoring feedback you have received so far. We have tried
> really hard. Considering different _independent_ people presented more or
> less consistent view on these points I think you should deeply
> reconsider how you take that feedback.
> 

I've responded to each email providing useful feedback on this patchset.  
I agreed with Tejun about not embedding the oom mechanism into 
memory.oom_policy.  I was trying to avoid having two files in the mem 
cgroup v2 filesystem for oom policy and mechanism.  I agreed that 
delegating the mechanism to the workload would be useful in some cases.  
I've solicited feedback on any other opinions on how that can be done 
better, but it appears another tunable is the most convenient way of 
allowing this behavior to be specified.

As a result, this would remove patch 3/4 from the series.  Do you have any 
other feedback regarding the remainder of this patch series before I 
rebase it?

I will address the unfair root mem cgroup vs leaf mem cgroup comparison in 
a separate patchset to fix an issue where any user of oom_score_adj on a 
system that is not fully containerized gets very unusual, unexpected, and 
undocumented results.

Thanks.
