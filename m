From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Don't increase effective low/min if no
 protection needed
Date: Tue, 18 Oct 2022 00:46:24 +0200
Message-ID: <Y03bQJcK4o4Po1v2@blackbook>
References: <20221011143015.1152968-1-longman@redhat.com>
 <Y0WOPZxWSnUjzZ8e@dhcp22.suse.cz>
 <defdb421-342e-ebcb-d7f0-005559dd1e0d@redhat.com>
 <Y0WiIDmPPXYZuHpX@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666046786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KPXn8oCISsFaCnRNyRjpdaEv1QQo5ZLAKB/NsLXVGBs=;
        b=NfKOqe4gHCl9/Htq5BcTbwrgFymKb4wGV1EoSbTVL1zMWiFBS0wESzuZBCcXi55G/gR0tQ
        dqkWXoDM2yaNsea3ydA79oc54ZMQO9pSGOy34tkFfc3j8hI+NmtNtlNXbV82hU2h+0y5E3
        y7ohEeM0pH8mJna2Hkfzj+XLk/7aVQo=
Content-Disposition: inline
In-Reply-To: <Y0WiIDmPPXYZuHpX-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Tue, Oct 11, 2022 at 07:04:32AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Wouldn't it make sense to fix the test? With recursive_prot on, the cgroup
> actually is under low protection and it seems like the correct behavior is
> to report the low events accordingly.

It depends whether the there is a residual protection that the
memory.low=0 sibling can use (with memory_recursiveprot).

In the discussed LTP test, there should be no residual protection that
would justify the apparently misreported memory.low events. I.e. the
test is correct, the failure points to a subtle issue with distributing
residual protection among siblings.

Been there, (haven't) done that:
1) https://bugzilla.suse.com/show_bug.cgi?id=1196298
2) https://lore.kernel.org/r/20220325103118.GC2828-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org/

HTH,
Michal
