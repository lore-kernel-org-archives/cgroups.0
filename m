From: Weiping Zhang <zwp10758-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 2/3] bio: track timestamp of submitting bio the
 disk driver
Date: Tue, 31 Mar 2020 16:45:33 +0800
Message-ID: <CAA70yB5cWESKW600Lwoi8toPaiDtOVH53P8GSou6uukmX5mvgQ@mail.gmail.com>
References: <20200327062859.GA12588@192.168.3.9> <20200331082505.GA14655@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WPmHARusSnaiKUVMtU99KCIM8nQK0a64r2bZ1V7If10=;
        b=bec0VgsFpnOofiwh5sjln5uyyX/r/BagIXYaHL+epFhYI7P96lPHazx5+jSe9j1llg
         8X4MWsu5s1rRUAVa7dRe45d9xEXFrhX/WLSKb5YaM5VF7L/+pDknpZXtVGFD+CxV1h6Q
         kjnc4xpEI/2rGqd8VunobqQ2qaNxQVaVfE0Tks9xemW3hJvQ1AMslQU07S4KuyB0Umyl
         woRzMaQo0v3r4JtENx5kVIlJjrsJ1D4Y2hjH78Fysu78MjIQCX+Ulekvs1FFiFJgRPCd
         oJ7wdJp3cqwzvEsygb935Gt9S397kS6ydbV9BDzkvTEkKhaSd8bF06pQNSUUJiHabrOt
         F0EA==
In-Reply-To: <20200331082505.GA14655-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =E4=BA=8E2020=E5=B9=B43=E6=9C=8831=E6=
=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=884:25=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Mar 27, 2020 at 02:28:59PM +0800, Weiping Zhang wrote:
> > Change-Id: Ibb9caf20616f83e111113ab5c824c05930c0e523
> > Signed-off-by: Weiping Zhang <zhangweiping-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
>
> This needs a commit description and loose the weird change id.
>
OK, I rewirte commit description, it record the timestamp of issue bio
to the disk driver,
then we can get the delta time in rq_qos_done_bio. It's same as the D2C tim=
e
of blktrace.
> I also think oyu need to fins a way to not bloat the bio even more,
> cgroup is a really bad offender for bio size.
struct request {
    u64 io_start_time_ns;
also record this timestamp, I'll check if we can use it.

Thanks a lot
