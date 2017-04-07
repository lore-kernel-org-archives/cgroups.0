From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/4] mm: memcontrol: re-use global VM event enum
Date: Fri, 7 Apr 2017 14:47:02 +0200
Message-ID: <20170407124702.GE16413@dhcp22.suse.cz>
References: <20170404220148.28338-1-hannes@cmpxchg.org>
 <20170404220148.28338-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170404220148.28338-2-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

I do agree that we should share global and memcg specific events constants
but I am not sure we want to share all of them. Would it make sense to
reorganize the global enum and put those that are shared to the
beginning? We wouldn't need the memcg specific translation then.

Anyway, two comments on the current implementation.

On Tue 04-04-17 18:01:46, Johannes Weiner wrote:
[...]
> +/* Cgroup-specific events, on top of universal VM events */
> +enum memcg_event_item {
> +	MEMCG_LOW = NR_VM_EVENT_ITEMS,
> +	MEMCG_HIGH,
> +	MEMCG_MAX,
> +	MEMCG_OOM,
> +	MEMCG_NR_EVENTS,
> +};

The above should mention that each supported global VM event should
provide the corresponding translation

[...]

here...
> +/* Universal VM events cgroup1 shows, original sort order */
> +unsigned int memcg1_events[] = {
> +	PGPGIN,
> +	PGPGOUT,
> +	PGFAULT,
> +	PGMAJFAULT,
> +};
> +
> +static const char *const memcg1_event_names[] = {
> +	"pgpgin",
> +	"pgpgout",
> +	"pgfault",
> +	"pgmajfault",
> +};

the naming doesn't make it easier to undestand why we need this.
global2memcg_event?

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
