From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] writeback, memcg: Implement foreign dirty flushing
Date: Thu, 15 Aug 2019 10:31:48 -0700
Message-ID: <20190815173148.GD588936@devbig004.ftw2.facebook.com>
References: <20190803140155.181190-1-tj@kernel.org>
 <20190803140155.181190-5-tj@kernel.org>
 <20190815143404.GK14313@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=no35aRJk15zFWg1jR8wwX86QzYLoUfFHVUo7VWQ/svc=;
        b=N47XHCOSmAXueVA0YYaev8/a4K3QvUHId7wqDd1kKuzb9i0XsPGZt3JSFV4fwHmm1o
         079FfdNxA44u+Lpn9KWO67P5gdQDjS8yLNUwxRyP+az0D6idFOXOvoIL6oT/ByHrYA+e
         5x2GXXGdhLQUUhHxcna9tpQrgumRatQu40F/xy7UzP2oUcoOJ5ObUyU55Ybx+CjVdZVf
         ZGK+QWvr7EafhXZLjXcXxcSaDgonosEcUP9Kh6/WmBW5wIhcwJ7Gd5u11eGiOYvLgYRX
         ruJyUluXJcICik/5Pis1nVgLz6wleggRuqyNbfxBltc6VpOrVEuqmr44g/tLfUNGnReK
         /wxg==
Content-Disposition: inline
In-Reply-To: <20190815143404.GK14313@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

Hello, Jan.

On Thu, Aug 15, 2019 at 04:34:04PM +0200, Jan Kara wrote:
> I have to say I'm a bit nervous about the completely lockless handling
> here. I understand that garbage in the cgwb_frn will just result in this
> mechanism not working and possibly flushing wrong wb's but still it seems a
> bit fragile. But I don't see any cheap way of synchronizing this so I guess
> let's try how this will work in practice.

Yeah, this approach is fundamentally best-effort, so I went for low
overhead and mostly correct operation.  If something like this doesn't
cut it (w/ bug fixes and some polishing over time), my gut feeling is
that we probably should bite the bullet and synchronize cgroup memory
and inode ownerships rather than pushing further on inherently
imprecise mitigation mechanisms.

Thanks.

-- 
tejun
