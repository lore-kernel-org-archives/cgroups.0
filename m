From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/2] mm/memcontrol.c: introduce helper
 mem_cgroup_zoneinfo_zone()
Date: Thu, 1 May 2014 08:54:50 -0400
Message-ID: <20140501125450.GA23420@cmpxchg.org>
References: <1397862103-31982-1-git-send-email-nasa4836@gmail.com>
 <20140422095923.GD29311@dhcp22.suse.cz>
 <20140428150426.GB24807@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=94uvjG5kJYVolJ5SuFsVOjUTEym1biJ4VLAAnUC8bnU=;
	b=rRct8nTk4jnq3MvYUQo6ZBSkn80x9WOVYAQD+UpMrczgy/cDA9DfyA4mZ0UiWylxRq0C2zdU+vtU2kJYYZQW8i8PST72T3sC+ZAOKMG0xnAiVrCsUmGaW49mHL39bm7SrgbhSFXv36H6wiMj0YCc0D18PQerhaqk6zkqaa0GlbE=;
Content-Disposition: inline
In-Reply-To: <20140428150426.GB24807-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3VaTQe2KTcn/@public.gmane.org

On Mon, Apr 28, 2014 at 05:04:26PM +0200, Michal Hocko wrote:
> On Tue 22-04-14 11:59:23, Michal Hocko wrote:
> > On Sat 19-04-14 07:01:43, Jianyu Zhan wrote:
> > > introduce helper mem_cgroup_zoneinfo_zone(). This will make
> > > mem_cgroup_iter() code more compact.
> > 
> > I dunno. Helpers are usually nice but this one adds more code then it
> > removes. It also doesn't help the generated code.
> > 
> > So I don't see any reason to merge it.
> 
> So should we drop it from mmotm?

Yes, please.

> > > Signed-off-by: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  mm/memcontrol.c | 15 +++++++++++----
> > >  1 file changed, 11 insertions(+), 4 deletions(-)

This helper adds no value, but more code and indirection.

Cc'd Andrew - this is about
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch

Thanks!
