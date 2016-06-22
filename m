From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: question about cgroupv2
Date: Wed, 22 Jun 2016 11:36:56 -0400
Message-ID: <20160622153656.GX3262@mtj.duckdns.org>
References: <5764ADC5.20205@cn.fujitsu.com>
 <5768D36D.3060606@huawei.com>
 <5768D8F5.1060107@cn.fujitsu.com>
 <9B0331B6EBBD0E4684FBFAEDA55776F92CD6983C@HASMSX110.ger.corp.intel.com>
 <5768FBF8.2060100@cn.fujitsu.com>
 <5769DF64.1040406@huawei.com>
 <9B0331B6EBBD0E4684FBFAEDA55776F92CD6A674@HASMSX110.ger.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EfGkhb0pnIYfbzc4+JfokVp8AhMF2TWmNiZpcaEbh8I=;
        b=VgT/SJhN3osMuWyLFaFFR9rspY4RSDuWT59u8maXYmTgD/r10s0sc1w3FmSlJXG6Pm
         47AksLQW3/b5vrIqLYPRXQiPBVC9Lv3yUFszK2NcQuQE69whpnbL946VkFu6JjqXnkLZ
         HeWTegM316LHBt+dXfwHKNtCDV/NHyhwC9BgNp0jFme+py8158Fcg7fKWguCdFwK9DZd
         7dwPkFtQ4DTBF49LIn/6lk8PJXyVfL5gpM5R/dpmzwLptUyhDN9abhnjuk7sRVhbjZWG
         Oa4vOoElpvRXA5Kbvi1E3MokYd6rj5N+/V3pTe5JYmdbPgcNuEjdCkpFHkukWQ6eUGue
         66QA==
Content-Disposition: inline
In-Reply-To: <9B0331B6EBBD0E4684FBFAEDA55776F92CD6A674-cNwSTNrqBuVnIh7sxsoRyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Rosen, Rami" <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jun 22, 2016 at 07:13:07AM +0000, Rosen, Rami wrote:
> Hi all,
> 
> > because systemd hasn't supported cgroup2 yet.
> 
> This is indeed so; systemd has support, from v226 (September 2015) for the new cgroup API via a
> kernel command-line option: 'systemd.unified_cgroup_hierarchy=1', which uses 
> a (meanwhile) deprecated mount option of cgroups. See:
> https://lists.freedesktop.org/archives/systemd-devel/2015-September/034177.html
> 	
> Probably  systemd will migrate to using cgroup v2 according to its current implementation 

It's being worked on will be there in the next release.

Thanks.

-- 
tejun
