From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: memcg swap doesn't work in mmotm-2014-07-09-17-08?
Date: Wed, 16 Jul 2014 14:37:27 -0400
Message-ID: <20140716183727.GB29639@cmpxchg.org>
References: <20140716181007.GA8524@nhori.redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=L6PdViiumD97gfxBBK9wW8GFQ8c/T1T2c6ZoCVbWaGk=;
	b=GOKZZS3U0WBED8ciTqYd4VizzPyE9rN4xuL0lGLQYL6aXcm+Xi4N7CXkFpgd8YdjTgjlGhzHeHpOesw7EoujEocYbZt98b5dMC4pumVpTfTprSD/NY7m/vKQgETXRbLja1VTdVG8GXApy1Lxtv5wwhNkWfmOrgLCdIGgIwCoAos=;
Content-Disposition: inline
In-Reply-To: <20140716181007.GA8524@nhori.redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, Naoya Horiguchi <nao.horiguchi@gmail.com>

On Wed, Jul 16, 2014 at 02:10:07PM -0400, Naoya Horiguchi wrote:
> Hi,
> 
> It seems that when a process in some memcg tries to allocate more than
> memcg.limit_in_bytes, oom happens instead of swaping out in
> mmotm-2014-07-09-17-08 (memcg.memsw.limit_in_bytes is large enough).
> It does work in v3.16-rc3, so I think latest patches changed something.
> I'm not familiar with memcg internally, so no idea about what caused it.
> Could you see the problem?

There are a lot of changes in memory and swap accounting, but I can
not reproduce what you are describing: I set up a cgroup with a 100MB
memory limit and an unlimited memory+swap, then start a task in there
that faults 200MB worth of anonymous pages.  The result is 100MB in
memory, 100MB in swap:

cache 0
rss 104267776
rss_huge 0
mapped_file 0
writeback 0
swap 105545728
pgpgin 26367
pgpgout 25950
pgfault 26695
pgmajfault 32
inactive_anon 52285440
active_anon 51982336
inactive_file 0
active_file 0
unevictable 0
hierarchical_memory_limit 104857600
hierarchical_memsw_limit 18446744073709551615

Filename                                Type            Size    Used    Priority
/swapfile                               file            8388604 109800  -1

Could you provide more detail on your configuration and test case?

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
