From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 4/8] memcg: accounting for ip_fib caches
Date: Mon, 15 Mar 2021 09:15:43 -0600
Message-ID: <afe47a9a-ec1e-36cb-7184-96a4c457f1f4@gmail.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
 <d569bf43-b30a-02af-f7ad-ccc794a50589@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=np/p9Ih58kbyvM0hIUqkXcnFFKPhSSCXOoOrFZ44REo=;
        b=MUPk/pbvsn449ONYJk455H6Kc7gE2u7S1noOh1h4Ceekj651HdpXnqPF/fmlu5WPOY
         DEMZjWTp3NjUYHaEVjXHq9/IpuVXsQNeu0rECQ2cRPbOYtmxEGxnt3Zw182ID7NEz35P
         CIUegNIVDabVbfTwMJT6CQUvgQNwZva/YpRFrAvOxpnGrB6pQBpNIQ40cU8N8bMx9eGl
         oUS6TFxnnRHPRrwCEy8p3u5SCf9hme2AESiU5ArpFKAn+UuCf70dKHW61rRBGmqU2iDF
         7ELKnpHho+NQSVdMrwNtVaNb4HFspvuEEKZ5jxvoxVayIb3tfeDsUE7ThTfq0g1JayYf
         dkUw==
In-Reply-To: <d569bf43-b30a-02af-f7ad-ccc794a50589-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>

On 3/15/21 6:23 AM, Vasily Averin wrote:
> An untrusted netadmin inside a memcg-limited container can create a
> huge number of routing entries. Currently, allocated kernel objects
> are not accounted to proper memcg, so this can lead to global memory
> shortage on the host and cause lot of OOM kiils.
> 
> This patch enables accounting for ip_fib_alias and ip_fib_trie caches
> ---
>  net/ipv4/fib_trie.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Acked-by: David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


