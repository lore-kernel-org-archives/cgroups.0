From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: reference to
 tools/cgroup/memcg_slabinfo.py
Date: Fri, 10 Jun 2022 14:03:26 +0800
Message-ID: <YqLeriHgZeylhuOZ@FVFYT0MHHV2J.usts.net>
References: <20220610024451.744135-1-yang.yang29@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J1XXW/35XoF6Aq4Yttw/47Ee+SbcRPhL6DUo491eP6M=;
        b=SDnqQnYW4s0VncwzYTXsBRd1NSOJCGawbA0wHY3UJJmP8C4vqtaU8Sko5l9pc1XfUE
         TzINJx/+WTBiweqzUrhE24hnzVoYrjm7F084uiiVkWF8rejMHaFFo3dgYNp8SjwLc/+l
         u8K5SCi8lhaJwlGuVE1VnQkM1dkzAeqMgNB1SBtBt0gni2/EBsJeUzcMT4/EkwZZQeX1
         jDhXRLw+BCGb4gfWqqFOUtYe1UpYvh1amf/ofBXF55QvB4vMMPn8nhFd3AmEc6LTwi4K
         KmFrNHcbRHhNBLpfiR7g5guHDD+ro1d7aO+YvLx2erxMbqzs7EVy1n+Cxc0/+fsO/4je
         32sA==
Content-Disposition: inline
In-Reply-To: <20220610024451.744135-1-yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Fri, Jun 10, 2022 at 02:44:52AM +0000, cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> 
> There is no slabinfo.py in tools/cgroup, but has memcg_slabinfo.py instead.
> 
> Signed-off-by: Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.
