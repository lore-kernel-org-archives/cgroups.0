From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Fri, 14 Apr 2023 06:54:05 -1000
Message-ID: <ZDmFLfII8EUX_ocY@slm.duckdns.org>
References: <1ce6a073-e573-0c32-c3d8-f67f3d389a28@redhat.com>
 <ZDcS_yVCgh6g1LoM@slm.duckdns.org>
 <e38f72aa-9705-cf0c-a565-fb790f16c53e@redhat.com>
 <ZDdG1K0kTETZMTCu@slm.duckdns.org>
 <cd4c3f92-4a01-e636-7390-8c6a3d0cfe6c@redhat.com>
 <ZDdNy2NAfj2_1CbW@slm.duckdns.org>
 <1b8d9128-d076-7d37-767d-11d6af314662@redhat.com>
 <ZDdYOI9LB87ra2t_@slm.duckdns.org>
 <9862da55-5f41-24c3-f3bb-4045ccf24b2e@redhat.com>
 <226cb2da-e800-6531-4e57-cbf991022477@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681491248; x=1684083248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oZAvqYOYWKaKZx+hMdeSRvFQw5l3f6+NXzgHNVGxyZc=;
        b=OfVaK49qpidMI4dngUHtYirJkn7oUxSdbRfakMpgbgn1EFE3V1SYLnsMiNawY5+rO8
         RSz6N22SGnArcSiCFDiDDF8y0Mg0rksJp6GEeqz4JCmOGYqPgTBU4DjnYzHkVJtnjfbs
         7M6o0fyvoZAa764vAUL+5wWCmydHepII7odqZRhxbPgswGcuJLGCb33m//yqFG51bGfd
         EuZchA48GyJDKBZFZBQz8/ubKoIpi6QR7p2vFeaq8xIxPzym+vxjvt+3fBHgCGQoGciR
         d+wDMNjSb7n0YwP2P3v8pIMdRq4upNL7fPmC5l6PUNGZPadQDMFZSkNyK/qtJpT0U7l1
         8/5Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <226cb2da-e800-6531-4e57-cbf991022477-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, Apr 13, 2023 at 09:22:19PM -0400, Waiman Long wrote:
> I now have a slightly different idea of how to do that. We already have an
> internal cpumask for partitioning - subparts_cpus. I am thinking about
> exposing it as cpuset.cpus.reserve. The current way of creating
> subpartitions will be called automatic reservation and require a direct
> parent/child partition relationship. But as soon as a user write anything to
> it, it will break automatic reservation and require manual reservation going
> forward.
> 
> In that way, we can keep the old behavior, but also support new use cases. I
> am going to work on that.

I'm not sure I fully understand the proposed behavior but it does sound more
quirky.

Thanks.

-- 
tejun
