From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/shmem: set default tmpfs size according to memcg limit
Date: Sat, 18 Nov 2017 00:20:40 +0800
Message-ID: <CALOAHbAWvYKve4eB9+zissgi24cNKeFih1=avfSi_dH5upQVOg@mail.gmail.com>
References: <1510888199-5886-1-git-send-email-laoar.shao@gmail.com>
 <CALvZod7AY=J3i0NL-VuWWOxjdVmWh7VnpcQhdx7+Jt-Hnqrk+g@mail.gmail.com> <20171117155509.GA920@castle>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ePv3D/rwZ8fPxghg/F4OfkZ9d9P1ZBtZWnxqGxRQUtc=;
        b=N/lD8fAYRInGB3CtBOc/SSmYlpO+i2T9uVgL4GWI+gYm4BlCZBexYa/Lt71XqNmAf4
         Pe5sGpjSgcdJmFLmGeL2+OTF2ApK6rAWaa7CZD3B7Q6fif6OS82NjVXj01E/tR+N9FY0
         kmXsnISmYoNH/Zd6nP9/KKjev2FjVS4IOyjyMVsOijl1fGxQ7YLvT/LoD4jg0hUdjhK0
         V7zVRYHdrfLlajmfQktKDeGJ+aoSJw949gMDehJma29n3fp8DBUCUmbmiNqAPE06hyZ/
         f1z+NKMe5taK3DkpTxvYYhaxuX8P0Nu0E3wSFpTVbCGOL7mErw0Yk+mCMVWTyNTh7hVh
         btRg==
In-Reply-To: <20171117155509.GA920@castle>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2017-11-17 23:55 GMT+08:00 Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>:
> On Thu, Nov 16, 2017 at 08:43:17PM -0800, Shakeel Butt wrote:
>> On Thu, Nov 16, 2017 at 7:09 PM, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > Currently the default tmpfs size is totalram_pages / 2 if mount tmpfs
>> > without "-o size=XXX".
>> > When we mount tmpfs in a container(i.e. docker), it is also
>> > totalram_pages / 2 regardless of the memory limit on this container.
>> > That may easily cause OOM if tmpfs occupied too much memory when swap is
>> > off.
>> > So when we mount tmpfs in a memcg, the default size should be limited by
>> > the memcg memory.limit.
>> >
>>
>> The pages of the tmpfs files are charged to the memcg of allocators
>> which can be in memcg different from the memcg in which the mount
>> operation happened. So, tying the size of a tmpfs mount where it was
>> mounted does not make much sense.
>
> Also, memory limit is adjustable,

Yes. But that's irrelevant.

> and using a particular limit value
> at a moment of tmpfs mounting doesn't provide any warranties further.
>

I can not agree.
The default size of tmpfs is totalram / 2, the reason we do this is to
provide any warranties further IMHO.

> Is there a reason why the userspace app which is mounting tmpfs can't
> set the size based on memory.limit?

That's because of misuse.
The application should set size with "-o size=" when mount tmpfs, but
not all applications do this.
As we can't guarantee that all applications will do this, we should
give them a proper default value.

Thanks
Yafang
