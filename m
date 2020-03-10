From: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 2/2] net: memcg: late association of sock to memcg
Date: Tue, 10 Mar 2020 08:53:56 -0700
Message-ID: <652106b3-975d-b8bc-ca27-682c0c8d8aa3@gmail.com>
References: <20200310051606.33121-1-shakeelb@google.com>
 <20200310051606.33121-2-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hyrZhGrQSEDWXCf6l1K0WVVemgS8j81vIr9KuEMeNkw=;
        b=Fnr9nH/1FiSHsgd5I4mASsBjBOAmLtnO9KW8gGJGjtqZ0Ies0iCUFa54FNxkQwMVH8
         9vozAHc88+mmTFfl0t8MJbh6NYELuNIstZCIwR9xp2lvT0U4DIVD5U27Y45Zt/3JjwLp
         i/18FPdI/yaUtIiZixGoY4EEBOXox38OvshHlJjNP4TwhQ9IIG0YaTz1gix2tUH36g1P
         xWot2m6eSJJfsRB6nnLF9GibDnWJba71embpqUTI+7dT02Sn8uD3GrKVmiJPgqcVFssa
         veqYq0kbeFu/nR8R5BxDg/vflmaADT6Bu4YfAKLhdKQ2e4nuvhxraukxO+555BkJCzpB
         MpIQ==
In-Reply-To: <20200310051606.33121-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 3/9/20 10:16 PM, Shakeel Butt wrote:
> If a TCP socket is allocated in IRQ context or cloned from unassociated
> (i.e. not associated to a memcg) in IRQ context then it will remain
> unassociated for its whole life. Almost half of the TCPs created on the
> system are created in IRQ context, so, memory used by such sockets will
> not be accounted by the memcg.
> 
> This issue is more widespread in cgroup v1 where network memory
> accounting is opt-in but it can happen in cgroup v2 if the source socket
> for the cloning was created in root memcg.
> 
> To fix the issue, just do the association of the sockets at the accept()
> time in the process context and then force charge the memory buffer
> already used and reserved by the socket.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks !

