From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 3/4] mm: memcg: let non-unified root stats flushes
 help unified flushes
Date: Mon, 4 Sep 2023 17:41:10 +0200
Message-ID: <ZPX6luPGqypp68+L@dhcp22.suse.cz>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-4-yosryahmed@google.com>
 <ZPXupwjewuLgksAI@dhcp22.suse.cz>
 <6tne52ip62ucev7nmnim3m7fhcydnwcytyxynrlxxgaf4cbqea@r4hec425izap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693842071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LhJ5sTl63kPWjdnDX0OeDaOslOG+1efqgSGhwPg2LwY=;
        b=OZAWOqBQsCEfpI3eFuLk7qToZKY+SYTEOk72LyofIJymzTGxX7iTneBlvSQa1EtpyTEC66
        9MfOrbNbfb0xXS5YRf8l+Hc4af3UnLICdYto92i8Net2jWr6FpKUI/1z1CgqCZjGdkYx6/
        JOU72i1B90DxzFoA2gmVtBFUPLmhYEs=
Content-Disposition: inline
In-Reply-To: <6tne52ip62ucev7nmnim3m7fhcydnwcytyxynrlxxgaf4cbqea@r4hec425izap>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 04-09-23 17:29:14, Michal Koutny wrote:
> Hello.
> 
> On Mon, Sep 04, 2023 at 04:50:15PM +0200, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > I have hard time to follow why we really want/need this. Does this cause
> > any observable changes to the behavior?
> 
> Behavior change depends on how much userspace triggers the root memcg
> flush, from nothing to effectively offloading flushing to userspace tasks.
> (Theory^^^)
> 
> It keeps stats_flush_threshold up to date representing global error
> estimate so that error-tolerant readers may save their time and it keeps
> the reasoning about the stats_flush_threshold effect simple.

So it also creates an undocumented but userspace visible behavior.
Something that userspace might start depending on, right?
-- 
Michal Hocko
SUSE Labs
