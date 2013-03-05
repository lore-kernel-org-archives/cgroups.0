From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: avoid accessing modular cgroup subsys
 structure without locking
Date: Tue, 5 Mar 2013 09:34:01 -0800
Message-ID: <20130305173401.GB12795@htj.dyndns.org>
References: <51355EFF.3080804@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=jDepx8hBw4iIU34eB+C5wPC+QUfhhdBkWzIudHJxDuI=;
        b=0jWkripYfzIDpDT3p9i1EJ0DCQCAnvC1y3TGKw++zIaJFTlK1ug3MvR6xstKuST0Y5
         eFk3Jd+/D2TZmf6+mIGRWAjw+GqVJMsflbRnEj9TOCqkO5LIxuR+ICXF/GzYuMEi9Eym
         AIPdrgEXTqJH01AMHv5LGFjXRP5UBjX12WejuBi0fEoxPZKf2AwPPwxTjZh5ow49Yh8L
         /lZu+LYaaG2ZuTbeX2M6gorkT2JQWoPkDrZN+mZFEQ881fFE5Xei1EdV6h1UCqz9lCMx
         04aqY3GsW/W0gTQnPaCKtj/Mo6hyP7HW1mUs0LalgULVHcP7DfW4xuf2LqUgZcQmJLAR
         TP5A==
Content-Disposition: inline
In-Reply-To: <51355EFF.3080804-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 05, 2013 at 10:57:03AM +0800, Li Zefan wrote:
> subsys[i] is set to NULL in cgroup_unload_subsys() at modular unload,
> and that's protected by cgroup_mutex, and then the memory *subsys[i]
> resides will be freed.
> 
> So this is unsafe without any locking:
> 
>   if (!ss || ss->module)
>   ...
> 
> v2:
> - add a comment for enum cgroup_subsys_id
> - simplify the comment in cgroup_exit()
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
