From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: vmpressure: don't count userspace-induced reclaim as
 memory pressure
Date: Mon, 27 Jun 2022 14:31:27 +0200
Message-ID: <YrmjH2FZF7iNn8da@dhcp22.suse.cz>
References: <YrQ1o3CeaZWhm+h4@dhcp22.suse.cz>
 <CAJD7tkadsLOV7GMFAm+naX4Y1WpZ-4=NkAhAMxNw60iaRPWx=w@mail.gmail.com>
 <YrSWruhPlJV1X9kp@dhcp22.suse.cz>
 <CALvZod6eLa1X1FJ2Qi6FXhFA-qBCP4mN2SB31MSgjj+g8hKo6Q@mail.gmail.com>
 <YrSdFy3qYdG+rGR6@dhcp22.suse.cz>
 <CAJD7tkZNEtzJMDsLMHuNHkxFfurS37UuK=zFcPCkOkWfN-dbJQ@mail.gmail.com>
 <YrlpcdgF1HzA7bHS@dhcp22.suse.cz>
 <CAJD7tkYVy2uNwaPiiJdPKT5P_O-9WgxD68iFJ6vw=TLJcQV3Ag@mail.gmail.com>
 <Yrl2T632Vfv8QGPn@dhcp22.suse.cz>
 <CAJD7tkZzwzHq7Q7KKUdVSdO4LWTPkrGprp0Q-ze_SWhUd_mTMw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656333088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H2x18KoFRy5eal2D3ylc2+U1rybp7813ga/wOUoNe6s=;
        b=MN+FbeFBztRg1vQn/aZS6WgzpJcvWE6GlhrAy1Bn2uYz6Fgk3nG1G2IBxSamszzE041LHN
        FYiV/4Oov7dyHxK7Ap2HTWMY4KowzOrjMf2zZGO5NgGZfnmfaD9ie3tBC7hiO/8eBkBjto
        EEejyW10KiaUFmPLEkSEZ9i8fEwxLpw=
Content-Disposition: inline
In-Reply-To: <CAJD7tkZzwzHq7Q7KKUdVSdO4LWTPkrGprp0Q-ze_SWhUd_mTMw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon 27-06-22 02:39:49, Yosry Ahmed wrote:
[...]
> (a) Do not count vmpressure for mem_cgroup_resize_max() and
> mem_cgroup_force_empty() in v1.

yes, unless you have a very good reason to change that. E.g. this has
been buggy and we have finally understood that. But I do not see any
indications so far.

> (b) Do not count vmpressure (consequently,
> mem_cgroup_under_socket_pressure()) in v2 where psi is not counted
> (writing to memory.max, memory.high, and memory.reclaim).

I can see clear arguments for memory.reclaim opt out for vmpressure
because we have established that this is not a measure to express a
memory pressure on the cgroup.

Max/High are less clear to me, TBH. I do understand reasoning for PSI
exclusion because considering the calling process to be stalled and
non-productive is misleading. It just does its work so in a way it is
a productive time in the end. For the vmpressure, which measures how
hard/easy it is to reclaim memory why this should special for this
particular reclaim?

Again, an explanation of the effect on the socket pressure could give a
better picture. Say that I somebody reduces the limit (hard/high) and it
takes quite some effort to shrink the consumption down. Should the
networking layer react to that in any way or should it wait for the
active allocation during that process to find that out?
-- 
Michal Hocko
SUSE Labs
