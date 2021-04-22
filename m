From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3 15/16] memcg: enable accounting for tty-related objects
Date: Thu, 22 Apr 2021 13:23:21 +0200
Message-ID: <YIFcqcd4dCiNcILj@kroah.com>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
 <da450388-2fbc-1bb8-0839-b6480cb0eead@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619090604;
        bh=Mx/79Tlvzv5GZtxiqgvpFLyIp0xUSUvc0zLjb/CPgfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HM18T0Su4Vlx98O/ybn/9SaDiRhFaXQtJwf1ePRALyjnUITAfJYC5wqL3e9wzNtro
         rVVshchUl0iYW/7PMJK8UBaQUMjEFlW1XNg/IOBJc8IMF2aIy5ssPEclGieQV0Evkz
         U4VRi+JjIXSOrg3tEjARIl6joWlpseTFcYhnURQc=
Content-Disposition: inline
In-Reply-To: <da450388-2fbc-1bb8-0839-b6480cb0eead-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, Apr 22, 2021 at 01:37:53PM +0300, Vasily Averin wrote:
> At each login the user forces the kernel to create a new terminal and
> allocate up to ~1Kb memory for the tty-related structures.

Does this tiny amount of memory actually matter?  This feels like it
would be lost in the noise, and not really be an issue for any real
system as it's hard to abuse (i.e. if a user creates lots of tty
structures, what can they do???)

So no, I do not think this patch is needed, thanks.

greg k-h
