From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm v5 0/9] memcg: accounting for objects allocated by
 mkdir, cgroup
Date: Thu, 23 Jun 2022 09:55:33 -0700
Message-ID: <CALvZod4WsmrpfZtfnP4AmvtnkvBRngXXGyhM6+aQzkdfjsinAQ@mail.gmail.com>
References: <4e685057-b07d-745d-fdaa-1a6a5a681060@openvz.org>
 <0fe836b4-5c0f-0e32-d511-db816d359748@openvz.org> <c516033f-a9e4-3485-26d9-a68afa694c1d@openvz.org>
 <YrSP25ebDmXE+kPS@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zxNuJF6Nbe8LLHbYqIbwZg9Zj1L4NANG6tNglCp+Qvc=;
        b=XHUVPgvbh1RbKwDTYzng/n5/obx4NKF4t5gJwAYybq7iw0yl1IDnJnj/UY6lbOdIcC
         JkaxYapcyaMhT7hyRjqzXPDIvNUgOB31tZlsO0LlgDI/TYnfopMr1Zeep1u7xtng6c7U
         Sm3VvZm1doZ/hhaqr8Q85AwjJvT8qWBqtgoRDufLJDPWRTqeYWW1HMtPPhtpNvrt51hn
         OzAAz9xbjUVszG9brdyyjkJOuSgnHuvZ6zm2eprL83/CPtn07FUuEfi6zGOrWwOkzBjA
         pYCc/T8UNb0tsN+TWWA7O5ktS1EBpp22pfEQuQWcMcqlVh/8XUXFTzRxBRfxmd9MTYgU
         9zuA==
In-Reply-To: <YrSP25ebDmXE+kPS-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jun 23, 2022 at 9:07 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Thu 23-06-22 18:03:31, Vasily Averin wrote:
> > Dear Michal,
> > do you still have any concerns about this patch set?
>
> Yes, I do not think we have concluded this to be really necessary. IIRC
> Roman would like to see lingering cgroups addressed in not-so-distant
> future (http://lkml.kernel.org/r/Ypd2DW7id4M3KJJW@carbon) and we already
> have a limit for the number of cgroups in the tree. So why should we
> chase after allocations that correspond the cgroups and somehow try to
> cap their number via the memory consumption. This looks like something
> that will get out of sync eventually and it also doesn't seem like the
> best control to me (comparing to an explicit limit to prevent runaways).
> --

Let me give a counter argument to that. On a system running multiple
workloads, how can the admin come up with a sensible limit for the
number of cgroups? There will definitely be jobs that require much
more number of sub-cgroups. Asking the admins to dynamically tune
another tuneable is just asking for more complications. At the end all
the users would just set it to max.

I would recommend to see the commit ac7b79fd190b ("inotify, memcg:
account inotify instances to kmemcg") where there is already a sysctl
(inotify/max_user_instances) to limit the number of instances but
there was no sensible way to set that limit on a multi-tenant system.
