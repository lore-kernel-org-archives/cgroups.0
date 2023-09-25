From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/2] mm: memcg: fix tracking of pending stats updates
 values
Date: Mon, 25 Sep 2023 15:50:26 +0200
Message-ID: <ZRGQIhWF02SRzN4D@dhcp22.suse.cz>
References: <20230922175741.635002-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1695649829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jcHoHaiIokbvVhLAntZeHFBs/mSZ9sLRljn4JH46n+8=;
        b=Y+Ze5tZaa/vhJYJpUpwQ0pZmKaOFR5s0ikzu9g5De+vsjp3KrPoNIbfEpJEqnpebKz7H2H
        cXibuPUBw6pEV4FasYGv0okod+puihW3ODDK0rw/6LlqrOe6N0+uNiT2vmYKLuq3S8sK/b
        e+u3WHYLF6e4U7Ku6SU3U1Iwmz9SDMY=
Content-Disposition: inline
In-Reply-To: <20230922175741.635002-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 22-09-23 17:57:38, Yosry Ahmed wrote:
> While working on adjacent code [1], I realized that the values passed
> into memcg_rstat_updated() to keep track of the magnitude of pending
> updates is consistent. It is mostly in pages, but sometimes it can be in
> bytes or KBs. Fix that.

What kind of practical difference does this change make? Is it worth
additional code?
 
> Patch 1 reworks memcg_page_state_unit() so that we can reuse it in patch
> 2 to check and normalize the units of state updates.
> 
> [1]https://lore.kernel.org/lkml/20230921081057.3440885-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> 
> v1 -> v2:
> - Rebased on top of mm-unstable.
> 
> Yosry Ahmed (2):
>   mm: memcg: refactor page state unit helpers
>   mm: memcg: normalize the value passed into memcg_rstat_updated()
> 
>  mm/memcontrol.c | 64 +++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 51 insertions(+), 13 deletions(-)
> 
> -- 
> 2.42.0.515.g380fc7ccd1-goog

-- 
Michal Hocko
SUSE Labs
