Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5586543F4B8
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 06:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790318544; cv=pass; b=g8Z+Yg5YTXJ+prL9+5EvLb/VYi4u/pPRx+taWXKbCXSxp/V27yRJwNQ3+GNZdTJfQbHtypFS21NTlt0t5jxQB2gx1nINlYj6J+QwdtGk9JYfY+6jQg6SBkTSkNgEm0/FaFgGgVJrLTMzh26HSGBwoIwE5vdCrOMI/WM6H7M++EM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790318544; c=relaxed/simple;
	bh=PIlXHAeNurzh/y2B+H0FitUxNrKxWKb3mLvgkGiI3zk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L+rF638rm9nJujK5Z8ham1km8vSWopIItZOuOS1AFpd6uCjfkg5sZhHKYOpuwp9ZeN800C83mrTzWUelsQ8a8jkBqiW3xXdrzo9M6fKKKAokUDmj0xrRswvhoBMz4MEzrkuYQ75H5Y2lhTqT7dxOpTqpu5R2+oPvcSChskaHPwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ua0NHD76; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ua0NHD76"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a5f9b036f9so5008a12.1
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 23:42:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790318540; cv=none;
        d=google.com; s=arc-20260327;
        b=S0YvFO1BbVuy8pP+/87wIPAm1PzLPjAvF0SM1DpgbBqKhI0KHZvBq3H/gHkP93Q7c+
         fudii1XQdg8TmR1IWHwN0u+eEhTCgwAh+xJbb64gn4u7g/vmCMu3NYt9qOrXGVJE3+sv
         Wb4WQ7q1pLFFF3kL857Emwr1shT8Pxe+lI26skArHEltjFAA0FZax1JRn+neWRIH5zhJ
         WRkPV801C06CSfMs6BQ6n2/aaJt+Buip2V1hA54MPIJBnTbqfz52iEXW1qeEmXJpVQd2
         T6dIKSetwn7ZNch10bcCMXuyz7np6XfOhWBsIMCIFm/yhingE3x693lCgARRg4uUFOBu
         gDtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U931IUFkMVd98OtvL0P43sJytu2CWHhy0Gubri2GWP8=;
        fh=cllYhWdThclhp0KOBZkjJjkTXwMYgCue8EL+3J41RUE=;
        b=Tkte1VP4Z9H2KvQwmSc+TExx+uk/vLD0KDuiLwBFqIlT+oZfrKNauHp/NkBD83bcpf
         Lwomh9C34RcwwqW9x8Qm7pdL0nD9UntU8lITWZMjzuXWs9+N/jNbSn2UmElLYSBD3ASp
         f5PMrdeDIV2CYID8Hcgek1YQUfcYiBCP6fCMFedkqIPaEGPaEjQkdGNUR3XVve2wyfh1
         M+srBPFlM7QtYXvHT9uq/KGH2wifMEKMi3KMQ+DAT0LXXVUw1iBeSsIs44UqjkTbJAVc
         7Cr8CMiNOEXQWUCj2KTHn+NTfDPH1AG6DZMc1wTqaJl2onrcbUrEcnJH3wW/aqEdXQLw
         YynA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790318540; x=1790923340; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U931IUFkMVd98OtvL0P43sJytu2CWHhy0Gubri2GWP8=;
        b=ua0NHD763Klybd6sOAhy6Zrkh90RyVqAwPpOOTWSbJNQQMoCY0etb1ln7bjuhdmErJ
         6Qp0Jr6BkEni5ttUluyDnlbXphc/SRJK0CrDmi/ZNxcApRXbcMasxDOJFZvJA9XS5VqT
         rxH6frhGT3DtFMA8QbE5fAMc9vtXUK+M4Y+aOTmRgZwHqh+fAvt4gWFlk8ufCWC8G0od
         DsMNNRrCPDyOSwbxYm38BJSPOitaeFCX68Re4W/UMNBQ0TBvYpDzJdbYIoHFWzXRVUFU
         rhDY1xV/7706WnhQiU8+SQZkn6Qh6je215QbDkj/DuihwCcQojPaCtqZf2NkKfyeQXGY
         rXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790318540; x=1790923340;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U931IUFkMVd98OtvL0P43sJytu2CWHhy0Gubri2GWP8=;
        b=XmuEbL0HyA9WiXV9CvwwRKA+v9VvdzbxDJe92+2NvvKcIynBDDXW8GlTYke2C/ReTE
         /OEP1htC2Ds9LVFxPiDWs1ULExaB5jXFCD4Hz8xGdXveSUfV/hMCZ8hWW2BlLgpQRx/P
         MPgDTt9S3XE/rYN83wAXsCYFvCzUMcMSSDGhPy2yGEOR0UhJF70TM3iPW6AVmH0tFSci
         mPtoU3OyRABhwglJMvIQcLgsP0cC64DTkHw5xFguz2QbBVQOFxZz1OhDdfr7Tvw9Lwhy
         k1PQ00GwtF5t6DDHUU/vGe/WlRIBTuS+/HnL2QPDn4dB4lcGj8QQjT+KhzBcs7Uf1xcM
         PyOQ==
