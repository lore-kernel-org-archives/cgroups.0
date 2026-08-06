Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1773839BA
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 17:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786036385; cv=pass; b=KmRN2Wtrfzz4KtA2kV6ouzB/Qa8IOp99CQHQNJABe6TzwLVg4Tjlbj0iS+GdPfNw5ifxWN9cpiZCKdLcge4ht21iwr9F22nFB/YebZFRA9nxsUFVNfQxuwVq9klxnSqgTxMzX7XYIihpoCXW24dF6VGhAxSc/1B0VKKaeASx1X0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786036385; c=relaxed/simple;
	bh=bXUKWDUfgbn9sVNEKtlFWPHzFvLv4UFxp+9Iiunsy00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rlHntGvsfSIzvhdEMhH7quaav0QmwpUETTVj2KdWB79yikiqw9T31MbgXcgFtWHKWbNLQMDugzKH3MY7Fe0CtSiUei/KL7Hh3HjNFrKn3RfjQK9YErKN3qYNYU5Cz6EIuXynT7aF25y4QyNom2UgIaBeFnaM6K1i12jP+/hXgwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N3sxl8N7; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N3sxl8N7"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c15a5b265so13141cf.0
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 10:13:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786036383; cv=none;
        d=google.com; s=arc-20260327;
        b=gcxcBqMFG1hTFpowGwRVro4R5eS8BgiKRbUh/uR5KRuzH+WV65v3IQFjuhpk3jiFjr
         jMQ8pyEtyvj3H2WePijXOV2DOVWabLwItFyQGZbUOy+t808nDAwo5GdN7jvDiCa4Sn6s
         ogWQApBYIpMs6ivgAd/uKgxAi72sOZZOyQTojTvvHbfw4GVxCzOFVPQpc6tfc34pzk2T
         dBbO7ICjmU9fU9AfSBEIUByVuCiHPYaE5K7MkwOs4yILIdt9bwn8R/+y4a106lrHPUzT
         l6YQAjy5ny76MPYxXxvHGN8Chu8t4AuFKvpXuPystnldIhmwrERLNhkfie0UWSAlinuf
         D/9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kOondB7zlLOm/USRZeEDNtNtm81Uo+XUZekrXkBxZ6g=;
        fh=fQTZSVNOdpyipLmiuCSSOJCrF7wRPghbmOtINwXbDVc=;
        b=BMCPaQ71zfdjSaorP8G29M6Qfza24IK1cnHNB+GTtlhfxGoL+MJYZww4s4IVrHgbfV
         rKvr2D2coEWivXfu1gUSgDbI6+b+OJMQDdO7++bcbo/Z6HPCWiSQesEvwX06WaMjI0KR
         nU/oexpzKshsU5Z9ZStgOhUIJntQWh9zuyyyFwRb0JEZk2AV9K68t6yV9vZJG+qnw2cP
         /jL0fQSx+smqDKXC2+QRpxOed5yerpvsWvpjZbE3NJdymxtgQizoPtmMdUKSECtouZSw
         Do2kYmFSIxHPzrXCY+mExUY+2hEPNFrLiG7IN1ZxepRelOqqkyr1VU4vDzF+4M8er7hl
         HPVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786036383; x=1786641183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kOondB7zlLOm/USRZeEDNtNtm81Uo+XUZekrXkBxZ6g=;
        b=N3sxl8N7xUHUgOJuAtDF4ECLmULfshPvKGF9lkXQ7HCElDVHXFLjMuAY2YGW8TAfCQ
         TcNKiIVDOpNx7o/qatDeeCKXqbFxbzi+jPNpuX/KMbRkkUU4TpmJdrMsROYBbrfdbztx
         p93i2X0RvCsmESZVeiP/UafhPdFJ03oisKqs/kw4Kr+Ldynf84jGylgis4XK9zF8bWj2
         yenrLx9UJLkEH3ijWBFXBqP5VWCKNB+sVhuYklW5Ca4nRqhiRZecirnsmu2bjFRcP6pf
         6inwhgHdLykg4DnJJ13a8DsHxiLKfCIdYrnhc6Gz2Rn/uMOGTusCGVy8Jorxo1LRMwiw
         nJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786036383; x=1786641183;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kOondB7zlLOm/USRZeEDNtNtm81Uo+XUZekrXkBxZ6g=;
        b=XcuhofeWg5JUZjCo5RV7z63voVTsLmUP8rf1l9pyl7ORvZJ64BZXgDjAd/7xg16AH9
         fUPFA8Ul467FUld/RZ0Iut3L4r5QYTLI7KC/vdKR3im9zmcqLA/JbxaRTWJb2KTAnELb
         XiUP7FDGOtQEwa+7b78JmUj4vF+yyHuy1/TDW+2hxkgQ6ffWFqH6Zk2hwA/6AtC0N2se
         31vTXSWpdzQOM2gdT69NtIXbh5AKHMWSHkiTatjJJSPo/pcE/KkjoIRD9eO7ihwylkNe
         jx6HLj/LDzK/mf4dOE7j1k1PqAvUbCAmeynNCJvveKfO23L5k47rfniuEpNgKvnLmOba
         hzgA==
