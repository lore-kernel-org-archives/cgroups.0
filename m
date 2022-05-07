From: CGEL <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Sat, 7 May 2022 02:05:25 +0000
Message-ID: <6275d3e7.1c69fb81.1d62.4504@mx.google.com>
References: <20220505033814.103256-1-xu.xin16@zte.com.cn>
 <YnUlntNFR4zeD+qa@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=jalhMSau/4ac1aQTeKEt0TtpRgwPn28KXUpA5qg/su4=;
        b=KRd718Jg9pNqg0PO87qH43qF2rb43W1ldMnyH8wRDwVA955pSBtF2Af3S9Z8RoJy9A
         c4uqDtiZTfE7hmRtXjAlBTkmPZuG8VLUjKfVS5sC4d/snsPe2GfdrXp394cHdt2jfEXd
         rP8jvytgtnjziXev8xgqf2zdJGypsg0FtDsZadiPSu/a4cWRLzCuRnBpyHhbfudhrCYL
         x0+eOlN9Bkc7mzWlg75F55khDRlA7PjdXQQb+mp3dfY3qCyMkspEbSdREXmQSQXFsMLW
         d3WlADCQUxFo0E+OD3dNCf3qmyxe1nDKBdgDN7dDy8NLWumIZzUdnDPoO47ogIY+l8Pg
         ddgQ==
Content-Disposition: inline
In-Reply-To: <YnUlntNFR4zeD+qa-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Fri, May 06, 2022 at 03:41:50PM +0200, Michal Hocko wrote:
> On Thu 05-05-22 03:38:15, cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> > From: Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org> 
> > 
> > Using THP may promote the performance of memory, but increase memory
> > footprint. Applications may use madvise to decrease footprint, but
> > not all applications support using madvise, and it takes much costs
> > to re-code all the applications. And we notice container becomes more
> > and more popular to manage a set of tasks.
> 
> Could you be more specific about the actual usecase? When do you group
> processes based on their general THP reqirements? You are mentioning
> containers but those are usually bags of different processes that just
> share a common objective.
>
> > So add support for cgroup to control THP behaviour will provide much
> > convenience, administrator may only enable THP for important containers,
> > and disable it for other containers.
> 
> Why would that be a matter of importance?
> 
> Also what is actual semantic when processes living inside those cgroups
> explicitly state their THP requirements?
>
Docker might support this new cgroup knob in the future, add provide UI likes:
# docker run -it --thp-enabled=[always,never,madvise]
The cmdline format from https://docs.docker.com/engine/reference/run/

If there are many containers to run on one host, and some of them have high
performance requirements, administrator could turn on thp for them:
# docker run -it --thp-enabled=always
Then all the processes in those containers will always use thp.
While other containers turn off thp by:
# docker run -it --thp-enabled=never

By doing this we could promote important containers's performance with less
footprint of thp.
> -- 
> Michal Hocko
> SUSE Labs
