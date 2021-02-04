From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 6/7] mm: memcontrol: switch to rstat
Date: Thu, 4 Feb 2021 10:45:20 -0800
Message-ID: <20210204184520.GC1837780@carbon.DHCP.thefacebook.com>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-7-hannes@cmpxchg.org>
 <20210203014726.GE1812008@carbon.dhcp.thefacebook.com>
 <YBwgOHL8dTjJpnKU@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=n01RPg3dbG9s+6rokXNj955+ScFUZdwv9Sh/7kue/PI=;
 b=htbSuhbKE2hY+UliGcsbu4VpxM2d4Uj26mLnvG/mSEobX0D+4qJysUpAJb0nrMl6RGnk
 adRjhOQ60kG0qVmS++oJErTKpm6MUv4xfRhaHxHguEBqz6Y47n6E5Ey7V+HbvqwLPSmB
 C5M2P8xp62myRY8Gc1ZoUgrJcGgOlXxUiMg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n01RPg3dbG9s+6rokXNj955+ScFUZdwv9Sh/7kue/PI=;
 b=NZLctum1uviEgeWh41yirPqslx4TYb6qPx2dKoXp3w/Qf3bxj2a6vUtiLPmvzHVBmsMLhI2kKi6fhNMQk+6w0JIuiOYEZvRrO6szSd478OWjz/bRVbLRFbKB65mK1vnP9QVfB1cNqMup6zbF6QYKjChPPbbhMczAACoZRJZPlCg=
Content-Disposition: inline
In-Reply-To: <YBwgOHL8dTjJpnKU-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Feb 04, 2021 at 11:26:32AM -0500, Johannes Weiner wrote:
> On Tue, Feb 02, 2021 at 05:47:26PM -0800, Roman Gushchin wrote:
> > On Tue, Feb 02, 2021 at 01:47:45PM -0500, Johannes Weiner wrote:
> > >  	for_each_node(node) {
> > >  		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
> > > +		unsigned long stat[NR_VM_NODE_STAT_ITEMS] = {0, };
> >                                                               ^^
> > I'd drop the comma here. It seems that "{0}" version is way more popular
> > over the mm code and in the kernel in general.
> 
> Is there a downside to the comma? I'm finding more { 0, } than { 0 }
> in mm code, and at least kernel-wide it seems both are acceptable
> (although { 0 } is more popular overall).

{ 0 } is more obvious and saves a character. The "problem" with comma
version is that { 1, } and { 0, } have a different meaning.

It seems like 13 (no comma) vs 11 (comma) in the mm code:
[guro@carbon mm]$ pwd
/home/guro/linux/mm
[guro@carbon mm]$ ag --nofilename "\{0\}"
DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};

	return (swp_entry_t) {0};

	unsigned long stat[MEMCG_NR_STAT] = {0};

	swp_entry_t entry = (swp_entry_t){0};
[guro@carbon mm]$ ag --nofilename "\{ 0 \}"
	struct cleancache_filekey key = { .u.key = { 0 } };
	struct cleancache_filekey key = { .u.key = { 0 } };
	struct cleancache_filekey key = { .u.key = { 0 } };
	struct cleancache_filekey key = { .u.key = { 0 } };

	unsigned long stack_entries[KFENCE_STACK_DEPTH] = { 0 };

	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
	DECLARE_BITMAP(tmp, SUBSECTIONS_PER_SECTION) = { 0 };
	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };

	unsigned long nr_zone_taken[MAX_NR_ZONES] = { 0 };
[guro@carbon mm]$ ag --nofilename "\{ 0, \}"
	int global_zone_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
	int global_numa_diff[NR_VM_NUMA_STAT_ITEMS] = { 0, };
	int global_node_diff[NR_VM_NODE_STAT_ITEMS] = { 0, };
	int global_zone_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
	int global_numa_diff[NR_VM_NUMA_STAT_ITEMS] = { 0, };
	int global_node_diff[NR_VM_NODE_STAT_ITEMS] = { 0, };
	unsigned long count[MIGRATE_TYPES] = { 0, };

	struct memory_failure_entry entry = { 0, };

	unsigned long nr_skipped[MAX_NR_ZONES] = { 0, };
	unsigned long zone_boosts[MAX_NR_ZONES] = { 0, };

	unsigned long count[MIGRATE_TYPES] = { 0, };

> 
> I don't care much either way. I can change it in v2 if there is one.

Sure, of course it's not worth a separate version.

Thanks!