X-Forwarded-Encrypted: i=1; AHgh+Rp38yctLIBPyd0eXLoj0fknkf6SRiv0Ux8n4k37EBCI0//jCbjDbDKQ3w+2cx66Dc8HnxNe3LdQ@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa5cXxtFLsqQq83bp5qOgoL7foSKDKLTJnA+hL71M0krb78QoD
	TqoLOjKnNtu/25O7gC+m6HrcJh4m9nJFS5AZCXMTsiA1mYMcEE3YN775yg/wZLhXQxMwb1pe5bf
	gYlHMPkLzuqSf0mbUPCaH3K2TGyoE5EDaQE2KQHso
X-Gm-Gg: AR+sD11W2Vv3oJIQwD5RF1ttZ41bhuyE9DP3DDbaqmuSz73WGRI/OPt8YeR5p5yGpAg
	5BNvx+jNLSL5CS3O6+XaWvyNVmOeJxO4OejZol6d7GoRSu5RI3+Tu9V+t7NOE1TcBi2UzREKUwO
	hjS6uFBeAbXBawtgpTF5YNoUVRNr0pdX1T0r2H7iXqyQWMHKb1fn12WckELuUY9yaFY7TaaqzW1
	IzXRogYN7gJbMjR1WgRYJWMaHLUX7g6yNFyxmd+y/KRQ2RpOoWtRKCl/kIk59/EBmtWJfWlnAJ9
	4msM8acWyL59TlDDxpoWBB+tvzV4pDS9nZmP79WJkzW5H42C/AIynT2TrUt7PKS1v1MMmKEvPAs
	=
X-Received: by 2002:a05:622a:4885:b0:516:3f51:81cb with SMTP id
 d75a77b69052e-52cfea4c54fmr20988091cf.13.1786036381929; Thu, 06 Aug 2026
 10:13:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728083742.2359320-1-cui.tao@linux.dev> <anS3saMkFog89yxy@localhost.localdomain>
In-Reply-To: <anS3saMkFog89yxy@localhost.localdomain>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 6 Aug 2026 10:12:51 -0700
X-Gm-Features: AUfX_myBqmi3uQlB-HqUGfH-0Y4PN_2k2H_3hlPoqzbY_beS516q1vCa1M6xGG4
Message-ID: <CAJuCfpGdVuY5L8+yMXEwQ-GuTB_PNb7Vkzp9w3CQKosaeE1aLQ@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/cgroup: add PSI pressure trigger and
 validation tests
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Tao Cui <cui.tao@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ziyang Men <ziyang.meme@gmail.com>, Tao Cui <cuitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 6, 2026 at 9:52=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.com=
> wrote:
>
> Hi,
> thanks for continuing with this.

Thanks for adding these tests and sorry I was not able to review them
yet. I'll try to review them this weekend and will provide my
feedback.
Thanks,
Suren.

>
> On Tue, Jul 28, 2026 at 04:37:42PM +0800, Tao Cui <cui.tao@linux.dev> wro=
te:
> > +/* Trigger smoke test: second on same fd -> EBUSY; IRQ rejects "some".=
 */
