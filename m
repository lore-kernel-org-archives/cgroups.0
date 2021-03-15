From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/8] memcg: accounting for fib_rules
Date: Mon, 15 Mar 2021 09:14:52 -0600
Message-ID: <4800bd7d-92b9-ee82-6b9d-71bc13769964@gmail.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
 <cb893761-cf6e-fa92-3219-712e485259b4@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xpuZaiVrlNlwHASDhPqhddOX6dJW8QhrY9uWLI1rY04=;
        b=edTWOLsBDmAlUGB7ucxeGLpXdgsmMVpfpuLUfSKoSpL6qBsDWSBR5ns5bV+aTTtYHL
         zA+g2MigGIdR8EeLa4iPweB3MWhPZiRm1POzYbneUQ2Ot87YFb7LzTaY4XIgShIwfcMS
         J250iOuJVnLOfLxIYEp6lbTIv8wCbspmuHnzFSTYFHNsGYmTigGvaFjGG1EL71CN5ShM
         6ZBnOcmUlMrmEoaczCt/267Gc8zTKXsjYUOxQRIB4MXRQrN0+PqUWWA8Sht9A6H2ours
         F6Jon+u3cwNGtzJlUeKGA0Se49N1rTP/H5iq/V6VPo0R6HaiQPjVbisl9xcncZBMBEt0
         xxkw==
In-Reply-To: <cb893761-cf6e-fa92-3219-712e485259b4-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
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
> This patch enables accounting for 'struct fib_rules'
> ---
>  net/core/fib_rules.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Acked-by: David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

