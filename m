From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Wed, 23 Nov 2022 16:22:31 -0500
Message-ID: <Y36PF972kOK3ADvx@cmpxchg.org>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <CAOUHufYd-5cqLsQvPBwcmWeph2pQyQYFRWynyg0UVpzUBWKbxw@mail.gmail.com>
 <CAOUHufYSeTeO5ZMpnCR781esHV4QV5Th+pd=52UaM9cXNNKF9w@mail.gmail.com>
 <Y31s/K8T85jh05wH@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VHgVq5sX90/a/BhOqlHy581ALJwbQnSRnRpBrgLVdZ4=;
        b=fELMiNAAnzjxMhrhiZt4CATnthWy6giZnkz2zXGp5/6n8EoC1LuU8oQfUfEcVQoLA/
         QichA/k207xrB80yyoNaf6+Tc6xJWRMTitzk6yAa5opT9pLOQT8wvAuJEAXSJePCzD1w
         P1cHz58W5dAAqh7AjcFl5B+evStoCtfUo/QXjnjllQ2Q64hRJfOI0JNS7wJdfKKTg9Xw
         pIr4EV4lXRRTewtoWKmDfsV/KVTYBib80VzDNbshHWyjyAUJnzLjamQI1lZwjr3d5Oo3
         LEr00TLTaUa5wfDOmxqWAXothKMITL8f1kDbUtzGHBJDRgCkI2aXdf/FUy+cJ5cKtYnu
         K3mw==
Content-Disposition: inline
In-Reply-To: <Y31s/K8T85jh05wH@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>, Linux MM <linux-mm@kvack.org>, Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>

On Tue, Nov 22, 2022 at 05:44:44PM -0700, Yu Zhao wrote:
> Hi Johannes,
> 
> Do you think it makes sense to have the below for both the baseline and
> MGLRU or it's some behavior change that the baseline doesn't want to
> risk?

It looks good to me. Besides the new FMODE_NOREUSE, it's also a nice
cleanup on the rmap side!

It would just be good to keep the comment from folio_referenced_one() and
move it to the vma_has_locality() check in invalid_folio_referenced_vma().

Otherwise,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
