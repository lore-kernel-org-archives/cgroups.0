From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] misc_cgroup: introduce misc.events and
 misc_events.local
Date: Fri, 10 Sep 2021 13:21:24 +0800
Message-ID: <2ed98cd6-38bb-100c-9be5-e67f64d8dd62@gmail.com>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <CAHVum0cGkzLg_5fZNFNTG=RRqGYW-8YG2V3gst1TevjtQ4YdBA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GiAJAArvmremFZL8MuX/lD3wxzrw3bHPueJYOVM9tdo=;
        b=jrzbmewRWK3TsvZT7rKAi8gViwiR+gddXgVX4IjLbsQmQuaAQNMVFGy/uUDNbnUmo4
         Zq454e0VUA1Clh6bXLc9ieMzumfSjFJQn8X8Rha3iG8cYdk8KGcpAM7mnpFm4gHNHs46
         gtRGjOtJz1vkEYb+66DTI0J09nT4mPzfMJ/61VL6IJ1C3lIqr1N5Ly0qY4zOgzbcw3hN
         aBsCvMeb5sNIKkvM1FYBrIPgHEKsP+M59ABRR83/GfiiN2YL5Tm3VHRaNKBS8LtCDrmt
         g5XOQzzRhinIGe+BWGLGwCA83o2jPNvwx9kZWr8zRfjNe4NdAaOPfOUkclUd6LsCjtnh
         ypgw==
In-Reply-To: <CAHVum0cGkzLg_5fZNFNTG=RRqGYW-8YG2V3gst1TevjtQ4YdBA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



Vipin Sharma wrote on 2021/9/10 12:56 上午:
> On Tue, Sep 7, 2021 at 10:24 PM brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>>
>> Introduce misc.events and misc.events.local to make it easier for
>> us to understand the pressure of resources. The main idea comes
>> from mem_cgroup.
>>
>> Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>> ---
>>  include/linux/misc_cgroup.h |  9 +++++++
>>  kernel/cgroup/misc.c        | 50 ++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 58 insertions(+), 1 deletion(-)
> 
> Thanks for the changes. Please also update the documentation at
> Documentation/admin-guide/cgroup-v2.rst for the new changes in the
> misc cgroup.
> 
All right, thanks.
