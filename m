From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] writeback, memcg: Implement cgroup_writeback_by_id()
Date: Thu, 15 Aug 2019 08:43:02 -0700
Message-ID: <20190815154302.GB588936@devbig004.ftw2.facebook.com>
References: <20190803140155.181190-1-tj@kernel.org>
 <20190803140155.181190-4-tj@kernel.org>
 <20190815140535.GJ14313@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VSR3T6Q49rCFXPPoyb9XFgF2ejksN7y0WyTo3YMYamM=;
        b=hyuuAh2CNIxYP3ggj8gDm8R4p/9az4kHrRaL6c7xkvVmp5KasB2iSYzUaAGIeZjGiM
         A95PrUyUJC+0/lW0z1W+odNW7+/4tOmRmm6g86Fh0uQd7iEZ7NQH9paD1ey8Ro+yUg4g
         y3VeNucMGXfPbFqNNe2fdHGkico4kMYi0IGp8QW1kdMhBhiJeExKMtbS0t6bdR0K3WmR
         I+szM8wY4iywtp965t3+afNr0ujT0/Y5OO7fs8HNBxXO9ilORnMG3/ZqeRVzaRoWWy1f
         y2cWJTQHxaLlPv/FNGs6kLzLnFQz0yqnp8YocfIMbukfVsK2R/XaBg8GPyF6ZzZ2cszC
         /M0g==
Content-Disposition: inline
In-Reply-To: <20190815140535.GJ14313@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

On Thu, Aug 15, 2019 at 04:05:35PM +0200, Jan Kara wrote:
> > +int cgroup_writeback_by_id(u64 bdi_id, int memcg_id, unsigned long nr_pages,
> > +			   enum wb_reason reason, struct wb_completion *done);
> > +int writeback_by_id(int id, unsigned long nr, enum wb_reason reason,
> > +		    struct wb_completion *done);
> 
> I guess this writeback_by_id() is stale? I didn't find it anywhere else...

Yes, removed.

Thanks.

-- 
tejun
