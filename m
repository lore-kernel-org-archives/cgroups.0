From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to
 mem_cgroup_charge_skmem()
Date: Wed, 12 Oct 2022 18:40:50 -0700
Message-ID: <20221012184050.5a7f3bde@kernel.org>
References: <20210817194003.2102381-1-weiwan@google.com>
        <20221012163300.795e7b86@kernel.org>
        <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
        <20221012173825.45d6fbf2@kernel.org>
        <20221013005431.wzjurocrdoozykl7@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665625251;
        bh=3ZCGToPaazLxSo8auNDegz7ZNYJoaGHGQK/xLD/k5Yc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cAqYNXvo5FQ12eE1mxDNT5gXxmkTLytoDOpPo9g0aqYCJsdWxA/DaZBASaBYKlRnp
         82Ml9I7x46PwbneRMgA+JDoQlT5D9elUmpV2dHCfvFDfSHZ+W4MNnuORvj3hTL8QnV
         fx1lYjFEPbYOV1F8An+ZsHF9SLuR+qBZnvdo1B7mepPnKUdx8hsQ96jHn0r2KLbQYF
         Uy1QgQ3Jbmpib/p0R13uw5SmVGv9/l0PynGEiomvK30DmPCD1YxTHirgDW4VWLS85a
         GlNqljtHAtSliG/bxK156q5pu/oaSG8itOlMPdyywpGzP6YcSC6jyatydVie+I7js3
         4gXeBnGxmwRJg==
In-Reply-To: <20221013005431.wzjurocrdoozykl7-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Wei Wang <weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Thu, 13 Oct 2022 00:54:31 +0000 Shakeel Butt wrote:
> So, before the patch, the memcg code may force charges but it will
> return false and make the networking code to uncharge memcg for
> SK_MEM_RECV.

Ah, right, I see it now :(

I guess I'll have to try to test (some approximation of) a revert 
after all.

Did the fact that we used to force charge not potentially cause
reclaim, tho?  Letting TCP accept the next packet even if it had
to drop the current one?
