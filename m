From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/8] memcg: accounting for ip6_dst_cache
Date: Mon, 15 Mar 2021 09:14:23 -0600
Message-ID: <a3d819f5-0291-0ba1-c5f8-42392d0404ad@gmail.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
 <8196f732-718e-0465-a39c-62668cc12c2b@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N4xTXJC3aSsvD0Tu2z/4hlaOiEJQneTxtWXS9WYbxG8=;
        b=M1Ya5zZ20aqVyvZ85hmde/EHfI5AObsfSfDrA87a21Ht4oI1Zmm7fH6gB2LcmyOger
         q5nPekECsbI4RLwiNAbf7epVDO84pP9BILC1Cod74cIPrC4D11b9Z/XJpnlBQKDNkR1G
         H54YjO0tsu3nSrLroPjSz0POB6CSRemuxDjKupePjHPqZ+6qfBdKXJd4qcEnvrwRoZgQ
         FeBZ/6Fn5q+jBkVm9Ohigril5diIuurWSi0P3xRRda93d6oCv8kSdUj4bYDLNZToEC4f
         lT80xEJFVSZi8J1t9lsLAFOqJeEVkboy4N3FZ0ALelUqPjcL+K758wvqWHJz4SvxEqvh
         bK4w==
In-Reply-To: <8196f732-718e-0465-a39c-62668cc12c2b-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 3/15/21 6:23 AM, Vasily Averin wrote:
> An untrusted netadmin inside a memcg-limited container can create a
> huge number of routing entries. Currently, allocated kernel objects
> are not accounted to proper memcg, so this can lead to global memory
> shortage on the host and cause lot of OOM kiils.
> 
> This patches enables accounting for 'struct rt6_info' allocations.
> ---
>  net/ipv6/route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


