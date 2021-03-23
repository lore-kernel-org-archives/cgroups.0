From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date: Tue, 23 Mar 2021 13:01:36 -0400
Message-ID: <YFoe8BO0JsbXTHHF@cmpxchg.org>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org>
 <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org>
 <CAOFY-A17g-Aq_TsSX8=mD7ZaSAqx3gzUuCJT8K0xwrSuYdP4Kw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aMZf3nAnd3Ur++OR8V/tDE1PbcZI5ey7Mp8g1oFzdQ8=;
        b=hn+/QKTWQ8HIyPatT9wTlycQejd9EC8+QxrYdIXm2iCp2ZexLrV0+iBG3Z8i4zXusA
         7/JD+um93ZmFKBY28q3Bna9RyArSGxILyxRJAmTuFK9RmO4VEbll8xungPHroHkZ/g/j
         Dth/GtDL7UnUJzXClUZQNYArZfATgy2XzyDoJHEtIDqTfq26v8tCj7FnIQJ/y7E3y0sn
         feoWvo6GCwYAJA4V2MXn8K80zZJdVdYqhxi7TJQv2SusDlupOFf0lMAhfNti9jNbB/ci
         zq7V0lrPsOlc3l7P5BJgApsv4RQ9/BQrTTg6woTtm6gpjiJJknRrdUwG+YCu7gQ1I6pg
         rYtA==
Content-Disposition: inline
In-Reply-To: <CAOFY-A17g-Aq_TsSX8=mD7ZaSAqx3gzUuCJT8K0xwrSuYdP4Kw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Arjun Roy <arjunroy.kdev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Mon, Mar 22, 2021 at 02:35:11PM -0700, Arjun Roy wrote:
> To make sure we're on the same page, then, here's a tentative
> mechanism - I'd rather get buy in before spending too much time on
> something that wouldn't pass muster afterwards.
> 
> A) An opt-in mechanism, that a driver needs to explicitly support, in
> order to get properly accounted receive zerocopy.

Yep, opt-in makes sense. That allows piece-by-piece conversion and
avoids us having to have a flag day.

> B) Failure to opt-in (e.g. unchanged old driver) can either lead to
> unaccounted zerocopy (ie. existing behaviour) or, optionally,
> effectively disabled zerocopy (ie. any call to zerocopy will return
> something like EINVAL) (perhaps controlled via some sysctl, which
> either lets zerocopy through or not with/without accounting).

I'd suggest letting it fail gracefully (i.e. no -EINVAL) to not
disturb existing/working setups during the transition period. But the
exact policy is easy to change later on if we change our minds on it.

> The proposed mechanism would involve:
> 1) Some way of marking a page as being allocated by a driver that has
> decided to opt into this mechanism. Say, a page flag, or a memcg flag.

Right. I would stress it should not be a memcg flag or any direct
channel from the network to memcg, as this would limit its usefulness
while having the same maintenance overhead.

It should make the network page a first class MM citizen - like an LRU
page or a slab page - which can be accounted and introspected as such,
including from the memcg side.

So definitely a page flag.

> 2) A callback provided by the driver, that takes a struct page*, and
> returns a boolean. The value of the boolean being true indicates that
> any and all refs on the page are held by the driver. False means there
> exists at least one reference that is not held by the driver.

I was thinking the PageNetwork flag would cover this, but maybe I'm
missing something?

> 3) A branch in put_page() that, for pages marked thus, will consult
> the driver callback and if it returns true, will uncharge the memcg
> for the page.

The way I picture it, put_page() (and release_pages) should do this:

void __put_page(struct page *page)
{
        if (is_zone_device_page(page)) {
                put_dev_pagemap(page->pgmap);

                /*
                 * The page belongs to the device that created pgmap. Do
                 * not return it to page allocator.
                 */
                return;
        }
+
+	if (PageNetwork(page)) {
+		put_page_network(page);
+		/* Page belongs to the network stack, not the page allocator */
+		return;
+	}

        if (unlikely(PageCompound(page)))
                __put_compound_page(page);
        else
                __put_single_page(page);
}

where put_page_network() is the network-side callback that uncharges
the page.

(..and later can be extended to do all kinds of things when informed
that the page has been freed: update statistics (mod_page_state), put
it on a private network freelist, or ClearPageNetwork() and give it
back to the page allocator etc.

But for starters it can set_page_count(page, 1) after the uncharge to
retain the current silent recycling behavior.)

> The anonymous struct you defined above is part of a union that I think
> normally is one qword in length (well, could be more depending on the
> typedefs I saw there) and I think that can be co-opted to provide the
> driver callback - though, it might require growing the struct by one
> more qword since there may be drivers like mlx5 that are already using
> the field already in there  for dma_addr.

The page cache / anonymous struct it's shared with is 5 words (double
linked list pointers, mapping, index, private), and the network struct
is currently one word, so you can add 4 words to a PageNetwork() page
without increasing the size of struct page. That should be plenty of
space to store auxiliary data for drivers, right?

> Anyways, the callback could then be used by the driver to handle the
> other accounting quirks you mentioned, without needing to scan the
> full pool.

Right.

> Of course there are corner cases and such to properly account for, but
> I just wanted to provide a really rough sketch to see if this
> (assuming it were properly implemented) was what you had in mind. If
> so I can put together a v3 patch.

Yeah, makes perfect sense. We can keep iterating like this any time
you feel you accumulate too many open questions. Not just for MM but
also for the networking folks - although I suspect that the first step
would be mostly about the MM infrastructure, and I'm not sure how much
they care about the internals there ;)

> Per my response to Andrew earlier, this would make it even more
> confusing whether this is to be applied against net-next or mm trees.
> But that's a bridge to cross when we get to it.

The mm tree includes -next, so it should be a safe development target
for the time being.

I would then decide it based on how many changes your patch interacts
with on either side. Changes to struct page and the put path are not
very frequent, so I suspect it'll be easy to rebase to net-next and
route everything through there. And if there are heavy changes on both
sides, the -mm tree is the better route anyway.

Does that sound reasonable?
