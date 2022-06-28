From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH mm v2] memcg: notify about global mem_cgroup_id space
 depletion
Date: Tue, 28 Jun 2022 11:08:19 +0200
Message-ID: <20220628090819.GB30543@blackbody.suse.cz>
References: <Yre8tNUY8vBrO0yl@castle>
 <97bed1fd-f230-c2ea-1cb6-8230825a9a64@openvz.org>
 <CAMZfGtWQEFmyuDngPfg59D-+b9sf58m9qhGoVPSQ_jAGmgT+sg@mail.gmail.com>
 <f3e4059c-69ea-eccd-a22f-9f6c6780f33a@openvz.org>
 <YrpVP6rpYGFsl3jj@castle>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656407300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z/CFWoysazPYOJ+RT+MoOQfwRcysVEsHRQF675n1OGQ=;
        b=JANHdKn0mmgpP88tAVTqM1LNjgntd0zv2uCWTJynSPXs4KRj2VMbaxE1WDbZpQZfBDRBC7
        /GxsxqrefLx2qwvL6P8kRKQJWWWolvM97j34XoT+6tfkvvfSzrs8eHKiO+zd0BJYf5cxEi
        LyXDetrh6tArsfPoS7eKN7rW3YmjliA=
Content-Disposition: inline
In-Reply-To: <YrpVP6rpYGFsl3jj@castle>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jun 27, 2022 at 06:11:27PM -0700, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> I think a better approach will be to add a cgroup event (displayed via
> cgroup.events) about reaching the maximum limit of cgroups. E.g.
> cgroups.events::max_nr_reached.

This sounds like a good generalization.

> Then you can set cgroup.max.descendants to some value below memcg_id
> space size. It's more work, but IMO it's a better way to communicate
> this event. As a bonus, you can easily get an idea which cgroup
> depletes the limit.

Just mind there's a difference between events: what cgroup's limit was
hit and what cgroup was affected by the limit [1] (the former is more
useful for the calibration if I understand the situation).

Michal

[1] https://lore.kernel.org/all/20200205134426.10570-2-mkoutny-IBi9RG/b67k@public.gmane.org/
