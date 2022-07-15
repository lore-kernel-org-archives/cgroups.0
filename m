From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Bug] race condition at rebind_subsystems()
Date: Fri, 15 Jul 2022 06:47:59 -1000
Message-ID: <YtGaP+e35DZYSQf0@slm.duckdns.org>
References: <1978e209e71905d89651e61abd07285912d412a1.camel@mediatek.com>
 <20220715115938.GA8646@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=UwC5anEg0yjsg9Rw8IcHiu3GinY8BZcocAU9uCH0MCI=;
        b=kRPX1ruM5CjMlu1wj9auhM8ser8wATC3gVJCAiI2vCbhcBXZUWMyDTYhDsEN/2ow6z
         C7+1TvQrQD+ErLtFG/kwIDtsu18cPtzxGuZpGEVGPFYl3nQyigz+bLUFOvO8aqhIeQJW
         4FSZJpcLxa1UNYvKt0avG7GV9ldTRpmJsArPWoQDpxzmoAeCe0mKq4oRFAnuTUE8JlYj
         ZBKcF2ZN1n8f1akV2/h1+4YiqKiFPWla4bdyW3gCXvq3GTO0h7JXURDp3MXRfzNjWyoz
         2UzQFer9HHCToT+r6naorvjdplG/zjIyDzUKHeaM8cEww4he+LQ0Q2IQqBilO84FpZme
         AYiQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220715115938.GA8646-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Jing-Ting Wu <jing-ting.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, lixiong.liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wenju.xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, jonathan.jmchen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org

(resending, I messed up the message header, sorry)

Hello,

On Fri, Jul 15, 2022 at 01:59:38PM +0200, Michal Koutn=FD wrote:
> The css->rstat_css_node should not be modified if there are possible RCU
> readers elsewhere.
> One way to fix this would be to insert synchronize_rcu() after
> list_del_rcu() and before list_add_rcu().
> (A further alternative (I've heard about) would be to utilize 'nulls'
> RCU lists [1] to make the move between lists detectable.)
>=20
> But as I'm looking at it from distance, it may be simpler and sufficient
> to just take cgroup_rstat_lock around the list migration (the nesting
> under cgroup_mutex that's held with rebind_subsystems() is fine).

synchronize_rcu() prolly is the better fit here given how that list_node's
usage, but yeah, great find.

Thanks.

--=20
tejun
