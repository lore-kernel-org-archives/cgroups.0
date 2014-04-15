From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm/memcontrol.c: make mem_cgroup_read_stat() read all
 interested stat item in one go
Date: Mon, 14 Apr 2014 21:52:24 -0400
Message-ID: <20140415015224.GB7969@cmpxchg.org>
References: <1397149868-30401-1-git-send-email-nasa4836@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=dDp8f2lnvHpFVbwhB5bKZIcPfWD9YCuFM3XfuYKXV1M=;
	b=pboVKU5IeQIpQ/VQ0Xc8EhyU0RRaG8C9a1MEBkV+JENT4dHxp7zj3iPybsqW6fKGVW6SeK6SgCQDzge6Z8uNrPbDOnm5wzbL6v/jWvOQvWYEfEgnjnTBE2xGWDYCBCpV0kGfQvrqaAEJJMYwpx0uiaYc1UsvJbSw8mnVlCXk+Uc=;
Content-Disposition: inline
In-Reply-To: <1397149868-30401-1-git-send-email-nasa4836@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hi Jianyu,

On Fri, Apr 11, 2014 at 01:11:08AM +0800, Jianyu Zhan wrote:
> Currently, mem_cgroup_read_stat() is used for user interface. The
> user accounts memory usage by memory cgroup and he _always_ requires
> exact value because he accounts memory. So we don't use quick-and-fuzzy
> -read-and-do-periodic-synchronization way. Thus, we iterate all cpus
> for one read.
> 
> And we mem_cgroup_usage() and mem_cgroup_recursive_stat() both finally
> call into mem_cgroup_read_stat().
> 
> However, these *stat snapshot* operations are implemented in a quite
> coarse way: it takes M*N iteration for each stat item(M=nr_memcgs,
> N=nr_possible_cpus). There are two deficiencies:
> 
> 1. for every stat item, we have to iterate over all percpu value, which
>    is not so cache friendly.
> 2. for every stat item, we call mem_cgroup_read_stat() once, which
>    increase the probablity of contending on pcp_counter_lock.
> 
> So, this patch improve this a bit. Concretely, for all interested stat
> items, mark them in a bitmap, and then make mem_cgroup_read_stat() read
> them all in one go.
> 
> This is more efficient, and to some degree make it more like *stat snapshot*.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  mm/memcontrol.c | 91 +++++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 62 insertions(+), 29 deletions(-)

This is when the user reads statistics or when OOM happens, neither of
which I would consider fast paths.  I don't think it's worth the extra
code, which looks more cumbersome than what we have.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
