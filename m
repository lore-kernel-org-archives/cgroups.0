From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] fs: buffer: use raw page_memcg() on locked page
Date: Tue, 9 Feb 2021 11:12:18 -0800
Message-ID: <CALvZod6jd5+H0jr8wyB_ivPcJzSYH-rCCQL64Hgg+D_wuAZZFg@mail.gmail.com>
References: <20210209190126.97842-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4FXGsIN5T7fPPrN05ehbZdpVJVDuk872+BL495X4FDE=;
        b=YvBxOcvDEJCqlebLaBfz/mFH6WfvwNvw+jQhAqduaI6hWBxU9A7ZskYOCf8zcRNuUL
         LNbWWsUWHTLKYRhFQE7ZkmHbXyvJranSr8hnyxgHcM87KHuoJ9eUsuztqw3ewH1h8/DU
         9YcegKtpf6/jTxL35RfgKtx9Rd1OBpJeO/ouB0m3udBtiglWVl7Lp6l3JA8RS47w9/J0
         2dhI4ZOMi9bgsIRYK+d8DIvW4DTc2kMjCcTmIbo41C8RoVDL5ru3Dpa/g6a8Gvbc9xNu
         PW6i+H6yvplDmsMMShk7HQ2tWFn96BXZ/4i4IcP8Nqc4o2ryZiRU0xfEw8EQ6+VEYUY0
         L6kw==
In-Reply-To: <20210209190126.97842-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Tue, Feb 9, 2021 at 11:01 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> alloc_page_buffers() currently uses get_mem_cgroup_from_page() for
> charging the buffers to the page owner, which does an rcu-protected
> page->memcg lookup and acquires a reference. But buffer allocation has
> the page lock held throughout, which pins the page to the memcg and
> thereby the memcg - neither rcu nor holding an extra reference during
> the allocation are necessary. Use a raw page_memcg() instead.
>
> This was the last user of get_mem_cgroup_from_page(), delete it.
>
> Reported-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
