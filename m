From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 4/6] cgroup/cpuset: Allow non-top parent partition
 root to distribute out all CPUs
Date: Wed, 11 Aug 2021 08:21:10 -1000
Message-ID: <YRQVFkNX5DcKixzy@slm.duckdns.org>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-5-longman@redhat.com>
 <YRQTTf+bJZ8f3O3+@slm.duckdns.org>
 <abfa6f2f-aa13-f18e-5a16-f568082d07bc@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HFDIoz8d7Mv9aa4YQB/vncboqcxrcGkzaCeqrt8Oa/c=;
        b=MS7b9dsp8zC6Ryob8fxICyK6KkSDR+X5AMd+2XpfBHkmhREj5PIpVfoOXNQiS4reRj
         0cTMvejH51bHkLHR2I8NMuhzRvYSqx3rZetceDQt90jdntsqtNvYKw2AmX3mJgVQVTVp
         z2mDnMbvykTMuDXEtX+r9TIEw51KrQ2r1vdwmV8+SGxf9f1Lvcxta/iq7gfj37x0svwl
         e4vZXTh5smg5nlsx1T8arrxCQbPfHtyfrGukGc8+cIZTm+WPKpAG1Nw5IWf0N1sAgXuk
         2ZZVKz5kEiCe86Ao+nx5cQxTIaWVAkGi8sLj53ubKE+jzK7VdMsym7KQZxTtLZ/Smn+a
         +HbA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <abfa6f2f-aa13-f18e-5a16-f568082d07bc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Wed, Aug 11, 2021 at 02:18:17PM -0400, Waiman Long wrote:
> I don't think that is true. A task can reside anywhere in the cgroup
> hierarchy. I have encountered no problem moving tasks around.

Oh, that shouldn't be happening with controllers enabled. Can you please
share a repro?

Thanks.

-- 
tejun
