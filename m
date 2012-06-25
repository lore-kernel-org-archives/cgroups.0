From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/11] memcg: Make it possible to use the stock for
 more than one page.
Date: Mon, 25 Jun 2012 10:44:37 -0700
Message-ID: <20120625174437.GC3869@google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-2-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=x/yTqJBfEOUJrlQVFZbj8Ye7V0qyhjxOxhypwFryDw4=;
        b=KBzm3VGM+jkezraAoR+AMtAAx2i1elg0Z/TwlXmx3uZEeLcI+bu9IwmYX0ZUI2J38O
         Ch3/BcG/NHPCANPfQrrc9FFV29Jv9kGgROUtF+xAswX2E0m7oXNyYV6Z5RxVNlYTAg7U
         z7TxKcCEIdpRYbta8baeGbpnkUC22EQHhVqGZsomMdmPZbINYAVrj2hrAjlaRPKkMNCc
         3firKtntY8mXz/QNPX7HXhEqzchBcPOk4iKclPX9juzGwrSnQTA84ckRmnFmhzi7S6Yk
         1Eb+WPRYqcPa4K/KJMMwqx1BjEx8hisCWoiuLHz90EILX7t79vGKfTpgQDdyahvoGdnu
         AH/g==
Content-Disposition: inline
In-Reply-To: <1340633728-12785-2-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hey, Glauber.

Just a couple nits.

On Mon, Jun 25, 2012 at 06:15:18PM +0400, Glauber Costa wrote:
> From: Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>

It would be nice to explain why this is being done.  Just a simple
statement like - "prepare for XXX" or "will be needed by XXX".

>  /*
> - * Try to consume stocked charge on this cpu. If success, one page is consumed
> - * from local stock and true is returned. If the stock is 0 or charges from a
> - * cgroup which is not current target, returns false. This stock will be
> - * refilled.
> + * Try to consume stocked charge on this cpu. If success, nr_pages pages are
> + * consumed from local stock and true is returned. If the stock is 0 or
> + * charges from a cgroup which is not current target, returns false.
> + * This stock will be refilled.

I hope this were converted to proper /** function comment with
arguments and return value description.

Thanks.

-- 
tejun
