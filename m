From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/5] cgroup: distinguish the default and legacy
 hierarchies when handling cftypes
Date: Mon, 14 Jul 2014 10:42:57 -0400
Message-ID: <20140714144257.GD31610@htj.dyndns.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
 <1404345055-8196-5-git-send-email-tj@kernel.org>
 <53C33CC7.3020707@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vwCKPFDRE9c5cf08wDueb5wOrza61OacR3uO7N73eXs=;
        b=sTujrPSlG4vPZlBHsYuz4bRyK4Z54uKvOTtlpSmTvV8gR/2jshrIjnP8M3W8MN43Go
         VIA5HnyIqUaJuD9cJwUAB9WkHR5AoerOOmK0q2zIU6/XqoScqOQRO/ewHpmH5NTf/2Ur
         uhjJx5c9LlqU10rmfVD5nFiFMh2jRxYi/3qhjDujvIlzz3I7/vZM/ILjJqyT5GMDKigO
         x/DHDqUslo9Aab8Z9M9q/yyDT58IJ+DDG8MmJ0AMGDHfWTa8yyLjj9VNaxpC8B7VXifJ
         9gbNAREahtlslkcC3A0FUUpv0+l4wqX5Hpfk4mgqlurJSc7V0WumHceiQNSHqKGDpiYa
         LEGw==
Content-Disposition: inline
In-Reply-To: <53C33CC7.3020707-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

On Mon, Jul 14, 2014 at 10:13:27AM +0800, Li Zefan wrote:
> I think we should remove this flag in cgroup_rm_cftypes_locked(). Otherwise
> if we call cgroup_add_dlf_cftypes() and then cgroup_rm_cftypes() and then
> cgroup_add_legacy_cftypes() for the same @cfts, both CFTYPE_ONLY_ON_DFL and
> CFTYPE_INSANE are set.

Heh, that's unlikely to actually happen but yes clearing would be
better.  Will update accordingly.

Thanks.

-- 
tejun
