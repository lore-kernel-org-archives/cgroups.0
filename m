From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Documentation: Clarify usage of memory limits
Date: Mon, 5 Jun 2023 14:09:15 -1000
Message-ID: <ZH55K79CaSD6Zya1@slm.duckdns.org>
References: <20230601183820.3839891-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686010158; x=1688602158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z84IZvmzWip89Eeas0z1NQsVyFYK452XIFdNItStgJo=;
        b=hrqPYRMhlf3i8gMrJ2AXc9LXwaaiJbiN9/s2TQXdJBJ80dtZzCntUtMbGD2yPaR5t5
         69JVQjlA6r1ljlN6bELt0TBdxnRRM5Qd38lMvlwgZl3QW2RcW8IKKaMk9TI9vHddTgf0
         zWD5mwak9jULNMU8vsOsHm3u3WdT4TsJ7yIj8yNPECuaKt4x8XSYr0GoUBgMmHdf1MLw
         sfdoULkhA9K/77al/u3iWAO4LxhuwtSxgJWqZyjLUn4wFOt0+Q7XPZ9OM9pTDsfrHgmU
         gtIxFiWJyF/Cbg4jEBFUi2UoSQBYmOzRMzPIWY0nKZK+LtC4TqdUOZnq6RqFg6/7PBfS
         OzNg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230601183820.3839891-1-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Chris Down <chris@chrisdown.name>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

Hello,

On Thu, Jun 01, 2023 at 11:38:19AM -0700, Dan Schatzberg wrote:
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
> 
> Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>

Applied to cgroup/for-6.4-fixes. Please see below for a comment tho.

> @@ -1213,23 +1213,25 @@ PAGE_SIZE multiple when read back.
>  	A read-write single value file which exists on non-root
>  	cgroups.  The default is "max".
>  
> -	Memory usage throttle limit.  This is the main mechanism to
> -	control memory usage of a cgroup.  If a cgroup's usage goes
> +	Memory usage throttle limit.  If a cgroup's usage goes
>  	over the high boundary, the processes of the cgroup are
>  	throttled and put under heavy reclaim pressure.
>  
>  	Going over the high limit never invokes the OOM killer and
> -	under extreme conditions the limit may be breached.
> +	under extreme conditions the limit may be breached. The high
> +	limit should be used in scenarios where an external process
> +	monitors the limited cgroup to alleviate heavy reclaim
> +	pressure.

I think it'd be helpful to provide pointers to oomd and systemd's
implementation of it here.

Thanks.

-- 
tejun
