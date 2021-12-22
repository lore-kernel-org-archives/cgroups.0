From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Date: Wed, 22 Dec 2021 17:56:50 +0100
Message-ID: <f3a83708-3f3c-a634-7bee-dcfcaaa7f36e@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640192271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QOgLrQeLTYXFsk2cNqehMzvGapHl59pV5Owm/dhArOw=;
        b=CDFZD6sccpV6jrCOHW97R2dW6ujbp077JyPh2ADMZt0zx5mlXMzqjdacEze7nuAIS+yDgg
        UUTjY5hFRuaR4dEPxO0senjKMM+P5Fb9FtYQQEqtpi9wAL8wTeXtwEHFfmOnL/n3Uun98r
        MrtWTdxdDOL+bAPIf7+6quPuG5+PzCM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640192271;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QOgLrQeLTYXFsk2cNqehMzvGapHl59pV5Owm/dhArOw=;
        b=2sorQ5ZFjTtsCyW0F9rkVJIQ3xM/7DGVPCyMsnYJ83+Sfg0XVuCsGs+/ZTFz/cA/5BbJ+I
        38BhGjxjJSKj3QDg==
Content-Language: en-US
In-Reply-To: <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Julia Lawall <julia.lawall-MZpvjPyXg2s@public.gmane.org>, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mic

On 12/14/21 13:57, Vlastimil Babka wrote:
> On 12/1/21 19:14, Vlastimil Babka wrote:
>> Folks from non-slab subsystems are Cc'd only to patches affecting them, and
>> this cover letter.
>>
>> Series also available in git, based on 5.16-rc3:
>> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v2r2
> 
> Pushed a new branch slab-struct-slab-v3r3 with accumulated fixes and small tweaks
> and a new patch from Hyeonggon Yoo on top. To avoid too much spam, here's a range diff:

Hi, I've pushed another update branch slab-struct_slab-v4r1, and also to
-next. I've shortened git commit log lines to make checkpatch happier,
so no range-diff as it would be too long. I believe it would be useless
spam to post the whole series now, shortly before xmas, so I will do it
at rc8 time, to hopefully collect remaining reviews. But if anyone wants
a mailed version, I can do that.

Changes in v4:
- rebase to 5.16-rc6 to avoid a conflict with mainline
- collect acks/reviews/tested-by from Johannes, Roman, Hyeonggon Yoo -
thanks!
- in patch "mm/slub: Convert detached_freelist to use a struct slab"
renamed free_nonslab_page() to free_large_kmalloc() and use folio there,
as suggested by Roman
- in "mm/memcg: Convert slab objcgs from struct page to struct slab"
change one caller of slab_objcgs_check() to slab_objcgs() as suggested
by Johannes, realize the other caller should be also changed, and remove
slab_objcgs_check() completely.
