From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 17:13:52 -0400
Message-ID: <YkdrEG5FlL7Gq2Vi@cmpxchg.org>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <YkXkA+Oh1Bx33PrU@carbon.dhcp.thefacebook.com>
 <CAJD7tkYVpnf1+sa9vRAQCw5H0LUH6zE6_yhNAFwKF3sW0BLzEA@mail.gmail.com>
 <YkdG4nv/uKI0EtMp@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1NBRp1HzbNCgKf7QFMBcsjXIZ9h5LA2zsVAhStlZGsU=;
        b=S3e9r2h5S/Lod35wzYRaK1L5GREWuQAVOTczCCvp+AvT9S37huY+EoFoDqDnnr6KOE
         N6e1yXaNF4QQVU8G9U/GULrvVAEC7yd+sEuCnVhhtnxImWTtkJnry6Mn85pnbyip6w0P
         VoBUATjnT3b1RpL+BsqSjYjyhZvg3WWi10vxawB6kHAkm2DkuEo8dhSfUn/QT/T6KGOY
         Dxc0HmB78YkJbJoJI12rAo3MJOChv+SEFUT6efmRoS4tPr8tFZK6tpnzR4DJ+hJI6F4B
         s+pNP7VlxTORg0K4n1IEq98avQdmm/GdYqZXPMXnfkFXpLjvwbp/RfpKhQgxN9hie8af
         gjrg==
Content-Disposition: inline
In-Reply-To: <YkdG4nv/uKI0EtMp-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Apr 01, 2022 at 11:39:30AM -0700, Roman Gushchin wrote:
> The interface you're proposing is not really extensible, so we'll likely need to
> introduce a new interface like memory.reclaim_ext very soon. Why not create
> an extensible API from scratch?
> 
> I'm looking at cgroup v2 documentation which describes various interface files
> formats and it seems like given the number of potential optional arguments
> the best option is nested keyed (please, refer to the Interface Files section).
> 
> E.g. the format can be:
> echo "1G type=file nodemask=1-2 timeout=30s" > memory.reclaim

Yeah, that syntax looks perfect.

But why do you think it's not extensible from the current patch? We
can add those arguments one by one as we agree on them, and return
-EINVAL if somebody passes an unknown parameter.

It seems to me the current proposal is forward-compatible that way
(with the current set of keyword pararms being the empty set :-))
