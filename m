From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Wed, 23 Jul 2014 17:19:09 +0200
Message-ID: <20140723151909.GC16721@dhcp22.suse.cz>
References: <20140715082545.GA9366@dhcp22.suse.cz>
 <20140715121935.GB9366@dhcp22.suse.cz>
 <20140718071246.GA21565@dhcp22.suse.cz>
 <20140718144554.GG29639@cmpxchg.org>
 <CAJfpegt9k+YULet3vhmG3br7zSiHy-DRL+MiEE=HRzcs+mLzbw@mail.gmail.com>
 <20140719173911.GA1725@cmpxchg.org>
 <20140722150825.GA4517@dhcp22.suse.cz>
 <CAJfpegscT-ptQzq__uUV2TOn7Uvs6x4FdWGTQb9Fe9MEJr2KjA@mail.gmail.com>
 <20140723143847.GB16721@dhcp22.suse.cz>
 <20140723150608.GF1725@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140723150608.GF1725-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed 23-07-14 11:06:08, Johannes Weiner wrote:
> On Wed, Jul 23, 2014 at 04:38:47PM +0200, Michal Hocko wrote:
[...]
> > OK, thanks for the clarification. I had this feeling but couldn't wrap
> > my head around the indirection of the code.
> > 
> > It seems that checkig PageCgroupUsed(new) and bail out early in
> > mem_cgroup_migrate should just work, no?
> 
> If the new page is already charged as page cache, we could just drop
> the call to mem_cgroup_migrate() altogether.

Yeah, it is just that we do not want to do all the
page->page_cgroup->PageCgroupUsed thing in replace_page_cache_page.

-- 
Michal Hocko
SUSE Labs
