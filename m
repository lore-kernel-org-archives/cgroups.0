From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 6/9] mm: memcontrol: remove ordering between
 pc->mem_cgroup and PageCgroupUsed
Date: Tue, 27 May 2014 15:45:00 -0400
Message-ID: <20140527194500.GC2878@cmpxchg.org>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-7-git-send-email-hannes@cmpxchg.org>
 <20140523132043.GB22135@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=r7jMvOwoanFiqhkGx80OYlRVVcOGSM/+B26WnsiEZbs=;
	b=rOEM7ImoikXPMNMBH//qCFHWU132d+ypfe9Ffi+CZxY2cRbHmoJ9l7pF8NBgmvcTEZxFXO5u8vbzLBDmsmopsoPs9H2eVT94BWbf499YN8cC/hHeGrG1kegJk31w+LHupRu8X9k1YeSEJBjg3MPYJQr2niug7J1PfK7c/rErb9w=;
Content-Disposition: inline
In-Reply-To: <20140523132043.GB22135@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 03:20:43PM +0200, Michal Hocko wrote:
> On Wed 30-04-14 16:25:40, Johannes Weiner wrote:
> > There is a write barrier between setting pc->mem_cgroup and
> > PageCgroupUsed, which was added to allow LRU operations to lookup the
> > memcg LRU list of a page without acquiring the page_cgroup lock.  But
> > ever since 38c5d72f3ebe ("memcg: simplify LRU handling by new rule"),
> > pages are ensured to be off-LRU while charging, so nobody else is
> > changing LRU state while pc->mem_cgroup is being written.
> 
> This is quite confusing. Why do we have the lrucare path then?

Some charge paths start with the page on the LRU, lrucare makes sure
it's off during the charge.

> The code is quite tricky so this deserves a more detailed explanation
> IMO.
> 
> There are only 3 paths which check both the flag and mem_cgroup (
> without page_cgroup_lock) get_mctgt_type* and mem_cgroup_page_lruvec AFAICS.
> None of them have rmb so there was no guarantee about ordering anyway.

Yeah, exactly.  As per the changelog, this is a remnant of the way it
used to work but it's no longer needed because of guaranteed off-LRU
state.

> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Anyway, the change is welcome
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
