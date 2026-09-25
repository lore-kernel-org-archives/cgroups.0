Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560A63BADBD
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 06:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790318920; cv=pass; b=o8/PxW9cj9Zn7hz9ONqtQdmCJI1peYlTY8e8/2moHnkgI3IgrqLEXq+RqS+rlXsNIi9SYHc2aXjgG1zBO+MVp/GgJs+leu3PDQrKzSruI6uQqpR29B3O1Dw2Cl0BeW9ZML5cXn0rxwmOTS5/LtDuG7aegDDzPA3fjLdW6iG91mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790318920; c=relaxed/simple;
	bh=xAXjRQzSicykP6sODBdAS9HNqAdxUb8mYWuh5UnzOcs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ukGmUMY6bdhnsQyRrRQfuFEFEpSKltoCHitheYY5ek9125av7XAJ7RlWvrqjatLERUisrBGgU+h3SSpFQXULW7c0kLffA33FSwbUebXGalogERrq7YDtAlbWj9ELp3sluBTCEp/AJ3YQfJsYi5mJ7IlwKqPuDjo1snNlBLC0OsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uyCcq758; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uyCcq758"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6aae147ef9dso7207a12.0
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 23:48:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790318916; cv=none;
        d=google.com; s=arc-20260327;
        b=kVY4ByUKz8QqicgUi1sRvsbyoTdamXYOGZfD75gKSkqpIgEJlVHnVcW49eI2I1/n6z
         ktwbLI9bEvhRIJRWJZWP6oL6aWVasJwAQm0JBxMF7w2dw+JEwl6Q48ypvAvyM96rA0+Q
         TZYVy7QFuJA2WmI0LCdjGVJxBVq0XN6+srKoZl0vUPRGRcGxw3AlFsaRulg0cXhGvOzC
         uH+in/O8nrtgHWp3GYMR1lynFBEl09sbOOPPVXBl6bEtFYDCju7kBTPobnXNvfWyM3tX
         uecF0HTmZciW6A3X6VcNMEPvIEOOVxhtFDU/M4CGU4Fpiy4fZFA4/0XPKnsiRiGU/nEY
         qseA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gJi7LDqcEuc2sR14VwXJiEgiHRxzpWlfA/fAlwqMSdc=;
        fh=PpON3J7eyWZEdN+bDQwJlKWTlCGoSe3kEQsxMzujyqE=;
        b=QwlMifo9dzSosqG1cMpKkIqF4Gt7nqxfnc0Q0ynsSWHb+JgmAPSOs4E0NN1/FsvK8q
         E82zUK2AeSi9Qv4tutdlap29MEuStZ7L7b7g3vIJetnMGvjM+VvM/gSN6Jf8WFnH/CCV
         tudkSnFO19skOCRc47JTHkuC7IDTUtCF1V/Wru33GURpz7uJ2agnxb/hK7TzUaKROXbs
         I5XInSkYyZ4DKJ+tQyuJyE8m1B0kIk1O0IKrTdBCYH3E3jV1DSIz+WrbqiW/OC9SEM7X
         IO0xVi/pqAgaSv+mlBiuwM9L1Gi/HvE7AF7PBlkHgD31fPrwYaLdGm9t8Of1apywykFw
         pXhQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790318916; x=1790923716; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gJi7LDqcEuc2sR14VwXJiEgiHRxzpWlfA/fAlwqMSdc=;
        b=uyCcq758ThIUTuTM2Mk6k0Lnf3P+HxTVWTMGOYbHEb1GgwBiH8nswkHJ9qNQAN9w0J
         x2pQncGlfnIb5dvfkq1fuvRhGZ7b8SG/dnnbm6hZ69z7gqGMad35XqgLHuKgdsfSp7Js
         /g/HioWH4cxAfHIJFFBfJFOlV0bDWejNVmEPodTx557TIxEowYPBNhZlC81UAsEBxofX
         /7jRzELmNecyNMLDjEWP5jdZkJ1C1z2wSeCz9GloFUzM3rlRCwDQePhEsbwxSqIByJMa
         Mk4f8kHohw3SbJ+lAKOgXFplP6SLub5LSebnSooZIgG4krSKenwWCn/VaOJScCn8Kxl/
         shuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790318916; x=1790923716;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gJi7LDqcEuc2sR14VwXJiEgiHRxzpWlfA/fAlwqMSdc=;
        b=nTN4hcX9lSXknhPozWfnHnAUw9DqLpoFGW2gcaZhfJAEljF2EYa+XdsFhvsumCE/7E
         EeYibT7p/Mn2VrpZiqgp7LQz3WhBsSNUJ/HWxuMVlucqCXaUpfZ5ZfyCuzNNn9BBc45A
         Ig24KO30mPbaeQHUEI+3XCpnnjGBrDTwYppcmCW94NrapYSjE4JyruAlLzfkVKBaOXoF
         5KB8thGjBwdfKLmBz8VInkImHIK1EAFr3DXz27roZUHMFma2A7LwAe375VGVkALPxlqC
         yLiLO4s1pP75sfLMpvWDCBSroFvmJm18Yqg07U7cxy4918unAcbiFcq6Vq/QA0VFdBi9
         DS9w==
