From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to
 mem_cgroup_charge_skmem()
Date: Wed, 12 Oct 2022 20:16:50 -0700
Message-ID: <20221012201650.3e55331d@kernel.org>
References: <20210817194003.2102381-1-weiwan@google.com>
        <20221012163300.795e7b86@kernel.org>
        <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
        <20221012173825.45d6fbf2@kernel.org>
        <20221013005431.wzjurocrdoozykl7@google.com>
        <20221012184050.5a7f3bde@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665631011;
        bh=pPVBjkE+WYLlwdAojvR6/fxG25rQT+sKY5Dn1ohZXRE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JocxvH1+TArBftSrmjX8X/t9EgB4e+ayDR3t9HrEFJdCLH+ouDr0NxbsXvKmz59XS
         CRSomupkkE/6iOEtIPZbQLa6tcU3hEiqWb8OEaW9V1Is4Rf8UfOIqxdZeq1OLepk1N
         TFRiM4i03yFDYgYUNUZiNkX/33xRDkU1qqZ18YJAtf3cVMZWo4mD4+QlpJ3WYAKlnd
         H1GWbnLEFEjoWnvQZxijUODUrGlD5XhPcXjmYNdW7YAGvdL+2TVcPIV5dml568G+Ak
         x73LJ6ActKw4GV/TfHAvHyJoANHfosb4nbynHdXzH4/mqIMP/1HLunwmohznygUjHC
         wbBamUHL0zpRQ==
In-Reply-To: <20221012184050.5a7f3bde-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Wei Wang <weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Wed, 12 Oct 2022 18:40:50 -0700 Jakub Kicinski wrote:
> Did the fact that we used to force charge not potentially cause
> reclaim, tho?  Letting TCP accept the next packet even if it had
> to drop the current one?

I pushed this little nugget to one affected machine via KLP:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 03ffbb255e60..c1ca369a1b77 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7121,6 +7121,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
                return true;
        }
 
+       if (gfp_mask == GFP_NOWAIT) {
+               try_charge(memcg, gfp_mask|__GFP_NOFAIL, nr_pages);
+               refill_stock(memcg, nr_pages);
+       }
        return false;
 }

The problem normally reproes reliably within 10min -- 30min and counting
and the application-level latency has not spiked.
