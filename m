From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/cpu: Fix tg_has_rt_task() malfunction
Date: Tue, 20 Sep 2016 15:41:09 -0400
Message-ID: <20160920194109.GC17513@htj.duckdns.org>
References: <1474208588556845.0.mail@mail>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=k3aYBVgxF8f71IgLq8KN6un30VhB4LkAO94fu6n8nJ4=;
        b=DM6VfKnxQRgMXkeoZBZJBAtEhZ3MQVmqcfKrJRzffNiyJNq3rmgjWZyLy0KMRjg94w
         ylqDYEQ3aAFRUPGkQQKj4vFI8tDHfmZKh7OpnwyVT9mRxoa29gl9GyqBhHU5Y5J+pT/s
         uUXKqmrYc13bqj0mubFCGSgCSsbVu6uz0Km41QUTZwNYGe82nRYjZlyx3bd1RPePt4wj
         2UEstAs0I0pGhz1kLBJT+YVGfyBCwAoMviC16LjRgnZajlhSaJCQJsBcvH0YUs6blIk5
         FbSNvNSX+NuF7hLNLSiydjykLsq/6n4zkT6g6lUoD6WpTcw6tO6DhKpObpSHwfcUpSuW
         u9hg==
Content-Disposition: inline
In-Reply-To: <1474208588556845.0.mail@mail>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: yingooyim <ygyim@konkuk.ac.kr>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, jinh@konkuk.ac.kr

On Sun, Sep 18, 2016 at 11:23:10PM +0900, yingooyim wrote:
> Hi,
> I am a graduate student of System Software Lab. at Konkuk University
> (http://sslab.konkuk.ac.kr).
>=20
> This patch is to fix the malfunction of tg_has_rt_tasks(). The
> tg_has_rt_tasks() function is supposed to determine whether a task
> group includes an "rt task" or not. However, it returns true for
> "dl task" too. The origin of this problem is that rt_task() called
> by tg_has_rt_tasks() returns true for dl tasks. Because of this
> problem, tg_rt_schedulable() that calls tg_has_rt_tasks() returns
> =E2=80=93EBUSY if we try to initialize an rt task group, while a dl task
> is running. That is, you cannot run an rt task group when there
> exists a dl task in the system. Our patch provided in this post
> simply makes the tg_has_rt_tasks() function return false for dl
> tasks by calling dl_task() in the conditional statement.
>=20
> Previously we have provided another patch for rt_task() (more
> precisely rt_prio()) to resolve this problem as follows:
> https://patchwork.kernel.org/patch/9299267/
> However, a dependency issue were raised. So, we think that it is
> better to modify tg_has_rt_tasks() instead of rt_task() itself.
>=20
> Signed-off-by: Yin-goo Yim <ygyim@konkuk.ac.kr>

Can you please repost with scheduler maintainers cc'd?

 Ingo Molnar <mingo@redhat.com>
 Peter Zijlstra <peterz@infradead.org>

Thanks.

--=20
tejun
