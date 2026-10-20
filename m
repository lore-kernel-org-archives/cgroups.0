Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792477341;
	b=2w4Z//aoGzB5df58jV1nmTsMFayem20E3wTIhNjSV+XFvsZhwf1UJmmDpI4KQ10IHQJH
	 Bpv+lYKeZ+N65dg7LwbUNEk+Ys+q9Pbk/Ls6lYxW/+22gQiYNr8hsov/F33m6rI0/GXjl
	 SH3mvxbXNgIc7vKEdusPWj4TarW1auBKSY69N6jiJ+QnCS2SN2piyNh2qdPCrwAY0CezC
	 AyPNn1kGFHDCuDUA/3FrLfgaBxZZlGcx2cqYoWTprLc1UyEQjBYsW7N97e8FQSXTyLGUf
	 /AxyetZlX+Qs9tVHXbU570pZcKqlbcQNi8Cz4lbRM10t6ZS4FCShFwZI46DocwOJ/Eg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792477341;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=kf8/+k3Jjj7ru8eZKZwxf7K+ABa74mbZZPeMICUo+Y4=;
	b=H+KrtDvLh43acQ17mJnyvRm/13bht9SdeP9wy/8tq7voFQkOs+iObgLnfWh6rMKxOi7H
	 TPEYkSOwYxU31D+YffLNj60PIeqKUjFIvDd0YSSzCqYNXP4s/Wym4egWj8VAT4wCfvOEF
	 8UmERQwAZuhtADPhAvQRi+lKNGTs8xHjLJRC77LEmxirja/p6Lqt6XOKH8ChZV7TC0Nme
	 smufnnqTlng77Ie1HFfL1yfeCCCuX0JNnvGcl9EI/CAEfLn4AUJu9hzIDTffAoKCUB84V
	 LDm7XzcwjtGWaeAl1UzOcOknnzXrqyruxSvD4cxXEJlZpRZGFeJZgz9MpRBOt2MdpRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lKX2o7+H;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884B4606A31D
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 06:22:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 884B4606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lKX2o7+H
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e98798cbddso11185865ad.0
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 23:22:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792477341; cv=none;
        d=google.com; s=arc-20260327;
        b=NazGaDpDJ0lZlxOWWjTSS5jCEWI3IMD9jZQdhVfqJhMIsBQlEwPrswHTlr/Vta3JT+
         NUNIbEbBYoSty/R5hriy7c4CAGWLI5lRZ1ZwcXRj0VuQe7PC2V01Xm7v421IJfQS492z
         1+l2Z3NHH9IbDZqEXNys5vxaY2xi3t3AMSt3bnvKoymM6a/bEa/GrjVW4bGJPn6qOxuA
         IeTlVRr5QxkfVEexRDIZGKLL2DsquGOkQUkJeuwBhpuJ2ZRVQIOHl1488OH7YB4d0/7C
         ZE0/FL7jeZq3S8CxyYqtNBEwCUcHUSazMM/PfF7Qk9+GfPg7ONaL+nVvYIDaH0dq/xre
         t+2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kf8/+k3Jjj7ru8eZKZwxf7K+ABa74mbZZPeMICUo+Y4=;
        fh=J7lAvmWg220VPleO3xg6E7FIWfSUeibZh6Pgl+b+dJE=;
        b=pScf2jvDC22lmrnyAaARqEx02ebRqcU3KIE8B6iKVMypGSsgqMVqCDLWvIOl5NwE+g
         1aha3I8wVjbqToYZ7KbRspIVaMLQBNM01erCybskRck2fweISI9lqjSi38ong6PeejOD
         VMQy2plaEUvVm487GXVrRmkJcsLkm0YrtqGsPwL/jsAZ8SyQL3iBy86zn0iYedvJbnns
         JoHvwy2/xlmAe6QEOy2gtuIp9o068DOSY7ZGYw4faMI7CyNQVqBuVY5k2IlRSUS/ZvOk
         l5d7EwCBNFt+CKLi0UAauanlDnv+WOt/SSgzIxYAtQ17iT1TlbSteWo+6zuoFxuWDkfY
         DXfQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792477341; x=1793082141; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kf8/+k3Jjj7ru8eZKZwxf7K+ABa74mbZZPeMICUo+Y4=;
        b=lKX2o7+HuD5fpQzZNTLEVq9KL1e8Mg8z16cabHaSJ/2C7LS6z3N6JJwzDTah6U7qBI
         0Lj4Nw1Z6+fnib8fx9+Q7HnXTwIWwK9PuO4Ap4RAkWDiDNOrml42b3GiPpLZ7uqQbsYm
         2CWHNx7TTHt2PQdvvmwyLu6JL14GB2SIAM3kcTBbj7gXgc9FNj5+tctXSfSLVQhuQ8Av
         Wjt1JUWa7uWleeCanSskhVMMuuU0Gpu544YbSCxqAF1tJH5nTQd2lquAcOtWdgTEpbL3
         rWxG3PRAJVitBBMaUDBkGgKW7mWpMCzCIfVJDBTZ/TtIQUwdIa9PTmGbyArlFuSM8Yai
         Zzmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792477341; x=1793082141;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kf8/+k3Jjj7ru8eZKZwxf7K+ABa74mbZZPeMICUo+Y4=;
        b=x7sX75/sO7CSjWAUqXmq0aE3lY3FfibxhxvvAv1EM3UPUXxIR+pzuQ0nmBowl6rmnQ
         atId/yRorBSAwdArn4pDVnnA8s7EvNZuhUOkCBEgZiI7nGX3Gs6UCTM5n47rrQzJFSUf
         6vhz6s8XK++fuWG6toqHFJ50BBLKPcvSL8mAEw8GadNxUtIVAQtjyrDVZFxjMato419A
         UNzzXlShHSHZxFIDJT7YpvNqVyg8xWUt4uRFmEsGvcW1gi5pfnIv+n036bOWmJG5pzF2
         +GfGhHquXvd9vnuxYWjLt/hGJEOEjcdzMr2xrixtUsep6dWUaE275GyjEgUte5p0h7NQ
         k0LA==
