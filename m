From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/4] mm: memcontrol: re-use global VM event enum
Date: Mon, 10 Apr 2017 10:13:34 -0400
Message-ID: <20170410141334.GA16119@cmpxchg.org>
References: <20170404220148.28338-1-hannes@cmpxchg.org>
 <20170404220148.28338-2-hannes@cmpxchg.org>
 <20170407124702.GE16413@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3Jf5Nrkp++mI1xdujs2DIrXE+lI2rarkosOeWpYm2SQ=; b=qrez5+/DpkIh8rhYtN9YMs0tOK
	VFlF44Meb+LfFtYwVTefzLJJ0JXEudsx2jrK4lqHxKTbFzd3JPoQzI1kOeOEX0sJZsH1qblXWvixw
	kku2u3XHWJWtDygrS+cSzq/z2TiZFnq6i48QTeNz3IXXibQw1A+EhdEprHNwCfL6B/0k=;
Content-Disposition: inline
In-Reply-To: <20170407124702.GE16413@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Apr 07, 2017 at 02:47:02PM +0200, Michal Hocko wrote:
> I do agree that we should share global and memcg specific events constants
> but I am not sure we want to share all of them. Would it make sense to
> reorganize the global enum and put those that are shared to the
> beginning? We wouldn't need the memcg specific translation then.

I'm not sure I follow. Which translation?

> Anyway, two comments on the current implementation.
> 
> On Tue 04-04-17 18:01:46, Johannes Weiner wrote:
> [...]
> > +/* Cgroup-specific events, on top of universal VM events */
> > +enum memcg_event_item {
> > +	MEMCG_LOW = NR_VM_EVENT_ITEMS,
> > +	MEMCG_HIGH,
> > +	MEMCG_MAX,
> > +	MEMCG_OOM,
> > +	MEMCG_NR_EVENTS,
> > +};
> 
> The above should mention that each supported global VM event should
> provide the corresponding translation
> 
> [...]
> 
> here...
> > +/* Universal VM events cgroup1 shows, original sort order */
> > +unsigned int memcg1_events[] = {
> > +	PGPGIN,
> > +	PGPGOUT,
> > +	PGFAULT,
> > +	PGMAJFAULT,
> > +};
> > +
> > +static const char *const memcg1_event_names[] = {
> > +	"pgpgin",
> > +	"pgpgout",
> > +	"pgfault",
> > +	"pgmajfault",
> > +};
> 
> the naming doesn't make it easier to undestand why we need this.
> global2memcg_event?

This is just to keep the file order consistent. It could have been
done like memory.stat in cgroup2, where we simply do

   seq_printf(s, "pgmajfault %lu\n", stat[PGMAJFAULT]);

but I didn't want to change the v1 code too much. So these two arrays
are just a sorted list of global VM events shown in v1's memory.stat.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
