From: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm 3/4] mm, memcg: replace memory.oom_group with policy
 tunable
Date: Fri, 19 Jan 2018 12:53:41 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1801191251080.177541@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com> <alpine.DEB.2.10.1801161814130.28198@chino.kir.corp.google.com> <20180117154155.GU3460072@devbig577.frc2.facebook.com>
 <alpine.DEB.2.10.1801171348190.86895@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=HDpKV/02DbdHINZc7lYlYzyOOpGrMBTdpR4DhPZn1pM=;
        b=bzodQpUdPQi05drILoGzQJxiGVyiipeYfzLCZPKvv8rwDMslcPNI+Cr6zcLirLJMPE
         pKaVWhca8WcfEVf/M3Q8gTNzmS2gU4J7c8NumHyYKzlitiyB/cYqDFe1+URnXB97aaod
         OYgAZXpknrJSWGYavbSlSShytm98kWee4JzucUWOO8HqpOm4ixl358nGjg1/QOqTQ7JN
         2/RQ48wy8/nHz7T4FH9WHR44MjBwodpxnj9qQWSbKWP12cKUxA4Rg3EWr8O7/Yl0k1jZ
         atJ6Fg/MmheQxCxyf7cgXkt/d5VZ9lnhTiPZcilwF9VlzZ+00mL0VVRW0vmPIZR7p4u/
         m9lg==
In-Reply-To: <alpine.DEB.2.10.1801171348190.86895@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Wed, 17 Jan 2018, David Rientjes wrote:

> Yes, this is a valid point.  The policy of "tree" and "all" are identical 
> policies and then the mechanism differs wrt to whether one process is 
> killed or all eligible processes are killed, respectively.  My motivation 
> for this was to avoid having two different tunables, especially because 
> later we'll need a way for userspace to influence the decisionmaking to 
> protect (bias against) important subtrees.  What would really be nice is 
> cgroup.subtree_control-type behavior where we could effect a policy and a 
> mechanism at the same time.  It's not clear how that would be handled to 
> allow only one policy and one mechanism, however, in a clean way.  The 
> simplest for the user would be a new file, to specify the mechanism and 
> leave memory.oom_policy alone.  Would another file really be warranted?  
> Not sure.
> 

Hearing no response, I'll implement this as a separate tunable in a v2 
series assuming there are no better ideas proposed before next week.  One 
of the nice things about a separate tunable is that an admin can control 
the overall policy and they can delegate the mechanism (killall vs one 
process) to a user subtree.  I agree with your earlier point that killall 
vs one process is a property of the workload and is better defined 
separately.

I'll also look to fix the breakage wrt root mem cgroup comparison with 
leaf mem cgroup comparison that is currently in -mm.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
