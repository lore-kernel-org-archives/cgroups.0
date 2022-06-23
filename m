From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH mm v5 0/9] memcg: accounting for objects allocated by
 mkdir, cgroup
Date: Thu, 23 Jun 2022 18:07:55 +0200
Message-ID: <YrSP25ebDmXE+kPS@dhcp22.suse.cz>
References: <4e685057-b07d-745d-fdaa-1a6a5a681060@openvz.org>
 <0fe836b4-5c0f-0e32-d511-db816d359748@openvz.org>
 <c516033f-a9e4-3485-26d9-a68afa694c1d@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656000477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wMF9zQXoS7789benC3y1Mqff9+pXyWjyfnVX7+d4uIU=;
        b=mvvikz1x06mAR0j9AIIjqZez94lYbuacM/0nvGLHh9QkoXhZ0Bgz3bcqKQylfvDVab1ffl
        fs5NfryGLmDNt9mFXbPF8S/1L9pyATCAiB9FP7RkBv2Nhdqo1yCiRNngO6aqd++vLOKIUx
        RwGAngJGkZvbsOT99UE2700SeBZB+E4=
Content-Disposition: inline
In-Reply-To: <c516033f-a9e4-3485-26d9-a68afa694c1d-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 23-06-22 18:03:31, Vasily Averin wrote:
> Dear Michal,
> do you still have any concerns about this patch set?

Yes, I do not think we have concluded this to be really necessary. IIRC 
Roman would like to see lingering cgroups addressed in not-so-distant
future (http://lkml.kernel.org/r/Ypd2DW7id4M3KJJW@carbon) and we already
have a limit for the number of cgroups in the tree. So why should we
chase after allocations that correspond the cgroups and somehow try to
cap their number via the memory consumption. This looks like something
that will get out of sync eventually and it also doesn't seem like the
best control to me (comparing to an explicit limit to prevent runaways).
-- 
Michal Hocko
SUSE Labs
