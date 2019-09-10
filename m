From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/10] blkcg: implement blk-iocost
Date: Tue, 10 Sep 2019 09:08:55 -0700
Message-ID: <20190910160855.GS2263813@devbig004.ftw2.facebook.com>
References: <20190828220600.2527417-1-tj@kernel.org>
 <20190828220600.2527417-9-tj@kernel.org>
 <20190910125513.GA6399@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=bdd/RVi8vfAfg851AYquHh04me7NuiJ7iVVTsDpYp68=;
        b=fUA+fYqvDaEh6XnC8UBQ3JpjN/2WjcxI+8CiRk4SalHIoVe5prkjFMu71bb/uLhLEi
         vdSRmM1ImkGHh+5l222crJZZ8/ZbN5H9jaqs5XiMxOkLTzGZGkekXnXHoceWM87OVVZW
         t0OZsTU5TT8dmyCn/uOnVU4OzwLHubfn9Uk/eyxwR46e9wcUNF0twyojDJIJ4r9hPgm+
         ctrVk79+ExOfFiWG/zP/jiTtOv9aL/Mk6GmHBR0tH9tBI793M0JSgUKIbdE11v4CZcki
         biWouuq8snH+yIDMNXZDgpkw+bvxzlXrTIXXskJqm/qPfuoXfRt7hgJ7cl/2r4M4jd6M
         /rRQ==
Content-Disposition: inline
In-Reply-To: <20190910125513.GA6399@blackbody.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: hannes@cmpxchg.org, clm@fb.com, dennisz@fb.com, newella@fb.com, lizefan@huawei.com, axboe@kernel.dk, josef@toxicpanda.com, Josef Bacik <jbacik@fb.com>, kernel-team@fb.com, Rik van Riel <riel@surriel.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>

Hello, Michal.

On Tue, Sep 10, 2019 at 02:55:14PM +0200, Michal Koutn=FD wrote:
> This adds the generic io.weight attribute. How will this compose with
> the weight from IO schedulers? (AFAIK, only BFQ allows proportional
> control as of now. +CC Paolo.)

The two being enabled at the same time doesn't make sense, so we can
just switch over to bfq when bfq is selected as the iosched.  I asked
what Paolo wanted to do in terms of interface a couple times now but
didn't get an answer and he posted a patch which makes the two
controllers conflict, so....  Paolo, so it looks like you want to
rename all bfq files to drop the bfq prefix, right?  I can implement
the switching if so.

> I see this attributes are effectively per-cgroup per-device. Apparently,
> one device should have only one weight across hierarchy. Would it make
> sense to have io.bfq.weight and io.cost.weight with disjunctive devices?

It never makes sense to have both enabled, so I don't think that
interface makes sense.

> > +		.name =3D "cost.qos",
> > +		.flags =3D CFTYPE_ONLY_ON_ROOT,
> > [...]
> > +		.name =3D "cost.model",
> > +		.flags =3D CFTYPE_ONLY_ON_ROOT,
> I'm concerned that these aren't true cgroup attributes. The root cgroup
> would act as container for global configuration options. Wouldn't these
> values better fit as (configurable) attributes of the respective
> devices?

Initially, I put them under block device sysfs but it was too clumsy
with different config file formats and all.  I think it's better to
have global controller configs at the root cgroup.

> Secondly, how is CFTYPE_ONLY_ON_ROOT supposed to be presented in cgroup
> namespaces?

Not at all.  These are system-wide configs.  cgroup namespaces
shouldn't have anything which aren't in non-root cgroups.

Thanks.

--=20
tejun
