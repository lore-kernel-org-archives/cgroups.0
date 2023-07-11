From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 0/9] cgroup/cpuset: Support remote partitions
Date: Mon, 10 Jul 2023 15:45:36 -1000
Message-ID: <ZKy0QCBBFf3JZXuh@slm.duckdns.org>
References: <20230627143508.1576882-1-longman@redhat.com>
 <ZKxzTrN2yiKfXndI@slm.duckdns.org>
 <305038a0-1db8-3d0d-3447-48be1f03d41c@redhat.com>
 <ZKypl8cr3jxiZ6bo@slm.duckdns.org>
 <c0fb6438-8d19-9d75-d717-68f047465332@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689039938; x=1691631938;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RpT1Zdi1tyj6h+VTlL69D/4kKVXAEIcYNY1HQcB2aX4=;
        b=djAxqkMNUbvbWccTngseI3ojv/tdct6mAnGVNvGsN66Rw0+/KG7ZP1kClU3wvuQ6c8
         GQ3KzQTxKalzx1Byuu+AtWpNXZKf1pOn/BjPXwU8xriOIpmywR5Cxe3H50bDyXGBkD7r
         xCf2GfJBLu8jwaE98lnR19uC0MBtGk7YoyMWMUoyCxojgfxDvlY+XTYzEHZHKe2zPKnR
         MnMJDm6w2ILbXhhgiiIjXW+yONQcPktxxcEGQg2VT34YKwlJKF6DXwCFWvdaAZ0HjZ/A
         xO4fVg3lf1hHzSlYuyu4WAil3G3kxest1hcp3YgefhVjBqd2A4195LYOjXdaHpsE5JjC
         jIjw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <c0fb6438-8d19-9d75-d717-68f047465332@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

Hello,

On Mon, Jul 10, 2023 at 09:38:12PM -0400, Waiman Long wrote:
> I don't want to add another cpuset.cpus.exclusive.effective control file.
> One possibility is to keep another effective masks in the struct cpuset and
> list both exclusive cpus set by the user and the effective ones side by
> side, like "<cpus> (<effective_cpus>)" if they differ or some other format.
> What do you think?

Hmm... if we go for separate effective mask, I think it'd be better to stay
consistent with cpuset.cpus[.effective]. That's the convention both
cpuset.cpus and cpuset.mems already follow. I'm not sure what we'd gain by
deviating.

Thanks.

-- 
tejun
