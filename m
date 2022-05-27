From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: wait for css offline when rmdir
Date: Thu, 26 May 2022 22:48:39 -1000
Message-ID: <YpCQZ5RRnxwh7fmK@slm.duckdns.org>
References: <1653619158-27607-1-git-send-email-zhanghongchen@loongson.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F/TuFldqNWvbTR7kMknQ2sKjIOSGzhXUVTHp1Dts3Bw=;
        b=Waerq1Kg5SvqcLdZ91WgRWzCShy7ZEJw5Th3INevO7MYiKqxU166flLRKYb6F3n2WE
         +/jhiCUpHLjXscO+mQm+qzYfcQ6QVGscfz94TDWbs+505PMsEP+VLtuM0nmfmnKsORsx
         e2rNwgY0TNH0ff4YJnyjGYKYCKLwXdHus/fT3gypmPcIAeRq3baIiEb27H10uQWXYWfr
         86WDeESm08ae9QxBJNHTwBk5pwNcblO1VibwZ1AnB5yigJm8+lsU84fszGAC0X4wtRRI
         3kHnhOT13M7HHIjATivsUNe1oExErxDO5MThHSnlAo+zQhu7ZP6+XxwioyoBbQaf/HJZ
         NFhw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1653619158-27607-1-git-send-email-zhanghongchen-cXZgJK919ebM1kAEIRd3EQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hongchen Zhang <zhanghongchen-cXZgJK919ebM1kAEIRd3EQ@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 27, 2022 at 10:39:18AM +0800, Hongchen Zhang wrote:
> when remove a cgroup dir, make sure all the csses associated which
> the cgroup are all offlined,so that we will be sure that the resources
> allocated by the csses are all freed when rmdir exit successfully.

Offlining doesn't guarantee that resources are freed and there's no definite
time limit on how long it'd take to free all resources. e.g. for memcg, if
there isn't sufficient memory pressure, its page cache can remain
indefinitely. Is there something practical you're trying to achieve?

Thanks.

-- 
tejun
