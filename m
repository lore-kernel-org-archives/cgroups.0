From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Date: Mon, 3 Jan 2022 18:56:21 +0100
Message-ID: <d3f0e9ef-7d21-8de6-5b15-116f39c2aca3@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
 <f3a83708-3f3c-a634-7bee-dcfcaaa7f36e@suse.cz>
 <YcxFDuPXlTwrPSPk@ip-172-31-30-232.ap-northeast-1.compute.internal>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641232582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CWXmfQBKbsotJ+DKTiOu/dBjpnMA9AO60pYklnpK268=;
        b=RhtzrMx8l25Gp/dHfXaSGxIrVaiGPT1oHmkDlXhSWyOvA3XmL4u7MKmkETxcTTsnSdyvu2
        2jQ+42aJxQsIJcy8XiqzBTF5lvvMOIEw62rvN/I2Cv3SEGwEYtC0RgDlqOLKfcdrrpJrAI
        TwUGB6+/291CiiyPqlt5NX4O2jOPKt4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641232582;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CWXmfQBKbsotJ+DKTiOu/dBjpnMA9AO60pYklnpK268=;
        b=t8qwh7PKelubXDsAPcP//m32DqwLxiSz3osyPqIC0+7efv+uVAzzP9TnLLkkHY3hH0TlrX
        HpPoN6SxQtgI3lBg==
Content-Language: en-US
In-Reply-To: <YcxFDuPXlTwrPSPk-UAkeum2rnor1owfsx/q8xBTA2CDgPq3U3JN/6IHv09UQhXZLsr/E6M+yXz+rYK7V@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes@cmpxchg>

On 12/29/21 12:22, Hyeonggon Yoo wrote:
> On Wed, Dec 22, 2021 at 05:56:50PM +0100, Vlastimil Babka wrote:
>> On 12/14/21 13:57, Vlastimil Babka wrote:
>> > On 12/1/21 19:14, Vlastimil Babka wrote:
>> >> Folks from non-slab subsystems are Cc'd only to patches affecting them, and
>> >> this cover letter.
>> >>
>> >> Series also available in git, based on 5.16-rc3:
>> >> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v2r2
>> > 
>> > Pushed a new branch slab-struct-slab-v3r3 with accumulated fixes and small tweaks
>> > and a new patch from Hyeonggon Yoo on top. To avoid too much spam, here's a range diff:
>> 
>> Hi, I've pushed another update branch slab-struct_slab-v4r1, and also to
>> -next. I've shortened git commit log lines to make checkpatch happier,
>> so no range-diff as it would be too long. I believe it would be useless
>> spam to post the whole series now, shortly before xmas, so I will do it
>> at rc8 time, to hopefully collect remaining reviews. But if anyone wants
>> a mailed version, I can do that.
>>
> 
> Hello Matthew and Vlastimil.
> it's part 3 of review.
> 
> # mm: Convert struct page to struct slab in functions used by other subsystems
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> # mm/slub: Convert most struct page to struct slab by spatch
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Tested-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> with a question below.
> 
> -static int check_slab(struct kmem_cache *s, struct page *page)
> +static int check_slab(struct kmem_cache *s, struct slab *slab)
>  {
>         int maxobj;
>  
> -       if (!PageSlab(page)) {
> -               slab_err(s, page, "Not a valid slab page");
> +       if (!folio_test_slab(slab_folio(slab))) {
> +               slab_err(s, slab, "Not a valid slab page");
>                 return 0;
>         }
> 
> Can't we guarantee that struct slab * always points to a slab?

Normally, yes.

> for struct page * it can be !PageSlab(page) because struct page *
> can be other than slab. but struct slab * can only be slab
> unlike struct page. code will be simpler if we guarantee that
> struct slab * always points to a slab (or NULL).

That's what the code does indeed. But check_slab() is called as part of
various consistency checks, so there we on purpose question all assumptions
in order to find a bug (e.g. memory corruption) - such as a page that's
still on the list of slabs while it was already freed and reused and thus
e.g. lacks the slab page flag.

But it's nice how using struct slab makes such a check immediately stand out
as suspicious, right?

> # mm/slub: Convert pfmemalloc_match() to take a struct slab
> It's confusing to me because the original pfmemalloc_match() is removed
> and pfmemalloc_match_unsafe() was renamed to pfmemalloc_match() and
> converted to use slab_test_pfmemalloc() helper.
> 
> But I agree with the resulting code. so:
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> # mm/slub: Convert alloc_slab_page() to return a struct slab
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Tested-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> # mm/slub: Convert print_page_info() to print_slab_info()
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> I hope to review rest of patches in a week.

Thanks for your reviews/tests!
