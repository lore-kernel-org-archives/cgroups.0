From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Wed, 23 Jul 2014 11:36:38 -0400
Message-ID: <20140723153638.GG1725@cmpxchg.org>
References: <20140715121935.GB9366@dhcp22.suse.cz>
 <20140718071246.GA21565@dhcp22.suse.cz>
 <20140718144554.GG29639@cmpxchg.org>
 <CAJfpegt9k+YULet3vhmG3br7zSiHy-DRL+MiEE=HRzcs+mLzbw@mail.gmail.com>
 <20140719173911.GA1725@cmpxchg.org>
 <20140722150825.GA4517@dhcp22.suse.cz>
 <CAJfpegscT-ptQzq__uUV2TOn7Uvs6x4FdWGTQb9Fe9MEJr2KjA@mail.gmail.com>
 <20140723143847.GB16721@dhcp22.suse.cz>
 <20140723150608.GF1725@cmpxchg.org>
 <20140723151909.GC16721@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=gahSqJjUiT4ZWBGU8JALlbDOy9N4K47kIJqUjtcjzWc=;
	b=TO7UnpF0Ec6gJAZjeRq1UWA6bXe0fUjW12gHHCk/w/CyDbVYhHsYx9UidAy/u/rblHxF9DQgsEuW8BrTxmfUJEwpbCBisLykRyRzUFs3RRbNylewwcvg12TcRfanir+G4dbAj5fleMVSMsOEfeuTRdxAdGeX0H9xqjh8SiOhy1A=;
Content-Disposition: inline
In-Reply-To: <20140723151909.GC16721@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, Jul 23, 2014 at 05:19:09PM +0200, Michal Hocko wrote:
> On Wed 23-07-14 11:06:08, Johannes Weiner wrote:
> > On Wed, Jul 23, 2014 at 04:38:47PM +0200, Michal Hocko wrote:
> [...]
> > > OK, thanks for the clarification. I had this feeling but couldn't wrap
> > > my head around the indirection of the code.
> > > 
> > > It seems that checkig PageCgroupUsed(new) and bail out early in
> > > mem_cgroup_migrate should just work, no?
> > 
> > If the new page is already charged as page cache, we could just drop
> > the call to mem_cgroup_migrate() altogether.
> 
> Yeah, it is just that we do not want to do all the
> page->page_cgroup->PageCgroupUsed thing in replace_page_cache_page.

If the new page is *always* already charged as cache, there is no
reason to even check PageCgroupUsed.  We wouldn't have to do anything
at this point.  The old code had to, because pages were uncharged
during truncation, but now we could just carry the original charge
across truncation and the re-use as replacement page, and then
uncharge the old page.  No migration necessary.

That's why I'm asking if newpage is always charged truncated page
cache, or whether it can be something else.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
