From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: cgroup v1 and balance_dirty_pages
Date: Thu, 17 Nov 2022 11:31:05 -0500
Message-ID: <Y3ZhyfROmGKn/jfr@cmpxchg.org>
References: <87wn7uf4ve.fsf@linux.ibm.com>
 <Y3ZPZyaX1WN3tad4@cmpxchg.org>
 <697e50fd-1954-4642-9f61-1afad0ebf8c6@linux.ibm.com>
 <9fb5941b-2c74-87af-a476-ce94b43bb542@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N1OZMheGA35bNHdC4rcQaw04gRFU5dhh6+LoysxwctI=;
        b=gBPgguogHnCs8qLFkHLovKhea+586FfigjxG2lZ/MaE9Nuf1D5ynr4EW8NuCB8Jttx
         g5dBrHk6MPtfBHgO5CGcxi48rGJ1AWA1RMFPyFq2Yv/PQzPmMQHGUojHrn/FcFOscZeV
         Cq2PpVSekSv9XdkK8Kx8IW8kJJXDl54YyobmXFWMWwS16b5C3foi2dFjudvmSGlLT9DJ
         Kg1Nz/FjWkQX8t98kBdKZTHvbOUJ1XXd0X4gGOpBOl3tzqnJ8mhW7HO7/PkGUq+jHbbT
         73u7ktxf1LpggHcxU8C8Vb6YWPFZfyNiu9/T3r0AkcjSVHf13bhsL55hymIVfB5AdpBR
         MzpA==
Content-Disposition: inline
In-Reply-To: <9fb5941b-2c74-87af-a476-ce94b43bb542-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 17, 2022 at 09:21:10PM +0530, Aneesh Kumar K V wrote:
> On 11/17/22 9:12 PM, Aneesh Kumar K V wrote:
> > On 11/17/22 8:42 PM, Johannes Weiner wrote:
> >> Hi Aneesh,
> >>
> >> On Thu, Nov 17, 2022 at 12:24:13PM +0530, Aneesh Kumar K.V wrote:
> >>> Currently, we don't pause in balance_dirty_pages with cgroup v1 when we
> >>> have task dirtying too many pages w.r.t to memory limit in the memcg.
> >>> This is because with cgroup v1 all the limits are checked against global
> >>> available resources. So on a system with a large amount of memory, a
> >>> cgroup with a smaller limit can easily hit OOM if the task within the
> >>> cgroup continuously dirty pages.
> >>
> >> Page reclaim has special writeback throttling for cgroup1, see the
> >> folio_wait_writeback() in shrink_folio_list(). It's not as smooth as
> >> proper dirty throttling, but it should prevent OOMs.
> >>
> >> Is this not working anymore?
> > 
> > The test is a simple dd test on on a 256GB system.
> > 
> > root@lp2:/sys/fs/cgroup/memory# mkdir test
> > root@lp2:/sys/fs/cgroup/memory# cd test/
> > root@lp2:/sys/fs/cgroup/memory/test# echo 120M > memory.limit_in_bytes 
> > root@lp2:/sys/fs/cgroup/memory/test# echo $$ > tasks 
> > root@lp2:/sys/fs/cgroup/memory/test# dd if=/dev/zero of=/home/kvaneesh/test bs=1M 
> > Killed
> > 
> > 
> > Will it hit the folio_wait_writeback, because it is sequential i/o and none of the folio
> > we are writing will be in writeback?
> 
> Other way to look at this is, if the writeback is never started via balance_dirty_pages,
> will we be finding folios in shrink_folio_list that is in writeback? 

The flushers are started from reclaim if necessary. See this code from
shrink_inactive_list():

	/*
	 * If dirty folios are scanned that are not queued for IO, it
	 * implies that flushers are not doing their job. This can
	 * happen when memory pressure pushes dirty folios to the end of
	 * the LRU before the dirty limits are breached and the dirty
	 * data has expired. It can also happen when the proportion of
	 * dirty folios grows not through writes but through memory
	 * pressure reclaiming all the clean cache. And in some cases,
	 * the flushers simply cannot keep up with the allocation
	 * rate. Nudge the flusher threads in case they are asleep.
	 */
	if (stat.nr_unqueued_dirty == nr_taken)
		wakeup_flusher_threads(WB_REASON_VMSCAN);

It sounds like there isn't enough time for writeback to commence
before the memcg already declares OOM.

If you place a reclaim_throttle(VMSCAN_THROTTLE_WRITEBACK) after that
wakeup, does that fix the issue?
