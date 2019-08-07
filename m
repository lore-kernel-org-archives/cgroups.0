From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] bdi: Add bdi->id
Date: Wed, 7 Aug 2019 13:34:14 -0700
Message-ID: <20190807203414.GA554060@devbig004.ftw2.facebook.com>
References: <20190803140155.181190-1-tj@kernel.org>
 <20190803140155.181190-3-tj@kernel.org>
 <20190806160102.11366694af6b56d9c4ca6ea3@linux-foundation.org>
 <20190807183151.GM136335@devbig004.ftw2.facebook.com>
 <20190807120037.72018c136db40e88d89c05d1@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IC+13V8Mtk7y8HC7bnHIWtqIcy1I5HJyllIeTOClBTQ=;
        b=gA2Gxo3VVUUiZocJ2EWD7FWO7YBQ8ft67UkLPK3AQg2nN2DoElFq/GksGEaLO+Xxs7
         yBG49lmFjj6YiLTjAaIGIQ41gk0yijO+ArJDE8dr0MOM8hPWXP6zZJu4zTmZ5U0pgrQi
         HknnD6KZRyK/MCSoGtYJTTYotU0YW8UoTRgeuRn+pC5MZtc7pzuYv6kj3xs5K4Iq01gZ
         86PLHXMC6iInXVPSj6NydUiB8ADQvz4JihwAriUqmR/FNZBo1PmtDfw6VQ/NCCRIFgf2
         ZxOvpizlKlGxc62Gw+giLRS40hco+rKNH4/JXvGmrSXjrc5JQOrAHKmp7zbC6NOQ0jDG
         Tr4A==
Content-Disposition: inline
In-Reply-To: <20190807120037.72018c136db40e88d89c05d1@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: axboe@kernel.dk, jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com

Hello,

On Wed, Aug 07, 2019 at 12:00:37PM -0700, Andrew Morton wrote:
> OK, but why is recycling a problem?  For example, file descriptors
> recycle as aggressively as is possible, and that doesn't cause any
> trouble.  Presumably recycling is a problem with cgroups because of
> some sort of stale reference problem?

Oh, because there are use cases where the consumers are detached from
the lifetime synchronization.  In this example, the benefit of using
IDs is that memcgs don't need to pin foreign bdi_wb's and just look up
and verify when it wants to flush them.  If we use pointers, we have
to pin the objects which then requires either shooting down those
references with timers or somehow doing reverse lookup to shoot them
down when bdi_wb is taken offline.  If we use IDs which can be
recycling aggressively, there can be pathological cases where remote
flushes are issued on the wrong target possibly repeatedly, which may
or may not be a real problem.

For cgroup ID, the problem is more immediate.  We give out the IDs to
userspace and there is no way to shoot those references down when the
cgroup goes away and the ID gets recycled, so when the user comes back
and asks "I want to attach this bpf program to the cgroup identified
with this ID", we can end up attaching it to the wrong cgroup if we
recycle IDs.  cgroup ended up with two separate IDs, which is kinda
dumb.

tl;dr is that it's either cumbersome or impossible to synchronize the
users of these IDs, so if they get recycled, they end up identifying
the wrong thing.

Thanks.

-- 
tejun
