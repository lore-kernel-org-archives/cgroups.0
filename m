From: Hong zhi guo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Test of [PATCH] blk-throttle: simplify logic by token bucket algorithm
Date: Fri, 18 Apr 2014 10:41:03 +0800
Message-ID: <CAA7+ByUAZUxfo_jc84h386DQBGW_ump+ZoCFy-nr0wqLa8furA@mail.gmail.com>
References: <1397546303-6709-1-git-send-email-zhiguohong@tencent.com>
	<1397546586-6776-1-git-send-email-zhiguohong@tencent.com>
	<20140415201448.GC13033@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=k9q3JmkSznQSxoQOJpbLMpMU6+kg6YDivJh7Ln4vJqE=;
        b=kqKmjT2k7eQu+f2G72c5dhckAJmAJjnoOvgxoA36+ZumeBnaOpWAykegL4Eg1flhH8
         +twIlyVBPMEh7PXxbBPVPA3lQsFzPJAhkOtzzlx378ZF3ym05KDwPxH5ZH/+mXGgnGdS
         AUiPVYnUOtLIdI3N+od4VqVTfEcMsu1R1NdR6n7OoZZLddPIQnWfL9Yb94zM7Vn6rRKc
         YnWgTgqy4l5VUhGi1xAjHlonaupIV2gzInJo4n4oQJZcNd2zsJJGlTUfCE1+4VEfaBGH
         9QjTqNzG2kM+T60YLHJ9VYNXRi/zZSw0HFCzdj+7dkm3Ovrkfre5F73SqF6CWaVYxkqX
         1hXQ==
In-Reply-To: <20140415201448.GC13033-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

I did it by:
"mount -t cgroup -o blkio,__DEVEL__sane_behavior cgrp /cgroup"

I'm using ubuntu 13.04 and replaced the kernel with my own build.


On Wed, Apr 16, 2014 at 4:14 AM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> What init system are you using? How did you specify sane flag. I am
> using systemd with F20 and I don't know how to specify this flag
> and test your patches.
>
> Thanks
> Vivek



-- 
best regards
Hong Zhiguo
