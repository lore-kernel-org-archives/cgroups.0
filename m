From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm/memcontrol: update lruvec counters in
 mem_cgroup_move_account
Date: Tue, 15 Oct 2019 13:04:01 +0200
Message-ID: <20191015110401.GZ317@dhcp22.suse.cz>
References: <157112699975.7360.1062614888388489788.stgit@buzz>
 <20191015082048.GU317@dhcp22.suse.cz>
 <3b73e301-ea4a-5edb-9360-2ae9b4ad9f69@yandex-team.ru>
 <20191015103623.GX317@dhcp22.suse.cz>
 <31cab57d-6e79-33cb-1a58-99065c6e7b82@yandex-team.ru>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <31cab57d-6e79-33cb-1a58-99065c6e7b82@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>

On Tue 15-10-19 13:49:14, Konstantin Khlebnikov wrote:
> On 15/10/2019 13.36, Michal Hocko wrote:
> > On Tue 15-10-19 11:44:22, Konstantin Khlebnikov wrote:
> > > On 15/10/2019 11.20, Michal Hocko wrote:
> > > > On Tue 15-10-19 11:09:59, Konstantin Khlebnikov wrote:
> > > > > Mapped, dirty and writeback pages are also counted in per-lruvec stats.
> > > > > These counters needs update when page is moved between cgroups.
> > > > 
> > > > Please describe the user visible effect.
> > > 
> > > Surprisingly I don't see any users at this moment.
> > > So, there is no effect in mainline kernel.
> > 
> > Those counters are exported right? Or do we exclude them for v1?
> 
> It seems per-lruvec statistics is not exposed anywhere.
> And per-lruvec NR_FILE_MAPPED, NR_FILE_DIRTY, NR_WRITEBACK never had users.

So why do we have it in the first place? I have to say that counters
as we have them now are really clear as mud. This is really begging for
a clean up.
-- 
Michal Hocko
SUSE Labs
