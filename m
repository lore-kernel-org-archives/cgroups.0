From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/9] mm: Mark function as static in memcontrol.c
Date: Fri, 7 Feb 2014 12:55:22 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1402071254410.4212@chino.kir.corp.google.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com> <0dbbc0fe4360069993ef8a9ca179f30482610270.1391167128.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-204402537-1391806523=:4212"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=pFmyq6qS+OSqVTRpn3fsaEr8UslGtn3PyXP2vpxhLYg=;
        b=BlH/l1L3WUZg5KyZPoma6HPNDSgAL0CAhIScs7SRa8+8zQa430R/8zs37FN8csyd/C
         YDFEkzBtJEBm4UD/1quj73LkPK4GCiv3ai6KCeaHbu+EjZPSd0VMk+dg7GZGzjdoCNhI
         4bTeD98SrWk0BCnqWQxW90K8Cv86umTDcZJfysz3sfM51jnkaC6anWFPXK0eD+pCCfir
         RdEZ37Sr8QMTQ6CELo9r3xBWlomquXzrVMXzfrxOBMaGRg8L7zThk5n4GgpfmnNz4BYV
         L1mhbJH83dfpJVKb9co33uS368aj4rpv0jdJ5FqSodZu3BXfuOU2tvPgiVErnnZtXZ8G
         N7cg==
In-Reply-To: <0dbbc0fe4360069993ef8a9ca179f30482610270.1391167128.git.rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-204402537-1391806523=:4212
Content-Type: TEXT/PLAIN; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 7 Feb 2014, Rashika Kheria wrote:

> Mark function as static in memcontrol.c because it is not used outside
> this file.
> 
> This also eliminates the following warning in memcontrol.c:
> mm/memcontrol.c:3089:5: warning: no previous prototype for ‘memcg_update_cache_sizes’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>

memcg_update_cache_sizes() was removed in commit d6441637709b ("memcg: 
rework memcg_update_kmem_limit synchronization") for 3.14-rc1.
--531381512-204402537-1391806523=:4212--
