From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: wait for css offline when rmdir
Date: Mon, 30 May 2022 15:01:21 -1000
Message-ID: <YpVo4XiIDu68w40Z@slm.duckdns.org>
References: <1653619158-27607-1-git-send-email-zhanghongchen@loongson.cn>
 <YpCQZ5RRnxwh7fmK@slm.duckdns.org>
 <e74e03f1-cb54-b158-a085-2965fd088d1d@loongson.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NJogN3IYLaA0/PYlQIBsunkdnH4gONu4lSZ4HSWPFBg=;
        b=BXpzd1eUKcwVwUU83YwPDVhBhh3yJZK6vwP+l6BQ0eANXd4G4rGkMYGwVNG58g81TR
         FRdBloytdVM9FuHTRCYWZxUFPIB+TwxM8AKv+L2jeO/7ul/Hn3QGFAwc/WKRILeAUZcH
         pRIJUfCJCAzkXBvoWF1EMIwKRQEYNfCCsKCLiZHjLyKgU7eEYXodFIsGN/kDgQ7fVmdJ
         4nrdNE7+rMKUSz9p0uajY72fJ0pD9laF02Sq+4yCUL0VoaTaVOHqHh4S72+Py6RwzTFp
         EsQynD1EBpGZpOHXo2jLWQI70kH5AFlZkJjb6gOisOmAySgftbphAzvyC5JqgI2j78Rb
         R4FA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e74e03f1-cb54-b158-a085-2965fd088d1d-cXZgJK919ebM1kAEIRd3EQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hongchen Zhang <zhanghongchen-cXZgJK919ebM1kAEIRd3EQ@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, May 30, 2022 at 09:53:51AM +0800, Hongchen Zhang wrote:
>   When I test the LTP's memcg_test_3 testcase at 8 Node server,I get the
> -ENOMEM error,which caused by no avaliable idr found in mem_cgroup_idr.
> the reason is the use of idr in mem_cgroup_idr is too fast than the free.In
> the specific case,the idr is used and freed cyclically,so when we rmdir one
> cgroup dir, we can synchronize the idr free through wating for the memcg css
> offlined,and then we can use it the next cycle.

This is a micro benchmark specific problem and it doesn't make sense to
change the overall behavior for this as the suggested change is neither
desirable or logical. Maybe you can just incur the delay only after idr
allocation fails and then retry?

Thanks.

-- 
tejun
