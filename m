From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] misc_cgroup: use a counter to count the number of
 failures
Date: Thu, 26 Aug 2021 13:29:54 +0200
Message-ID: <20210826112954.GD4520@blackbody.suse.cz>
References: <a09f381462b1ce9c506a22713b998e21b459f7e9.1628899295.git.brookxu@tencent.com>
 <20210824164423.GA11859@blackbody.suse.cz>
 <YSVDwc/1sEmXdOK9@slm.duckdns.org>
 <4ed67493-e595-e002-69f9-1f53662ba189@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1629977395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IN2Dtsa48cpPIFgznxW6CFNis9T0sGloZqOdQstyxAo=;
        b=M+31mAg0zGIMPzDxcdU19Pxt7nwlp+rrH9dYqxplbi8iG3GiPB7PHCSVgk3FfheCJFRxXg
        ulMuwr76znAH/IGQnRHgKr2k5NYpeW4BiHjWEndgG7ZBZl/bbwAi80S00H/GjH7PlxevmC
        /esdDomCduAV0AEL4GdMz040vAT3Fag=
Content-Disposition: inline
In-Reply-To: <4ed67493-e595-e002-69f9-1f53662ba189-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 26, 2021 at 09:34:45AM +0800, brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> The core logic of pids cgroup and misc cgroup is similar.

Yes, the latter is conceptually a generalization of the former and it can
be tempting to use the general form. Beware that pids controller would
need to retain its existing API (and the behavior of being an
independent controller) and that would be IMO exceptions
counterweighting the generalization.

> Is it possible for us to merge pids cgroup into misc cgroup?

Technically it might be possible but I can't see the benefit (but maybe
you envisioned something else where my reasoning won't apply).

Michal
