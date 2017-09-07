From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Thu, 7 Sep 2017 16:56:32 +0800
Message-ID: <20170907085534.GA30135@tardis>
References: <1504764252-29091-1-git-send-email-prsood@codeaurora.org>
 <20170907072848.2sjjddwincaeplju@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BO/iQnYGt1PiGpjFnSH2ZcpsXaeuGuHcp/qEoQtkBXw=;
        b=i6zx1BpA860uekGPEPH4Kw4qyhjWuYUO1fZqRW4dwnN8/jJxJEkoOhN7BsfjIpY4pO
         r5kFLtDnp38018k1kd/UNbG932S1nb7a5H2HU6ohcFnl8MskYLBrU0ZbSCbIOvA6ljJz
         P0o2uNzjq1CWoQiMbqMtzficiyQ3OBa09yrngDWmElhS2hzCsC9qVY5R/Hf5fFuAnWt/
         uL5s3dMB/b53kncxYQn7wo8eLBCdyDJCHTvfOKo0oUWER0bcKsyhQLiNl+YN1rtF9GWM
         MJ2WqEO13qZ8fWIGBOIrGU06y4o8qxJhOi4L1n7TTf6zjbpgSbSS4T5t07L5IEwgW2zJ
         I8tA==
Content-Disposition: inline
In-Reply-To: <20170907072848.2sjjddwincaeplju@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Prateek Sood <prsood@codeaurora.org>, tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, mingo@kernel.org, longman@redhat.com, linux-kernel@vger.kernel.org, sramana@codeaurora.org, Thomas Gleixner <tglx@linutronix.de>


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 07, 2017 at 09:28:48AM +0200, Peter Zijlstra wrote:
> On Thu, Sep 07, 2017 at 11:34:12AM +0530, Prateek Sood wrote:
> > Remove circular dependency deadlock in a scenario where hotplug of CPU =
is
> > being done while there is updation in cgroup and cpuset triggered from
> > userspace.
> >=20
> > Example scenario:
> > kworker/0:0 =3D> kthreadd =3D> init:729 =3D> init:1 =3D> kworker/0:0
> >=20
> > kworker/0:0 - percpu_down_write(&cpu_hotplug_lock)  [held]
> >               flush(work)   [no high prio workqueue available on CPU]
> >               wait_for_completion()

Hi Prateek,

so this is:

	_cpu_down():
	  cpus_write_lock(); // percpu_down_write(&cpu_hotlug_lock)
	  cpuhp_invoke_callbacks():
	    workqueue_offine_cpu():
	      wq_update_unbound_numa():
	        alloc_unbound_pool():
	          get_unbound_pool():
		    create_worker():
		      kthread_create_on_node():
		        wake_up_process(kthreadd_task);
		        wait_for_completion(); // create->done

, right?

Wonder running in a kworker is necessary to trigger this, I mean running
a cpu_down() in a normal process context could also trigger this, no?
Just ask out of curiosity.

Regards,
Boqun

> >=20
> > kthreadd    - percpu_down_read(cgroup_threadgroup_rwsem)  [waiting]
> >=20
> > init:729    - percpu_down_write(cgroup_threadgroup_rwsem)   [held]
> >               lock(cpuset_mutex)   [waiting]
> >=20
> > init:1      - lock(cpuset_mutex)   [held]
> >               percpu_down_read(&cpu_hotplug_lock)   [waiting]
>=20
> That's both unreadable and useless :/ You want to tell what code paths
> that were, not which random tasks happened to run them.
>=20
>=20
[...]

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEj5IosQTPz8XU1wRHSXnow7UH+rgFAlmxCb0ACgkQSXnow7UH
+rgh+Af+L0P//IFtlwFQLkh8VHI6or8ipwT+Cl7+vNjK+G5MpRJV9X68o5gYr+jj
YATJz6ZWYRD+H7MmIoqmuwdpG7Q2iB9OmNFKvVsSaok+jYFF6Alwz2Jrjo1Ex+x1
ZTZ9FdzXEL62l52Hcyq8kfPoIeRFbZNoRyyAGPT4xFJtYrmnJrl/GOyAk2rAhQyU
90mCxiLd4EO9SF7+6WgFWmGIG8Yj97AYCRtWc17q3rp7YuRY4vqJIdUQFZUnEKI9
rQwW/8GZUkC46xfgJSI3gwHdF2rTx02PNNoNwihqo65ZgrCyI0ks2z2QN1M93pwp
fBuLaGZP9Yy99ypGti2VWSArBrs0cw==
=QkrD
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
