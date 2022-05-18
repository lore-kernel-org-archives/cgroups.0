From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 4/4] selftests: memcg: Remove protection from top level
 memcg
Date: Wed, 18 May 2022 17:44:52 +0200
Message-ID: <20220518154452.GA22503@blackbody.suse.cz>
References: <20220512174452.tr34tuh4k5jm6qjs@dev0025.ash9.facebook.com>
 <20220513171811.730-1-mkoutny@suse.com>
 <20220513171811.730-5-mkoutny@suse.com>
 <Yn6qrHHS935ppX98@carbon>
 <20220517172443.3e524a8319c693ab24c5f22e@linux-foundation.org>
 <YoRDSfv6xK/R+n+R@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652888694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Li9ptdI+7pbwM42wCuvaB+5mMwjEshptpUoGbDfSMkY=;
        b=fiVX2lKRrKorbVXuGy5EOhLKEcCdgm6LoS8Q1eP9hMLFZ2O3zUvKl1DntQYEBgb0s1ipqE
        H/kIM/mlE/wx9ugHkH4GOKa9eNdWhazdoVMHSX0xucMBrzjBMuZ1NrZX8D8sL7eoM3dPpJ
        2579nbRfMXXYzKEL+5hpZWLzllAZ1FU=
Content-Disposition: inline
In-Reply-To: <YoRDSfv6xK/R+n+R@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

On Tue, May 17, 2022 at 05:52:25PM -0700, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> Please, go ahead with it. If anything comes up, it can be addressed later.

I hope I can still post v2 of the tests cleanups (applying feedback from
here), it's in [1] with more info there. (I sent it to a new thread
based on get_maintainers.pl).

Thanks,
Michal

[1] https://lore.kernel.org/r/20220518154037.18819-1-mkoutny-IBi9RG/b67k@public.gmane.org