> > +static int test_proc_triggers(const char *root)
> > +{
> > +     static const char *const resources[] =3D { "io", "memory", "cpu" =
};
> > +     int ret =3D KSFT_FAIL;
> > +     int fd =3D -1;
> > +     int i;
> > +
> > +     (void)root;
>
> WTH?
>
> > +
> > +     for (i =3D 0; i < (int)ARRAY_SIZE(resources); i++) {
>
> This (int) cast is quite uncommon, look around.
>
> > +/* Induce deterministic CPU pressure (more hogs than CPUs). */
> > +static int test_cgroup_trigger_fire(const char *root)
> > +{
> > +     char *cg =3D NULL, *cpupress =3D NULL;
> > +     int fd =3D -1, ret =3D KSFT_FAIL;
> > +     struct pollfd pfd;
> > +     long ncpus, i;
> > +     pid_t pid;
> > +
> > +     cg =3D cg_name(root, "psi_trigger_test");
> > +     if (!cg)
> > +             goto cleanup;
> > +     if (cg_create(cg))
> > +             goto cleanup;
> > +
> > +     cpupress =3D cg_control(cg, "cpu.pressure");
> > +     if (!cpupress)
> > +             goto cleanup;
> > +     fd =3D open(cpupress, O_RDWR);
> > +     if (fd < 0) {
> > +             ksft_print_msg("open cpu.pressure: %s\n", strerror(errno)=
);
> > +             goto cleanup;
> > +     }
> > +
> > +     /* 1us threshold in a 1s window: any cpu stall fires it. */
> > +     errno =3D 0;
> > +     if (write_trigger(fd, "some 1 1000000") <=3D 0) {
> > +             ksft_print_msg("arming trigger failed: %s\n", strerror(er=
rno));
> > +             goto cleanup;
> > +     }
>
> When I see this, could you increase the window size to 2000000 (so that
> it has potential to run for unprivileged users)?
>
> > +
> > +     ncpus =3D sysconf(_SC_NPROCESSORS_ONLN);
> > +     if (ncpus <=3D 0)
> > +             ncpus =3D 1;
> > +
> > +     pid =3D fork();
> > +     if (pid < 0) {
> > +             ksft_print_msg("fork: %s\n", strerror(errno));
> > +             goto cleanup;
> > +     }
> > +     if (pid =3D=3D 0) {
> > +             /* Enter the cgroup, then over-subscribe it with CPU hogs=
. */
> > +             if (cg_enter_current(cg))
> > +                     _exit(KSFT_FAIL);
> > +             for (i =3D 0; i < ncpus; i++) {
> > +                     if (fork() =3D=3D 0) {
> > +                             for (;;)
> > +                                     asm volatile("" ::: "memory");
> > +                             _exit(0);
> > +                     }
> > +             }
> > +             for (;;)
> > +                     asm volatile("" ::: "memory");  /* child is also =
a hog */
> > +             _exit(0);
> > +     }
>
> This part could be replaced with generalized hog_cpus_timed() from
> test_cpu.c (after move to cgroup_util.c).
>
> > +int main(int argc, char **argv)
> > +{
> > +     char root[PATH_MAX];
> > +     int mempress_fd;
> > +     int i;
> > +
> > +     (void)argc;
>
> What's up with this?
>
> > +
> > +     ksft_print_header();
> > +     ksft_set_plan(ARRAY_SIZE(tests));
> > +
> > +     if (cg_find_unified_root(root, sizeof(root), NULL))
> > +             ksft_exit_skip("cgroup v2 isn't mounted\n");
> > +
> > +     /* PSI must be enabled (CONFIG_PSI=3Dy, not default-disabled). */
> > +     mempress_fd =3D open("/proc/pressure/memory", O_RDONLY);
> > +     if (mempress_fd < 0)
> > +             ksft_exit_skip("PSI unavailable (CONFIG_PSI=3Dn or psi=3D=
0)\n");
> > +     close(mempress_fd);
> > +
> > +     if (cg_read_strstr(root, "cgroup.controllers", "memory"))
> > +             ksft_exit_skip("memory controller isn't available\n");
> > +     if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
> > +             if (cg_write(root, "cgroup.subtree_control", "+memory"))
> > +                     ksft_exit_skip("failed to enable memory controlle=
r\n");
>
> The memory controller is unnecessary now, right?
>
>
> Regards,
> Michal
