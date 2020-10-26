From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: add file_thp, shmem_thp to memory.stat
Date: Mon, 26 Oct 2020 13:40:29 -0400
Message-ID: <20201026174029.GC548555@cmpxchg.org>
References: <20201022151844.489337-1-hannes@cmpxchg.org>
 <20201025113725.b60f2b08d7331a31edf009a1@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=djs/CW12V4A+rnL8mVXSs9xI/UkOfc/xmnw7+ByJ/eM=;
        b=SZXO+BBXdNcrW74AgUZzt6jyzJoA0LDHbnm9Q60LBwKaRuIS5DDT8EMMIBQ+8v7ybm
         4NMxPkr7hkQW92+yQF9eagujlyehAYXlus7xlj6hPQLSQMeQSussoqkFMviC/T+HpnMm
         PQVFhtfBESS3t56Pa4XiIY40M5syaVbQxiTdqrx9SAtQ/I/sCUqe8ViQ+SkdoWu4qwLa
         eYJSCZCWZ20Op3LGAmbWZJRfgCp8qlGS/L6t+v+KvllIPjm/p2Y6TgAzRSkbQnKw8b8d
         Nm0NAwFXkKwMQDJRD0S5jyFk+bq/xrZlSbypj0dEbQ+PamTzXpqJBSrL9GtX5iXwqkXG
         VXoQ==
Content-Disposition: inline
In-Reply-To: <20201025113725.b60f2b08d7331a31edf009a1-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sun, Oct 25, 2020 at 11:37:25AM -0700, Andrew Morton wrote:
> On Thu, 22 Oct 2020 11:18:44 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> 
> > As huge page usage in the page cache and for shmem files proliferates
> > in our production environment, the performance monitoring team has
> > asked for per-cgroup stats on those pages.
> > 
> > We already track and export anon_thp per cgroup. We already track file
> > THP and shmem THP per node, so making them per-cgroup is only a matter
> > of switching from node to lruvec counters. All callsites are in places
> > where the pages are charged and locked, so page->memcg is stable.
> > 
> > ...
> >
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1507,6 +1507,8 @@ static struct memory_stat memory_stats[] = {
> >  	 * constant(e.g. powerpc).
> >  	 */
> >  	{ "anon_thp", 0, NR_ANON_THPS },
> > +	{ "file_thp", 0, NR_FILE_THPS },
> > +	{ "shmem_thp", 0, NR_SHMEM_THPS },
> 
> Documentation/admin-guide/cgroup-v2.rst is owed an update?

Ah yes. This?

From 310c3e1714e1c093d4cd26dff38326fc348cdd31 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date: Mon, 26 Oct 2020 13:39:19 -0400
Subject: [PATCH] mm: memcontrol: add file_thp, shmem_thp to memory.stat fix

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 608d7c279396..515bb13084a0 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1300,6 +1300,14 @@ PAGE_SIZE multiple when read back.
 		Amount of memory used in anonymous mappings backed by
 		transparent hugepages
 
+	  file_thp
+		Amount of cached filesystem data backed by transparent
+		hugepages
+
+	  shmem_thp
+		Amount of shm, tmpfs, shared anonymous mmap()s backed by
+		transparent hugepages
+
 	  inactive_anon, active_anon, inactive_file, active_file, unevictable
 		Amount of memory, swap-backed and filesystem-backed,
 		on the internal memory management lists used by the
-- 
2.29.0

