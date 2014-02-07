From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/9] mm: Mark functions as static in page_cgroup.c
Date: Fri, 7 Feb 2014 12:56:11 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1402071255590.4212@chino.kir.corp.google.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com> <6054d570fc83c3d4f3de240d6da488f876e21450.1391167128.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-2145918811-1391806572=:4212"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=U5eaBmU8xJX4h/hwtTvQA1daUFICs7zSpokjEGx3aYU=;
        b=nFBE0/4vNT/ehBO6EXXL0zVFmjFXN/CIVrX7x9dpP16dnCBJzQEsHR7Cery03BJDt0
         aQ82OaUUfHPcQ6IXQvRv+IpEh9tfLpd6lOPpFbX3hyjeoF1GlTBqs8N+8Q6b5hFDL3GE
         IiBXNNdYt81JdYzw76jbopf7fAPkXXiFzEhtOAs5d6Z7n+Izin5xXEs7ZuKrzITV6BC9
         ajBzQkzE/UXvMu3eq5THs/nrFOJa3iPEr6jq4ij/3dQqrUsmJt4zgWpf1q9YE9hDQUGj
         rwjdjdcbdMr/alQNVPl5m5hG+vae275jGaszfuBnkWeg05tB24EREfWR5D5BLqJLvKv+
         jXVQ==
In-Reply-To: <6054d570fc83c3d4f3de240d6da488f876e21450.1391167128.git.rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-2145918811-1391806572=:4212
Content-Type: TEXT/PLAIN; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 7 Feb 2014, Rashika Kheria wrote:

> Mark functions as static in page_cgroup.c because they are not used
> outside this file.
> 
> This eliminates the following warning in mm/page_cgroup.c:
> mm/page_cgroup.c:177:6: warning: no previous prototype for ‘__free_page_cgroup’ [-Wmissing-prototypes]
> mm/page_cgroup.c:190:15: warning: no previous prototype for ‘online_page_cgroup’ [-Wmissing-prototypes]
> mm/page_cgroup.c:225:15: warning: no previous prototype for ‘offline_page_cgroup’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
--531381512-2145918811-1391806572=:4212--
