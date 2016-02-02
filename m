From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v2 1/5] mm: memcontrol: generalize locking for the
 page->mem_cgroup binding
Date: Tue, 2 Feb 2016 17:18:25 +0300
Message-ID: <20160202141825.GB21016@esperanza>
References: <1454090047-1790-1-git-send-email-hannes@cmpxchg.org>
 <1454090047-1790-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454090047-1790-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Jan 29, 2016 at 12:54:03PM -0500, Johannes Weiner wrote:
> So far the only sites that needed to exclude charge migration to
> stabilize page->mem_cgroup have been per-cgroup page statistics, hence
> the name mem_cgroup_begin_page_stat(). But per-cgroup thrash detection
> will add another site that needs to ensure page->mem_cgroup lifetime.
> 
> Rename these locking functions to the more generic lock_page_memcg()
> and unlock_page_memcg(). Since charge migration is a cgroup1 feature
> only, we might be able to delete it at some point, and these now easy
> to identify locking sites along with it.
> 
> Suggested-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
