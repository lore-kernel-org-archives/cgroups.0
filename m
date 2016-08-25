From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Subject: Re: [PATCH 0/5] Networking cgroup controller
Date: Wed, 24 Aug 2016 17:28:48 -0700
Message-ID: <CAF2d9jihrtUs870+K19zQWtvA4WOkX6ZfKC0BGTt1FQ3NVfxww@mail.gmail.com>
References: <1470876798-4024-1-git-send-email-anaravaram@google.com> <CAG53R5UY7TH3XiOHa1sEa-zGXKfLm9UYBPR6zwP1KHbDSZe4tg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=0i3TsYsv4Skjc8jC77E0OEAj8zZ4ze6EpXW/ZycS+Hk=;
        b=fJk5hbiudUaSjQVnftwZpSkA/CeQsaU5xp7Pr+yxaADJEWouUIcG2BaUVvt93knj/A
         4j1VB4TWx/b/XChhFBefxQ05tRIi1H/8lMcoEx2XPCN7vSyitUDLOTQhytDdbUycwdnU
         OXmO0hkJz0SN6CuF30ykWFptyZdJZHmmOOkh/r9YMPeaENvgD+Oe9Q36cZWd6tT+7Ppj
         7os6uBO1ilJIgGhLJseodQRw+Kbmw1S95zEvwc9DtxVvSjrSRS4D/hfX6dcSL7d8gS9z
         xrspbovBHlH6AOWzwFDTWe6AocSKMBhLT6wecOlX93XuVrerGWy36hmy47p019PIPyQC
         JYbg==
In-Reply-To: <CAG53R5UY7TH3XiOHa1sEa-zGXKfLm9UYBPR6zwP1KHbDSZe4tg@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: Anoop Naravaram <anaravaram@google.com>, Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, linux-netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>, tom@herbertland.com

On Tue, Aug 23, 2016 at 1:49 AM, Parav Pandit <pandit.parav@gmail.com> wrote:
> Hi Anoop,
>
> Regardless of usecase, I think this functionality is best handled as
> LSM functionality instead of cgroup.
>
I'm not so sure about that. Cgroup APIs are useful and this is just an
extension to it.


> Tasks which are proposed in this patch are related to access control checks.
> LSM already has required hooks for socket operations such as bind(),
> listen() as few small examples.
>
> Refer to security_socket_listen() which invokes LSM specific hooks.
> This is invoked in source/net/socket.c as part of listen() system call.
> LSM hook callback can check whether a given a process can listen to
> requested UDP port or not.
>
This has administrative overhead that is not addressed. The underlying
cgroup infrastructure takes care of it in this (current)
implementation.

> Parav
>
>
[...]
