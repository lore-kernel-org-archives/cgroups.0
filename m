From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v4 0/2] refactor sqthread cpu binding logic
Date: Thu, 2 Sep 2021 12:00:33 -0600
Message-ID: <efd3c387-9c7c-c0d8-1306-f722da2a9ba1@kernel.dk>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210902164808.GA10014@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RRi6/kL9/FEDjPGtZKu7zb6d6VYXajVwfUuyvAHAAG4=;
        b=kYIwMu1LevdkHbawEkeMi5GOardoiEgFGDF6OdkKJRN4E16HpAYVkTBxJEE83RB4LD
         orioYYIcrNpdjtyXbO8E0OkbH2Zyci+BgY1ApQfqf9HWkYKBVNTRKW5MHhPcvV1lOJoK
         G7V6KKl163jjEN43Waa8yy15zxzA9cV3UvjnKcJxwV+9hD63z0bb6SUBFaVqJQwrqUPv
         ahvmtg4hK/psKaRKXkhRpKuSp2yQydob1Ozg1Y6uiWZkolOEUJgLmQ7k/2L+ruJRMA6M
         BJrzd3/zLrMa6QTRnLPC2cxsHPul03uGiaJc4WCQDswvH8+fa+AfatzLmJbDK7967YdY
         AfnA==
In-Reply-To: <20210902164808.GA10014-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hao Xu <haoxu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

On 9/2/21 10:48 AM, Michal Koutn=C3=BD wrote:
> Hello Hao.
>=20
> On Wed, Sep 01, 2021 at 08:43:20PM +0800, Hao Xu <haoxu-KPsoFbNs7GizrGE5b=
RqYAgC/G2K4zDHf@public.gmane.org> wrote:
>> This patchset is to enhance sqthread cpu binding logic, we didn't
>> consider cgroup setting before. In container environment, theoretically
>> sqthread is in its container's task group, it shouldn't occupy cpu out
>> of its container.
>=20
> I see in the discussions that there's struggle to make
> set_cpus_allowed_ptr() do what's intended under the given constraints.
>=20
> IIUC, set_cpus_allowed_ptr() is conventionally used for kernel threads
> [1]. But does the sqthread fall into this category? You want to have it
> _directly_ associated with a container and its cgroups. It looks to me
> more like a userspace thread (from this perspective, not literally). Or
> is there a different intention?

It's an io thread, which is kind of a hybrid - it's a kernel thread in
the sense that it never exits to userspace (ever), but it's a regular
thread in the sense that it's setup like one.

> It seems to me that reusing the sched_setaffinity() (with all its
> checks and race pains/solutions) would be a more universal approach.
> (I don't mean calling sched_setaffinity() directly, some parts would
> need to be factored separately to this end.) WDYT?

We already have this API to set the affinity based on when these were
regular kernel threads, so it needs to work with that too. As such they
are marked PF_NO_SETAFFINITY.

> [1] Not only spending their life in kernel but providing some
> delocalized kernel service.

That's what they do...

--=20
Jens Axboe

