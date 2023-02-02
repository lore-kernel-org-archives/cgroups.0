From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup user-after-free
Date: Thu, 2 Feb 2023 09:50:08 -1000
Message-ID: <Y9wT8At0MF1S5v0k@slm.duckdns.org>
References: <697032f2331a92eec0e03e85e46cb78bd975a788.camel@mediatek.com>
 <Y8Cwdsk5pYNd8fX8@slm.duckdns.org>
 <f8b24df3bd009d112479e9d5db36ec4afff9bb71.camel@mediatek.com>
 <3bb8e65797b905e4e9d4fad93a8f4fe26b8958a4.camel@mediatek.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0XqCItSDIlA9UN2KgN+ixgTMg/eGZMlJcrANVyohEDY=;
        b=iNBaT8Z+Ig7zrOQHc1RHN6iLOys2Q0io9gpYMeH9LzsUki6o83huVNzd3aSQV5JEzL
         QaQrK6iF24BTp/OaynHeDuVzOKVK72wVPLciBF0niO4O89anZ3czxsEFPo9KcbK3hZOt
         xG4jzE2Scyetx+HzYrSSxtl9aOcoJWt7DO4NNuUYH0sVPe9PeEABvNn+l8pjQ4rYu3hh
         1m/ogKgjMf6hFOFKPOWgr9Yndv0LRIChXjzkP0tt8mBZy2lLUtpjoTvaLh+fjVvLr1Kj
         EyoozxTzk5b4ThayMM0cCuOkOqWvXk59XVYxSz5oynrw23D0jagogoyMumcW0Jk+MF/k
         NQKw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3bb8e65797b905e4e9d4fad93a8f4fe26b8958a4.camel-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Lixiong Liu =?utf-8?B?KOWImOWIqembhCk=?= <Lixiong.Liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wenju Xu =?utf-8?B?KOiuuOaWh+S4vik=?= <Wenju.Xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, wsd_upstream <wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Jing-Ting Wu =?utf-8?B?KOWQs+mdnOWptyk=?= <Jing-Ting.Wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, WJ Wang =?utf-8?B?KOeOi+WGmyk=?= <wj.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Andress Kuo =?utf-8?B?KOmDreWtn+S/rik=?= <Andress.Kuo-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Feb 01, 2023 at 06:04:04AM +0000, Lixiong Liu (刘利雄) wrote:
> On Fri, 2023-01-13 at 13:40 +0800, lixiong liu wrote:
> > > > Root cause: 
> > > > cgroup_migrate_finish free cset’s cgroup,
> > > > 
> > > > but cgroup_sk_alloc use the freed cgroup,
> > > > 
> > > > then use-after-free happened.
> > > 
> > > Sounds similar to the problem fixed by 07fd5b6cdf3c ("cgroup: Use
> > > separate
> > > src/dst nodes when preloading css_sets for migration"). Can you try
> > > it out?
> > > 
> > > Thanks.
> > > 
> > 
> > 
> > Thanks for your quick feedback.
> > 
> > 
> >   
> > But we encountered use-after-free version
> > 
> > already contains this patch.
> > 
> > 
> > 
> > So, with this patch will also encounter
> > 
> > this use-after-free.
> > 
> > Thanks!
> > 
> > 
>   Do you have any suggestion for this issue?

Unfortunately, there isn't a lot to latch onto. It's on an older kernel and
there's no reproducer. Refcnting in the path is tricky and it wouldn't be
too surprising for some bugs to be there. If you can repro on a recent
kernel, that'd help a lot.

Thanks.

-- 
tejun
