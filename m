From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 14/18] mm: memcontrol: prepare swap controller setup for
 integration
Date: Fri, 24 Apr 2020 09:30:32 +0900
Message-ID: <20200424003031.GD13929@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-15-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CI/1B5Cidn96PsLF1+MV6uHHJxnOtG8IuRZiucSwLqg=;
        b=u0+t3gSFNWhK/2bnK/QRc6HtUv83cARoTNpUd4TiJNOcMJz4I9cfqiF0ls+ngsJQFc
         k0oU8JEm6gqxKnX66U5j3OzqbI9sPdzd1V4yDvG3PsPwCzgJcB4FRDncbQJWVPbbvmVu
         /mhMZlY9Vt5ukryupUkZ32AsEqym9dDnewKDOf69r/BHg/V5wmMQrcntbqa4JbfvMEPl
         qVfNo2lKVdjaQU2ihOQ+DC2MYz/U/dhqorIAZSE3n0IqKLAHqPLT86RoUOixMdq2UleY
         +fAFeLfN7qDUWZqIaVIjBMPrOjRYx0ySqgmCxLkApI7G+ttGIXtuo3aiJmwAoE/wfX1Q
         X1Gw==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-15-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:22PM -0400, Johannes Weiner wrote:
> A few cleanups to streamline the swap controller setup:
> 
> - Replace the do_swap_account flag with cgroup_memory_noswap. This
>   brings it in line with other functionality that is usually available
>   unless explicitly opted out of - nosocket, nokmem.
> 
> - Remove the really_do_swap_account flag that stores the boot option
>   and is later used to switch the do_swap_account. It's not clear why
>   this indirection is/was necessary. Use do_swap_account directly.
> 
> - Minor coding style polishing
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

