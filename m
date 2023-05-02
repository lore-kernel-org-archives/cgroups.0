From: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 03/40] fs: Convert alloc_inode_sb() to a macro
Date: Tue, 2 May 2023 15:57:51 -0400
Message-ID: <ZFFrP8WKRFgZRzoB@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-4-surenb@google.com>
 <20230502143530.1586e287@meshulam.tesarici.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683057484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bbTqJ6Cy48RWo6Tz/tI7JJZLpQOgd1GnXsK6J+pb2Po=;
        b=TPEXvTAZj7eMMlezn0mxuUI2XEAYSmuur8j15Vhz2aAoEuxaC8gwe/DdLVCUdzI8I+L6aU
        DEG5XTP5rhYFuMy34wKLVWK/nyN2iMJiF2WhtVwQS5E54+cSGLx6PlY24qgxqRCabxvnfl
        6yoheYQVL8RgpgGG5HowroFYWwjIS0M=
Content-Disposition: inline
In-Reply-To: <20230502143530.1586e287-TD/jYOLh/Qr2G+KSGY6Hrl+YFMdMcpeZ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Petr =?utf-8?B?VGVzYcWZw61r?= <petr-hIRrMMry8ebtwjQa/ONI9g@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andr

On Tue, May 02, 2023 at 02:35:30PM +0200, Petr Tesařík wrote:
> On Mon,  1 May 2023 09:54:13 -0700
> Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > From: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> > 
> > We're introducing alloc tagging, which tracks memory allocations by
> > callsite. Converting alloc_inode_sb() to a macro means allocations will
> > be tracked by its caller, which is a bit more useful.
> > 
> > Signed-off-by: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> > ---
> >  include/linux/fs.h | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 21a981680856..4905ce14db0b 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2699,11 +2699,7 @@ int setattr_should_drop_sgid(struct mnt_idmap *idmap,
> >   * This must be used for allocating filesystems specific inodes to set
> >   * up the inode reclaim context correctly.
> >   */
> > -static inline void *
> > -alloc_inode_sb(struct super_block *sb, struct kmem_cache *cache, gfp_t gfp)
> > -{
> > -	return kmem_cache_alloc_lru(cache, &sb->s_inode_lru, gfp);
> > -}
> > +#define alloc_inode_sb(_sb, _cache, _gfp) kmem_cache_alloc_lru(_cache, &_sb->s_inode_lru, _gfp)
> 
> Honestly, I don't like this change. In general, pre-processor macros
> are ugly and error-prone.

It's a one line macro, it's fine.

> Besides, it works for you only because __kmem_cache_alloc_lru() is
> declared __always_inline (unless CONFIG_SLUB_TINY is defined, but then
> you probably don't want the tracking either). In any case, it's going
> to be difficult for people to understand why and how this works.

I think you must be confused. kmem_cache_alloc_lru() is a macro, and we
need that macro to be expanded at the alloc_inode_sb() callsite. It's
got nothing to do with whether or not __kmem_cache_alloc_lru() is inline
or not.

> If the actual caller of alloc_inode_sb() is needed, I'd rather add it
> as a parameter and pass down _RET_IP_ explicitly here.

That approach was considered, but adding an ip parameter to every memory
allocation function would've been far more churn.
