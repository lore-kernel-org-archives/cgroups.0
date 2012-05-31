From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
Date: Wed, 30 May 2012 22:02:23 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com>
 <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com> <4FC6C111.2060108@jp.fujitsu.com> <alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com> <4FC6D881.4090706@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=HDdXOVLmQG/6BUj0aQnhkZGHrQPm2VIqzez/dvY3A8E=;
        b=Q0ZSJzt1pdxrLsTHwiaXUC0jCZEwg82TGCtuAZoODbQOHSB8fdTWahn0oOUtPe+LOU
         xEhOjOXg35/SmEDQTbYbqDQxkbLEJMjmsL8HWq1dHtVo7NjYO0cwyYdGzkl/CcselYcE
         oGwMG+tx4g9rr73V8t0nppHqmZ1CNugRSfE9G4xtodq63NRE6db8LtxrVJv8mksT7sPy
         7V5YZgC89nMAZLyJLPzrg+2qQQRIJEdQnVBkHU+RDIwu9IodGcm7gB+LOEVuHukplkfl
         1IjYf3gGbkzh32lOc13H9B2elGXV7qSMPfBxZ0+T2+HtHFaJMUnSighxjX7aLX+tOd6L
         HKsA==
In-Reply-To: <4FC6D881.4090706@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Gao feng <gaofeng@cn.fujitsu.com>, hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, containers@lists.linux-foundation.org

On Thu, 31 May 2012, Kamezawa Hiroyuki wrote:

> > It's not just a memcg issue, it would also be a cpusets issue.
> 
> I think you can add cpuset.meminfo.
> 

It's simple to find the same information by reading the per-node meminfo 
files in sysfs for each of the allowed cpuset mems.  This is why this 
approach has been nacked in the past, specifically by Paul Jackson when he 
implemented cpusets.

The bottomline is that /proc/meminfo is one of many global resource state 
interfaces and doesn't imply that every thread has access to the full 
resources.  It never has.  It's very simple for another thread to consume 
a large amount of memory as soon as your read() of /proc/meminfo completes 
and then that information is completely bogus.  We also don't want to 
virtualize every single global resource state interface, it would be never 
ending.

Applications that administer memory cgroups or cpusets can get this 
information very easily, each application within those memory cgroups or 
cpusets does not need it and should not rely on it: it provides no 
guarantee about future usage nor notifies the application when the amount 
of free memory changes.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
