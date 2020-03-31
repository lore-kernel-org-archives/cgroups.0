From: Weiping Zhang <zwp10758-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 2/3] bio: track timestamp of submitting bio the
 disk driver
Date: Tue, 31 Mar 2020 18:56:49 +0800
Message-ID: <CAA70yB5JeK0F_N_qcCaBeAUUUU=8TErV9EXONRGDmqkJ8bKRvA@mail.gmail.com>
References: <20200327062859.GA12588@192.168.3.9> <20200331082505.GA14655@infradead.org>
 <CAA70yB5cWESKW600Lwoi8toPaiDtOVH53P8GSou6uukmX5mvgQ@mail.gmail.com> <20200331091644.GB12040@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=D4IVQ7JDKhY91r0DBf8xKIDAIEvpogwte6mgLoTb3Oc=;
        b=JfkWb4TT+RcwZGVAEmdXuwffw1dfSxUEjBTdhxma75/CCqNb0D+er5mivvJaJjGP/f
         nzZmBa0fReQdx/vRYCYbYL8WNExei7LxxJ3+VUiJqprPDJE+QUJeLaKcmPyF1Ph+2GLV
         GKOAdUZFS7j8nQwKD9Am+IBe0SGt5rJK2um1HUW01epaPSrjSVSU1tRREn/Rbyi2CYza
         mS0cKkM9E5HARhZxH7ix4FvpdQRAR/X06gn/xxUhcYFy8hEiu8CU2IotM9TqUyc02ujX
         F+HjHjz25LhISTm3rPs0U6d4JmKL8Vhf7PmA4vLYnImRPA8EjrCyQitAFbHhvw9QZzUA
         b4eA==
In-Reply-To: <20200331091644.GB12040-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =E4=BA=8E2020=E5=B9=B43=E6=9C=8831=E6=
=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=885:16=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Mar 31, 2020 at 04:45:33PM +0800, Weiping Zhang wrote:
> > Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =E4=BA=8E2020=E5=B9=B43=E6=9C=883=
1=E6=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=884:25=E5=86=99=E9=81=93=EF=BC=
=9A
> > >
> > > On Fri, Mar 27, 2020 at 02:28:59PM +0800, Weiping Zhang wrote:
> > > > Change-Id: Ibb9caf20616f83e111113ab5c824c05930c0e523
> > > > Signed-off-by: Weiping Zhang <zhangweiping-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
> > >
> > > This needs a commit description and loose the weird change id.
> > >
> > OK, I rewirte commit description, it record the timestamp of issue bio
> > to the disk driver,
> > then we can get the delta time in rq_qos_done_bio. It's same as the D2C=
 time
> > of blktrace.
> > > I also think oyu need to fins a way to not bloat the bio even more,
> > > cgroup is a really bad offender for bio size.
> > struct request {
> >     u64 io_start_time_ns;
> > also record this timestamp, I'll check if we can use it.
>
> But except for a few exceptions bios are never issued directly to the
> driver, requests are.  And the few exception (rsxx, umem) probably should
> be rewritten to use requests.  And with generic_{start,end}_io_acct we
> already have helpers to track bio based stats, which we should not
> duplicate just for cgroups.
generic_{start,end}_io_acct and blk_account_io_done,
these two method use the a timeline (part->stamp), but cgroup doesn't have,
so cgroup cann't use these general helper to counting the total io ticks
for read,write and others. Block cgroup use delta =3D now -
bio->bi_issue[issue_time]
to counting total io ticks.

How about move it into the blk-iotrack code, rq_qos_issue will call the
rq_qos_ops.issue,  then if user doesn't enable blk-iotrack, these code
will not be executed.

Thanks
