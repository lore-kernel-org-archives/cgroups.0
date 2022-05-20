From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] memcg: enable accounting for allocations in alloc_fair_sched_group
Date: Fri, 20 May 2022 01:18:57 +0000
Message-ID: <20220520011857.ggonbc32peagkhl2@google.com>
References: <Ynv7+VG+T2y9rpdk@carbon> <30f5b95a-db87-3924-6ad0-4c302c924ff0@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6CTUhgjUo83Du844ljegCXcw0SIVsWK556UKC8YwhGM=;
        b=JjZ4zTDWiB1nRfl2wC3BsM34tJOz6BnpAkzjM0rDRRpVqW5wr4jPCl1W10bF/oVI4i
         kfNM7xy1sWyNzlErQbLJpvvZ/eh+JUR3GuYKxZaVXVC/mGj8aPBDTqc5fXOqt77buNhq
         +3tlliTSlpw+P5FkV4v72rF54Y7mFmb6UIIDoyIUiN2peDKDKr8kcciBU+qG8ahNzUll
         Z9Dqqj8fvA05IoK2XUKC16G0CfibMIezwCct8opoG3bua8nGrcLUnsbXOaGFjQs1yumH
         g5HeiRKAieKuBxiN0Y/jWP2z6f2JaDWI3aqoDLsHvV3lWpnGPUnuA7p9+Ck3rklSRHIw
         I4MQ==
In-Reply-To: <30f5b95a-db87-3924-6ad0-4c302c924ff0-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 13, 2022 at 06:52:20PM +0300, Vasily Averin wrote:
> Creating of each new cpu cgroup allocates two 512-bytes kernel objects
> per CPU. This is especially important for cgroups shared parent memory
> cgroup. In this scenario, on nodes with multiple processors, these
> allocations become one of the main memory consumers.
> 
> Accounting for this memory helps to avoid misuse inside memcg-limited
> contianers.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
