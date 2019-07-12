From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] numa: introduce per-cgroup numa balancing locality,
 statistic
Date: Fri, 12 Jul 2019 09:58:15 +0200
Message-ID: <20190712075815.GN3402@hirez.programming.kicks-ass.net>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
 <3ac9b43a-cc80-01be-0079-df008a71ce4b@linux.alibaba.com>
 <20190711134754.GD3402@hirez.programming.kicks-ass.net>
 <b027f9cc-edd2-840c-3829-176a1e298446@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LtqSlKZWetZ9uGFV2K19vEGagHhsXV8pg3vWp1m725Y=; b=V/iJunfl8ealcixJfAjaVt7Vrd
        tQUwwlpOMrfElHa7L5+1G8ivCqLA+QLKj++7et5n8GxiXViFsXqzO+QKB50yOVHqQJqPj63zR7Mz/
        oni9H7rrI0E/MaIPnNyX2MvDdFRFA0l6aIhPXeI0fJroCJs0BvecfAMR6kPmcfRvkfXcoZAJqZv39
        WH7yKi2rPXVO0Ik5pkgDA4sGvIwc9mD+A2jkIDR21O9JacqiJHxs/qgg/VPYPQB10dOMf4lUH9bDx
        wAmbgeQC11Xxo56c1HakyQocSdLZdhESnCzqS4A3/c4YMXSo8zEBk+A9qp7YhvUXI29jz1M9lnF0l
Content-Disposition: inline
In-Reply-To: <b027f9cc-edd2-840c-3829-176a1e298446@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org, keescook@chromium.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, riel@surriel.com

On Fri, Jul 12, 2019 at 11:43:17AM +0800, 王贇 wrote:
> 
> 
> On 2019/7/11 下午9:47, Peter Zijlstra wrote:
> [snip]
> >> +	rcu_read_lock();
> >> +	memcg = mem_cgroup_from_task(p);
> >> +	if (idx != -1)
> >> +		this_cpu_inc(memcg->stat_numa->locality[idx]);
> > 
> > I thought cgroups were supposed to be hierarchical. That is, if we have:
> > 
> >           R
> > 	 / \
> > 	 A
> > 	/\
> > 	  B
> > 	  \
> > 	   t1
> > 
> > Then our task t1 should be accounted to B (as you do), but also to A and
> > R.
> 
> I get the point but not quite sure about this...
> 
> Not like pages there are no hierarchical limitation on locality, also tasks

You can use cpusets to affect that.

> running in a particular group have no influence to others, not to mention the
> extra overhead, does it really meaningful to account the stuff hierarchically?

AFAIU it's a requirement of cgroups to be hierarchical. All our other
cgroup accounting is like that.
