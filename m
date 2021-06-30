From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 15/18] mm/memcg: Add mem_cgroup_folio_lruvec()
Date: Wed, 30 Jun 2021 17:21:12 -0400
Message-ID: <YNzgSOkl77FHdfhV@cmpxchg.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-16-willy@infradead.org>
 <YNzDiTFZpRgKY0CE@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fr9/V6zIlyWck7HPPeS/TCISALLUxUMSsg+X8S97SXI=;
        b=IHSBJTW86/4n83zVuVdOYB3dXkYzVbUh3RZq3+9raR0OesfrwlcgGpsCSG22rwBLa8
         5tZM0tz7yNIlyQ+UukH++/9forrJNhx71wU56uudMVEHfT2eTLz5FuzvcvabzL/b3DgS
         FaexCwnP9dqgR81LBpnq6dPUvVokwVh5E20tfSclZYpmarmNA7Gv6IwQbkZPafS7J2cv
         gjjX251lVq3VJrcWOK821GgzrLCMxir0gtU9TFP6uyc3qbggepQByhTqmPgI3rZWGAFn
         jIGyjmjG4ynnEbfjtC52ENZpDkYsnDVjrCdguiGd9tq6+9bvVAiI+DQbWD3QWATYCWbp
         Pf/w==
Content-Disposition: inline
In-Reply-To: <YNzDiTFZpRgKY0CE-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 30, 2021 at 08:18:33PM +0100, Matthew Wilcox wrote:
> On Wed, Jun 30, 2021 at 05:00:31AM +0100, Matthew Wilcox (Oracle) wrote:
> > This is the folio equivalent of mem_cgroup_page_lruvec().
> 
> I'm just going through and removing the wrappers.
> 
> Why is this function called this?  There's an odd mix of
> 
> lock_page_memcg()

This was chosen to match lock_page().

> page_memcg()

And this to match page_mapping(), page_zone() etc.

> count_memcg_page_event()

count_vm_event()

> split_page_memcg()

split_page(), split_page_owner()

> mem_cgroup_charge()
> mem_cgroup_swapin_charge_page()

These are larger, heavier subsystem API calls that modify all kinds of
state, not just the page. Hence the namespacing.

With the smaller getter/setter type functions on pages we have
traditionally used <verb>_<object> rather than page_<verb>, simply
because the page is such a low-level object and many functions do
sequences of page manipulations. Namespacing would turn them into:

	page_do_this(page);
	page_set_that(page);
	page_lock(page);
	if (page_is_blah(page))
		page_mark_foo(page);
	page_unlock(page);
	page_put(page);

which is hard on the reader because it obscures the salient part of
each line behind repetetive boiler plate.

> mem_cgroup_lruvec()

This is arguably not a namespace prefix, but rather an accessor
function to look up the memcg's lruvec.

> mem_cgroup_from_task()

This is a pattern to look up memcgs from various objects:

- mem_cgroup_from_css()
- mem_cgroup_from_counter()
- mem_cgroup_from_id()
- mem_cgroup_from_seq()
- mem_cgroup_from_obj()

and we used to have mem_cgroup_from_page() at some point...

> I'd really like to call this function folio_lruvec().

That would be a better name indeed.

However, pairing renames with conversion is worrisome because it means
having two unintuitively diverging names for the same operation in the
API during a time where everybody has to relearn the code base already.

Please either precede it with a rename to page_lruvec(), or keep the
existing naming pattern in the conversion.

> It happens to behave differently if the folio is part of a memcg,
> but conceptually, lruvecs aren't particularly tied to memcgs.

Conceptually, lruvecs are always tied to a memcg. On !CONFIG_MEMCG
kernels that just happens to be the root cgroup.

But because it's an accessor to a page attribute, dropping the
namespacing prefix is in line with things like page_memcg().
