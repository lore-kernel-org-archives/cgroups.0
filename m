From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] Documentation: Clarify usage of memory limits
Date: Thu, 1 Jun 2023 15:15:28 -0400
Message-ID: <e6ae97f4-cdae-e655-d118-a11b3d679fd6@redhat.com>
References: <20230601183820.3839891-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685646935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sTw7D4C+tdrDjUAl3eL33ndjxBJJWM8+IdlGnpSawqo=;
        b=h6PBIzajQ/GDMTjuw8eGYueQBUAGg5JwMQDTM0oYm27sKOv121/MIeA9d1CV6jCuHxxRzL
        i8ryzcPpiO/i79Zp011GuuyZNTiRPUxVdOXeLikJag027Apkp3o8pcPNnuWgrz32gQdTyb
        sQtH+fjAwxfnI93KuIdz9rapi2iQf5A=
Content-Language: en-US
In-Reply-To: <20230601183820.3839891-1-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dan Schatzberg <schatzberg.dan@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

On 6/1/23 14:38, Dan Schatzberg wrote:
> The existing documentation refers to memory.high as the "main mechanism
> to control memory usage." This seems incorrect to me - memory.high can
> result in reclaim pressure which simply leads to stalls unless some
> external component observes and actions on it (e.g. systemd-oomd can be
> used for this purpose). While this is feasible, users are unaware of
> this interaction and are led to believe that memory.high alone is an
> effective mechanism for limiting memory.
>
> The documentation should recommend the use of memory.max as the
> effective way to enforce memory limits - it triggers reclaim and results
> in OOM kills by itself.

That is not how my understanding of memory.high works. When memory usage 
goes past memory.high, memory reclaim will be initiated to reclaim the 
memory back. Stall happens when memory.usage keep increasing like by 
consuming memory faster than what memory reclaim can recover. When 
memory.max is reached, OOM killer will then kill off the tasks.

IOW, memory consumption should not go past memory.high in normal usage 
scenario. I believe what you describe here isn't quite correct.

Cheers,
Longman

> Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
> ---
>   Documentation/admin-guide/cgroup-v2.rst | 22 ++++++++++------------
>   1 file changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index f67c0829350b..e592a9364473 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1213,23 +1213,25 @@ PAGE_SIZE multiple when read back.
>   	A read-write single value file which exists on non-root
>   	cgroups.  The default is "max".
>   
> -	Memory usage throttle limit.  This is the main mechanism to
> -	control memory usage of a cgroup.  If a cgroup's usage goes
> +	Memory usage throttle limit.  If a cgroup's usage goes
>   	over the high boundary, the processes of the cgroup are
>   	throttled and put under heavy reclaim pressure.
>   
>   	Going over the high limit never invokes the OOM killer and
> -	under extreme conditions the limit may be breached.
> +	under extreme conditions the limit may be breached. The high
> +	limit should be used in scenarios where an external process
> +	monitors the limited cgroup to alleviate heavy reclaim
> +	pressure.
>   
>     memory.max
>   	A read-write single value file which exists on non-root
>   	cgroups.  The default is "max".
>   
> -	Memory usage hard limit.  This is the final protection
> -	mechanism.  If a cgroup's memory usage reaches this limit and
> -	can't be reduced, the OOM killer is invoked in the cgroup.
> -	Under certain circumstances, the usage may go over the limit
> -	temporarily.
> +	Memory usage hard limit.  This is the main mechanism to limit
> +	memory usage of a cgroup.  If a cgroup's memory usage reaches
> +	this limit and can't be reduced, the OOM killer is invoked in
> +	the cgroup. Under certain circumstances, the usage may go
> +	over the limit temporarily.
>   
>   	In default configuration regular 0-order allocations always
>   	succeed unless OOM killer chooses current task as a victim.
> @@ -1238,10 +1240,6 @@ PAGE_SIZE multiple when read back.
>   	Caller could retry them differently, return into userspace
>   	as -ENOMEM or silently ignore in cases like disk readahead.
>   
> -	This is the ultimate protection mechanism.  As long as the
> -	high limit is used and monitored properly, this limit's
> -	utility is limited to providing the final safety net.
> -
>     memory.reclaim
>   	A write-only nested-keyed file which exists for all cgroups.
>   

