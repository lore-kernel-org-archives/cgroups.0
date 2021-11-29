From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: get the wrong css for css_alloc() during
 cgroup_init_subsys()
Date: Mon, 29 Nov 2021 07:39:49 -1000
Message-ID: <YaUQZZbFDDOpwHYY@slm.duckdns.org>
References: <20211127145919.31159-1-richard.weiyang@gmail.com>
 <20211127145919.31159-2-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jXtNF/sPL2y+FUYzBp0rUX3UsbHP3l0DZcj0VSipxzQ=;
        b=Ja64lXFdxwDLTwzcCX7CVYDIpHTlZxNqc0Fa6bm28nUCevMarEHl0xIPFIx8/H8NUV
         D6NCwIn8E8TV6liXLFYmB4hDBK+HIz/lThf6bZVJvocJ6J8syTB/g5X05Cy3eJ9NaB7C
         y+0wNiXp0x+DIlrvBdRkEkoHGRIU/0Dm4uEoEqcz4r0bl5SL7dMtug4+HlZrwpnfTWG+
         b4Q3Wnge5QIK3/lfxSIvRUWuJv8am15+opOEPf2Nvv+FpbXzfqW5csZiK4GwB7vE/MFm
         yQ27hpi+zg0inn1ldPqVacjNX9vRBj02UV6zz//ORkQLpARoEcY7eJNKPhvuF/3ZkFpA
         Oq6Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211127145919.31159-2-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Nov 27, 2021 at 02:59:19PM +0000, Wei Yang wrote:
> css_alloc() needs the parent css, while cgroup_css() gets current
> cgropu's css. So we are getting the wrong css during
> cgroup_init_subsys().
> 
> Fortunately, cgrp_dfl_root.cgrp's css is not set yet, so the value we
> pass to css_alloc() doesn't harm to the system.
> 
> Let's pass NULL directly during init, since we know there is no parent
> yet.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-5.17 w/ minor description adjustment.

Thanks.

-- 
tejun
