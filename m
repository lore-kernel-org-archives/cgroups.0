From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] cgroup: Make cgroup_debug static
Date: Wed, 18 May 2022 06:57:13 -1000
Message-ID: <YoUlaTQrEf+NxINS@slm.duckdns.org>
References: <20220517112523.243386-1-xiujianfeng@huawei.com>
 <YoPWJZ+RJmlvBLwV@slm.duckdns.org>
 <c099059c-2953-232d-3d53-e8863c221cb0@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=12ObYYrf99f0yLEIMoJi0RP8wJdhcsztzbMI93JYaGg=;
        b=fJuwr+79VK40EWiLDG7rqWOctqpq6NcDBduZ3aXuqdASFa6Lj98Yc312Y03+qRCODk
         6UQy0HrgZTAejHxAh+UOFjyZ/2CGbXNYAPpBBlCqJf/596yD53ifCnhcJWeyvqTR1jWn
         StEH1xtvTb4qIomCptdjFPb3uHvzEfFHpPeAhK/H8nHOw+r0ReqkF4YQYkrNfAyx0mMz
         /gh/6CpYiO0DC3/99Q7xkRa/pT+GO7sbeXBXM9WdlbVzviKDCA9BJCWHe32m7ZIHVbgE
         4TIuVjndwOW00mw7ya+C+VmsVltd2TM61fvflm1FuS44n9tvhU2RqZZHHkNG5zfOG1rC
         a98g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c099059c-2953-232d-3d53-e8863c221cb0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: xiujianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 18, 2022 at 02:48:36PM +0800, xiujianfeng wrote:
> 
> 在 2022/5/18 1:06, Tejun Heo 写道:
> > On Tue, May 17, 2022 at 07:25:23PM +0800, Xiu Jianfeng wrote:
> > > Make cgroup_debug static since it's only used in cgroup.c
> > > 
> > > Signed-off-by: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > The only thing it does is gating CFTYPE_DEBUG which isn't used anymore.
> > Can you remove both CFTYPE_DEBUG and cgroup_debug() instead?
> 
> It's ok to me, but I found CFTYPE_DEBUG is still used in cpuset subsys,
> 
>   .name = "cpus.subpartitions",
>   .seq_show = cpuset_common_seq_show,
>   .private = FILE_SUBPARTS_CPULIST,
>   .flags = CFTYPE_DEBUG,
> 
> if remove CFTYPE_DEBUG and cgroup_debug,  cpus.subpartitions will be showed
> by default,  is this ok?

Ah, I missed that. You're right. Lemme apply the original path.

Thanks.

-- 
tejun
