From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] writeback, memcg: Implement foreign dirty flushing
Date: Wed, 7 Aug 2019 11:34:34 -0700
Message-ID: <20190807183434.GN136335@devbig004.ftw2.facebook.com>
References: <20190803140155.181190-1-tj@kernel.org>
 <20190803140155.181190-5-tj@kernel.org>
 <20190806160306.5330bd4fdddf357db4b7086c@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TEd6gatoycG7ZYK/wRTlCi/eISRx26y7juuHAC9jUEs=;
        b=R644OPU+lCko3k9nDXGu9/A/vuDcJn94rJoMUPsDRCffxsG+isnp+BHBLQmc2K644e
         66mQuGkZTGxAke75vOwmSvJK6B7tThNNgU17Mmy0pGVSIX7MQcF/72c5IwF+SVKe2+/9
         3vXSRys0roMn1jdcB9qW6Ab8phv2F8C6FUUrmfEUu1zHhqC8meLDYyMaehtDUQwJF5bQ
         Y8GRTNQsLFdruJQs1xnvhyznDmk+7799OjLS/bJHXjEXyrGCjSTajeSkhizcSbuqKREl
         DPUrIKRtYKK8ndWxQKW2D8e2SYP9w65swXBr4FQtUapMvV0tAHkSYCN+X0SubrlfmUMZ
         lRmQ==
Content-Disposition: inline
In-Reply-To: <20190806160306.5330bd4fdddf357db4b7086c@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: axboe@kernel.dk, jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com

Hello,

On Tue, Aug 06, 2019 at 04:03:06PM -0700, Andrew Morton wrote:
> > +	if (i < MEMCG_CGWB_FRN_CNT) {
> > +		unsigned long update_intv =
> > +			min_t(unsigned long, HZ,
> > +			      msecs_to_jiffies(dirty_expire_interval * 10) / 8);
> 
> An explanation of what's going on here would be helpful.
> 
> Why "* 1.25" and not, umm "* 1.24"?

Just because /8 is cheaper.  It's likely that a fairly wide range of
numbers are okay for the above.  I'll add some comment to explain that
and why the specific constants are picked.

> > +void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
> > +{
> > +	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
> > +	unsigned long intv = msecs_to_jiffies(dirty_expire_interval * 10);
> 
> Ditto.

This is just dirty expiration.  If the dirty data has expired,
writeback must already be in progress by its bdi_wb, so there's no
reason to scheduler foreign writeback.  Will add a comment.

Thanks.

-- 
tejun