X-Forwarded-Encrypted: i=1; AKwUvBy+uLtJdDIKIZC6GBTDtGe/DzZDQ66cVQZc2mmiqnUh/F2K5xQ24HXsHn2TI5T5pd4ROn5sEQ18@vger.kernel.org
X-Gm-Message-State: AFuF++lQfgnnxBTwf/q+TDJFnPxE016TZFUGG+roywbP5Ytxzsvg57FW
	cDOAEFUXL6Mk9shgpcX5Gd9xforyW9JDEkyp2pQlntGl0+MqCZEWajEoE3WoHgq6z8W8SG5w6Ux
	G50g/05T0uuvPwFGHK2yPq1xJc9Wv4+LAR39LzcuB
X-Gm-Gg: AYBFou1w/94AyMQZIgIlZ/hjP/pozWyF7X4Pgg5LLUBYN4/0YFHZ1ZeNIACTyxr0gHF
	fyRoCUeL73PBp+hZwHVU6zxw1JO62enQknwxhKILWELF3tvRSHVvyvCttm9IHmWnFfXI2rNGBio
	eKZ2/ODRdHBESgBxEKA5XCkFSEbXK5YNJDalLNee1MeFSPAnR5FO5CZo8KGIrx0Kcqca9W0XFum
	UFMvH1wrcWpOn8H+V+wSxMI08b3ez0ttaO9U9WpF4yazkejwbi+4oPQ6nYNN9E+1VU8PU6u6xeT
	PmU3sCZxguevc2LJ6+w7Bz9f8yIjt21qpc4x96aSkZAPejKB1AVzVQ==
X-Received: by 2002:a05:6402:1393:b0:6a6:9d11:d843 with SMTP id
 4fb4d7f45d1cf-6aae4a10dc9mr23362a12.16.1790318915527; Thu, 24 Sep 2026
 23:48:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902040725.877155-1-cui.tao@linux.dev> <aphkAGKpg3dgFc6c@localhost.localdomain>
 <8c816b23-d394-4389-94ab-7fec889b1300@linux.dev> <CAJuCfpEFmV9hE4dT2B_KTEaZfPe-tfkwJmYhgRRRFm-LqiwUrQ@mail.gmail.com>
In-Reply-To: <CAJuCfpEFmV9hE4dT2B_KTEaZfPe-tfkwJmYhgRRRFm-LqiwUrQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 24 Sep 2026 23:48:21 -0700
X-Gm-Features: AclHuK96vZwQIjgONAkZmuEEJWbsreEVi2eh7jETXBKjDxgGfV57_j9mQyioUpU
Message-ID: <CAJuCfpF3qhfDazeOBbRqdqEG6D5P3S3dhVEFHC_pB9ie6kSD9g@mail.gmail.com>
Subject: Re: [PATCH v5] selftests/cgroup: add PSI pressure trigger and
 validation tests
To: Tao Cui <cui.tao@linux.dev>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ziyang Men <ziyang.meme@gmail.com>, 
	Tao Cui <cuitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 11:42=E2=80=AFPM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Thu, Sep 3, 2026 at 12:24=E2=80=AFAM Tao Cui <cui.tao@linux.dev> wrote=
:
> >
> > Hello Michal, Suren,
> >
> > =E5=9C=A8 2026/9/3 02:47, Michal Koutn=C3=BD =E5=86=99=E9=81=93:
> > > Hello Tao.
> > >
> > > On Wed, Sep 02, 2026 at 12:07:25PM +0800, Tao Cui <cui.tao@linux.dev>=
 wrote:
