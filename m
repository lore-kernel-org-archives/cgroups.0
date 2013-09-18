From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 0/7] improve memcg oom killer robustness v2
Date: Wed, 18 Sep 2013 16:42:45 +0200
Message-ID: <20130918144245.GC3421@dhcp22.suse.cz>
References: <20130916145744.GE3674@dhcp22.suse.cz>
 <20130916170543.77F1ECB4@pobox.sk>
 <20130916152548.GF3674@dhcp22.suse.cz>
 <20130916225246.A633145B@pobox.sk>
 <20130917000244.GD3278@cmpxchg.org>
 <20130917131535.94E0A843@pobox.sk>
 <20130917141013.GA30838@dhcp22.suse.cz>
 <20130918160304.6EDF2729@pobox.sk>
 <20130918142400.GA3421@dhcp22.suse.cz>
 <20130918163306.3620C973@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130918163306.3620C973-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 18-09-13 16:33:06, azurIt wrote:
> > CC: "Johannes Weiner" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Andrew Morton" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David Rientjes" <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "KAMEZAWA Hiroyuki" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "KOSAKI Motohiro" <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >On Wed 18-09-13 16:03:04, azurIt wrote:
> >[..]
> >> I was finally able to get stack of problematic process :) I saved it
> >> two times from the same process, as Michal suggested (i wasn't able to
> >> take more). Here it is:
> >> 
> >> First (doesn't look very helpfull):
> >> [<ffffffffffffffff>] 0xffffffffffffffff
> >
> >No it is not.
> > 
> >> Second:
> >> [<ffffffff810e17d1>] shrink_zone+0x481/0x650
> >> [<ffffffff810e2ade>] do_try_to_free_pages+0xde/0x550
> >> [<ffffffff810e310b>] try_to_free_pages+0x9b/0x120
> >> [<ffffffff81148ccd>] free_more_memory+0x5d/0x60
> >> [<ffffffff8114931d>] __getblk+0x14d/0x2c0
> >> [<ffffffff8114c973>] __bread+0x13/0xc0
> >> [<ffffffff811968a8>] ext3_get_branch+0x98/0x140
> >> [<ffffffff81197497>] ext3_get_blocks_handle+0xd7/0xdc0
> >> [<ffffffff81198244>] ext3_get_block+0xc4/0x120
> >> [<ffffffff81155b8a>] do_mpage_readpage+0x38a/0x690
> >> [<ffffffff81155ffb>] mpage_readpages+0xfb/0x160
> >> [<ffffffff811972bd>] ext3_readpages+0x1d/0x20
> >> [<ffffffff810d9345>] __do_page_cache_readahead+0x1c5/0x270
> >> [<ffffffff810d9411>] ra_submit+0x21/0x30
> >> [<ffffffff810cfb90>] filemap_fault+0x380/0x4f0
> >> [<ffffffff810ef908>] __do_fault+0x78/0x5a0
> >> [<ffffffff810f2b24>] handle_pte_fault+0x84/0x940
> >> [<ffffffff810f354a>] handle_mm_fault+0x16a/0x320
> >> [<ffffffff8102715b>] do_page_fault+0x13b/0x490
> >> [<ffffffff815cb87f>] page_fault+0x1f/0x30
> >> [<ffffffffffffffff>] 0xffffffffffffffff
> >
> >This is the direct reclaim path. You are simply running out of memory
> >globaly. There is no memcg specific code in that trace.
> 
> 
> No, i'm not. Here is htop and server graphs from this case:

Bahh, right you are. I didn't look at the trace carefully. It is
free_more_memory which calls the direct reclaim shrinking.

Sorry about the confusion
-- 
Michal Hocko
SUSE Labs
