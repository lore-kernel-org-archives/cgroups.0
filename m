From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH RFC] mm/memcontrol: reclaim severe usage over high limit
 in get_user_pages loop
Date: Mon, 29 Jul 2019 11:17:38 +0200
Message-ID: <20190729091738.GF9330@dhcp22.suse.cz>
References: <156431697805.3170.6377599347542228221.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <156431697805.3170.6377599347542228221.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>

On Sun 28-07-19 15:29:38, Konstantin Khlebnikov wrote:
> High memory limit in memory cgroup allows to batch memory reclaiming and
> defer it until returning into userland. This moves it out of any locks.
> 
> Fixed gap between high and max limit works pretty well (we are using
> 64 * NR_CPUS pages) except cases when one syscall allocates tons of
> memory. This affects all other tasks in cgroup because they might hit
> max memory limit in unhandy places and\or under hot locks.
> 
> For example mmap with MAP_POPULATE or MAP_LOCKED might allocate a lot
> of pages and push memory cgroup usage far ahead high memory limit.
> 
> This patch uses halfway between high and max limits as threshold and
> in this case starts memory reclaiming if mem_cgroup_handle_over_high()
> called with argument only_severe = true, otherwise reclaim is deferred
> till returning into userland. If high limits isn't set nothing changes.
> 
> Now long running get_user_pages will periodically reclaim cgroup memory.
> Other possible targets are generic file read/write iter loops.

I do see how gup can lead to a large high limit excess, but could you be
more specific why is that a problem? We should be reclaiming the similar
number of pages cumulatively.
-- 
Michal Hocko
SUSE Labs