X-Forwarded-Encrypted: i=1; AKwUvByMFCFId3ZqP72godZKxTBVwrxiBooC+18VYQ5Ocwb2cRoQm3P77FvXb7rrL96t5HeDa5Li1gwQ@vger.kernel.org
X-Gm-Message-State: AFuF++lLkjpgbP5i9d2oNPddhAsMAvdImLhL4mAwd7CTCoqMGhOjcfZC
	TGT4uXWk3cNKB2DwM5zItR33aTvIku6XMNjN0KXSbS0SGrg1rkNF+TNDAh0RtQ6C8bBmdL01+Iv
	idnCdybt83EfRWK3aTy9L+lEl8SLxZDNDj0HYNKJX
X-Gm-Gg: AYBFou2ggyc0r1b40/wIxvdAmBzMwvz+VKZ42UVIslfbDzfl6uutaorK/fOzlDLWTB/
	VwpqfsGdIe+8Mop8ZUsp6mIr7RCPykApV8vBue6hiz47M2js5XMsqVsGqnEgP0onUcp4IjIurjV
	l2Rx/TL5ZyvGO0ZDO0phGMJceyZmYwt/kUcnk2Hsyc4kJhk7uyj4KIac4r7t04OjnjKMitMCRMs
	aiXqerLAlJJJrc0yY1Q6aYIECyICFB/XFeGn4JP+RO1VNJteJsfCsWfc8InR9HM5M9ur8j2w91A
	YRn+eyCOtgqOGh17uJnrOz3XdBvaHm+dHAiZ/CBTy1WZ7ehf+03Eyw==
X-Received: by 2002:a05:6402:38c:b0:6aa:b663:4801 with SMTP id
 4fb4d7f45d1cf-6aaea0fb6d8mr14030a12.15.1790318539859; Thu, 24 Sep 2026
 23:42:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902040725.877155-1-cui.tao@linux.dev> <aphkAGKpg3dgFc6c@localhost.localdomain>
 <8c816b23-d394-4389-94ab-7fec889b1300@linux.dev>
In-Reply-To: <8c816b23-d394-4389-94ab-7fec889b1300@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 24 Sep 2026 23:42:06 -0700
X-Gm-Features: AclHuK-5vOY-egLSEE_bH_0i2hCHj7p-HnkJlCAYVNPv8oCs54l4oqzVV9WylcQ
Message-ID: <CAJuCfpEFmV9hE4dT2B_KTEaZfPe-tfkwJmYhgRRRFm-LqiwUrQ@mail.gmail.com>
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

