From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH v3] blk-throttle: Fix io statistics for cgroup v1
Date: Thu, 11 May 2023 14:38:00 +0800
Message-ID: <CAMZfGtV8FUoBzhPjFu8V5=e=dQ3wRm+qK7S0HHCB22cjKDLAdQ@mail.gmail.com>
References: <20230507170631.89607-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1683787117; x=1686379117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYtaRcshlY3QmxEEqVJsJU+0bmCyXLBCJqkTVjmG1hA=;
        b=d0SnZ+pjyye00WmokuVRn85o0hU1sSEe2pqirea4ZcrpkfnFfRYD5NIGNnwLArYw3e
         iv64Az5W7Mu6DGr5zAJF0G8CcBCqF+sF384FS8jxP5axqWOpR9v+E5hN6C+C43h/hTNT
         0Yx7lFxm3QbgqJZg7f+9vk4JZk/9f4SujuFsWm4dfd9cVPLYUwMwbnjJFjr+VvzXVno/
         jRtlFY3mjWUXLzS3+M7/j9KC/kW7xmujUlxKN60lZpZQNRCgUXJwiyhSzBdtnmEbV+u8
         spumpdd5/+/4H/V5/yepOz9LH8iOQZNj3AK2Py3JcECSr0I5tTJe9mQ7GWgdn6jT/Psc
         i6uQ==
In-Reply-To: <20230507170631.89607-1-hanjinke.666@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jinke Han <hanjinke.666@bytedance.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, andrea.righi@canonical.com

On Mon, May 8, 2023 at 1:07=E2=80=AFAM Jinke Han <hanjinke.666@bytedance.co=
m> wrote:
>
> From: Jinke Han <hanjinke.666@bytedance.com>
>
> After commit f382fb0bcef4 ("block: remove legacy IO schedulers"),
> blkio.throttle.io_serviced and blkio.throttle.io_service_bytes become
> the only stable io stats interface of cgroup v1, and these statistics
> are done in the blk-throttle code. But the current code only counts the
> bios that are actually throttled. When the user does not add the throttle
> limit, the io stats for cgroup v1 has nothing. I fix it according to the
> statistical method of v2, and made it count all ios accurately.
>
> Fixes: a7b36ee6ba29 ("block: move blk-throtl fast path inline")
> Tested-by: Andrea Righi <andrea.righi@canonical.com>
> Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>

Good catch.

Acked-by: Muchun Song <songmuchun@bytedance.com>

Thanks.
