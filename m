From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 1/3] mm: migrate: do not touch page->mem_cgroup of live
 pages
Date: Wed, 3 Feb 2016 12:20:09 +0300
Message-ID: <20160203092009.GE21016@esperanza>
References: <1454109573-29235-1-git-send-email-hannes@cmpxchg.org>
 <1454109573-29235-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454109573-29235-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Jan 29, 2016 at 06:19:31PM -0500, Johannes Weiner wrote:
> Changing a page's memcg association complicates dealing with the page,
> so we want to limit this as much as possible. Page migration e.g. does
> not have to do that. Just like page cache replacement, it can forcibly
> charge a replacement page, and then uncharge the old page when it gets
> freed. Temporarily overcharging the cgroup by a single page is not an
> issue in practice, and charging is so cheap nowadays that this is much
> preferrable to the headache of messing with live pages.
> 
> The only place that still changes the page->mem_cgroup binding of live
> pages is when pages move along with a task to another cgroup. But that
> path isolates the page from the LRU, takes the page lock, and the move
> lock (lock_page_memcg()). That means page->mem_cgroup is always stable
> in callers that have the page isolated from the LRU or locked. Lighter
> unlocked paths, like writeback accounting, can use lock_page_memcg().
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