X-Forwarded-Encrypted: i=1; AKwUvByYbZQHgYNGHYTB4SRrjDOLq9SNDLBumaXYN78pBSpGB8ob1Yv3NiSkpvDCjB9q7qaLjdbsPn+S@vger.kernel.org
X-Gm-Message-State: AFq9FYI5fqJXT8oSNDL91fNuGOMcArHr7T9+b2hF03mYxjOU08ZQ4Thp
	gc+4HX8fD8Ik54SJo80z4twQxyQhSZ7T7CM3luShVTLYtU3sGp7WF7rYLlCA6RWgerL/MX3Qxwx
	A2LE/eCBjaZvxlgtlo2EWeQ308INwQxA=
X-Gm-Gg: AYBFou2dqpo8G6JXzltx6JTN7FXBg1RVY/Ts3g1Y35r2bZH2aGYOT4VGO3DiCIuUkeb
	YcmBSIatv7S6TRNSQ/ubbrxm/DRxkwGL+ZpvWKgNJBTydLghbPxnS5kr6P7Uxm7qvXpO9FOLbNi
	PzVj+QhXGR8E5huVQvMU4nTIEumjp4WOn2t98icZxaPSVt0yohsOED+cS1z+sjlyF/ixE43+n77
	72B48Wfnxhz5/0+L14om0KY42OMKkEVgSn+4L0xQ/gDUGY10Lar2ttz9minxFR1eN9zbteBJFT5
	8clMjRyeDLJJgmNv12UWhxYnSORAknhRhBJA/rSu48M8TGmkmPN3fKA=
