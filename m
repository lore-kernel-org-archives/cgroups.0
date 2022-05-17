From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 6/6] zswap: memcg accounting
Date: Tue, 17 May 2022 16:52:16 -0700
Message-ID: <20220517165216.7acd8434f8b25606836e21e6@linux-foundation.org>
References: <20220510152847.230957-1-hannes@cmpxchg.org>
        <20220510152847.230957-7-hannes@cmpxchg.org>
        <20220511173218.GB31592@blackbody.suse.cz>
        <YnwJUL90fuoHs3YW@cmpxchg.org>
        <20220513151426.GC16096@blackbody.suse.cz>
        <Yn6QfdouzkcrygTR@cmpxchg.org>
        <20220516143459.GA17557@blackbody.suse.cz>
        <YoKtgaxOAMBVKiCf@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652831537;
        bh=pEz6dre40UCCubkWjCpmYmIXIWT0QJP+YHG6iJ3oqAE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tsprR4zmK/oALRYBT6vfLxQ1klcvHAWxPcTURMr4US/hz7Uw0voe1Rd7mrChl8sdH
         2miTXW+EY7qU+TEI2unOpAlcbme0xr2QXB48zpwSoZaqLZ+c/nu+dY2yTH5iNx0vo8
         yhD8XhZUkOY2U6dkpIa/o/EV1/RwxLY79S8QzLW0=
In-Reply-To: <YoKtgaxOAMBVKiCf@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Seth Jennings <sjenning@redhat.com>, Dan Streetman <ddstreet@ieee.org>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Mon, 16 May 2022 16:01:05 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > > Flushing unnecessary groups with a ratelimit doesn't sound like an
> > > improvement to me.
> > 
> > Then I'm only concerned about a situation when there's a single deep
> > memcg that undergoes both workingset_refault() and zswap querying.
> > The latter (bare call to cgroup_rstat_flush()) won't reset
> > stats_flush_threshold, so the former (or the async flush more likely)
> > would attempt a flush too. The flush work (on the leaf memcg) would be
> > done twice even though it may be within the tolerance of cumulated
> > error the second time.
> > 
> > This is a thing that might require attention in the future (depending on
> > some data how it actually performs). I see how the current approach is
> > justified.
> 
> Yes, we can optimize it should the need arise. So far it's been fine.
> 
> Thanks for your thoughts, Michal.

Me too.

I think everything is settled here so I plan to import this series into
mm-stable in a couple of days.

at
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/

 documentation-filesystems-proc-update-meminfo-section.patch
 documentation-filesystems-proc-update-meminfo-section-fix.patch
 documentation-filesystems-proc-update-meminfo-section-fix-2.patch
 mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
 mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
 mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch
 mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix.patch
 mm-kconfig-simplify-zswap-configuration.patch
 mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
 zswap-memcg-accounting.patch
 zswap-memcg-accounting-fix.patch
 zswap-memcg-accounting-fix-2.patch


