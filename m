From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 1/5] selftests: memcg: Fix compilation
Date: Mon, 23 May 2022 15:29:17 +0200
Message-ID: <20220523132917.GA4988@blackbody.suse.cz>
References: <20220518161859.21565-1-mkoutny@suse.com>
 <20220518161859.21565-2-mkoutny@suse.com>
 <5242b7ab-d6b6-55d4-c211-ec27293be795@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653312559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gtxU29oO1IFvVA3hN0PuI5lGfiBVozRsUJAeElrZ+0M=;
        b=IXT+cH2wydH7nqcS1UuXTHk70XKlgBcSFLBInZA3NzwcOi4YTvYLyHoGDjpnf/0xPS002U
        7cEHjkPzTdRzhmhZJWszJj4Fmk8JZszqWKwLAE63ifwZ8einhrZsvmylYrUY/hY4mtk3oP
        EvlUPDNRE0cf0oPb0O2GzeRQU+RCI9M=
Content-Disposition: inline
In-Reply-To: <5242b7ab-d6b6-55d4-c211-ec27293be795-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Muhammad Usama Anjum <usama.anjum-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

On Sat, May 21, 2022 at 07:11:01PM +0500, Muhammad Usama Anjum <usama.anjum=
-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org> wrote:
> On 5/18/22 9:18 PM, Michal Koutn=FD wrote:
> > This fixes mis-applied changes from commit 72b1e03aa725 ("cgroup:
> > account for memory_localevents in test_memcg_oom_group_leaf_events()").
> Shouldn't the Fixes tag be added here and in 2/5 patch?

Ad the patch 1/5 -- yes, sounds appropriate.

Ad the patch 2/5 -- that's an effective revert, I don't see reverts
being marked with Fixes.

I see the patch 5/5 didn't make it to MLs (their public archives, except
for LKML). So I'll resend the series with the modified commit message
(if nothing else pops up).

Michal
