From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Date: Thu, 28 Feb 2013 06:49:46 -0800
Message-ID: <CAOS58YMBcvhfBWdQmt=JersRgB9nVgsrLACtLovz===2ZXfR=w@mail.gmail.com>
References: <512B01FA.5020506@huawei.com>
	<512B020D.9040504@huawei.com>
	<20130226022703.GA13837@htj.dyndns.org>
	<512C8D84.7090707@huawei.com>
	<CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
	<512DE4A8.5050303@huawei.com>
	<CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com>
	<512EFEDF.8080205@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=2T6lmVG38ghHciaOTYJIzxt7tZlQZyAOA62z7zOFKCU=;
        b=V5Og19tQNiLwHBA11isy3r3854PgG9o/jR4FXkT7+9AA7U8+dHnFBT2UbDu0ZUZdwn
         BSH1it8Fs6sduMhNiSwIoGd6K0IvyV52doaRV+Ak9bj1vndTuomudo9RaxFSjqyLOQK8
         mSpIq19Y5/cIU7OcAyTv83WXc2HjdjO/1venFPXbYwczm+qMYs7J2PnjcZ+w2q90pZQa
         22NmITsW4UaVR31uLV9QVbJYeiUJIqPrZZgruo2BDQbutX9RP1KHYrL7D7NJO7qkfHuV
         6VGal/rVPf+YtMOR9ZNcVYl/bp2OwSidaaV1+s7Ap4SzVonfWxgNgiYZRmVKGF88sUoD
         2yCw==
In-Reply-To: <512EFEDF.8080205@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Wed, Feb 27, 2013 at 10:53 PM, Li Zefan <lizefan@huawei.com> wrote:
>> static const struct cgroup_name root_cgroup_name = { .name = "/" };
>
> Can't... That's char name[0] not char *name.

Flexible array members can be statically initialized. If you wanna be
really anal about it, you can do it manually with a wrapping struct
but I don't think that would be necessary.

Thanks.

-- 
tejun
