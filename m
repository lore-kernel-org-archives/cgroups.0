From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] Documentation: Clarify usage of memory limits
Date: Sat, 3 Jun 2023 22:33:50 +0100
Message-ID: <ZHuxvjP4QlsT1saH@chrisdown.name>
References: <20230601183820.3839891-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1685828031; x=1688420031;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPgdBuOb3Mk3v1wiPzP0vcApMpycUA28Au999GkAKxA=;
        b=D3Y8+UlBvD28MImoMBw8EQN27ymlp+CpIHs8DUTXSuWC/2z4HjNVGgQw6xlaEWYl7y
         tBzUH8yq2WdHoBJBJCMkaXOabLKHqgpvAvXB+x2Lq/oldMQ6qb87FFv3ro42Gx3wP4+p
         Sf398UgV54hGA+VSakDaldq+PoP4qE3KtkEIQ=
Content-Disposition: inline
In-Reply-To: <20230601183820.3839891-1-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Dan Schatzberg writes:
>The existing documentation refers to memory.high as the "main mechanism
>to control memory usage." This seems incorrect to me - memory.high can
>result in reclaim pressure which simply leads to stalls unless some
>external component observes and actions on it (e.g. systemd-oomd can be
>used for this purpose). While this is feasible, users are unaware of
>this interaction and are led to believe that memory.high alone is an
>effective mechanism for limiting memory.
>
>The documentation should recommend the use of memory.max as the
>effective way to enforce memory limits - it triggers reclaim and results
>in OOM kills by itself.
>
>Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Oof, the documentation is very out of date indeed -- no wonder people were 
confused by other advice to only use memory.high with something external 
monitoring the cgroup.

Thanks!

Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

>---
> Documentation/admin-guide/cgroup-v2.rst | 22 ++++++++++------------
> 1 file changed, 10 insertions(+), 12 deletions(-)
>
>diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>index f67c0829350b..e592a9364473 100644
>--- a/Documentation/admin-guide/cgroup-v2.rst
>+++ b/Documentation/admin-guide/cgroup-v2.rst
>@@ -1213,23 +1213,25 @@ PAGE_SIZE multiple when read back.
> 	A read-write single value file which exists on non-root
> 	cgroups.  The default is "max".
>
>-	Memory usage throttle limit.  This is the main mechanism to
>-	control memory usage of a cgroup.  If a cgroup's usage goes
>+	Memory usage throttle limit.  If a cgroup's usage goes
> 	over the high boundary, the processes of the cgroup are
> 	throttled and put under heavy reclaim pressure.
>
> 	Going over the high limit never invokes the OOM killer and
>-	under extreme conditions the limit may be breached.
>+	under extreme conditions the limit may be breached. The high
>+	limit should be used in scenarios where an external process
>+	monitors the limited cgroup to alleviate heavy reclaim
>+	pressure.
>
>   memory.max
> 	A read-write single value file which exists on non-root
> 	cgroups.  The default is "max".
>
>-	Memory usage hard limit.  This is the final protection
>-	mechanism.  If a cgroup's memory usage reaches this limit and
>-	can't be reduced, the OOM killer is invoked in the cgroup.
>-	Under certain circumstances, the usage may go over the limit
>-	temporarily.
>+	Memory usage hard limit.  This is the main mechanism to limit
>+	memory usage of a cgroup.  If a cgroup's memory usage reaches
>+	this limit and can't be reduced, the OOM killer is invoked in
>+	the cgroup. Under certain circumstances, the usage may go
>+	over the limit temporarily.
>
> 	In default configuration regular 0-order allocations always
> 	succeed unless OOM killer chooses current task as a victim.
>@@ -1238,10 +1240,6 @@ PAGE_SIZE multiple when read back.
> 	Caller could retry them differently, return into userspace
> 	as -ENOMEM or silently ignore in cases like disk readahead.
>
>-	This is the ultimate protection mechanism.  As long as the
>-	high limit is used and monitored properly, this limit's
>-	utility is limited to providing the final safety net.
>-
>   memory.reclaim
> 	A write-only nested-keyed file which exists for all cgroups.
>
>-- 
>2.34.1
>
