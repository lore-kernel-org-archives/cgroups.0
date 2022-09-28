From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [PATCH] Revert "net: set proper memcg for net_init hooks allocations"
Date: Wed, 28 Sep 2022 15:35:29 +0300
Message-ID: <CADxRZqys7222fYUj-0--RsR+L4s0TyJr6Wa6EeoaXMBZcNkLeQ@mail.gmail.com>
References: <20220926195931.2497968-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <sparclinux-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=hDGLmeg/3H5e1OtBsmLFUKZd98FFvCcHEVJ0xsvxMhM=;
        b=RVu0ef59fpgN3POkCew4+CPhjI2r/eU7f55jOv7S0H68+VbgnWPqOfbGELhS6Vlx8d
         8ARCwXOOHGaGAG7AeavP0QVbHzCavzTtptch7u7fI/G331yBAk80JqSPt2EWIpBh7YuU
         PMwjaklaBHAsype1SI4Kt3pl4lt1nZfgpJankk11I8aeCgdkX39StChW3jwSg2MUE0JP
         fEQl5/6stF4PYpgt1Jfvcmz9+k20Bp92L8NehZN99/GK/eMy70O3UAOoQl9jcpEsQmq2
         rw991OcohUDoGG2fHdyhHjb51NUMUQoZwLE0Sc4kKOSG8Z2OIH3lycZjHnJXkoEvxWsT
         E1qw==
In-Reply-To: <20220926195931.2497968-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Vasily Averin <vvs@openvz.org>, Jakub Kicinski <kuba@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Sparc kernel list <sparclinux@vger.kernel.org>

On Mon, Sep 26, 2022 at 11:00 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> This reverts commit 1d0403d20f6c281cb3d14c5f1db5317caeec48e9.
>
> Anatoly Pugachev reported that the commit 1d0403d20f6c ("net: set proper
> memcg for net_init hooks allocations") is somehow causing the sparc64
> VMs failed to boot and the VMs boot fine with that patch reverted. So,
> revert the patch for now and later we can debug the issue.

Tested-by: Anatoly Pugachev <matorola@gmail.com>