On Thu, Sep 3, 2026 at 12:24=E2=80=AFAM Tao Cui <cui.tao@linux.dev> wrote:
>
> Hello Michal, Suren,
>
> =E5=9C=A8 2026/9/3 02:47, Michal Koutn=C3=BD =E5=86=99=E9=81=93:
> > Hello Tao.
> >
> > On Wed, Sep 02, 2026 at 12:07:25PM +0800, Tao Cui <cui.tao@linux.dev> w=
rote:
> >> +/* PSI triggers are written with a trailing NUL the kernel parser exp=
ects. */
> >> +static ssize_t write_trigger(int fd, const char *trigger)
> >> +{
> >> +    return write(fd, trigger, strlen(trigger) + 1);
> >> +}
> >
> > Hyrum's law. It all works for me: NUL, \n or just write(2) the exact
> > length of the string.
> > For conventionality, I'd prefer the simple literals and plain strlen() =
+
> > 0. (I reckon cg_write() cannot be used because of FD access.)
> >
>
> Your Hyrum's law point made me look at the parser, and I'm glad it
> did, because the behavior is more subtle than "all of them work".
> psi_write() does
>
>         buf[buf_size - 1] =3D '\0';
>
> i.e. it overwrites the last byte of whatever was written. With a plain
> strlen()-sized write that eats the last digit: "some 150000 2000000"
> silently arms a 200000us window when privileged, and fails with EINVAL
> for unprivileged users (200000 is not a multiple of the 2s minimum). I
> reproduced both on 7.0.0-28 here. I suspect your runs succeeded
> because a truncated window still makes a valid trigger for root, so
> nothing looked off.
>
> I went with your \n variant instead: the newline gets clobbered, the
> payload stays intact, and it is the conventional procfile form. So the
> reliance on the undocumented NUL is gone, even though not quite via
> strlen()+0.
>
> Two follow-ups this suggests, if there is interest (I'm not pushing
> either within this series):
>
> - psi.rst says nothing about the terminator while sysfs documents its
>   (append, not clobber) behavior explicitly; a sentence in psi.rst
>   would at least make the convention discoverable.
> - kernfs and sysfs both append the NUL after the written data, so the
>   user bytes survive. psi_write() could do the same with
>   buf_size =3D min(nbytes, sizeof(buf) - 1) and buf[buf_size] =3D '\0'.
>   Terminator-terminated writes keep their exact meaning, and a bare
>   strlen() write would parse in full instead of losing its last digit.
>   That would be the more principled fix, but it is a behavior change
>   for unterminated writes, so it needs a call from the PSI maintainers.

Yeah, I was expecting a NUL-terminated string with the NUL included
when we write, like shown in the psi.rst code example:

write(fds.fd, trig, strlen(trig) + 1)

but I agree that this might be unconventional.
I guess we could check if buf[buf_size - 1] is already '\0' then do
nothing (keeps current users happy) and otherwise we append the NUL at
the end. That way both write(fds.fd, trig, strlen(trig) + 1) and
write(fds.fd, trig, strlen(trig) + 0) would work. Would you agree or
did I miss anything?

