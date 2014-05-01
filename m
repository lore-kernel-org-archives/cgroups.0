From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] mm/memcontrol.c: introduce helper
 mem_cgroup_zoneinfo_zone()
Date: Thu, 1 May 2014 09:36:03 -0400
Message-ID: <20140501133603.GA25536@cmpxchg.org>
References: <1397862103-31982-1-git-send-email-nasa4836@gmail.com>
 <20140422095923.GD29311@dhcp22.suse.cz>
 <20140428150426.GB24807@dhcp22.suse.cz>
 <20140501125450.GA23420@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=T2K2X32RBOvz5Vk3M1DncMmnYtLwNs7+blqbMR1V4gQ=;
	b=g0O1BaATwuHrt35BasBbovK1biPIX6zVWsERz2rDFtCpss8qitVuxeeMgh0kSa1zEf833htro6XtK3j26na6/S3HNCV4BrruLJzTc4tsXMpO+lve+D32DJ2SJlMRVZ+yaylWesA5iyJfxlLWcMN3JoNhTDLm2akePFfNwEVppF8=;
Content-Disposition: inline
In-Reply-To: <20140501125450.GA23420@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Jianyu Zhan <nasa4836@gmail.com>, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

[fix Andrew's email address]

On Thu, May 01, 2014 at 08:54:50AM -0400, Johannes Weiner wrote:
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
> 
> Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
