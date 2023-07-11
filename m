From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 8/9] cgroup/cpuset: Documentation update for partition
Date: Mon, 10 Jul 2023 14:42:54 -1000
Message-ID: <ZKyljsbJgLNpsBLI@slm.duckdns.org>
References: <20230627143508.1576882-1-longman@redhat.com>
 <20230627143508.1576882-9-longman@redhat.com>
 <ZKx4ZJowRhRtjZxB@slm.duckdns.org>
 <6d5aee58-f558-868c-76e0-0b58f8332110@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689036177; x=1691628177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wqRUB5GOcQ1b+cRv1jVfh7t7hV1+cLaTJfgnZElCik8=;
        b=fStzMHOmVVj1XFBo8m8JIqOV4qRKdD6NBhDqvoD1ujGZh2PM6dkZ8MIBJ+nWzmHb4s
         UqTFODF5I1PwXsOX3QeWHl+IGXLA/luXJ/HBORQffFBKWEF8mYCkoUGBNi9JXkSLmF/C
         9mtLTd4VeoDQjwmzw2bjAPrjcJucK+SOmg2+XmTvGLYk6RyrraW+FuUg/KorzOo5C/gj
         fP7cTvV3NeWUFAXE1s0ueIlyV6YMAAuDjNiCTv45hXoCDcWSJwc7E56efvP4eH6FwNHg
         7GRnvAHRgCQ2K3DHxEnmoCDmBpyQ5Ao0kYyaUd66yabQyM1PyQhcz4h0ZAXL62K0rdlF
         Yztg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <6d5aee58-f558-868c-76e0-0b58f8332110@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

Hello,

On Mon, Jul 10, 2023 at 08:21:43PM -0400, Waiman Long wrote:
> > Wouldn't a partition root's cpus.exclusive always contain all of the CPUs in
> > its cpus? Would it make sense for cpus.exclusive to be different from .cpus?
> 
> In auto-filled case, it should be the same as cpuset.cpus. I will clarify
> that in the documentation. Thanks for catching that.

When the user writes something to the file, what would it mena if the
content differs from the cgroup's cpuset.cpus?

Thanks.

-- 
tejun
