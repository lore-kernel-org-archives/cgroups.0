From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] cls_cgroup: get sk_classid only from full sockets
Date: Mon, 18 Apr 2016 05:14:48 -0700
Message-ID: <1460981688.10638.103.camel@edumazet-glaptop3.roam.corp.google.com>
References: <146097943086.15300.8997345346172526153.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KjEF2yZb2nZ6I9mx0dBAM3KAhk7V9BiheA1vvWvVM34=;
        b=g72MkmOXBGft4EpNpxogPiMNVbzyJzaGIUXIuu8H1t6TnFr57ichHtgI8jwrvHg2HW
         97YkfnwmOqFqloF3t3HTgqNC37qzJQjyV2Ing+pD1nKOWfy0hfoUW3cmQzSXm1ZRnuon
         KlU7XwO2v+e1/rM2RsUwEPmiCYcDRI2eAlLJkipk/W9sf+95Sf1BTu1y4YESOY0/Kzd9
         XsKfk3/UABBLmbLvNZ0GESBdjDycrDd9PWnHA4hTtLdZfPDpO6BR2pnGWbiCKoAMmqMY
         fAjPQSFmksG2apR/bsnYnvOs90Htdt6SBZDZLN45nVHI8UHCVCF7ktMOoMGKhVGDpRME
         E1aA==
In-Reply-To: <146097943086.15300.8997345346172526153.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2016-04-18 at 14:37 +0300, Konstantin Khlebnikov wrote:
> skb->sk could point to timewait or request socket which has no sk_classid.
> Detected as "BUG: KASAN: slab-out-of-bounds in cls_cgroup_classify".
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> ---

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks !


