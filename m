From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix an unused-function warning
Date: Thu, 28 May 2020 13:15:43 -0400
Message-ID: <20200528171543.GB69521@cmpxchg.org>
References: <20200528095640.151454-1-arnd@arndb.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=atthkvZPtmuffgqI3U1N92nhhfohScsuYraFPx1a33w=;
        b=etNjUDmYG/GoUh6tlvW65FzID7MhbLN6fmu5w4+qhKKoJPNlpoymnwadrQfmgoqUiQ
         lRYk6V4zjlAp1JoiKlZG7EnTqD9m/LUK2LUxhTjK6XSYT1Qm5Wm13M/uiw0pbGdyJz84
         G4lqCSxJgN5+v+05NyelPzHo0kpcv6Ih5o4w6a6n68b318tTQF7/zNt8STf2OTad3Cx6
         c+5+5OIB9NVG04+b0XA4N+rWS376QGJKQC45cnbq29In09VIZYjftadLqnIw8Jro0HHB
         Uzpsy0cJlADEg5EH40MR2pIpshdxFwaahEEMvaLa2M1R8R0GrhmwOUGvKvbY4ZaT5aVC
         /H2Q==
Content-Disposition: inline
In-Reply-To: <20200528095640.151454-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 28, 2020 at 11:56:26AM +0200, Arnd Bergmann wrote:
> On NOMMU kernels without CONFIG_MEMCG_KMEM, we now get a harmless
> warning about an unused function:
> 
> mm/memcontrol.c:2595:13: error: unused function 'cancel_charge' [-Werror,-Wunused-function]
> 
> Hide this function in a matching #ifdef.
> 
> Fixes: 5bd144bf764c ("mm: memcontrol: drop unused try/commit/cancel charge API")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thanks Arnd!
