From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Date: Mon, 20 Dec 2021 01:24:52 +0100
Message-ID: <b94c2530-0f17-11c4-e3ef-effc6b7f0d33@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
 <Ybk+0LKrsAJatILE@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1639959892; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QS/OCdCcmeiC9lIu10Q6seQIOyuScTvbNIZyhMByFhM=;
        b=EFlINYyd/0dwFEmGFLZJLMASlucVauTDQ5SZ12dNfQ6r31naTaptiEwTVbyOfxPXpCB2cT
        ljvPQE3G4g1tnbRcINtU1YQtlSxy1/U6VoQT1ofUjs0fEIc2xRhwT6WL5cD9PbkZJ35Dj6
        NzwUpPjWlTGet3+basc0unwNwWyigwM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1639959893;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QS/OCdCcmeiC9lIu10Q6seQIOyuScTvbNIZyhMByFhM=;
        b=en4PMr7JQnpVhR/Yj5DceOur/mcdk1eiP1XwqtDuloUzTdwsT7JJTZLi1UAwmw3RS7NXzU
        ZjrRD/TsdRhwADDA==
Content-Language: en-US
In-Reply-To: <Ybk+0LKrsAJatILE-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes@cmpxchg>

On 12/15/21 02:03, Roman Gushchin wrote:
> On Tue, Dec 14, 2021 at 01:57:22PM +0100, Vlastimil Babka wrote:
>> On 12/1/21 19:14, Vlastimil Babka wrote:
>> > Folks from non-slab subsystems are Cc'd only to patches affecting them, and
>> > this cover letter.
>> > 
>> > Series also available in git, based on 5.16-rc3:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v2r2
>> 
>> Pushed a new branch slab-struct-slab-v3r3 with accumulated fixes and small tweaks
>> and a new patch from Hyeonggon Yoo on top. To avoid too much spam, here's a range diff:
> 
> Hi Vlastimil!
> 
> I've started to review this patchset (btw, a really nice work, I like
> the resulting code way more). Because I'm looking at v3 and I don't have
> the whole v2 in my mailbox, here is what I've now:

Thanks a lot, Roman!

> * mm: add virt_to_folio() and folio_address()
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm/slab: Dissolve slab_map_pages() in its caller
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm/slub: Make object_err() static
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm: Split slab into its own type
> 1) Shouldn't SLAB_MATCH() macro use struct folio instead of struct page for the
> comparison?

Folio doesn't have define most of the fields, and matching some to page and
others to folio seems like unnecessary complication. Maybe as part of the
final struct page cleanup when the slab fields are gone from struct page,
the rest could all be in folio - I'll check once we get there.

> 2) page_slab() is used only in kasan and only in one place, so maybe it's better
> to not introduce it as a generic helper?

Yeah that's the case after the series, but as part of the incremental steps,
page_slab() gets used in many places. I'll consider removing it on top though.

> Other than that
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm: Add account_slab() and unaccount_slab()
> 1) maybe change the title to convert/replace instead of add?

Done.

> 2) maybe move later changes to memcg_alloc_page_obj_cgroups() to this patch?

Maybe possible, but that would distort the series more than I'd like to at
this rc6 time.

> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm: Convert virt_to_cache() to use struct slab
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm: Convert __ksize() to struct slab
> It looks like certain parts of __ksize() can be merged between slab, slub and slob?
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm: Use struct slab in kmem_obj_info()
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> 
> I'll try to finish reviewing the patchset until the  end of the week.
> 
> Thanks!
> 
> Roman

