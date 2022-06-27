From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup] cgroup: set the correct return code if hierarchy
 limits are reached
Date: Mon, 27 Jun 2022 18:07:20 +0900
Message-ID: <YrlzSFkywHthpAZN@mtj.duckdns.org>
References: <186d5b5b-a082-3814-9963-bf57dfe08511@openvz.org>
 <d8a9e9c6-856e-1502-95ac-abf9700ff568@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tRneTDLFQMzVfO2N/gHNDmUeVj26egu5hiaZEE0FtjA=;
        b=fQ6t0azwoBYBWQ8D03hqBSBzPvIyFe3pEoBa6IZz851wn1dYbZd0wh1MP3LHlJrK1Z
         PR26etFEelPHmooDifKqYpWUU2au6IzvThqe7T/W9DIHRtZzh76Gl+aJbsl81IElKp1g
         Xr6UAyqwZDm/OodxwZM5UIxd2tz5aK2ERESgtEinTj0kBv/8fpavsVUfi8Rsqv9ts2zr
         ncCAouqGAx6myEp+eMgvDhtVPZNwQol0xcDdNC7W9qEI9YVLNQJ154N9AIB3kGxtm+fV
         CVRlFohYoB+MOLR5g4J5qiaCzmq6dBpKT+foP0DhKFsDGm3HoQ+jvSJSF5xyzu8rxB6W
         YHOA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d8a9e9c6-856e-1502-95ac-abf9700ff568-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jun 27, 2022 at 05:12:55AM +0300, Vasily Averin wrote:
> When cgroup_mkdir reaches the limits of the cgroup hierarchy, it should
> not return -EAGAIN, but instead react similarly to reaching the global
> limit.

While I'm not necessarily against this change, I find the rationale to
be somewhat lacking. Can you please elaborate why -ENOSPC is the right
one while -EAGAIN is incorrect?

Thanks.

-- 
tejun