> > >> +/* PSI triggers are written with a trailing NUL the kernel parser e=
xpects. */
> > >> +static ssize_t write_trigger(int fd, const char *trigger)
> > >> +{
> > >> +    return write(fd, trigger, strlen(trigger) + 1);
> > >> +}
> > >
> > > Hyrum's law. It all works for me: NUL, \n or just write(2) the exact
> > > length of the string.
> > > For conventionality, I'd prefer the simple literals and plain strlen(=
) +
> > > 0. (I reckon cg_write() cannot be used because of FD access.)
> > >
> >
> > Your Hyrum's law point made me look at the parser, and I'm glad it
> > did, because the behavior is more subtle than "all of them work".
> > psi_write() does
> >
> >         buf[buf_size - 1] =3D '\0';
> >
> > i.e. it overwrites the last byte of whatever was written. With a plain
> > strlen()-sized write that eats the last digit: "some 150000 2000000"
> > silently arms a 200000us window when privileged, and fails with EINVAL
> > for unprivileged users (200000 is not a multiple of the 2s minimum). I
> > reproduced both on 7.0.0-28 here. I suspect your runs succeeded
> > because a truncated window still makes a valid trigger for root, so
> > nothing looked off.
> >
> > I went with your \n variant instead: the newline gets clobbered, the
> > payload stays intact, and it is the conventional procfile form. So the
> > reliance on the undocumented NUL is gone, even though not quite via
> > strlen()+0.
> >
> > Two follow-ups this suggests, if there is interest (I'm not pushing
> > either within this series):
> >
> > - psi.rst says nothing about the terminator while sysfs documents its
> >   (append, not clobber) behavior explicitly; a sentence in psi.rst
> >   would at least make the convention discoverable.
> > - kernfs and sysfs both append the NUL after the written data, so the
> >   user bytes survive. psi_write() could do the same with
> >   buf_size =3D min(nbytes, sizeof(buf) - 1) and buf[buf_size] =3D '\0'.
> >   Terminator-terminated writes keep their exact meaning, and a bare
> >   strlen() write would parse in full instead of losing its last digit.
> >   That would be the more principled fix, but it is a behavior change
> >   for unterminated writes, so it needs a call from the PSI maintainers.
>
> Yeah, I was expecting a NUL-terminated string with the NUL included
> when we write, like shown in the psi.rst code example:
>
> write(fds.fd, trig, strlen(trig) + 1)
>
> but I agree that this might be unconventional.
> I guess we could check if buf[buf_size - 1] is already '\0' then do
> nothing (keeps current users happy) and otherwise we append the NUL at
> the end. That way both write(fds.fd, trig, strlen(trig) + 1) and
> write(fds.fd, trig, strlen(trig) + 0) would work. Would you agree or
> did I miss anything?

Hmm. I'm looking into v6 version of your patch and you are adding '\n'
at the end. So, my plan would not work for this case and I really
don't want to handle these terminators as special cases...

