From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] Documentation: Clarify usage of memory limits
Date: Thu, 1 Jun 2023 15:36:30 -0400
Message-ID: <20230601193630.GA157732@cmpxchg.org>
References: <20230601183820.3839891-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1685648191; x=1688240191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YMBOA4WH9GmX8va2TeN6IF1hKckQ4hk2vM+qJu7Yuk8=;
        b=JKQScWQlepZwk1rwr8D4B8rhFPkzPfrRjo7oBWfw+nEP9EfqxAcT+QW4osjwPhmT5Q
         ZQV6JWXs8rJRB3wOSil33aA6VH95iOYN6NoX5pyxPzvm5t4sMk6BhLLDlzYUm0BDj51b
         NzeK/c8Vw1d6f0CTxvogTrH8Jj3bZjQMBYb3ccX2/bMjCwpvFGw6aikcmLyNiBcs4KEU
         czOUcxsiQkOFgG8W7JYe0fmkQADh9wc7yDtbyUxt+Mn4vHqjpz7R6q6mj9tnNkmcZpcb
         6qOD1px5L7EOtewVnd2LWHez4iP7SCtbcRjjzfJCt5Ov8Ju3NzRD7iK3yEysqmi3RAWk
         z6WA==
Content-Disposition: inline
In-Reply-To: <20230601183820.3839891-1-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

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

Yeah, this is quite stale. How this ended up working in practice is a
bit different from how we initially conceived it.

Thanks for updating it.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
