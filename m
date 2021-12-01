From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix a typo in comment
Date: Wed, 1 Dec 2021 06:50:48 -1000
Message-ID: <Yaen6KWQyhBAbsks@slm.duckdns.org>
References: <20211201011736.10988-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MRSYNLjvSzUUD2xStcS4K0DD5X/I++O60gfhBgUbT1A=;
        b=qD/FVYfVYxmqsU9ppUga0DOisU5misR0u9i2eWCAlmghTQhk2rqoOHFkDMQAVEB5lr
         agBx4fpPF7aHLeF7MxHf/bDvg99DY+6dIugyiOBecjhKRs/ikXPhTZ8ZopDe8vDuHGty
         GDlC+FF6m3p44aef2NDAw2vhjotCIXWmjIWqK4n3Kh66nBFEYQ4fuR+ddkFku29Yw1vH
         0D10wjaXiq155B8cUVi9WVyOjZU9of5qErlotVhwBmvZ1AQ2sZCAxNhimazk28IUvBCd
         MsqbWrBwmOtyJCjwEFRfcV8u92k53umoHak17/mkA4E0CzHB4RMtzvZ+psbSxsOKDW3o
         ruJw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211201011736.10988-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 01, 2021 at 01:17:36AM +0000, Wei Yang wrote:
> In commit 8699b7762a62 ("cgroup: s/child_subsys_mask/subtree_ss_mask/"),
> we rename child_subsys_mask to subtree_ss_mask. While it missed to
> rename this in comment.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-5.17.

Thanks.

-- 
tejun
