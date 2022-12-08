From: Shakeel Butt <shakeelb@google.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Thu, 8 Dec 2022 00:31:36 +0000
Message-ID: <20221208003136.fxm6msgiswl2xdac@google.com>
References: <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
 <Y4T43Tc54vlKjTN0@cmpxchg.org> <CABWYdi0z6-46PrNWumSXWki6Xf4G_EP1Nvc-2t00nEi0PiOU3Q@mail.gmail.com>
 <CABWYdi25hricmGUqaK1K0EB-pAm04vGTg=eiqRF99RJ7hM7Gyg@mail.gmail.com>
 <Y4+RPry2tfbWFdSA@cmpxchg.org> <CANn89iJfx4QdVBqJ23oFJoz5DJKou=ZwVBNNXFNDJRNAqNvzwQ@mail.gmail.com>
 <Y4+rNYF9WZyJyBQp@cmpxchg.org> <20221206231049.g35ltbxbk54izrie@google.com> <Y5CMrPMDxngMZWN8@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=phKzW+pnWcxpZMlO+OGC3q3KyWa3Ai371n7pkUjY42s=;
        b=GcvzBKZHxUPcMbsMIVs11wJmblKLng4iReNp1M5ibs/jGlVOlzs8gse33hKi0r80d3
         4py+w8LI+3nJYWK8ZHaSqhXB2Uiak2y9NhC7j3lJ6R1R69as73jNKJKxJH9LiwjI8e1d
         MetDnMkMhXBRBjs9blHiXf9td0dJKWvI6zm9E3odBEh/Q0aEDhi9QSdUDkbSJu0sBLf7
         GmD67NVPCz8BOXn9qmTnJmvuIfl7OIhCFLqkKxmDFJOjrSau5U5GhJqzKYp7SqdjHIFp
         NH630+6SYXOZNb0eEnqgRPAuNnT0GH0bcEZ+5l/9XRUIU/cBltRovIN/r4VTIfO5+EP9
         y2Cg==
In-Reply-To: <Y5CMrPMDxngMZWN8@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Eric Dumazet <edumazet@google.com>, Ivan Babrou <ivan@cloudflare.com>, Linux MM <linux-mm@kvack.org>, Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>

On Wed, Dec 07, 2022 at 01:53:00PM +0100, Johannes Weiner wrote:
[...]
> 
> I don't mind doing that if necessary, but looking at the code I don't
> see why it would be.
> 
> The socket code sets protocol memory pressure on allocations that run
> into limits, and clears pressure on allocations that succeed and
> frees. Why shouldn't we do the same thing for memcg?
> 

I think you are right. Let's go with whatever you have for now as this
will reduce vmpressure dependency.

However I think there are still open issues that needs to be addressed
in the future:

1. Unlike TCP memory accounting, memcg has to account/charge user
memory, kernel memory and tcp/netmem. So, it might make more sense to
enter the pressure state in try_charge_memcg() function. This means
charging of user memory or kernel memory can also put the memcg under
socket pressure.

2. On RX path, the memcg charge can succeed due to GFP_ATOMIC flag.
Should we reset the pressure state in that case?

3. On uncharge path, unlike network stack, should we unconditionally
reset the socket pressure state?

Shakeel
