From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH-block] blk-cgroup: Use css_tryget() in
 blkcg_destroy_blkgs()
Date: Mon, 28 Nov 2022 12:00:55 -0700
Message-ID: <f89e922c-16d5-0bcf-7e7e-096f42793a36@kernel.dk>
References: <20221128033057.1279383-1-longman@redhat.com>
 <d08a0059-7c0b-d65f-d184-5b0cb75c08ed@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LvEJDQxAkm5Pcp5ay5EjtKj5MIU+4aSru9VkuAAqDpI=;
        b=ZIxVcpTUMb/D5eaOHDEpksfQ3kJ7ZSLXnpj/xXuk9U3DX0xoA2fCl9AbKfhZwZhspV
         fbCcGlev/4EIGojtU1A9K3yvnZdq0T/YLnigSVlZGNQ4cmCpsz54dTGsTSZnzhQQSh2F
         Cfpm/jc+vFpNjyQ+IZMGe+5QzeVLYaYHfv1vY5263b/JPmEuMWLMhThQSjKqNuWjbaqr
         st2WSkGe+KfyQYa85gs07HW4jJt3Qgj8hCQALJ5ZvFw66ttA8YfEsaKse0X+lJHhwT/n
         JbSc9Xv4dAC1AUM24H/pg1KhjbiUnHTiPpNuNxguOTpswj0T3okv4RQZv7mFYqAHY8sd
         vCwA==
Content-Language: en-US
In-Reply-To: <d08a0059-7c0b-d65f-d184-5b0cb75c08ed-HInyCGIudOg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 11/28/22 11:56=E2=80=AFAM, Bart Van Assche wrote:
> On 11/27/22 19:30, Waiman Long wrote:
>> Fixes: 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction path")
>=20
> Has Jens' for-next branch perhaps been rebased? I see the following commi=
t ID for that patch:
>=20
> dae590a6c96c ("blk-cgroup: Flush stats at blkgs destruction path")

I don't know that sha is from, not from me. for-6.2/block has not been
rebased, for-next gets rebased whenever I need to do so as linux-next is
continually rebased anyway. But the sha for that commit would not change
as a result.

I don't even have that sha in my tree, so...

--=20
Jens Axboe


