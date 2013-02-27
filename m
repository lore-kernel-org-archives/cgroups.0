From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Date: Wed, 27 Feb 2013 05:23:25 -0800
Message-ID: <CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com>
References: <512B01FA.5020506@huawei.com>
	<512B020D.9040504@huawei.com>
	<20130226022703.GA13837@htj.dyndns.org>
	<512C8D84.7090707@huawei.com>
	<CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
	<512DE4A8.5050303@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=Vf4paKZ0zjHM6NNhcIo9rA3CZeK/OLkAekzD+tFoERw=;
        b=fRVmjP01x1Zz0H8EbHf+v7Rwa8IR8uoiG3oEc889zkO5hDa3qth/A1UOzGZR8saI3s
         5P9hDW86oTwE9P1E9Qt1/Xua4A+yNlIpSvO+9Z6xjjz8ohmaWVV27biUVr2kvkzO1h1d
         bWayXIakECY0jgrkYly28zWGvql0PX1wRHdkQrwB9l3CHV8P53skfOsW+fWx6FIw5lT5
         Qc6J0d0pMSjxGeHZ+gaudU//BfRqT3G9Bk178rLjak+V5tjWX8+zdVwDMQ4H0mu/V8xK
         WkT7c21QXX3siB83mg8mIO0m/vQF8ZjEVLdFq9WbbdiXzaiTkjg/sQIIsR2TxUuIxFE1
         jAww==
In-Reply-To: <512DE4A8.5050303-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Feb 27, 2013 at 2:49 AM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> Well, cgrp->name is a pointer to struct cgroup_name.
>
> At first I tried to declare cgrp->name as char *, and use container_of()
> to get struct cgroup_name, but it didn't result in simpler code.

Hmmm?  But then what prevents defining const struct cgroup_name?

static const struct cgroup_name root_cgroup_name = { .name = "/" };

Thanks.

-- 
tejun
