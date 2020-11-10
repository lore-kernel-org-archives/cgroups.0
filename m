From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg/slab: Fix root memcg vmstats
Date: Tue, 10 Nov 2020 10:57:23 -0800 (PST)
Message-ID: <alpine.DEB.2.23.453.2011101054350.1685210@chino.kir.corp.google.com>
References: <20201110031015.15715-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=/kb37eWBLDbjDnXmFWfjVVLRM7gSVNXEojlTedCdvIo=;
        b=JqIkwI7mdvEOLGgaIkz1ad0WiIuxYzgH0Yc+w9hHs29ATydarbNS09YbvxzgGRTA+P
         4v2AYugE3z7Q2QIeD3OhEndw3WYxeW2qZ16+ck2tb5l8QvEnSQ3AF/yxD9OfnJXgSvfU
         0kUI2sAyChygWhOdSkQLeY4rXbW4trVTu5JZ6TAtI7Nl4yewa5HMXRcieo9By2J0Sv/1
         FZfrBAyhW2vT5RjBkJAMyeqeBzWN1CfhkwhjlYL1MDOnm0kZmD51aUsf2d8saiztrvEk
         sgMVef5QM8EDIEN1uklngMw5xuO1SAjFMC28c0Fo0sTiedCuw73rPx2KgT5Ctj3UEx+K
         9MNw==
In-Reply-To: <20201110031015.15715-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, 10 Nov 2020, Muchun Song wrote:

> If we reparent the slab objects to the root memcg, when we free
> the slab object, we need to update the per-memcg vmstats to keep
> it correct for the root memcg. Now this at least affects the vmstat
> of NR_KERNEL_STACK_KB for !CONFIG_VMAP_STACK when the thread stack
> size is smaller than the PAGE_SIZE.
> 
> Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

I assume that without this fix that the root memcg's vmstat would always 
be inflated if we reparented?  If that's accurate, perhaps this is 
deserving of a

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.3+
