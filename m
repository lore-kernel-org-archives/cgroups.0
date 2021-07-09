From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 3/3] mm, memcg: inline swap-related functions to improve
 disabled memcg config
Date: Fri, 9 Jul 2021 10:49:45 -0400
Message-ID: <YOhiCbrBjWnJaJMt@cmpxchg.org>
References: <20210709000509.2618345-1-surenb@google.com>
 <20210709000509.2618345-4-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sl7zNgfOy4Ks0Fk6pkfy9FhpGYHd/QTs7j+H3rSlVoM=;
        b=QA6tQE9mCvmjOaTfcc2lhfJ7BmUP0CTjYUCkE42z/dXIUmI+XlkPMDOIo3wA9Ewd8i
         TJcT0Rjq4p0GKVFYWW4j9Z1BcCOpXN4vxlhh0bU60qcdL/HIkNQKC8c3XQYi+hCe6xVR
         7LkNosRmU6md/syD7lrW9ODys7pLAhmCYjFS3RlKMHmbyHNwnwns2S+NrAp/9socbAT1
         UV55cIljPhKM/izeG48aY0Wy97a79OseJ1N8UaBbkZTZ1fslg1hFWwkdoblX5UjI3Lc6
         uzOf7aOyTsRBNkJWX+cX40JVq0JY0KnTTyyXoH1lR6JySxF1VylzyMoTh1CsWjQnkLg+
         1TJQ==
Content-Disposition: inline
In-Reply-To: <20210709000509.2618345-4-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Thu, Jul 08, 2021 at 05:05:09PM -0700, Suren Baghdasaryan wrote:
> Inline mem_cgroup_try_charge_swap, mem_cgroup_uncharge_swap and
> cgroup_throttle_swaprate functions to perform mem_cgroup_disabled static
> key check inline before calling the main body of the function. This
> minimizes the memcg overhead in the pagefault and exit_mmap paths when
> memcgs are disabled using cgroup_disable=memory command-line option.
> This change results in ~1% overhead reduction when running PFT test
> comparing {CONFIG_MEMCG=n} against {CONFIG_MEMCG=y, cgroup_disable=memory}
> configuration on an 8-core ARM64 Android device.
> 
> Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Looks reasonable to me as well.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
