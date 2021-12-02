From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Date: Thu, 2 Dec 2021 13:25:52 +0100
Message-ID: <3fb4f879-c48b-7f74-c7bd-59ca16c5fe8d@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1638447953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MrIx4FxLZ15vBR8OhFRI6NkqolHxOQGKVsTXFgnLCBo=;
        b=qAgWGsgshMrO9UnM/+8sSOlYxRa0x1O8XpA8dUD5ZVMGONmJ2RDBkHY6oZHOP/CefUeY2W
        954cBjvCgf3iQ9Fpxo98OPqTwDxSGd46MsfoJM6vU7BOrlGazX/vEuwUWnOFoWTd6XuzaD
        w7H0llUJOCCbq91x7aGxd7WUo+DNpdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1638447953;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MrIx4FxLZ15vBR8OhFRI6NkqolHxOQGKVsTXFgnLCBo=;
        b=ygy8WyNyvVScvOltk0InA2SrhTOtpUcVIav8ZI0IWbEjHGA8DLYGwOXkFQskM4PuCmxvLa
        OJFR6QAwsLLfnrBA==
Content-Language: en-US
In-Reply-To: <20211201181510.18784-1-vbabka-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Julia Lawall <julia.lawall-MZpvjPyXg2s@public.gmane.org>, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mic

On 12/1/21 19:14, Vlastimil Babka wrote:
> Folks from non-slab subsystems are Cc'd only to patches affecting them, and
> this cover letter.
> 
> Series also available in git, based on 5.16-rc3:
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v2r2

I have pushed a v3, but not going to resent immediately to avoid unnecessary
spamming, the differences is just that some patches are removed and other
reordered, so the current v2 posting should be still sufficient for on-list
review:

https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v3r1

patch 29/33 iommu: Use put_pages_list
- removed as this version is broken and Robin Murphy has meanwhile
incorporated it partially to his series:
https://lore.kernel.org/lkml/cover.1637671820.git.robin.murphy-5wv7dgnIgG8@public.gmane.org/

patch 30/33 mm: Remove slab from struct page
- removed and postponed for later as this can be only be applied after the
iommu use of page.freelist is resolved

patch 27/33 zsmalloc: Stop using slab fields in struct page
patch 28/33 bootmem: Use page->index instead of page->freelist
- moved towards the end of series, to further separate the part that adjusts
non-slab users of slab fields towards removing those fields from struct page.
