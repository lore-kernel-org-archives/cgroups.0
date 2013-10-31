From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] memcg, kmem: rename cache_from_memcg to
 cache_from_memcg_idx
Date: Wed, 30 Oct 2013 19:37:16 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1310301937060.18783@chino.kir.corp.google.com>
References: <1382527875-10112-1-git-send-email-h.huangqiang@huawei.com> <1382527875-10112-3-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=Jr9BQRAj7BVovIoO4jhekJqxI3XZz+hGwrJnLMyzc1c=;
        b=JBGFEChATpn+g5NBUzmiMgM00qaixZKRshLaeEP6K+4TyyAT0TzJjXlLZm6TUwzuHx
         OaeCLnqLkl6jw3xi7gFb6efajTqGvBVMrjT7YlKO409exBxaLYdfMEG105o9B1hmFCoR
         dCc+mLDcjyBKLu/A53rYOkcx67G0q4z9TNTppGPCZGC+jOAfiuDC/lGuUT8C/5QjOBAl
         P25Sh4297P6WP+YWe1BAXUs4zBmkzzF89U62R5oInOMfMkOa4a7Q5bI1hpZXg50I5CAg
         f3qua3HtDpuF3TcC2St5pN+Fidhir/S2Zi87rgsUMQvFMUBLr0FDxewIYrXzrvK1TiNx
         VFSA==
In-Reply-To: <1382527875-10112-3-git-send-email-h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, 23 Oct 2013, Qiang Huang wrote:

> We can't see the relationship with memcg from the parameters,
> so the name with memcg_idx would be more reasonable.
> 
> Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
