From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm/page_owner: Dump memcg information
Date: Mon, 31 Jan 2022 14:01:18 -0500
Message-ID: <c781641d-e5dc-f79b-a9c0-aa91ab228316@redhat.com>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-4-longman@redhat.com>
 <YfeuK5j7cbgM+Oo+@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643655695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lxAwEA9Ms4jKsy8aU7wpsx4G3K1ATTggQYOqNKinqIQ=;
        b=bRvqa2oyRrg1muy2A3fct8z9mQg5YKEVdOo678W9fMhUh1ggJuW+d1PNeoMji/8/JWN/ho
        hpn3ERFMeC23C7+A1kf3iuGuubSHD70CA2HRaEATjABF8QApGd5026KQE33RKCU02yi1xn
        8NV3cboLDzYxpRLTCPA6yZo0iut8NU4=
Content-Language: en-US
In-Reply-To: <YfeuK5j7cbgM+Oo+-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 1/31/22 04:38, Michal Hocko wrote:
> On Sat 29-01-22 15:53:15, Waiman Long wrote:
>> It was found that a number of offlined memcgs were not freed because
>> they were pinned by some charged pages that were present. Even "echo
>> 1 > /proc/sys/vm/drop_caches" wasn't able to free those pages. These
>> offlined but not freed memcgs tend to increase in number over time with
>> the side effect that percpu memory consumption as shown in /proc/meminfo
>> also increases over time.
>>
>> In order to find out more information about those pages that pin
>> offlined memcgs, the page_owner feature is extended to dump memory
>> cgroup information especially whether the cgroup is offlined or not.
> It is not really clear to me how this is supposed to be used. Are you
> really dumping all the pages in the system to find out offline memcgs?
> That looks rather clumsy to me. I am not against adding memcg
> information to the page owner output. That can be useful in other
> contexts.

I am just piggybacking on top of the existing page_owner tool to provide=20
information for me to find out what pages are pinning the dead memcgs.=20
page_owner is a debugging tool that is not turned on by default. We do=20
have to add a kernel parameter and=C2=A0 rebooting the system to use that, =

but that is pretty easy to do once we have a reproducer to reproduce the=20
problem.

Cheers,
Longman

