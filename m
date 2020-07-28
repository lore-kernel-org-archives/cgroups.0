From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: restore proper dirty throttling when
 memory.high changes
Date: Tue, 28 Jul 2020 15:07:11 +0100
Message-ID: <20200728140711.GA196042@chrisdown.name>
References: <20200728135210.379885-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QDO5xtNZ22C72a1tBmEqwRX/00TFY7M8B1T43bXeDoo=;
        b=SLaBgESU+1xIJqSNqhieu03SNXKyKL+9MH8hgBEP20Gv4XC0tv7Aigf51SuYFDsJ0+
         09GIRi4cOnfUbvnWrtl2Bj6Hz1USuSfKPbNvwk6y0GavN4M4MAnesqzHkieumXy0qARA
         QDirQJmvwSNdLa088Smv1pEnZ7tVhoCsP9bwM=
Content-Disposition: inline
In-Reply-To: <20200728135210.379885-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Johannes Weiner writes:
>Commit 8c8c383c04f6 ("mm: memcontrol: try harder to set a new
>memory.high") inadvertently removed a callback to recalculate the
>writeback cache size in light of a newly configured memory.high limit.
>
>Without letting the writeback cache know about a potentially heavily
>reduced limit, it may permit too many dirty pages, which can cause
>unnecessary reclaim latencies or even avoidable OOM situations.
>
>This was spotted while reading the code, it hasn't knowingly caused
>any problems in practice so far.
>
>Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
>Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
