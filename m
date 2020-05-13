From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 00/19 V2] mm: memcontrol: charge swapin pages on
 instantiation
Date: Wed, 13 May 2020 08:35:45 -0400
Message-ID: <20200513123545.GB488426@cmpxchg.org>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
 <20200513113032.GA93568@dev-dsk-sblbir-1c-a524888b.ap-northeast-1.amazon.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XPrK4VVoXQ0vmjjlKF3mWEEfj4+VgK3r8tZECPQos5E=;
        b=zFqMJydTAPVLxNLXFDGmaVOy8rh6YFK1hKv2Qx0WWlU5242a2O1SoY314bSQ3vHLYG
         fnm+ll+8xNx0LDpF6ao7AIhPzgBKjsrAzDSVrxXrFWjn0wXikhgApqIaBZ6RRowBmUQr
         TUHGa7lNx1EMlc4ISPqhND0a1EIPh/7bboJjlqyL+qejWBjIlcT2We1UYz8lcIF8MLfW
         qfVBuPWRVXCRGYQqNlL/jtMkttkRSBjwdJyyusuu69L1QxXCCbZoUKdMgs67WIohRC9o
         wilWL6mdq85EgIOi/9ZWphJ3CgLHhOjTSLJM16IGS3GGtyZSM0LJFF+1GAyQb0+JP1J3
         cqkg==
Content-Disposition: inline
In-Reply-To: <20200513113032.GA93568-NRm0YHp59q3WjiIBzMsuWuWgrJflrKkg5MPKucqWqmtRpfTj4gZeKJvkWQ9sCspaVpNB7YpNyf8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello Balbir!

On Wed, May 13, 2020 at 11:30:32AM +0000, Balbir Singh wrote:
> On Fri, May 08, 2020 at 02:30:47PM -0400, Johannes Weiner wrote:
> > To eliminate the page->mapping dependency, memcg needs to ditch its
> > private page type counters (MEMCG_CACHE, MEMCG_RSS, NR_SHMEM) in favor
> > of the generic vmstat counters and accounting sites, such as
> > NR_FILE_PAGES, NR_ANON_MAPPED etc.
> 
> Could you elaborate on what this means and the implications of this on
> user space programs?

This has no bearing on userspace. It's just simplifying how
memory.stat is implemented. The output is the same.

For the full story:

In the past, memcg has done its own accounting to produce a breakdown
of consumers in memory.stat. When a page was charged, we relied on
knowing whether it's a file, anon or shmem page, and had our own
MEMCG_RSS, MEMCG_CACHE, MEMCG_SHMEM counters.

As the general VM code already does this type of classification to
produce /proc/vmstat, this meant unnecessary duplication: more places
to bump counters, more places that have to make sure the page state is
stable in all the right ways, more dependencies on when it's safe to
call the charge and the uncharge callbacks.

A while ago we added per-cgroup arrays of the vmstat counters and a
cgroup-aware accounting callback (mod_lruvec_state) that can be a
drop-in replacement for the generic VM code (mod_node_state and
friends). We already had some counters converted over to that.

These patches just do more of that conversion from private memcg
accounting to having callbacks into generic VM accounting sites.

Instead of testing PageAnon() and accounting MEMCG_CACHE/MEMCG_RSS in
the charge code, we switch __add_to_page_cache_locked() and
page_add_new_anon_rmap() to the cgroup-aware mod_lruvec_page_state()
to bump our per-cgroup NR_FILE_PAGES and NR_ANON_MAPPED counters along
with the node and global counters.

As a result, the memcg gets a breakdown for memory.stat without having
to have private knowledge of what a page cache page is - how to test
it, when it's safe to test it, whether there can be huge pages in the
page cache, etc. pp. Memcg can focus on counting bytes, and the VM
code that is specialized in dealing with the page cache (or anon
pages, or shmem pages) can fill in those kinds of details for us.

Less dependencies, less duplication, simpler API rules.

The memory.stat output is the same, it's just much simpler code.
