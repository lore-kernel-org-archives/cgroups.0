From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup user-after-free
Date: Thu, 12 Jan 2023 15:14:30 -1000
Message-ID: <Y8Cwdsk5pYNd8fX8@slm.duckdns.org>
References: <697032f2331a92eec0e03e85e46cb78bd975a788.camel@mediatek.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/+22Q56bJPrledR2Cz6M9kGSFqzu3U0nD7pq3Hab+AU=;
        b=LskLqLtZroGnCLT7v2RAIbLULPmZdsvu+XzR5D7MTLPsEC8wXxf272Z1o+0hiCjvSw
         qCJB26/ruPEjGO9FEme6GxPxk1Jpqhmzx/rcE2woX5PtAQRllglFJUqPzPqFgHxqLuUX
         JMS8qq+fXNeUZjx7jY80f2+gg6DHsNPa/+ihzIx/5qH3t3iPZiFPRrlkD/34R3crlFxC
         0N8G1VAb51W/zqTdhDE9f+Ox7hgVcOUiN8GVadsvOUT7oovyDsc16OIZ8lve1Qgmdc0W
         tzcL6hwJ49DJ0/nkeSsYJvoBbW8nMevIDVzqk5CFywnuWwFtDcYxU22PgihW9CgQH/Qk
         HIiA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <697032f2331a92eec0e03e85e46cb78bd975a788.camel-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Lixiong Liu =?utf-8?B?KOWImOWIqembhCk=?= <Lixiong.Liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Cc: "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wenju Xu =?utf-8?B?KOiuuOaWh+S4vik=?= <Wenju.Xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, wsd_upstream <wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Jing-Ting Wu =?utf-8?B?KOWQs+mdnOWptyk=?= <Jing-Ting.Wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, WJ Wang =?utf-8?B?KOeOi+WGmyk=?= <wj.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Andress Kuo =?utf-8?B?KOmDreWtn+S/rik=?= <Andress.Kuo-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Jan 12, 2023 at 09:48:55AM +0000, Lixiong Liu (刘利雄) wrote:
> Hi,
> 
> We meet cgroup use-after-free happened in T SW version with 
> 
> kernel-5.15.
>  
> Root cause: 
> cgroup_migrate_finish free cset’s cgroup,
> 
> but cgroup_sk_alloc use the freed cgroup,
> 
> then use-after-free happened.

Sounds similar to the problem fixed by 07fd5b6cdf3c ("cgroup: Use separate
src/dst nodes when preloading css_sets for migration"). Can you try it out?

Thanks.

-- 
tejun
