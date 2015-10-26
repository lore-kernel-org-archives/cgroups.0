From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] oom_kill: add option to disable dump_stack()
Date: Mon, 26 Oct 2015 14:38:11 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1510261424290.12408@chino.kir.corp.google.com>
References: <1445634150-27992-1-git-send-email-arozansk@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=cdLMvKyRezEPBUY678xjatliyjxbdGptCNVrJgJa06M=;
        b=jTUpYXqHllDSGpWaUER7Uq2vctOo59ep1JvbVx4ospU6NWtNrEzlIEbnUCVEoQzC4Z
         orIqU+i4SKJuYEQCY2rGD6v4dwI7/lGS1Y8ZGP8AFv5364i6cR9s7ahRoRfJ6JPRPWHK
         jDm1PvwrhofMTt7LkKhzypi7BbB5yIumPkrz/ST5Ml45PHN9oRgmX7hvKHlU/46tN34v
         KgnmuoqJTczytv52+rIXYkcvNI2/QMrbbKMDod7BPOxwchBvVlaiJ7cTx1k72xNpXNAG
         oK+a9riIYHpf+dFXN9yDB3lq2vCbnzdvPoWlatt+BFwNt0IMq3CBt5wzMKYj5YxyaMjM
         nX6g==
In-Reply-To: <1445634150-27992-1-git-send-email-arozansk@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <arozansk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, cgroups@vger.kernel.org

On Fri, 23 Oct 2015, Aristeu Rozanski wrote:

> One of the largest chunks of log messages in a OOM is from dump_stack() and in
> some cases it isn't even necessary to figure out what's going on. In
> systems with multiple tenants/containers with limited resources each
> OOMs can be way more frequent and being able to reduce the amount of log
> output for each situation is useful.
> 
> This patch adds a sysctl to allow disabling dump_stack() during an OOM while
> keeping the default to behave the same way it behaves today.
> 
> Cc: Greg Thelen <gthelen@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: linux-mm@kvack.org
> Cc: cgroups@vger.kernel.org
> Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

There's lots of information in the oom log that is irrelevant depending on 
the context in which the oom condition occurred.  Removing the stack trace 
would have made things like commit 9a185e5861e8 ("/proc/stat: convert to 
single_open_size()") harder to fix.  In that case, we were calling the oom 
killer on large file reads from procfs when we could have easily have 
used vmalloc() instead.

When you have a memcg oom kill, the state of the system's memory can 
usually be suppressed because it only occurred because a memcg hierarchy 
reached its limit and has nothing to do with the exhaustion of RAM.

We already control oom output with global sysctls like vm.oom_dump_tasks 
and memcg tunables like memory.oom_verbose.  I'm not sure that adding more 
and more tunables simply to control the oom killer output is in the best 
interest of either procfs or a long-term maintainable kernel.

I can understand the usefulness of having a very small amount of output to 
the kernel log and then enabling tunables to investigate why oom kills are 
happening, but in many situations I've found to only have the oom killer 
output left behind in a kernel log and the situation is not on-going so I 
can't start diagnosing the problem if I don't know what triggered it.

I think adding additional sysctls to control oom killer output is in the 
wrong direction.  I do agree with removing anything that is irrelevant in 
all situations, however.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
