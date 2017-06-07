From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/6] mm: vmstat: move slab statistics from zone to node
 counters
Date: Wed, 7 Jun 2017 12:20:13 -0400
Message-ID: <20170607162013.GA25280@cmpxchg.org>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
 <20170530181724.27197-3-hannes@cmpxchg.org>
 <20170531091256.GA5914@osiris>
 <20170531113900.GB5914@osiris>
 <20170531171151.e4zh7ffzbl4w33gd@yury-thinkpad>
 <87mv9s2f8f.fsf@concordia.ellerman.id.au>
 <20170605183511.GA8915@cmpxchg.org>
 <20170605143831.dac73f489bfe2644e103d2b3@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NGKcMgNsYwdujaWm0H03HqaoRVOhtO3OD6O7v18W2pc=; b=fLybsAzW2qY12tO8M5R4kn+4eg
	055p6BdiK673yf89TBHHWIMe4SkoOiiIq8Rmbk0TWvgH5ZVgVILpgrUfPHuEr8/3DMubd0AFNFvDz
	HvPIesLtuiuyHkwuKFDYLifKtz7L56X5qwv9nuRz3ZMFj8y6AmtZvJZWk1YRsPvVpdpw=;
Content-Disposition: inline
In-Reply-To: <20170605143831.dac73f489bfe2644e103d2b3@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Yury Norov <ynorov@caviumnetworks.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Josef Bacik <josef@toxicpanda.com>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-s390@vger.kernel.org

On Mon, Jun 05, 2017 at 02:38:31PM -0700, Andrew Morton wrote:
> On Mon, 5 Jun 2017 14:35:11 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5107,6 +5107,7 @@ static void build_zonelists(pg_data_t *pgdat)
> >   */
> >  static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch);
> >  static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
> > +static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
> >  static void setup_zone_pageset(struct zone *zone);
> 
> There's a few kb there.  It just sits evermore unused after boot?

It's not the greatest, but it's nothing new. All the node stats we
have now used to be in the zone, i.e. the then bigger boot_pageset,
before we moved them to the node level. It just re-adds static boot
time space for them now.

Of course, if somebody has an idea on how to elegantly reuse that
memory after boot, that'd be cool. But we've lived with that footprint
for the longest time, so I don't think it's a showstopper.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
