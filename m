From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Tue, 23 Aug 2022 06:20:20 -1000
Message-ID: <YwT+RDZyszAQ/Vro@slm.duckdns.org>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
 <YvKd6dezPM6UxfD/@slm.duckdns.org>
 <fcd0bd39-3049-a279-23e6-a6c02b4680a7@bytedance.com>
 <b89155d3-9315-fefc-408b-4cf538360a1c@bytedance.com>
 <YvPN07UlaPFAdlet@cmpxchg.org>
 <20220815132343.GA22640@blackbody.suse.cz>
 <9d1997a4-9278-07bd-7f57-952306b28b14@bytedance.com>
 <YwTz32VWuZeLHOHe@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=MkchlG+vC7eeExntyPywB6o/N2CwihE3Mv9oTg/XCfA=;
        b=XxzpYtA2pnvxm7jj/aZsB1ovGYgGFFOxiJHjtvxhSaQ2REDVDoCQIjB/GtHH3oVwse
         NbSR71cHM3UNRFgLwyej9TpI0L9rWYkF3KkrxZ2C2kw/EhuAh1C8pna4IXsnCDF3BF2V
         8IhM33IU1xrqLpTtcYD8/GGzjVMCaXX2XEfzTFIJp+wjFzbfTmxY37Dv4svHZMG0+KEo
         aRjhTxwWgpoysJLCODS4LSRitnpLJHVgILVZtGtASuPTh6vMwSzxhp5+JZNm5nJ5IYCo
         b3Dy8XSRPGHhnsPawF9cGPvUjeBwgKkMqHXYvYuy4cvIN6PNJjDppSYfrn2gz9H3zm6h
         9Uyg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YwTz32VWuZeLHOHe-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hello,

On Tue, Aug 23, 2022 at 11:35:59AM -0400, Johannes Weiner wrote:
> Re 1: I agree. If desired in the future we can make the default
> configurable. Kconfig, mount option, what have you. cgroup.pressure
> will work fine as a name regardless of what the default is.

Given that there's already cgroup_disable=pressure for cases which want it
fully disabled, I'm not sure we'd need to add more complex disabling
options. The only difference that'd make is for users who are configuring
cgroups manually which is pretty rare and it'd create a clear downside of
increasing confusion as the base assumption becomes dynamic. So, I think the
current default-on with opting-out is and will be just fine.

> Re 2: Not all consumers of the pressure metrics create trigger. I
> would argue that few do. So it isn't the best signal to decide on
> whether aggregation should occur. And yes, it's further complicated by
> the triggers being written to the very pressure files. If we don't
> hide them, we have to come up with another way to mark them as stale,
> lest they confuse the heck out of users. Without breaking format...
> 
> So IMO, default-enable, "cgroup.pressure" as a name, and hiding the
> pressure files should be good for now while allowing to make the
> default configurable down the line.

Sounds great.

Thanks.

-- 
tejun
