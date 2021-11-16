From: Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 21/32] mm: Convert struct page to struct slab in
 functions used by other subsystems
Date: Wed, 17 Nov 2021 00:04:46 +0100
Message-ID: <CA+fCnZcwti=hiPznPoMNWR-hvEOQbQRjEcDgnGbX+cb=kFa6sA@mail.gmail.com>
References: <20211116001628.24216-1-vbabka@suse.cz> <20211116001628.24216-22-vbabka@suse.cz>
 <CA+fCnZd_39cEvP+ktfxSrYAj6xdM02X6C0CxA5rLauaMhs2mxQ@mail.gmail.com> <6866ad09-f765-0e8b-4821-8dbdc6d0f24e@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NCLmpq3O2WgfnqHHONPo5k+Xb63HO8UeUsJwn/lUkKw=;
        b=S/WK2x3jIwCL9hw45soRVak8siXKxbKoVIkWsbVqHbuyFEp71jYSmrLDup+9cDXA8p
         DjebcwbV7B+z1OQ5GTfuFq30luZF4jPlC7TxDzMar1i3ioWHKlo9SS++CP0LsH1D0W0q
         KM5WdHzQfWRN7RiByjFOkn+OH+oSd8Nn0Qq/quRPXged8Oe4xORjDRUfuOCqNigM73RW
         AGiit48kQXh4fWFTik4ITYJbOXGMmL9I0ALedzjrWNNXD/d3V3u2cIEKuomhXNy5E7sQ
         ZXjsBH66ms5a3MjGWKjF0cjq3xp1/d7qUG/esLryx1CXCLPPc9sRLoHIYnW1QFYoqSQC
         xGhQ==
In-Reply-To: <6866ad09-f765-0e8b-4821-8dbdc6d0f24e-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Julia Lawall <julia.lawall-MZpvjPyXg2s@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kasan-dev <kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 16, 2021 at 5:33 PM Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wrote:
>
> On 11/16/21 15:02, Andrey Konovalov wrote:
> >> --- a/mm/kasan/report.c
> >> +++ b/mm/kasan/report.c
> >> @@ -249,7 +249,7 @@ static void print_address_description(void *addr, u8 tag)
> >>
> >>         if (page && PageSlab(page)) {
> >>                 struct kmem_cache *cache = page->slab_cache;
> >> -               void *object = nearest_obj(cache, page, addr);
> >> +               void *object = nearest_obj(cache, page_slab(page),      addr);
> >
> > The tab before addr should be a space. checkpatch should probably report this.
>
> Good catch, thanks. Note the tab is there already before this patch, it just
> happened to appear identical to a single space before.

Ah, indeed. Free free to keep this as is to not pollute the patch. Thanks!
