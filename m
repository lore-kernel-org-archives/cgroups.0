From: David Rientjes <rientjes@google.com>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Sat, 9 Sep 2017 01:45:53 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709090132590.53827@chino.kir.corp.google.com>
References: <20170904142108.7165-1-guro@fb.com> <20170904142108.7165-6-guro@fb.com> <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz> <20170905215344.GA27427@cmpxchg.org> <20170906082859.qlqenftxuib64j35@dhcp22.suse.cz> <alpine.DEB.2.20.1709071122360.20082@nuc-kabylake>
 <alpine.DEB.2.10.1709071502430.143767@chino.kir.corp.google.com> <alpine.DEB.2.20.1709081601310.27965@nuc-kabylake>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=TLG9yn6dQsr1JRuFgU1/uu4WdhK4hEZPxW+B1/u/73M=;
        b=RiTTDsGwHBrfCT3bJonW9iEW3zBcqEoxKasaWtAGfHehRKyX+g7dCIIv+3Og94ZOJc
         Wu/UWZeJN7WPE2q6GS8kIJRuNvNxwdJYRIsR+ifIKQmls9fUnoHidltGhWBmvjEnNyEv
         kLqWv94E3KI23TjEiCnOFT2bEBNfv4OMX2wR0PumKQB+V5CRhlDSEkMsIVCERm8JVSX3
         LJNF6IzfcLlJAPg4ZDnpqaRdUqGmhpJAZ7CFdg1t6o8yaAhaNwLwxYL+zPxBmkEMCh6m
         mqxsy3DwNTki4aIjbiETJvGLAYp7GMQ8tm++LVXUwPHAzqjL+M7/98a14yankihcRt+m
         SZgA==
In-Reply-To: <alpine.DEB.2.20.1709081601310.27965@nuc-kabylake>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christopher Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 8 Sep 2017, Christopher Lameter wrote:

> Ok. Certainly there were scalability issues (lots of them) and the sysctl
> may have helped there if set globally. But the ability to kill the
> allocating tasks was primarily used in cpusets for constrained allocation.
> 

I remember discussing it with him and he had some data with pretty extreme 
numbers for how long the tasklist iteration was taking.  Regardless, I 
agree it's not pertinent to the discussion if anybody is actively using 
the sysctl, just fun to try to remember the discussions from 10 years ago.  

The problem I'm having with the removal, though, is that the kernel source 
actually uses it itself in tools/testing/fault-injection/failcmd.sh.  
That, to me, suggests there are people outside the kernel source that are 
also probably use it.  We use it as part of our unit testing, although we 
could convert away from it.

These are things that can probably be worked around, but I'm struggling to 
see the whole benefit of it.  It's only defined, there's generic sysctl 
handling, and there's a single conditional in the oom killer.  I wouldn't 
risk the potential userspace breakage.

> The issue of scaling is irrelevant in the context of deciding what to do
> about the sysctl. You can address the issue differently if it still
> exists. The systems with super high NUMA nodes (hundreds to a
> thousand) have somehow fallen out of fashion a bit. So I doubt that this
> is still an issue. And no one of the old stakeholders is speaking up.
> 
> What is the current approach for an OOM occuring in a cpuset or cgroup
> with a restricted numa node set?
> 

It's always been shaky, we simply exclude potential kill victims based on 
whether or not they share mempolicy nodes or cpuset mems with the 
allocating process.  Of course, this could result in no memory freeing 
because a potential victim being allowed to allocate on a particular node 
right now doesn't mean killing it will free memory on that node.  It's 
just more probable in practice.  Nobody has complained about that 
methodology, but we do have internal code that simply kills current for 
mempolicy ooms.  That is because we have priority based oom killing much 
like this patchset implements and then extends it even further to 
processes.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
