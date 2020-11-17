From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] mm: memcg: remove obsolete memcg_has_children()
Date: Mon, 16 Nov 2020 19:55:51 -0700
Message-ID: <20201117025551.GA1103291@ubuntu-m3-large-x86>
References: <20201116055043.20886-1-lukas.bulwahn@gmail.com>
Mime-Version: 1.0
Return-path: <kernel-janitors-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rph6elS4sVb6X0aZV8oBI4KEro3xkFbil1su2bbIStE=;
        b=USQyK3bB+z/rsRt1AELXV8ctRWtIiY5icuzdfAECiIyyhTqCjd/cubqHwqXKSUrpNW
         jS0x+7FDLMQEfX5d7LQRDJHMhIRUHZF7ZyjiIzz9U1hm4GfyOWrcoaA437AVuzPTV8jD
         gPnd6rltXsXDr1sppsRO9SurjxkcvrJY9DaPtvKkm38dDeNTSA+354EJG7j5ZVdclpAn
         oz/RVsDsjTwbuaICvAL+c02bw1WRI2G1FJ+tljpDFR8an2UnbZAvBcHpkmo4aS1mSE9w
         nBDJ91GZEg6FqhfGkMA0vfYxJtfEqU73B3egT2cKvmkDKOWEzPGV2v85V43YHu74tHYP
         09tw==
Content-Disposition: inline
In-Reply-To: <20201116055043.20886-1-lukas.bulwahn@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Tom Rix <trix@redhat.com>, Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 16, 2020 at 06:50:43AM +0100, Lukas Bulwahn wrote:
> Commit 2ef1bf118c40 ("mm: memcg: deprecate the non-hierarchical mode")
> removed the only use of memcg_has_children() in
> mem_cgroup_hierarchy_write() as part of the feature deprecation.
> 
> Hence, since then, make CC=clang W=1 warns:
> 
>   mm/memcontrol.c:3421:20:
>     warning: unused function 'memcg_has_children' [-Wunused-function]
> 
> Simply remove this obsolete unused function.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
