From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: add file_thp, shmem_thp to memory.stat
Date: Sun, 25 Oct 2020 11:37:25 -0700
Message-ID: <20201025113725.b60f2b08d7331a31edf009a1@linux-foundation.org>
References: <20201022151844.489337-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603651046;
        bh=AKPWbbhGU2lDq8bH1SvgMMUeWmC+dVgo7ZU0pT2CqBo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NrxUh7Ba2gTECKM/q2Nb8g7MqpeqjWVu+CAWoTjJUX/Xn1y/Q5hnn6KlhM+GpLPkg
         2tNRiG7gHYOqtaJXG05Ww3O7BpZlEBqcme73OYOcJpfFNaDI0CpD94hEw4kvO5XbRg
         hNzx1hkDDMKIB1YweVadIc2+HdMbcNwoITFZpxe8=
In-Reply-To: <20201022151844.489337-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, 22 Oct 2020 11:18:44 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> As huge page usage in the page cache and for shmem files proliferates
> in our production environment, the performance monitoring team has
> asked for per-cgroup stats on those pages.
> 
> We already track and export anon_thp per cgroup. We already track file
> THP and shmem THP per node, so making them per-cgroup is only a matter
> of switching from node to lruvec counters. All callsites are in places
> where the pages are charged and locked, so page->memcg is stable.
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1507,6 +1507,8 @@ static struct memory_stat memory_stats[] = {
>  	 * constant(e.g. powerpc).
>  	 */
>  	{ "anon_thp", 0, NR_ANON_THPS },
> +	{ "file_thp", 0, NR_FILE_THPS },
> +	{ "shmem_thp", 0, NR_SHMEM_THPS },

Documentation/admin-guide/cgroup-v2.rst is owed an update?

