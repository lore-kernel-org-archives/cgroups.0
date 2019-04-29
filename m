From: Michal Hocko <mhocko@kernel.org>
Subject: Re: memcg causes crashes in list_lru_add
Date: Mon, 29 Apr 2019 12:17:32 +0200
Message-ID: <20190429101732.GB21837@dhcp22.suse.cz>
References: <f0cfcfa7-74d0-8738-1061-05d778155462@suse.cz>
 <2cbfb8dc-31f0-7b95-8a93-954edb859cd8@suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2cbfb8dc-31f0-7b95-8a93-954edb859cd8@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Slaby <jslaby@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, mm <linux-mm@kvack.org>, Linux kernel mailing list <linux-kernel@vger.kernel.org>

On Mon 29-04-19 11:25:48, Jiri Slaby wrote:
> On 29. 04. 19, 10:16, Jiri Slaby wrote:
[...]
> > Any idea how to fix this mess?
> 
> memcg_update_all_list_lrus should take care about resizing the array. So
> it looks like list_lru_from_memcg_idx returns a stale pointer to
> list_lru_from_kmem and then to list_lru_add. Still investigating.

I am traveling and on a conference this week. Please open a bug and if
this affects upstream kernel then report upstream as well. Cc linux-mm
and memcg maintainers. This doesn't ring bells immediately. I do not
remember any large changes recently.
-- 
Michal Hocko
SUSE Labs
