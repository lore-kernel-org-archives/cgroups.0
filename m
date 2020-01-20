From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 3/6] cgroup: refactor fork helpers
Date: Mon, 20 Jan 2020 15:22:03 +0100
Message-ID: <20200120142202.GC30403@redhat.com>
References: <20200117181219.14542-1-christian.brauner@ubuntu.com>
 <20200117181219.14542-4-christian.brauner@ubuntu.com>
 <20200120140029.GB30403@redhat.com>
 <20200120140452.qyjogmmhyqc3gxon@wittgenstein>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579530129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PWUAb8tz3AF3amrWTTvwK6sWsIt1KM7KTKlRn37IBoI=;
        b=DhyAIzlXBQJX48Nrtt9eyRBpojky86u6rI3fU1wFLsYUxMb3F2Ig1pZVMsXNrQWJr7D+W7
        kFxNWl6qo89TvoYDrB0UIUNyjU5FZJ6DQpvYRKR7vtcmiU4IsDo2PmMs3IDqz/pO+X80JX
        DiwnbLZrHFlVC/SKz2rfQ083rS6+o2I=
Content-Disposition: inline
In-Reply-To: <20200120140452.qyjogmmhyqc3gxon@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

On 01/20, Christian Brauner wrote:
>
> On Mon, Jan 20, 2020 at 03:00:30PM +0100, Oleg Nesterov wrote:
> > This is probably the only patch in series I can understand ;)
> >
> > To me it looks like a good cleanup regardless, but
> >
> > On 01/17, Christian Brauner wrote:
> > >
> > > The patch just passes in the parent task_struct
> >
> > For what? "parent" is always "current", no?
>
> Yes. What exactly are you hinting at? :) Would you prefer that the
> commit message speaks of "current" instead of "parent"?

I meant, I don't understand why did you add the new "parent" arg,
cgroup_xxx_fork() can simply use "current" ?

Oleg.

