From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/memcg: use NUMA_NO_NODE to indicate allocation
 from unspecified node
Date: Tue, 11 Jan 2022 10:23:57 +0800
Message-ID: <CAMZfGtVR90mUTL_JgKwO_4ek_nk8CbZGPchn3GxvwtN9q+dxbg@mail.gmail.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QSQyDPVUrDTpPa0aeIkb88gZSvWQCxb+kxHI+54cFz0=;
        b=XP3yQrg8fDZpSWUZkuN/qfg9052nmszm/0Ms512ggngyobd7ttIvqnXRyrfbVQTWaf
         /zGqSCW6zCzW84h4JMDO76dAuixk4yxZqFqgmYbuFIecfy++oe16hNrJXFTIYI3h86rj
         7J7KqCLyp1LCIst+ibhYsv6zCd9IeG9Hlhapn40NZpRLtRAxXaJ3m9P3fifzHCfrX0+Z
         rYtTnG1Ldv3rswgr8S0TJTBmeTDEr5CdzTxhHwZdq0Y2dYKVSTgZVBR3bPP/PoKSsE6/
         h2T8vQYugkLWcuH4JEaXMIvSedPawB/waoT7n5CVkTpXpLBJCdawHZLGfukgzi3IKixh
         f8Wg==
In-Reply-To: <20220111010302.8864-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Jan 11, 2022 at 9:03 AM Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Instead of use "-1", let's use NUMA_NO_NODE for consistency.
>
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.
