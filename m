From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] misc_cgroup: use a counter to count the number of
 failures
Date: Tue, 24 Aug 2021 18:44:23 +0200
Message-ID: <20210824164423.GA11859@blackbody.suse.cz>
References: <a09f381462b1ce9c506a22713b998e21b459f7e9.1628899295.git.brookxu@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1629823464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z2MS98YdJwtJG8FeEq/L2x2vYouQos57GNWyqg6QJyA=;
        b=hglYmTZ0ibs1kipNcDW5ppNCm78oIvq31YUQTGxYE8JL/H3Wp8stjoxc6XSfbVqbCPZWyt
        dASzpF/UoW3GZDFju1KQQEVfGEgc/19+HZjo10yyqbLoV3XhjN/WiOCz7eUY3CydwdrSeP
        hjtEnkPekDuCd/Wzr5eXZa4izsSh76k=
Content-Disposition: inline
In-Reply-To: <a09f381462b1ce9c506a22713b998e21b459f7e9.1628899295.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

On Sat, Aug 14, 2021 at 08:15:16AM +0800, brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 1. If a large number of containers are created and deleted,
>    there will be a lot of error logs.
> 2. According to an error log, we cannot better understand
>    the actual pressure of resources.
> 
> Therefore, perhaps we should use a failcnt counter to count
> the number of failures, so that we can easily understand the
> actual pressure of resources and avoid too many error log..

This is an understandable use case and generally the implementation via
the counter is good as well.

However, the non-hierarchical failcnt interface looks like v1ism to me
(I think new features should come with v2 first in mind).
What about exposing this in misc.events file with max.$res_name entries? 

Or if the hierarchical reporting is unnecessary now, there can be just
misc.events.local for starters.

(That reminds me the forgotten pids.events[.local] rework [1], oops.)

Michal

https://lore.kernel.org/lkml/20191128172612.10259-1-mkoutny-IBi9RG/b67k@public.gmane.org/#t

