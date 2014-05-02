From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm/memcontrol.c: introduce helper
 mem_cgroup_zoneinfo_zone()
Date: Fri, 2 May 2014 15:05:16 -0700
Message-ID: <20140502150516.d42792bad53d86fb727816bd@linux-foundation.org>
References: <1397862103-31982-1-git-send-email-nasa4836@gmail.com>
	<20140422095923.GD29311@dhcp22.suse.cz>
	<20140428150426.GB24807@dhcp22.suse.cz>
	<20140501125450.GA23420@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140501125450.GA23420@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Jianyu Zhan <nasa4836@gmail.com>, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.com

On Thu, 1 May 2014 08:54:50 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Mon, Apr 28, 2014 at 05:04:26PM +0200, Michal Hocko wrote:
> > On Tue 22-04-14 11:59:23, Michal Hocko wrote:
> > > On Sat 19-04-14 07:01:43, Jianyu Zhan wrote:
> > > > introduce helper mem_cgroup_zoneinfo_zone(). This will make
> > > > mem_cgroup_iter() code more compact.
> > > 
> > > I dunno. Helpers are usually nice but this one adds more code then it
> > > removes. It also doesn't help the generated code.
> > > 
> > > So I don't see any reason to merge it.
> > 
> > So should we drop it from mmotm?
> 
> Yes, please.
> 
> > > > Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> > > > ---
> > > >  mm/memcontrol.c | 15 +++++++++++----
> > > >  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> This helper adds no value, but more code and indirection.
> 
> Cc'd Andrew - this is about
> mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
> mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch

The patch seemed rather nice to me.  mem_cgroup_zoneinfo_zone()
encapsulates a particular concept and gives it a name.  That's better
than splattering the logic into callsites.

The patch makes no change to code size but that's because gcc is silly.
Mark mem_cgroup_zoneinfo_zone() as noinline and the patch shrinks
.text by 40 bytes.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
