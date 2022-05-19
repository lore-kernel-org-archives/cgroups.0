From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/4] memcg: enable accounting for kernfs nodes and iattrs
Date: Thu, 19 May 2022 18:33:00 +0200
Message-ID: <20220519163300.GH16096@blackbody.suse.cz>
References: <Ynv7+VG+T2y9rpdk@carbon>
 <22ccf325-6aa5-9b55-4729-d03f34125650@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652977981; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q9osOjg5SEQf5DXLZedr3XVR8VPlIeZRjkYt869VHRU=;
        b=TmLYAlgy/fHvdR4/9jW2UdK+5qB/knaCOzFSFXm4Nre8kfaIVOlKZrhDHEYiPK7XUFYO9N
        r2YMBlzhiFpYyOvDKK5ZrTv3+Nr4QQ21SMrv95F7Cqxb7YTWtsZoASUVfhRsAKdZFE7k2A
        iACnDNmbm/SUQTUMMkllqn+uMvoR3nE=
Content-Disposition: inline
In-Reply-To: <22ccf325-6aa5-9b55-4729-d03f34125650-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 13, 2022 at 06:51:55PM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index cfa79715fc1a..40e896c7c86b 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -391,10 +391,12 @@ void __init kernfs_init(void)
>  {
>  	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
>  					      sizeof(struct kernfs_node),
> -					      0, SLAB_PANIC, NULL);
> +					      0, SLAB_PANIC | SLAB_ACCOUNT,
> +					      NULL);
>  
>  	/* Creates slab cache for kernfs inode attributes */
>  	kernfs_iattrs_cache  = kmem_cache_create("kernfs_iattrs_cache",
>  					      sizeof(struct kernfs_iattrs),
> -					      0, SLAB_PANIC, NULL);
> +					      0, SLAB_PANIC | SLAB_ACCOUNT,
> +					      NULL);

IIUC your stats report, struct kernfs_iattrs is mere 88B (per
kernfs_node), when considering attributes, I actually thought of
something like:

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -950,7 +950,7 @@ struct simple_xattr *simple_xattr_alloc(const void *value, size_t size)
        if (len < sizeof(*new_xattr))
                return NULL;

-       new_xattr = kvmalloc(len, GFP_KERNEL);
+       new_xattr = kvmalloc(len, GFP_KERNEL_ACCOUNT);
        if (!new_xattr)
                return NULL;

Again, I'd split the patch into two: kernfs_node and
kernfs_iattrs+simple_xattr for easier bisecting.

Thanks,
Michal
