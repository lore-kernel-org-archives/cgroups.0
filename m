From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: enable accounting for struct cgroup
Date: Thu, 19 May 2022 18:53:25 +0200
Message-ID: <20220519165325.GA2434@blackbody.suse.cz>
References: <Ynv7+VG+T2y9rpdk@carbon>
 <a17be77f-dc3b-d69a-16e2-f7309959c525@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652979207; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6frXTBgzGRsjQpEWOm3xYp6acz/9cACY818c3GjmbTE=;
        b=aU4Zz5L96bfOjnVSWwfUl/ZOl+pAHsxcqe088kJSSjOLa4Lo/g4x6rXHcEeW56lZA8rXfn
        Zd72o8ccBgsUKXmWVf+tFT7ICCA3Xn7X1C1Dh3B73jS5NH59GNa1+Osny2pwZrHT6DYSl8
        I73RnhMuNCm9ZcgAXED12k4VMQysZuA=
Content-Disposition: inline
In-Reply-To: <a17be77f-dc3b-d69a-16e2-f7309959c525-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 13, 2022 at 06:52:12PM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> Creating each new cgroup allocates 4Kb for struct cgroup. This is the
> largest memory allocation in this scenario and is epecially important
> for small VMs with 1-2 CPUs.

What do you mean by this argument?

(On bigger irons, the percpu components becomes dominant, e.g. struct
cgroup_rstat_cpu.)

Thanks,
Michal
