From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Thu, 20 Jul 2023 09:57:09 -1000
Message-ID: <ZLmRlTej8Tm82kXG@slm.duckdns.org>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689883031; x=1690487831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=488yUOu99r9XLGMS28MSYzrMwwZ0NrAxoU1mgPEtyC0=;
        b=JMOtgIe5DMCQIM5oGBqiM/ylvwu1hwkVQ2QtHWVBkEpUkMxSBsHgJiIR+2G1Cmd92f
         hAUBEFj/gA1H/BM8ljgqxthlJlVxMD476DlEUWU/1N6EBCogXk6q2lfnqU5N7Y10dcs3
         AlbzAMThKFik0AKakGGOEzM0/6Q1qkYZTz0YA/AooEzuEbU/CD+SD8lVnNX3xr8RxCSU
         Z0kfnx/V4AVR80XTFTSA1OHu1ZT0svkQ43EtUm5dBUMiCtXTeSxMUQfZM5+8wHRc1pfI
         MThEn2/skjYIxiEp09PvzELiObCA7r0EcUFVqOAkb2xbdwig8ciQeTkHCv3PbXXnZNIz
         WHSA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230720153515.GA1003248-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 20, 2023 at 11:35:15AM -0400, Johannes Weiner wrote:
> It could also be argued that if you don't want to lose control over a
> set of resources, then maybe don't delete their control domain while
> they are still alive and in use. For example, when restarting a
> workload, and the new instance is expected to have largely the same
> workingset, consider reusing the cgroup instead of making a new one.

Or just create a nesting layer so that there's a cgroup which represents the
persistent resources and a nested cgroup instance inside representing the
current instance.

Thanks.

-- 
tejun
