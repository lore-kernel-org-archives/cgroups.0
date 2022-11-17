From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: cgroup v1 and balance_dirty_pages
Date: Thu, 17 Nov 2022 10:12:39 -0500
Message-ID: <Y3ZPZyaX1WN3tad4@cmpxchg.org>
References: <87wn7uf4ve.fsf@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cb4RJ2noO6I+KBBEP872ofv51+cSy/3xrWUOMQWU1g4=;
        b=unvKwDbp6LIvRE1YZzhs+MLHGUogLNHOaJtbDbivWS5s44b5nd/+fzpFFuHNOngT5A
         4frV5x8oF3oEG+aSh2cr/LvyIvOLohkDasFZmTzDykSqt6JO/eI9HIhqoG9pCQzMorp7
         cxFJ8gX3Cl/eHNc3HKfulahIoglZ7NtSKddroAvfL0pkYFpiFZm0sWerGkyOm4Y6sFnE
         H/LiloikMwsXjYmWX95A7aWP4f6s8o+oHlLLspaKrBitIaNF0zrDvHaSBhtzn+7uevhb
         J3+xquR69zS5ohA1ttWbfAKezUsgPpzc0+yy75yslYQD/tEZUBYp0hgJ8Sz8+ASq2vX3
         w0Qw==
Content-Disposition: inline
In-Reply-To: <87wn7uf4ve.fsf-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Aneesh,

On Thu, Nov 17, 2022 at 12:24:13PM +0530, Aneesh Kumar K.V wrote:
> Currently, we don't pause in balance_dirty_pages with cgroup v1 when we
> have task dirtying too many pages w.r.t to memory limit in the memcg.
> This is because with cgroup v1 all the limits are checked against global
> available resources. So on a system with a large amount of memory, a
> cgroup with a smaller limit can easily hit OOM if the task within the
> cgroup continuously dirty pages.

Page reclaim has special writeback throttling for cgroup1, see the
folio_wait_writeback() in shrink_folio_list(). It's not as smooth as
proper dirty throttling, but it should prevent OOMs.

Is this not working anymore?

> Shouldn't we throttle the task based on the memcg limits in this case?
> commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
> on traditional hierarchies") indicates we run into issues with enabling
> cgroup writeback with v1. But we still can keep the global writeback
> domain, but check the throtling needs against memcg limits in
> balance_dirty_pages()?

Deciding when to throttle is only one side of the coin, though.

The other side is selective flushing in the IO context of whoever
generated the dirty data, and matching the rate of dirtying to the
rate of writeback. This isn't really possible in cgroup1, as the
domains for memory and IO control could be disjunct.

For example, if a fast-IO cgroup shares memory with a slow-IO cgroup,
what's the IO context for flushing the shared dirty data? What's the
throttling rate you apply to dirtiers?
