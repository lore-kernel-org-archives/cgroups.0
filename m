From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: add file_thp, shmem_thp to memory.stat
Date: Thu, 22 Oct 2020 11:00:32 -0700 (PDT)
Message-ID: <alpine.DEB.2.23.453.2010221100150.1331349@chino.kir.corp.google.com>
References: <20201022151844.489337-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=+Jm50fe41wfDpU30qvqkj0sqMT/OM8dCaofZzxuvBXc=;
        b=Ked+h/0SpWqtiUKSQ+9P+ieLMEYOUTVO+Qm1xZegAoXCKTnpLFKnApIRgEQNuVl+xY
         23Ki0jXwUy5jxqKjbS2p6j57kwY3nhDmCf37yAxUZIDdarrFWzYtYwszarW8AmN7W1tK
         QaLA/Ut1Q91UzjmR8M+CJmabUDT+4GAGKWWZS3k2oqfzBELUTGLx66J0bAP5qIk5i6tN
         Vs7wLG8jgWwCSeX8OCz+Zk0H6cEsdJR9buSyEVvsBbfH6HCvq04fuHMoF5qKL3KXNRtP
         LOqXn+Ehbt1GJq1WgSjRK/9M7jcRx4qYct5wkhxVGQiCFzuQpUmPwAr76h/VN6Cd6ywY
         QO2A==
In-Reply-To: <20201022151844.489337-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, 22 Oct 2020, Johannes Weiner wrote:

> As huge page usage in the page cache and for shmem files proliferates
> in our production environment, the performance monitoring team has
> asked for per-cgroup stats on those pages.
> 
> We already track and export anon_thp per cgroup. We already track file
> THP and shmem THP per node, so making them per-cgroup is only a matter
> of switching from node to lruvec counters. All callsites are in places
> where the pages are charged and locked, so page->memcg is stable.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Nice!
