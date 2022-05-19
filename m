From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/4] memcg: enable accounting for large allocations in
 mem_cgroup_css_alloc
Date: Thu, 19 May 2022 18:46:32 +0200
Message-ID: <20220519164632.GJ16096@blackbody.suse.cz>
References: <Ynv7+VG+T2y9rpdk@carbon>
 <212f1b74-7d4e-29f2-9e92-2a1820beff61@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652978794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ERYUV2kwi2PrxYJcK4bUaEn7oG4ict65od3QwN96zgk=;
        b=izPide9gHt6StxVJSvjOgcfaBOzm8bPvhHUkQ9+KRHIvRukpecTgScNhnLBheJM4KLWvZl
        nriJE+zOct0kwoPg1ErV4XpT/9f7vXi7kgeLRsynK1hKtYVNSn0nX18+KExVkV2ffDIkTm
        0ohH2IGWafBloHIm3e8txAtJe+HDuIs=
Content-Disposition: inline
In-Reply-To: <212f1b74-7d4e-29f2-9e92-2a1820beff61-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 13, 2022 at 06:51:41PM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm=
+yROfE0A@public.gmane.org> wrote:
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
