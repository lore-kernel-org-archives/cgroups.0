From: Tejun Heo <tj@kernel.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Wed, 13 Apr 2016 15:37:34 -0400
Message-ID: <20160413193734.GC20142@htj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LJCEkZuxGVHIcQhA3anbHRqLA4BsAEKktxNMBEOA7JQ=;
        b=c50iozjDsKaFEkF0IyBrfjAktcaQ2jiA9FEk3qNe/SJfpzf6BLkl71EVpDPVsmy9pv
         IFvgQEQQkpsmnYEgRSAuMUJeW+igHsxQKqgDGsGCcEHxdavm4YfT/juvlHP7kZEOYRr8
         yGKeVC3dO8xnHybSXaPYIOOmbebP43AemWUHZcdqKQ+LtLVwM6CDtW5p9srgiJ/0Yzte
         Nt1DZ6XnCqzTEKV94dqBpJlM01VdBd5VtpjL4PphfOz8JS5QVssC1t09CP+fSGMO5HoZ
         krKnxfCkkO4hBTRkPLeb6L1r7ml1bZABCFoaBIDPi8hmnbCQVZRbospUbOTQ5AnPPVTY
         kxMw==
Content-Disposition: inline
In-Reply-To: <20160413192313.GA30260@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, cgroups@vger.kernel.org, Cyril Hrubis <chrubis@suse.cz>, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>

Hello, Michal.

On Wed, Apr 13, 2016 at 09:23:14PM +0200, Michal Hocko wrote:
> I think we can live without lru_add_drain_all() in the migration path.
> We are talking about 4 pagevecs so 56 pages. The charge migration is

Ah, nice.

> racy anyway. What concerns me more is how all this is fragile. It sounds
> just too easy to add a dependency on per-cpu sync work later and
> reintroduce this issue which is quite hard to detect.
> Cannot we come up with something more robust?  Or at least warn when we
> try to use per-cpu workers with problematic locks held?

Yeah, workqueue does limited lockdep annotation but it doesn't
integrate fully with the rest of dependency tracking.  It'd be nice to
have that.  Don't know how to tho.

Thanks.

-- 
tejun
