From: David Rientjes <rientjes@google.com>
Subject: Re: [v6 2/4] mm, oom: cgroup-aware OOM killer
Date: Thu, 31 Aug 2017 13:01:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708311246340.130518@chino.kir.corp.google.com>
References: <20170823165201.24086-3-guro@fb.com> <20170824114706.GG5943@dhcp22.suse.cz> <20170824122846.GA15916@castle.DHCP.thefacebook.com> <20170824125811.GK5943@dhcp22.suse.cz> <20170824135842.GA21167@castle.DHCP.thefacebook.com> <20170824141336.GP5943@dhcp22.suse.cz>
 <20170824145801.GA23457@castle.DHCP.thefacebook.com> <20170825081402.GG25498@dhcp22.suse.cz> <20170830112240.GA4751@castle.dhcp.TheFacebook.com> <alpine.DEB.2.10.1708301349130.79465@chino.kir.corp.google.com>
 <20170831133423.GA30125@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=/xOzoPMtls0vdZIRRu1m3zdkNyqKsXaYeZShg3p9IQE=;
        b=hqPz/95GZ44bcw4NbyBxWX1ADAnjUIh3V40dsz/LGfjLX6NYIic4Es9318IbLPFR4W
         tKHfEPUwgTKrK/NvN4KuU6B6oOA8DTPSHWw7GjIKmFLzZq5GrXV1ka+cjPjy1Mga8/HC
         RG7d7OW1UMPe0Cq7VVPaQwV8ZCxOduJzZ57dXUWrOowcSxIJ7QJ9fLRlUFk6+Dh2I3u8
         8T0GAovbnk3Ih/OsV51iINFEflghXIhj2sNb2oxlIFfXAob+4iVQTApF/KAUbpD8MERr
         u3RdXNZWWwYXgGVS2EPbm5VO+P3iaET0xlf+WAGtCi78VhepBFUg00eTlBfRnxTfRwu2
         wL9A==
In-Reply-To: <20170831133423.GA30125@castle.DHCP.thefacebook.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 31 Aug 2017, Roman Gushchin wrote:

> So, it looks to me that we're close to an acceptable version,
> and the only remaining question is the default behavior
> (when oom_group is not set).
> 

Nit: without knowledge of the implementation, I still don't think I would 
know what an "out of memory group" is.  Out of memory doesn't necessarily 
imply a kill.  I suggest oom_kill_all or something that includes the verb.

> Michal suggests to ignore non-oom_group memcgs, and compare tasks with
> memcgs with oom_group set. This makes the whole thing completely opt-in,
> but then we probably need another knob (or value) to select between
> "select memcg, kill biggest task" and "select memcg, kill all tasks".

It seems like that would either bias toward or bias against cgroups that 
opt-in.  I suggest comparing memory cgroups at each level in the hierarchy 
based on your new badness heuristic, regardless of any tunables it has 
enabled.  Then kill either the largest process or all the processes 
attached depending on oom_group or oom_kill_all.

> Also, as the whole thing is based on comparison between processes and
> memcgs, we probably need oom_priority for processes.

I think with the constraints of cgroup v2 that a victim memcg must first 
be chosen, and then a victim process attached to that memcg must be chosen 
or all eligible processes attached to it be killed, depending on the 
tunable.

The simplest and most clear way to define this, in my opinion, is to 
implement a heuristic that compares sibling memcgs based on usage, as you 
have done.  This can be overridden by a memory.oom_priority that userspace 
defines, and is enough support for them to change victim selection (no 
mount option needed, just set memory.oom_priority).  Then kill the largest 
process or all eligible processes attached.  We only use per-process 
priority to override process selection compared to sibling memcgs, but 
with cgroup v2 process constraints it doesn't seem like that is within the 
scope of your patchset.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
