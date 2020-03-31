From: Weiping Zhang <zwp10758-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 0/4] Add support Weighted Round Robin for blkcg and nvme
Date: Tue, 31 Mar 2020 23:47:41 +0800
Message-ID: <CAA70yB51=VQrL+2wC+DL8cYmGVACb2_w5UHc4XFn7MgZjUJaeg@mail.gmail.com>
References: <cover.1580786525.git.zhangweiping@didiglobal.com>
 <20200204154200.GA5831@redsun51.ssa.fujisawa.hgst.com> <CAA70yB5qAj8YnNiPVD5zmPrrTr0A0F3v2cC6t2S1Fb0kiECLfw@mail.gmail.com>
 <CAA70yB62_6JD_8dJTGPjnjJfyJSa1xqiCVwwNYtsTCUXQR5uCA@mail.gmail.com> <20200331143635.GS162390@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S+cb3bISW4bZmT92F1j7Pnq/uvLuSPQAD/l0XluG3es=;
        b=CZ/zV+JpODQPLEkTvr5bV1RtBpJRe9fHt7rTi1ZlaBgKVi9+wGb7JWDMSyVv0LFEsD
         o7PNPQNrt5OdGEe2WyyKKey7Y+vGvDbN3ZH4ABhpa4VnHcXwOIxT7GUBNx/KZLCkmWEk
         lrVuQgPUpgsHRfGXRvtQO3g0TW5D0OAiH81tJGPLzmcM0WGR4NBc/+UWiH2Z1VKmj6Gp
         mUinuOWxNArJRaIiJVjAmIbvhJuf9+2XxQZh8Bx8SBloKhJWEPzEszXl58bmi8CifTLw
         nT3J0bmpXMxgKhC6fTOKnt6huiA+8g/NT10Ysn2FSkTRzgZBVwIgHoorZyCh5XjndMoQ
         EmHQ==
In-Reply-To: <20200331143635.GS162390-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Keith Busch <kbusch-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Minwoo Im <minwoo.im.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nadolski, Edmund" <edmund.nadolski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> =E4=BA=8E2020=E5=B9=B43=E6=9C=8831=E6=97=A5=E5=91=
=A8=E4=BA=8C =E4=B8=8B=E5=8D=8810:36=E5=86=99=E9=81=93=EF=BC=9A
>
> Hello, Weiping.
>
> On Tue, Mar 31, 2020 at 02:17:06PM +0800, Weiping Zhang wrote:
> > Recently I do some cgroup io weight testing,
> > https://github.com/dublio/iotrack/wiki/cgroup-io-weight-test
> > I think a proper io weight policy
> > should consider high weight cgroup's iops, latency and also take whole
> > disk's throughput
> > into account, that is to say, the policy should do more carfully trade
> > off between cgroup's
> > IO performance and whole disk's throughput. I know one policy cannot
> > do all things perfectly,
> > but from the test result nvme-wrr can work well.
>
> That's w/o iocost QoS targets configured, right? iocost should be able to
> achieve similar results as wrr with QoS configured.
>
Yes, I have not set Qos target.
> > From the following test result, nvme-wrr work well for both cgroup's
> > latency, iops, and whole
> > disk's throughput.
>
> As I wrote before, the issues I see with wrr are the followings.
>
> * Hardware dependent. Some will work ok or even fantastic. Many others wi=
ll do
>   horribly.
>
> * Lack of configuration granularity. We can't configure it granular enoug=
h to
>   serve hierarchical configuration.
>
> * Likely not a huge problem with the deep QD of nvmes but lack of queue d=
epth
>   control can lead to loss of latency control and thus loss of protection=
 for
>   low concurrency workloads when pitched against workloads which can satu=
rate
>   QD.
>
> All that said, given the feature is available, I don't see any reason to =
not
> allow to use it, but I don't think it fits the cgroup interface model giv=
en the
> hardware dependency and coarse granularity. For these cases, I think the =
right
> thing to do is using cgroups to provide tagging information - ie. build a
> dedicated interface which takes cgroup fd or ino as the tag and associate
> configurations that way. There already are other use cases which use cgro=
up this
> way (e.g. perf).
>
Do you means drop the "io.wrr" or "blkio.wrr" in cgroup, and use a
dedicated interface
like /dev/xxx or /proc/xxx?

I see the perf code:
struct fd f =3D fdget(fd)
struct cgroup_subsys_state *css =3D
css_tryget_online_from_dir(f.file->f_path.dentry,
        &perf_event_cgrp_subsys);

Looks can be applied to block cgroup in same way.

Thanks your help.
