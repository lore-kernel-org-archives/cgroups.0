From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg 2/3] memcg: remove charge forcinig for dying tasks
Date: Thu, 21 Oct 2021 12:03:18 +0200
Message-ID: <YXE65h/1qeSzKA4C@dhcp22.suse.cz>
References: <YW/WoJDFM3ddHn7Y@dhcp22.suse.cz>
 <cover.1634730787.git.vvs@virtuozzo.com>
 <56180e53-b705-b1be-9b60-75e141c8560c@virtuozzo.com>
 <YXAOjQO5r1g/WKmn@dhcp22.suse.cz>
 <cbda9b6b-3ee5-06ab-9a3b-debf361b55bb@virtuozzo.com>
 <YXAubuMMgNDeguNx@dhcp22.suse.cz>
 <dee26724-3ead-24d4-0c1b-23905bfcdae9@i-love.sakura.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634810599; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lb7XXB7wqKHGBh2gL7Zyuh+FLppJxySX9xGrB8I5wEA=;
        b=MaSik9roDAoYdCgZi6qhyc/laF7U1vE39+hc/YlZ2kqzOLWCOp9dmjNxyq1n3YFWcr31HR
        hfp/RkT+NiT208Nclww+4g8e32HXhCKSORvYbq/dLlJBIuj5KXhL/Vt7R6h6isHu1TOkUv
        f6TAQnNCl2+kwVuGHquE1a7UyTfgFd0=
Content-Disposition: inline
In-Reply-To: <dee26724-3ead-24d4-0c1b-23905bfcdae9-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Thu 21-10-21 00:20:02, Tetsuo Handa wrote:
> On 2021/10/20 23:57, Michal Hocko wrote:
> > One argument for removing it from here is the maintainability. Now you
> > have a memcg specific check which is not in sync with the oom. E.g.
> > out_of_memory does task_will_free_mem as the very first thing. You are
> > also automatically excluding oom killer for cases where that might make
> > a sense.
> 
> What makes it possible to remove this check?
> This check was added because task_will_free_mem() in out_of_memory() does NOT work.
> See commit 7775face207922ea ("memcg: killed threads should not invoke memcg OOM killer").

You are right. I've forgot about this and should have checked git blame.
Thanks for bringing this up!

-- 
Michal Hocko
SUSE Labs
