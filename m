From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] cgroup: Introduce cpu controller test suite
Date: Fri, 22 Apr 2022 07:48:36 -1000
Message-ID: <YmLqdIiXdpQqcPTd@slm.duckdns.org>
References: <20220422173349.3394844-1-void@manifault.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XxZBZ3stUkdhVW/utSJpsv4jrMoNhjVNY7NCi5QPbWU=;
        b=EeMR2o3WC1it+xKaAE3UcnjfygI28wLy1fn4KUlwq5rUdHXA3ogqmv0vTwBr0/yoz6
         cDJzg1rfj241iv+2uzC/BYGGmTQnKA/47HSG40F4e3rn8DO/sTGjGLJRZKBNYcdc4SkJ
         VkxKM+/h5DcmnfD6wJ5B5PusUoozoXv2HxITbZos6wYa396jYdGaTuZm1sAUBzw7DwuF
         Vdb4koyAer9x2qkiNcMLqPOqC1r2BHVTFWFhhbVE4d70XYAPKDtci9NNSWGC9H/laxad
         B6pBvpciftuPkCUfsnr9UwtkqOowG6+yMOVvJAiLds17XVWjt2On7Tg7vNK/gpJ5LN5I
         UWqA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220422173349.3394844-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, David.

On Fri, Apr 22, 2022 at 10:33:47AM -0700, David Vernet wrote:
> This patchset introduces a new test_cpu.c test suite as part of
> tools/testing/selftests/cgroup. test_cpu.c will contain testcases that
> validate the cgroup v2 cpu controller.
> 
> This patchset only contains testcases that validate cpu.stat and
> cpu.weight, but I'm expecting to send further patchsets after this that
> also include testcases that validate other knobs such as cpu.max.
> 
> Note that checkpatch complains about a missing MAINTAINERS file entry for
> [PATCH 1/4], but Roman Gushchin added that entry in a separate patchset:
> https://lore.kernel.org/all/20220415000133.3955987-4-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org/.

Looks great to me. Thanks for adding the much needed selftests. Peter, if
you're okay with it, imma route it through the cgroup tree.

Thanks.

-- 
tejun
