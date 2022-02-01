From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND] mm: memcg: synchronize objcg lists with a
 dedicated spinlock
Date: Tue, 1 Feb 2022 12:48:41 -1000
Message-ID: <Yfm4yfrrJeTlaJZc@slm.duckdns.org>
References: <Yfm1IHmoGdyUR81T@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HsfDWGpmirQwGTRSNLQmFIAkG7JByQa85AM3b1LDm9s=;
        b=CJBxYQNIX+LlGI+UmRx6JCxuUPoQ7jTBOZzzrt7PdYR/WkLZRWZvXQj3G0f86j/+b6
         UXbU0FxuqsspOF5IPtFH6OFpXkbZEwPt8NK/wSkHNf9OyU9cgEqG3luPE28pUZ0L1BBl
         lhiM199dG1suxWuKlC7TBlGkQIvSt6OVQZsqMz/l1bKYP/qJWEMRNbXAc4w1D8bVngks
         sgYdJc/royL6aG8SLjFjryd6VtDD3S8E5U1tN+Hxc6fRDDMrayyKiSkVhFLXo1aM+Kk1
         kGhFbb5oFGdSUfrW64XdKFsIP7FFFzAmKgZ3/UObVR8WXVzMS/cpiV3oLZwRBhe471b/
         Q/XQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Yfm1IHmoGdyUR81T-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 01, 2022 at 02:33:04PM -0800, Roman Gushchin wrote:
...
> In this example a slab allocation from __send_signal() caused a
> refilling and draining of a percpu objcg stock, resulted in a
> releasing of another non-related objcg. Objcg release path requires
> taking the css_set_lock, which is used to synchronize objcg lists.
> 
> This can create a circular dependency with the sighandler lock,
> which is taken with the locked css_set_lock by the freezer code
> (to freeze a task).
> 
> In general it seems that using css_set_lock to synchronize objcg lists
> makes any slab allocations and deallocation with the locked
> css_set_lock and any intervened locks risky.
> 
> To fix the problem and make the code more robust let's stop using
> css_set_lock to synchronize objcg lists and use a new dedicated
> spinlock instead.
> 
> Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Reported-by: Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
> Tested-by: Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
> Reviewed-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I suppose this will go through -mm? If you want me to route it through the
cgroup tree, please let me know.

Thanks.

-- 
tejun
