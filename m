From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: memcontrol: reclaim when shrinking memory.high below
 usage
Date: Fri, 11 Mar 2016 09:42:39 +0100
Message-ID: <20160311084238.GE27701@dhcp22.suse.cz>
References: <1457643015-8828-1-git-send-email-hannes@cmpxchg.org>
 <20160311083440.GI1946@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160311083440.GI1946@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri 11-03-16 11:34:40, Vladimir Davydov wrote:
> On Thu, Mar 10, 2016 at 03:50:13PM -0500, Johannes Weiner wrote:
> > When setting memory.high below usage, nothing happens until the next
> > charge comes along, and then it will only reclaim its own charge and
> > not the now potentially huge excess of the new memory.high. This can
> > cause groups to stay in excess of their memory.high indefinitely.
> > 
> > To fix that, when shrinking memory.high, kick off a reclaim cycle that
> > goes after the delta.
> 
> I agree that we should reclaim the high excess, but I don't think it's a
> good idea to do it synchronously. Currently, memory.low and memory.high
> knobs can be easily used by a single-threaded load manager implemented
> in userspace, because it doesn't need to care about potential stalls
> caused by writes to these files. After this change it might happen that
> a write to memory.high would take long, seconds perhaps, so in order to
> react quickly to changes in other cgroups, a load manager would have to
> spawn a thread per each write to memory.high, which would complicate its
> implementation significantly.

Is the complication on the managing part really an issue though. Such a
manager would have to spawn a process/thread to change the .max already.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
