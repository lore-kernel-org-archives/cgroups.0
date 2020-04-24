From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/18] mm: memcontrol: switch to native NR_ANON_THPS
 counter
Date: Fri, 24 Apr 2020 09:29:21 +0900
Message-ID: <20200424002910.GA13929@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-12-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gzkio/hjOsP5SuHUSxUmuTr2KttZIZznccGmIe5MGTE=;
        b=LjfGxbjdlWzcFZwfvVVJkPC+E9ey1960eHifxNarjq22YJ0k9l9Vo0xL7T6TmlIZwt
         lC9m3uWPZO/jNOocdrGsnyEZ3uGvSwmZdIr1Rc76z1PdMi58UMJPinl6nfCQCs4no8L2
         9b+SMjJ8KNMJT3eoTlODXq8TSx7hxhT+XjGRVsZ6KpxCF2oFP8sB5orojvn9YHbH9OVi
         3OOvvVEPzZqoFbUV8qSzg5ro/Xraq56018GGKNT8nqCxLUPt7lMAzjBhG2AxTSwvqRrF
         NLO4/Hc8WBnhRzoSrvIXszHmog/8eLSmGgtz2PT9m/FY2YKfIS45xYux9tul5Mn2l+p9
         PTVA==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-12-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:19PM -0400, Johannes Weiner wrote:
> With rmap memcg locking already in place for NR_ANON_MAPPED, it's just
> a small step to remove the MEMCG_RSS_HUGE wart and switch memcg to the
> native NR_ANON_THPS accounting sites.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

