From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Thu, 17 Aug 2023 12:44:35 -0700
Message-ID: <202308171244.4FCA8DB40@keescook>
References: <ZN5WkbPelHUSTXOA@work>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692301476; x=1692906276;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yOdpLYxoLdDmx+TSr95GHH7gDMjqei8L96nVIKirCWI=;
        b=On9xusN8g7izznKyvse5ccEsSYnblSeWqRtkpxOK5gsVqQ5zms7D2DhmB5e51qjXqb
         njjxN2GoUtGK//o3YuF4w9bZtAdG4CAaDmuvnwkvDLlVGqy1pID+HJSSidHDADrCEan9
         woMrLYxmESn8f1AugKZGdsnAc+1pCOvmry1h4=
Content-Disposition: inline
In-Reply-To: <ZN5WkbPelHUSTXOA@work>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 17, 2023 at 11:19:13AM -0600, Gustavo A. R. Silva wrote:
> Change the notation from pointer-to-array to pointer-to-pointer.
> With this, we avoid the compiler complaining about trying
> to access a region of size zero as an argument during function
> calls.
> 
> This is a workaround to prevent the compiler complaining about
> accessing an array of size zero when evaluating the arguments
> of a couple of function calls. See below:
> 
> kernel/cgroup/cgroup.c: In function 'find_css_set':
> kernel/cgroup/cgroup.c:1206:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
>  1206 |         cset = find_existing_css_set(old_cset, cgrp, template);
>       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> kernel/cgroup/cgroup.c:1206:16: note: referencing argument 3 of type 'struct cgroup_subsys_state *[0]'
> kernel/cgroup/cgroup.c:1071:24: note: in a call to function 'find_existing_css_set'
>  1071 | static struct css_set *find_existing_css_set(struct css_set *old_cset,
>       |                        ^~~~~~~~~~~~~~~~~~~~~
> 
> With the change to pointer-to-pointer, the functions are not prevented
> from being executed, and they will do what they have to do when
> CGROUP_SUBSYS_COUNT == 0.
> 
> Address the following -Wstringop-overflow warnings seen when
> built with ARM architecture and aspeed_g4_defconfig configuration
> (notice that under this configuration CGROUP_SUBSYS_COUNT == 0):
> 
> kernel/cgroup/cgroup.c:1208:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:1258:15: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:6089:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:6153:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> 
> This results in no differences in binary output.
> 
> Link: https://github.com/KSPP/linux/issues/316
> Signed-off-by: Gustavo A. R. Silva <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

-- 
Kees Cook
