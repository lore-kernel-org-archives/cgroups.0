From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH] memcg: refactor mem_cgroup_resize_limit()
Date: Sat, 3 Jun 2017 18:15:10 +0300
Message-ID: <20170603151510.GB15130@esperanza>
References: <20170601230212.30578-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Am2T2DkJNwBJ4vByTAjH3bJv9MIQnrUERJ+655cSaMA=;
        b=VTj8fpBGihdJgLHDbkWBLa+Qdz57SViFu6k1TJ9MiIbkv30+l5GA+VEduJhW0smA/k
         juvc+Ki9uB8HRCVd/GLpSntg3nVmDwpIaLpSWUMkJ/ui/kWdbCQiC8pe+5Z8QuaMhp83
         SCMHsY2v0D0xI8YK2FBS09wj4xzUuiPfvRigLPmRxLXHl3+nkhwztMHAOOClhr/x4JnO
         /EmsjRE3McIKWqvrqjp8yEuzFV4uBxb3NQ9oeI2XqH02JSJS8d+WAMdFmi0NfA735N2y
         RdVX9NxBmMfoVG54Ceht2L81Lom1CkoisEKPVc6E3GiELxaowfOdPf4pf01lZCcPc5IO
         vJpw==
Content-Disposition: inline
In-Reply-To: <20170601230212.30578-1-yuzhao@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, Jun 01, 2017 at 04:02:12PM -0700, Yu Zhao wrote:
> mem_cgroup_resize_limit() and mem_cgroup_resize_memsw_limit() have
> identical logics. Refactor code so we don't need to keep two pieces
> of code that does same thing.
> 
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  mm/memcontrol.c | 71 +++++++++------------------------------------------------
>  1 file changed, 11 insertions(+), 60 deletions(-)

Makes sense to me.

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
