From: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: per-cgroup memory reclaim stats
Date: Sat, 20 May 2017 22:15:22 +0300
Message-ID: <20170520191522.GA7065@esperanza>
References: <1494530183-30808-1-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ULUkZqLDSZusXI9Damfq8rZr7qIHV7MNfPM66YcHeEE=;
        b=TY0h6e0Rvg3Qnu60ZZQPmKwgB6zJPxWZ8fZzWSqK0is+dlwYiJnDG2QrN7nJUREMWy
         YY5DttJ+8NT0hLDbMGwMuhxiDrkhkfaOzbxTqULQRyOpwYms4JeVQFb9nk5bg7RjRTXx
         oMzNurWszmvffJ06KM7EMXPPEKuIYQiOL+D/OS89dig7dMnNAjO9sKvPaUSnSIlOIHE/
         3Iuw4GTC/aYXFoOv3s9jhyiNiBiael803o/FnfJuiynzltbjyJOWnPOM13jwlqfU0Syw
         BKGdH8PkeStveEezd5r2bectOPtChKbm2xWsiOycBy2MwVsAfGtn3PKVCE4BgPgEOrZ1
         JgOw==
Content-Disposition: inline
In-Reply-To: <1494530183-30808-1-git-send-email-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, May 11, 2017 at 08:16:23PM +0100, Roman Gushchin wrote:
> Track the following reclaim counters for every memory cgroup:
> PGREFILL, PGSCAN, PGSTEAL, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE and
> PGLAZYFREED.
> 
> These values are exposed using the memory.stats interface of cgroup v2.
> 
> The meaning of each value is the same as for global counters,
> available using /proc/vmstat.
> 
> Also, for consistency, rename mem_cgroup_count_vm_event() to
> count_memcg_event_mm().
> 
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Acked-by: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
