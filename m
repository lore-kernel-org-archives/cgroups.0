From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 3/3] cgroup/cpuset: Keep user set cpus affinity
Date: Tue, 16 Aug 2022 12:19:07 -1000
Message-ID: <YvwX24GXadKQNp6V@slm.duckdns.org>
References: <20220816192734.67115-1-longman@redhat.com>
 <20220816192734.67115-4-longman@redhat.com>
 <Yvv66EWygCwHUCqy@slm.duckdns.org>
 <c10e4f69-9951-6c38-6e28-fafcaec00d89@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=v/EIdBGUkUPtNpLpVOdmRMecyshYK7WIwF9D88OOScU=;
        b=XFz549JzgGby3QShSMg1u6ld0qYxrMD3+idlLFNetfD3Uf4CUVmSJzQwu21B0nSuY3
         DE4olgojem8eez9w5KVGDNKI9NvFlyOpx319HD1Xz0JPYqZ7GtDaO4Vyu517VUEk0vBa
         3EPbHmc4qV8pUgXU3pMJS7zvviFi4hykmH28LUfjweBN4/f1jde/ZTjmWze/tOVxcjiD
         4wVtggFwXqgarGqZBPJL4V5dNiKgZShkmuN19HOl8yD0CjcppHuDpJIaW2fOtUgfImf7
         O+dicxS87PkLT0yR/gQzPEFBhH8VvmUxwvw6Z992mJ3fcqgr6NEgfIBdiJy8L84CfIGW
         C8oA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c10e4f69-9951-6c38-6e28-fafcaec00d89-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Tue, Aug 16, 2022 at 06:11:03PM -0400, Waiman Long wrote:
> It is hard to synchronize different subsystems atomically without running
> into locking issue. Let me think about what can be done in this case.

I have a hard time seeing why this would be particularly difficult. cpuset
just needs to make the latest cpumask available to sched core in an easily
accessible form and whenever that changes, trigger a set_cpus_allowed call.
There's no need to entangle operations across the whole subsystems. All
that's needed to be communicated is the current cpumask.

> Is using a sequence number to check for race with retry good enough?

It seems unnecessarily fragile and complicated to me. If we're gonna change
it, let's change it right.

Thanks.

-- 
tejun