X-Received: by 2002:a17:902:ce81:b0:2e5:334f:f47e with SMTP id
 d9443c01a7336-2e9a69ea07fmr86514295ad.21.1792477340861; Mon, 19 Oct 2026
 23:22:20 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261018-cgroup-kill-exited-leader-v1-0-c71ad94c20cc@gmail.com>
 <20261018-cgroup-kill-exited-leader-v1-1-c71ad94c20cc@gmail.com> <atYTukAn0-7CAXmp@redhat.com>
In-Reply-To: <atYTukAn0-7CAXmp@redhat.com>
From: Kirill Kolyshkin <kolyshkin@gmail.com>
Date: Mon, 19 Oct 2026 23:22:09 -0700
X-Gm-Features: AclHuK9ygSdoDJEA1JRd9ZHGPjt0wCVb9_5HzGSf6_SYCV4LA_12hP3cAjxp2vw
Message-ID: <CAGmPdrypQQnmE1iCTWS46c47P0puRsA0Z4jYnXFFnZ0Um7KJOQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cgroup: fix cgroup.kill for exited thread group leader
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Serge Hallyn <serge@hallyn.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Christian Brauner <brauner@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 5:57=E2=80=AFAM Oleg Nesterov <oleg@redhat.com> wro=
te:
>
> On 10/18, Kir Kolyshkin wrote:
> >
> > cgroup.kill does not work in case a process' thread group leader is gon=
e
> > but other threads are still running. This is because __cgroup_kill()
> > only walks the thread group leaders and sends SIGKILL to each of them
> > with send_sig(), which uses PIDTYPE_PID:
> >
> > 1. The exited leader is still listed by CSS_TASK_ITER_PROCS as long as
> >    the process has live threads, but a signal directed at a single
> >    exiting task never takes effect: complete_signal() does not look for
> >    another thread to deliver it to, and __send_signal_locked() now drop=
s
> >    it altogether.  The process keeps running.
> >
> > 2. The live threads of such a process can be migrated to another cgroup
> >    by writing any of their IDs to cgroup.procs, while the exited leader
> >    stays behind.  The destination cgroup has no thread group leader to
> >    iterate, so writing to its cgroup.kill does nothing at all.
>
> ...
>
> > Case 1 can be fixed by using do_send_sig_info(..., PIDTYPE_TGID) instea=
d
> > of send_sig(), so that the signal is taken by a live thread even if the
> > task found by the iterator is exiting. Note it was pointed out by Eric
> > in [1] while reviewing v2 of cgroup.kill patchset, and v3 was meant to
> > switch to it, but the change was only made in cgroup_post_fork(),
> > leaving __cgroup_kill() with send_sig().
> >
> > Case 2 can only be fixed by iterating over all threads, so this is what
> > the fix also does. Once a thread group is being killed, its other
> > threads are skipped since they already have a fatal signal pending.
>
> ...
>
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -4289,7 +4289,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
> >       cgrp->kill_seq++;
> >       spin_unlock_irq(&css_set_lock);
> >
> > -     css_task_iter_start(&cgrp->self, CSS_TASK_ITER_PROCS | CSS_TASK_I=
TER_THREADED, &it);
> > +     css_task_iter_start(&cgrp->self, CSS_TASK_ITER_THREADED, &it);
>
> I guess this change alone is enough to fix both problems?

Correct; my initial version only had this change, and it fixes
both issues.

>
> But even if I am right,
>
> > @@ -4299,7 +4299,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
> >               if (__fatal_signal_pending(task))
> >                       continue;
> >
> > -             send_sig(SIGKILL, task, 0);
> > +             do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, task, PIDTYPE_=
TGID);
>
> I agree that do_send_sig_info(PIDTYPE_TGID) makes more sense.

Indeed, I added it for "making sense" (rather than for fixing the
issue) after reading through the initial cgroup.kill patchset reviews.
Eric flagged both places in v2, but only one was fixed in v3.

>
> Acked-by: Oleg Nesterov <oleg@redhat.com>
>
>
> Either way, I am not sure about SEND_SIG_NOINFO. Perhaps __cgroup_kill()
> should use SEND_SIG_PRIV? I dunno.
>
> Oleg.
>
