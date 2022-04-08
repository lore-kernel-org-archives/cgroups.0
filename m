From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 1/4] memcg: introduce per-memcg reclaim interface
Date: Fri, 8 Apr 2022 10:55:56 -0400
Message-ID: <YlBM/HlPyPUZew5N@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
References: <20220408045743.1432968-1-yosryahmed@google.com>
 <20220408045743.1432968-2-yosryahmed@google.com>
 <YlA754XNFAmWQcm6@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <YlBCeadBqbeVvALK@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RkQdhzMDs8tUm3hby//Hd4ev3pWtbOp3xvInpobyZS4=;
        b=lrvPVCsfGDkCGwWe+RqJphGmx2SiDaJ/okIVXFr8qJJlv4iQ0V5JkRw7+guRP5MaZw
         mSDnFKo0tUG8SHb/7TwFtprWvMIxR8/ouU0ZIgADO7mnBVZmIqpXtIXqhxOLaBkQG8Lf
         MXzCgZYkcqy/gIIW0fdXxdV/4AmvuSD1c0L9oQyKOoAgESKgyuvDqrC3xLPjHwcs6kSI
         3gBvM9nBKrAH4VCbo0mws7lAb+6OwhEpHeKM2Q2ymtjm+DXvVzPOBR/r5P1dnjBUVIDL
         e97dBtSrb3+S3OvirDjNe8NRRCKOtTA52lXeSjeZj+y3RaXdT5vClJ5bg0/IR9EuISIP
         /wPg==
Content-Disposition: inline
In-Reply-To: <YlBCeadBqbeVvALK-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vaibhav Jain <vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, l

On Fri, Apr 08, 2022 at 04:11:05PM +0200, Michal Hocko wrote:
> Regarding "max" as a possible input. I am not really sure to be honest.
> I can imagine that it could be legit to simply reclaim all the charges
> (e.g. before removing the memcg) which should be achieveable by
> reclaiming the reported consumption. Or what exactly should be the
> semantic?

Yeah, it just allows you to avoid reading memory.current to just
reclaim everything if you can specify "max" - you're still protected
by nretries to eventually bail out. Mostly, though I just feel like
supporting "max" makes memory.reclaim semetric with a lot of the
cgroup memory control files which tend to support "max".