>
> >
> > >> +
> > >> +static int pressure_open(const char *resource)
> > >> +{
> > >> +    char path[PATH_MAX];
> > >> +    int fd;
> > >> +
> > >> +    snprintf(path, sizeof(path), "/proc/pressure/%s", resource);
> > >> +    fd =3D open(path, O_RDWR);
> > >> +    if (fd < 0)
> > >> +            ksft_perror(path);
> > >
> > > This outputs:
> > > | # /proc/pressure/irq: No such file or directory (2)
> > > | #      SKIP      /proc/pressure/irq unavailable
> > >
> > > I.e. similar message is printed twice.
> > > Since strace is a companion of cgroup selftests, I'd keep this helper
> > > silent.
> > >
> >
> > Agreed, the helper is silent now. The duplicate was my own doing: I
> > added the print in v5 on Suren's v4 request (it replaced a raw
> > fprintf) without noticing the SKIP message right below it already
> > carries the reason, so removing it satisfies both comments.
> >
> > >> +    return fd;
> > >> +}
> > >> +
> > >> +FIXTURE(psi)
> > >> +{
> > >> +    char root[PATH_MAX];
> > >> +    char *cg;
> > >> +};
> > >> +
> > >> +FIXTURE_SETUP(psi)
> > >> +{
> > >> +    int psi_fd;
> > >> +
> > >> +    if (cg_find_unified_root(self->root, sizeof(self->root), NULL))
> > >> +            SKIP(return, "cgroup v2 isn't mounted");
> > >> +
> > >> +    /* PSI must be enabled (CONFIG_PSI=3Dy, not disabled on the cmd=
line). */
> > >> +    psi_fd =3D open("/proc/pressure/memory", O_RDONLY);
> > >> +    if (psi_fd < 0)
> > >> +            SKIP(return, "PSI unavailable (CONFIG_PSI=3Dn or psi=3D=
0)");
> > >> +    close(psi_fd);
> > >> +
> > >> +    self->cg =3D cg_name(self->root, "psi_trigger_test");
> > >> +    if (!self->cg)
> > >> +            SKIP(return, "failed to allocate cgroup name");
> > >> +    if (cg_create(self->cg))
> > >> +            SKIP(return, "failed to create cgroup: %s", strerror(er=
rno));
> > >
> > > Why are these two SKIPs (not failures)?
> > >
> >
> > You're right, they are not environment problems. They are ASSERTs in
> > FIXTURE_SETUP() now, so a run without privileges fails loudly instead
> > of vanishing into skips.
> >
> > >> +TEST_F(psi, cgroup_trigger_fire)
> > >> +{
> > >> +    char *cpupress;
> > >> +    struct pollfd pfd =3D { .events =3D POLLPRI };
> > >> +    long ncpus;
> > >> +    int fd;
> > >> +    int i;
> > >> +
> > >> +    cpupress =3D cg_control(self->cg, "cpu.pressure");
> > >> +    ASSERT_NE(NULL, cpupress);
> > >> +    fd =3D open(cpupress, O_RDWR);
> > >> +    free(cpupress);
> > >> +    ASSERT_GE(fd, 0);
> > >> +    pfd.fd =3D fd;
> > >> +
> > >> +    /*
> > >> +     * 1usec threshold over a 2s window: any CPU stall fires it. Th=
e 2s
> > >> +     * window is the smallest unprivileged users are allowed to arm=
.
> > >> +     */
> > >> +    ASSERT_GT(write_trigger(fd, "some 1 2000000"), 0);
> > >
> > > The selftest rarely can be run as unprivileged user (even test cgroup
> > > creation needs privileges), so this comment is irrelevant. (But it's
> > > fine to test with that value.)
> > >
> >
> > Dropped.
> >
> > > On the more abstract level -- I was playing with this and thinking ab=
out
> > > a value that'd test both sides, i.e. false triggers as well as false
> > > non-triggers. I'd find that to be the half of the window and the numb=
er
> > > of tasks should be then (3*ncpus + 1) / 2.
> > > Or perhaps test two thresholds, one tiny like you did and one maximum
> > > (whole window) with same amount tasks but expect trigger, no trigger
> > > respectively.
> > >
> >
> > I tried both of your variants before picking one. The half-window
> > threshold with (3*ncpus+1)/2 hogs fired reliably, and the two-threshold
> > variant also held up on the negative side: with the threshold equal to
> > the whole window, ncpus+1 hogs never fired it (measured cpu.pressure
> > "some" stays around 2-17% under that oversubscription, so the margin
> > is comfortable rather than borderline). I kept the existing tiny-
> > threshold test and added cgroup_trigger_no_fire for the whole-window
> > side, which matches your second variant and keeps the hog setup shared.
> >
> > >
> > >> +
> > >> +    ncpus =3D sysconf(_SC_NPROCESSORS_ONLN);
> > >> +    if (ncpus =3D=3D -1)
> > >> +            TH_LOG("sysconf(_SC_NPROCESSORS_ONLN): %s", strerror(er=
rno));
> > >> +    ASSERT_NE(-1, ncpus);
> > >
> > > Same as messages from pressure_open() above. Simply assert.
> > >
> > >> +
> > >> +    /* ncpus+1 hogs guarantee CPU contention inside the cgroup. */
> > >> +    for (i =3D 0; i < ncpus + 1; i++)
> > >> +            ASSERT_GE(cg_run_nowait(self->cg, hog_cpu, NULL), 0);
> > >> +
> > >> +    ASSERT_EQ(1, poll(&pfd, 1, PSI_POLL_TIMEOUT_MS));
> > >> +    ASSERT_NE(0, pfd.revents & POLLPRI);
> > >> +    close(fd);
> > >> +}
> > >> +
> > >> +TEST_HARNESS_MAIN
> > >
> > > All in all, this looks so much better than the initial version, well
> > > done. Just a few polishing touches.
> > >
> >
> > All 7 tests pass on a 2-CPU and a 16-CPU machine.
> >
> > Thank you both, this series learned a lot from you: Suren walked me
> > through the harness conversion and the reporting details, and you kept
> > the semantics honest, which is what surfaced the parser behavior. The
> > test is in a much better shape than what I started with, and the
> > parser finding above came out of your push on both directions of the
> > trigger.
> >
> > Thanks
> > Tao
> >
> > > Michal
> >
