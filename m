From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 2/2] mm/memcg: Consolidate
 mem_cgroup_resize_[memsw]_limit() functions.
Date: Tue, 9 Jan 2018 15:26:22 -0800
Message-ID: <20180109152622.31ca558acb0cc25a1b14f38c@linux-foundation.org>
References: <20171220135329.GS4831@dhcp22.suse.cz>
	<20180109165815.8329-1-aryabinin@virtuozzo.com>
	<20180109165815.8329-2-aryabinin@virtuozzo.com>
	<CALvZod64eZGKne7jZip_O4_q4yjaRsVWpTRa0pQgRT3guqQkGA@mail.gmail.com>
	<6ba40354-10d8-7955-7932-9dcd05ed5977@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <6ba40354-10d8-7955-7932-9dcd05ed5977@virtuozzo.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>

On Tue, 9 Jan 2018 20:26:33 +0300 Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:

> On 01/09/2018 08:10 PM, Shakeel Butt wrote:
> > On Tue, Jan 9, 2018 at 8:58 AM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
> >> mem_cgroup_resize_limit() and mem_cgroup_resize_memsw_limit() are almost
> >> identical functions. Instead of having two of them, we could pass an
> >> additional argument to mem_cgroup_resize_limit() and by using it,
> >> consolidate all the code in a single function.
> >>
> >> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> > 
> > I think this is already proposed and Acked.
> > 
> > https://patchwork.kernel.org/patch/10150719/
> > 
> 
> Indeed. I'll rebase 1/2 patch on top, if it will be applied first.

Yes please.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
