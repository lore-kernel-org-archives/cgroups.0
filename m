From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: kernel panic on null pointer on page->mem_cgroup
Date: Mon, 21 Aug 2017 09:02:18 -0400
Message-ID: <20170821130218.GA1371@cmpxchg.org>
References: <20170808010150.4155-1-bradleybolen@gmail.com>
 <20170808162122.GA14689@cmpxchg.org>
 <20170808165601.GA7693@jaegeuk-macbookpro.roam.corp.google.com>
 <20170808173704.GA22887@cmpxchg.org>
 <CADvgSZSn1v-tTpa07ebqr19heQbkzbavdPM_nbRNR1WF-EBnFw@mail.gmail.com>
 <20170808200849.GA1104@cmpxchg.org>
 <20170809014459.GB7693@jaegeuk-macbookpro.roam.corp.google.com>
 <CADvgSZSNn7N3R7+jjeCgns2ZEPtYc6c3MWmkkQ3PA+0LHO_MfA@mail.gmail.com>
 <20170809183825.GA26387@cmpxchg.org>
 <20170810115605.GQ23863@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=o4OnLepSPD+Fgn/QoD3hwZbXrePDwNCQq1I8jeeGB6I=; b=cngxbj3c86pf8BCRbuZenyb7S+
	Uzp/ZbtlXUW9f7gv/uLe0pFfIfl+L3P4VGv+AVuEm4tuO7tcI7hz0DztwZuUSw+sWiQyqDYsmhPK3
	w7XVhIsjGOA7piDL3Z1ao+tELlA9FFogTjMdH0iGnXJlsINgc+1GUy4jGrp9RtVGDUIQ=;
Content-Disposition: inline
In-Reply-To: <20170810115605.GQ23863@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Brad Bolen <bradleybolen@gmail.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 10, 2017 at 01:56:05PM +0200, Michal Hocko wrote:
> On Wed 09-08-17 14:38:25, Johannes Weiner wrote:
> > The issue is that writeback doesn't hold a page reference and the page
> > might get freed after PG_writeback is cleared (and the mapping is
> > unlocked) in test_clear_page_writeback(). The stat functions looking
> > up the page's node or zone are safe, as those attributes are static
> > across allocation and free cycles. But page->mem_cgroup is not, and it
> > will get cleared if we race with truncation or migration.
> 
> Is there anything that prevents us from holding a reference on a page
> under writeback?

Hm, I'm hesitant to add redundant life-time management to the page
there just for memcg, which is not always configured in.

Pinning the memcg instead is slightly more complex, but IMO has the
complexity in a preferrable place.

Would you agree?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
