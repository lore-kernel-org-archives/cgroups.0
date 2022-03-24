From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcg: Do not count memory.low reclaim if it
 does not happen
Date: Thu, 24 Mar 2022 10:51:57 +0100
Message-ID: <20220324095157.GA16685@blackbody.suse.cz>
References: <20220322182248.29121-1-mkoutny@suse.com>
 <YjuUuLW+8iRtYOmP@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648115519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7gpGpR3wa2+cKOuymKs7lOAFj3Lr0LMnbgKaKE1lmS0=;
        b=BGawxnk4ZkQIE7RH/c/DMxnbfBkVfcFqPuS610Wd3K1lipapLcY5WY8j8HJStzYE0qHan9
        vrS4rkjy97O26ObUlec4H4FLbLds3Pdx2zDW0dSGgyhnAZScTDYtdQ/kEqDrcs3RcUTORB
        ad8lq6Av0xdWgp0oZGGgHRSkCsgq2j8=
Content-Disposition: inline
In-Reply-To: <YjuUuLW+8iRtYOmP-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Palethorpe <rpalethorpe-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Wed, Mar 23, 2022 at 02:44:24PM -0700, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> Does it mean that in the following configuration:
> 	`parent .low=50M
> 	  ` s1	.low=0M   .current=50M
> 	  ` s2  .low=0M   .current=50M
> there will be no memory.events::low at all? (assuming the recursive thing is on)

True, no memory.events:low among siblings.
Number of memory.events:low in the parent depends on how much has to be
reclaimed (>50M means carving into parent's protection, hence it'll be
counted).

This is a quantitative change in the events reporting (point 1 of
RFCness), my understanding is that the potential events due to recursive
surplus protection carry no new information regarding configured
memory.low.


Michal
