From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Thu, 9 Sep 2021 09:49:56 -0700
Message-ID: <CAHVum0ffLr+MsF0O+yEWKcdpR0J0TQx6GdDxeZFZY7utZT8=KA@mail.gmail.com>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu@tencent.com> <20210909143720.GA14709@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I16UVI1xVNxqcbO392QGXtKnK4wf/LUEXByP19oIeTk=;
        b=Ts2msjDfBeODNwvVyn3lwhkrQzPDGDljScDheKIeHLjMmkvMh7yGfx688Vm87Hv5D/
         RF65aHED9Q5juZc+DoS23IdDOeQgwYzCoXIrXr5Fw4VOE7FTPw3mx+H/yRoXJ4YoKHRk
         2toWXQn8T84Uwzeqeh0micHUDl6U5YT3P2zgfa2f/NNEwx0LV36LXvFpCPDXLbr8V7fM
         5YRQrdmhm2pTpZdbRv39VwXOMaJ52wXaSiRHqj4TVSIb7KgrDhxfRfxzCXtoi+dTr2nd
         j8hZGk/fqXUJadr8sgos3olZOpt8LLlGqPp2jOdwOpHYO6Ovzu0YNtoyoutkl6jMzO/0
         mCQA==
In-Reply-To: <20210909143720.GA14709-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 9, 2021 at 7:37 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Wed, Sep 08, 2021 at 01:24:36PM +0800, brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
>
> So there could be two type of events (not referring to the v1-specific
> failcnt):
> - max - number of times the cgroup's misc.max was hit,
> - fail - number of times operation failed (rejected) in the cgroup.
>
> The former would tell you which limit is probably set too low, the
> latter would capture which cgroup workload is affected. (The difference
> would become apparent with >1 level deep hierarchies.)

We are adding two files in this patch series, misc.events and
misc.events.local. I think "fail" should go in misc.events.local and
its name should be changed to "max". So, both files will have "max"
entry but the one in misc.events will refer to the failures in the
current cgroup and its children, and the one in misc.events.local will
refer to the originating cgroup.

>
> Regards,
> Michal
>
> [1] https://lore.kernel.org/lkml/20191202191100.GF16681-LpCCV3molIbIZ9tKgghJQ/d9D2ou9A/h@public.gmane.org=
cebook.com/
>
