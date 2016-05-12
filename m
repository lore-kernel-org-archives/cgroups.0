From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Documentation/memcg: update kmem limit doc as codes
 behavior
Date: Thu, 12 May 2016 12:03:22 -0400
Message-ID: <20160512160322.GU4775@htj.duckdns.org>
References: <572B0105.50503@huawei.com>
 <20160505083221.GD4386@dhcp22.suse.cz>
 <5732CC23.2060101@huawei.com>
 <20160511064018.GB16677@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6g8krwBXN2v+yvuTS6BM6OZiYTpYzLvtlVdaMReBAAw=;
        b=oKO0zG4/GC6hyECJ9jcIE6Kc3c6i/DS72ecfxlXMQKb3T/TdmZYzYKjPrRY5bQMcWj
         v58vohXDcHDG2zL9nsaava8YIfUbXuFjt1lMZxGU7OTd5an+MewoGT9H8rYu3WVxne3n
         wNqJ70hXxpw8fEA1Ykf66RkG7sa/Kp8/EoyJffk+wNOs/MEXuOgcmwbVRrVdVF1gyKY9
         irG6JLi4Lv2M662FI+sBMdcxuwv+N/ZXZjHV544t5nAR8NJbe34AMKXZAv2qWoxjvCZS
         bg5+etNF9hez/j38FDPY2ozhyRL7z12NI9aK9jvH3RetAU7ssPV0WnThrj+f+yv+fPUZ
         iswQ==
Content-Disposition: inline
In-Reply-To: <20160511064018.GB16677@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Qiang Huang <h.huangqiang@huawei.com>, corbet@lwn.net, Zefan Li <lizefan@huawei.com>, hannes@cmpxchg.org, akpm@linux-foundation.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Wed, May 11, 2016 at 08:40:19AM +0200, Michal Hocko wrote:
> On Wed 11-05-16 14:07:31, Qiang Huang wrote:
> > The restriction of kmem setting is not there anymore because the
> > accounting is enabled by default even in the cgroup v1 - see
> > b313aeee2509 ("mm: memcontrol: enable kmem accounting for all
> > cgroups in the legacy hierarchy").
> > 
> > Update docs accordingly.
> 
> I am pretty sure there will be other things out of date in that file but
> this is an improvemtn already.
> 
> > Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Andrew, can you please pick this one up?

Thanks!

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
