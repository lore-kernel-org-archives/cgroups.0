From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Date: Mon, 4 Mar 2013 09:38:25 -0800
Message-ID: <20130304173825.GC30413@htj.dyndns.org>
References: <512C8D84.7090707@huawei.com>
 <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
 <512DE4A8.5050303@huawei.com>
 <CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com>
 <512EFEDF.8080205@huawei.com>
 <CAOS58YMBcvhfBWdQmt=JersRgB9nVgsrLACtLovz===2ZXfR=w@mail.gmail.com>
 <51304C6D.8050207@huawei.com>
 <20130301203917.GT4503@ZenIV.linux.org.uk>
 <CAOS58YPNAPhWUwNq9G39Airo+TvV2ecXBiNU5s9PFqkL3RbRFg@mail.gmail.com>
 <51340ECD.1030905@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=/gThhqWoTKQIO46kzKyRsD8coWUxaveckoFJ4V8H8t0=;
        b=cD/BynlS7BzC/zCl2RkUJVa6AFLWlulNG8i0pL06YbvAfd0bjQn4QOYkpNVF+nz8e+
         j36zq5OMPmL5oyGEpQYhaaMw7alqrIpccgrANt5JPFaVRPBeJzFU768fh2M+YT8AjmSp
         VYN61LvrIwIS+GAiXtYs1RcEGcbesbgIGAhzgIfrHZ3JDvrRetN7784uQ1brMGwCE4TK
         yR6nFIMZdJSKGlUkoNM543+nIr3/JalodKIW1mGW/6oARwlVpUF1jm4TV+gUDIcR77Hn
         LWU6miDBGyTf97m/dcq1ij/dlzHEOZOTjti6b2j5DzEzgA1Erhl+xU3vwBaGGbzzdNo9
         C+eA==
Content-Disposition: inline
In-Reply-To: <51340ECD.1030905-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Mon, Mar 04, 2013 at 11:02:37AM +0800, Li Zefan wrote:
> > Yeah, that's what I meant by the "anal" part although it seems like
> > c99 doesn't even allow that. Do we care tho? It seems like a logical
> > feature which should show up in the standard eventually. Maybe it
> > could be a problem for clang?
> > 
> 
> Do we have a decision now? Please pick v4 if this GNU extension can't be used
> in kernel code, otherwise v5.

I'm just gonna apply the one with the initializer.  It's simpler and
not like we can't back out easily if it ever becomes a problem.

Thanks.

-- 
tejun