>
> >> +
> >> +static int pressure_open(const char *resource)
> >> +{
> >> +    char path[PATH_MAX];
> >> +    int fd;
> >> +
> >> +    snprintf(path, sizeof(path), "/proc/pressure/%s", resource);
> >> +    fd =3D open(path, O_RDWR);
> >> +    if (fd < 0)
> >> +            ksft_perror(path);
> >
> > This outputs:
> > | # /proc/pressure/irq: No such file or directory (2)
> > | #      SKIP      /proc/pressure/irq unavailable
> >
> > I.e. similar message is printed twice.
> > Since strace is a companion of cgroup selftests, I'd keep this helper
> > silent.
> >
>
> Agreed, the helper is silent now. The duplicate was my own doing: I
> added the print in v5 on Suren's v4 request (it replaced a raw
> fprintf) without noticing the SKIP message right below it already
> carries the reason, so removing it satisfies both comments.
>
> >> +    return fd;
> >> +}
> >> +
> >> +FIXTURE(psi)
> >> +{
> >> +    char root[PATH_MAX];
> >> +    char *cg;
> >> +};
> >> +
> >> +FIXTURE_SETUP(psi)
> >> +{
> >> +    int psi_fd;
> >> +
> >> +    if (cg_find_unified_root(self->root, sizeof(self->root), NULL))
> >> +            SKIP(return, "cgroup v2 isn't mounted");
> >> +
> >> +    /* PSI must be enabled (CONFIG_PSI=3Dy, not disabled on the cmdli=
ne). */
> >> +    psi_fd =3D open("/proc/pressure/memory", O_RDONLY);
> >> +    if (psi_fd < 0)
> >> +            SKIP(return, "PSI unavailable (CONFIG_PSI=3Dn or psi=3D0)=
");
> >> +    close(psi_fd);
> >> +
> >> +    self->cg =3D cg_name(self->root, "psi_trigger_test");
> >> +    if (!self->cg)
> >> +            SKIP(return, "failed to allocate cgroup name");
> >> +    if (cg_create(self->cg))
> >> +            SKIP(return, "failed to create cgroup: %s", strerror(errn=
o));
> >
> > Why are these two SKIPs (not failures)?
> >
>
> You're right, they are not environment problems. They are ASSERTs in
> FIXTURE_SETUP() now, so a run without privileges fails loudly instead
> of vanishing into skips.
>
> >> +TEST_F(psi, cgroup_trigger_fire)
> >> +{
> >> +    char *cpupress;
> >> +    struct pollfd pfd =3D { .events =3D POLLPRI };
> >> +    long ncpus;
> >> +    int fd;
> >> +    int i;
> >> +
> >> +    cpupress =3D cg_control(self->cg, "cpu.pressure");
> >> +    ASSERT_NE(NULL, cpupress);
> >> +    fd =3D open(cpupress, O_RDWR);
> >> +    free(cpupress);
> >> +    ASSERT_GE(fd, 0);
> >> +    pfd.fd =3D fd;
> >> +
> >> +    /*
> >> +     * 1usec threshold over a 2s window: any CPU stall fires it. The =
2s
> >> +     * window is the smallest unprivileged users are allowed to arm.
> >> +     */
> >> +    ASSERT_GT(write_trigger(fd, "some 1 2000000"), 0);
> >
> > The selftest rarely can be run as unprivileged user (even test cgroup
> > creation needs privileges), so this comment is irrelevant. (But it's
> > fine to test with that value.)
> >
>
> Dropped.
>
> > On the more abstract level -- I was playing with this and thinking abou=
t
> > a value that'd test both sides, i.e. false triggers as well as false
> > non-triggers. I'd find that to be the half of the window and the number
> > of tasks should be then (3*ncpus + 1) / 2.
> > Or perhaps test two thresholds, one tiny like you did and one maximum
> > (whole window) with same amount tasks but expect trigger, no trigger
> > respectively.
> >
>
> I tried both of your variants before picking one. The half-window
> threshold with (3*ncpus+1)/2 hogs fired reliably, and the two-threshold
> variant also held up on the negative side: with the threshold equal to
> the whole window, ncpus+1 hogs never fired it (measured cpu.pressure
> "some" stays around 2-17% under that oversubscription, so the margin
> is comfortable rather than borderline). I kept the existing tiny-
> threshold test and added cgroup_trigger_no_fire for the whole-window
> side, which matches your second variant and keeps the hog setup shared.
>
> >
> >> +
> >> +    ncpus =3D sysconf(_SC_NPROCESSORS_ONLN);
> >> +    if (ncpus =3D=3D -1)
> >> +            TH_LOG("sysconf(_SC_NPROCESSORS_ONLN): %s", strerror(errn=
o));
> >> +    ASSERT_NE(-1, ncpus);
> >
> > Same as messages from pressure_open() above. Simply assert.
> >
> >> +
> >> +    /* ncpus+1 hogs guarantee CPU contention inside the cgroup. */
> >> +    for (i =3D 0; i < ncpus + 1; i++)
> >> +            ASSERT_GE(cg_run_nowait(self->cg, hog_cpu, NULL), 0);
> >> +
> >> +    ASSERT_EQ(1, poll(&pfd, 1, PSI_POLL_TIMEOUT_MS));
> >> +    ASSERT_NE(0, pfd.revents & POLLPRI);
> >> +    close(fd);
> >> +}
> >> +
> >> +TEST_HARNESS_MAIN
> >
> > All in all, this looks so much better than the initial version, well
> > done. Just a few polishing touches.
> >
>
> All 7 tests pass on a 2-CPU and a 16-CPU machine.
>
> Thank you both, this series learned a lot from you: Suren walked me
> through the harness conversion and the reporting details, and you kept
> the semantics honest, which is what surfaced the parser behavior. The
> test is in a much better shape than what I started with, and the
> parser finding above came out of your push on both directions of the
> trigger.
>
> Thanks
> Tao
>
> > Michal
>
