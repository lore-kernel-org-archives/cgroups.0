From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 6/7] mm: memcontrol: switch to rstat
Date: Thu, 4 Feb 2021 11:26:32 -0500
Message-ID: <YBwgOHL8dTjJpnKU@cmpxchg.org>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-7-hannes@cmpxchg.org>
 <20210203014726.GE1812008@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ACIgalIASwLRIdWMuW6Oj7uCmIS5PMrqjcUMfzNwZKE=;
        b=MhxcF478bHTzeOjaqn3t+dgrOQ2TemimDwkXVDLohFRJNl95pHbGa9lLMm7eUh47yK
         hqGCwPMieGsvldBevk/GTzZFLDZryCRd8tlWXVG8uYNf9AohQdvgTb+LxFJwSEjutywo
         3E18OctPqEd11DhJx4NgXE4Yj0fHAQ0WIyhu+wgSKgvMnTRsuVjDtnLBrLvkb4TXY9Om
         LcJVZVFkYyCc7nEmtuJiow7He54ZkAWBEXGmmJe/6WxLOur+I/zZe0/QnliUXFYnnBc3
         +cNlrBxAgNgbdTKF95BPokovA+P0SqJ0wm/w/bqBYg83pfhDJKy0DV+MBi+sqDRpT+Bx
         ZldA==
Content-Disposition: inline
In-Reply-To: <20210203014726.GE1812008-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Feb 02, 2021 at 05:47:26PM -0800, Roman Gushchin wrote:
> On Tue, Feb 02, 2021 at 01:47:45PM -0500, Johannes Weiner wrote:
> >  	for_each_node(node) {
> >  		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
> > +		unsigned long stat[NR_VM_NODE_STAT_ITEMS] = {0, };
>                                                               ^^
> I'd drop the comma here. It seems that "{0}" version is way more popular
> over the mm code and in the kernel in general.

Is there a downside to the comma? I'm finding more { 0, } than { 0 }
in mm code, and at least kernel-wide it seems both are acceptable
(although { 0 } is more popular overall).

I don't care much either way. I can change it in v2 if there is one.
