Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4032E49BD95
	for <cgroups@vger.kernel.org>; Mon, 14 Sep 2026 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789409316; cv=pass; b=ZsN5d8inksAtl4vUNkJpPLSP8qHBOTjkHaiaXNsQ6SkS1hVyOQ4fHaZPf/F7rzVv0Z641VQl7x6+WqPDTFuVAnCkjHq4Jko6PG3pVA9/FR8VcmG9tIy6QcYGsHACdr6SFyDPXpRlaI8Lk9tQXH3xFqLCpgYP87aMwLfbjD8A4dU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789409316; c=relaxed/simple;
	bh=nrL7HxkxpCYK37KcSgRy3IUkJkgNJYps77Sf88qk4eo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IAwKlV5Lj7ShEqdW+rl1NW3Yp5j0a6xlcwOllzc97uYEakS48BhlKKYdajvfHeuPEged6VxC5WnMtl1xWMujSjqVV9WwGQASAKuL72NBC6N4Nt1Kg0An+9iFuN1oh2eS34RDgt5aYqPWfcdYfkh8qe/dwp51lCPnS+Jm9JlcK+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nthWdiIT; arc=pass smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nthWdiIT"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a2ff176d5eso21585651fa.0
        for <cgroups@vger.kernel.org>; Mon, 14 Sep 2026 11:08:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789409300; cv=none;
        d=google.com; s=arc-20260327;
        b=TQHg2XDzpPbH3cXOvc4MyG3lx7ZOWHo7Rtzv0aGMkfEzvs5AN2t6Gy36iiPTN56w9v
         9HpmL3IzQro68VI+Vv+gtcvFr0h1qXYPWg4kHjE20HtNNs2w99W0j2o/xsG7rgGPCcmh
         gLiRTfkGAIMeg7h50iH/gRYF1tewu9okeHMR0/Hen5xFfe5bHMQbu99LtMYWzicPzoxb
         hLAUXMUdTB7/dsxjVdBqrtrfR1A7c5sZssEMX6oWSv+HMATHJMMQrfKIOL7bdE9uNU+R
         4aXFl40U5PFQOs+c49NoSPwKVVeVcdr59u1+8pmX6PpsDhTvIUfpfP+tZR1J4ciBNQZr
         otAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YqfeFaksCtRDL645H6Ma8BX+7yBDF05G4zL3//smvsI=;
        fh=KVTGyWub4Almxv8k1Ep/xi6UjIv49BvV3BHiV/jWnGs=;
        b=QXklL8j9BpKZn7AcpOjB/AKnxtmfLEMI4mKROcQhy/TbkKOnarQVO6lkA0XWAa5zm0
         whO94awelyoNmMWxZecZwEwqGICGdsSzxR+t01BTrBxHJ++6FkQje1mO8X4bCh6rljna
         Sdxz02l2mXvdzjHuo0qCcs9G+TOGMnsFbPyIBgU4yRuX3d9yotdXT6Mi20l4vFHR032Z
         p0kUotb8MCtt/+rrNlFzjutTxOOZMZS6yt3oe+EtV7e4OOhsxUkkz1jHBgTDbz25bewT
         etKniA9SexFBdCg3cbyAov97d/shHo9aRFhX3oLvGo6cHLcnmfdImPVnhPPAXtLhtkfZ
         5Jcw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789409300; x=1790014100; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YqfeFaksCtRDL645H6Ma8BX+7yBDF05G4zL3//smvsI=;
        b=nthWdiIT1dqdQPptON5i6UB8AYh32ISOiDmwdttRHgnKK3TyZN7elsFCPNU4D8D+k1
         qTuRx2iNbqlTLm2GrkuCYePCIpamewXWUv8bTr5o2y0f5Xc7ZIOeGauYVGYdnJLUmSB4
         Bt9ipvvAZCGC3v8w79Wj4R9qUZSa6AqrBFoAe00K/7j6XFR5Ya4zpGfiknj8zGWc/afo
         q8IGBmYPAPtfQ8NxCe4u3VF/sqgdnZvV0bN8welvGOf22JqWji3perwKCIQ2bRaIqlQ+
         Kp2muJ1t8BxJnFSZQaIk48NoDFee/ypD189gKhA+/YIiSdVWpx+Mvg9Btli2s3DBti8t
         0ddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789409300; x=1790014100;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YqfeFaksCtRDL645H6Ma8BX+7yBDF05G4zL3//smvsI=;
        b=I/2dFXopT+bLIudSbwR64kMnYlGUurOKeF/eH0oIHkmDe9GZ198zr1FpZSCjZ9o0mC
         gJaY6DmoZvmWZTDNnCsmu8Pje9SwCX9XpO34iWH3JqWICrSjpJwdrBM5d4OFvqOB2iAK
         NffTqu7VQ0hbmk/KIu6PPHpAKs1ToWn8RYPUCNfEVR0w5mWeDE8zivYh+w82RtaHE24U
         to6nYRDzwTaTnwSQLE9DZF8AA/zbO49iBsUYzIYUtDsRpAuHLMEiXfmMVsRV/UWHy08P
         3WQhcQWR02eyim/lzoVzYbMoukg/mSUVpG7Gqv1/cTdytCdkdb6jh+mD3h/BO0TWh6ks
         guuA==
X-Forwarded-Encrypted: i=1; AKwUvByuWjGadld5dzJjyD520nmJ4aI7Ka52LibvuTw2LkqCVlTcgIng6v8YCfl5tPrPIkQUFeSmXh/a@vger.kernel.org
X-Gm-Message-State: AFuF++lq1iQNGBO/dhEHH6Jp+Pi3iXTcyBDsQsqpc9gyaAbHqGV9ZiRN
	Df2IQUlri2OC+Fw/I7+ODddyDNwPg/Oor5WuZXQ2MbCLEQDXmXKUj8HK5HXJhfCLiFne6r5d09E
	meX3PImiy4JAjMhPLS0E8Hajm6XpeMOYoLZlt
X-Gm-Gg: AYBFou2ZUcKOjkq4Kd85UXql1xRBHjOHn+zkiWXfWw4QPrvCn1XOEwindnbJrIOnoar
	654cFslEZUAEMkVQrrXFGH902G0/91mm4rVrnzhhtldXd8n9nRSVo1vOKYRNAOMBOtW7zUJwLar
	xvCRcZKCrFKyviD2DD6stHonzQbq9itfpM0aIcixQEBw/gWWEbBzO3wWMbSFHi9fHpVDnvHznGx
	ZJyYF73MHhQcru0VHdOrNSClUwo8/waZ7eaW3ObrXIPMonZMteXEXGJ2Q5apz4ZdrX8hsXN9pjE
	kWG2wUiNmftoLuy82cDgSGEpTKg49nw8GmEhohJzrYzbbibylxe5SUz6oUhbLkzk/rD8qCd0EZV
	KEIN7hT3VqPM5SQ==
X-Received: by 2002:a2e:8a86:0:b0:3a1:4f33:f60e with SMTP id
 38308e7fff4ca-3a5c8904fa7mr13824431fa.8.1789409299251; Mon, 14 Sep 2026
 11:08:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANGjgdn=H50AaA-+O_GA-hkE9UwLANmkjx1zRsKUzxF5za8VfQ@mail.gmail.com>
 <aqa7KgIJYGgf7INk@slm.duckdns.org> <CANGjgd=f9n7zEZS=xi71y_dY6Uk75_qgP9qVDkYBusNz9sp2sg@mail.gmail.com>
 <CABdmKX2Oer9wrxWdR8s48Czro8H51HY+S_mfnUj-RvhjCM1RgA@mail.gmail.com>
In-Reply-To: <CABdmKX2Oer9wrxWdR8s48Czro8H51HY+S_mfnUj-RvhjCM1RgA@mail.gmail.com>
From: Chengfeng Lin <lin2530632123@gmail.com>
Date: Tue, 15 Sep 2026 02:08:06 +0800
X-Gm-Features: AcwNN1VjX10xVedHjffuUUEznl-luy-airmCt-rJgo7haX1ZQMrAAmn74RSRo6w
Message-ID: <CANGjgdmKg1_QyzhCSh03T4RStw5_znnhqmFFS8TVwQbm-sZZbA@mail.gmail.com>
Subject: Re: [REGRESSION] kernfs: empty cgroup rmdir latency after
 delete-notification changes
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Kara <jack@suse.cz>, 
	driver-core@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi T.J.,

Thanks for the patch. Your changes reduced rmdir() latency by
21.87-22.86% in the same empty-cgroup benchmark, with sched_ext disabled.

I tested these two states on 2f0c1cf72f46 (7.3-rc2):

  A: baseline + Shakeel's file-handle decoding read-lock fix [1]
  B: A + your INODE_INITED changes, without modifying your code

I used the original binary on the bare-metal i7-12700KF, pinned to CPU0,
with full preemption, the performance governor and Turbo disabled.
Both kernels used GCC 15.2 and the same config except LOCALVERSION.

The clean timing sequence used four fresh boots: A1 -> B1 -> B2 -> A2.

                     A1       B1       B2       A2
  rmdir (us)        9.727    7.600    7.548    9.784

Each value is the median of nine sample means. Each sample contains
128 measured removals after 16 warmups. All four B/A comparisons showed
the improvement above. Removal CVs were below 2.03%. The drift between
boots was +0.59% for A and -0.68% for B. The improvement held after
dropping the first sample from each boot.

Separate, untimed traces showed the same 26 kernfs nodes per removal,
but ilookup() calls fell from 26 to 1. Deletion lock counts were unchanged.
Basic checks of file/directory deletion notifications and link counts
with FDs held open passed on both kernels.

I also timed the full mkdir() -> stat() -> rmdir() sequence using a
separate binary on the same kernels. The latest continuous follow-up used
four fresh boots, with nine samples per boot. Each sample had 16 warmups
and 32 measured sequences, with no pauses between them. The full sequence
fell from 30.07-30.65 us to 27.97-28.34 us, a 5.77-8.76% reduction.
The maximum CV was 1.76%, and boot drift stayed below 2% in both states.
In the earlier continuous follow-up with 128 operations per sample, the
full sequence was 5.15-6.52% shorter, but CVs of 4.52-6.46% were too high
to establish a stable overall improvement percentage.

Untimed tracing placed the added write lock in first stat(), during inode
initialization. The patch skips lookups for nodes whose inodes were never
initialized; it does not move those lookups into stat(). The individual
mkdir() and stat() timings remained too variable to quantify their changes.

I also checked whether the benefit persisted with less frequent operations.
For this diagnostic, I added 50 and 200 ms pauses between sequences,
outside the timers. I kept 16 warmups and 32 measured sequences per sample.
rmdir() still saved 2.10-2.58 us, but its baseline rose from about 10 us
to 18 us, reducing the percentage gain. The full sequence was 0.66-2.85%
shorter, with a maximum CV of 1.53%.

I included [1] because the file-handle path on this base lacks
kernfs_rwsem protection. Source review suggests a possible wait cycle
when that path recreates an evicted inode. Initialization waits for
kernfs_iattr_rwsem, while removal holds it and waits for I_NEW to clear.
I have not reproduced this possible deadlock in the kernel.
Does the base for your diff already include [1] or equivalent locking?

[1] [PATCH v2 3/4] kernfs: don't lose IN_DELETE_SELF
    when decoding a file handle
https://lists.openwall.net/linux-kernel/2026/09/05/828

Results and reproducers:
https://github.com/lcf0399/linux-regression-evidence/tree/f101b1b9c0d3dfce0=
7f81b11ca2da2c252150e4c/kernfs-empty-cgroup-removal/bare-metal/inode-inited

Thanks,
Chengfeng

T.J. Mercier <tjmercier@google.com> =E4=BA=8E2026=E5=B9=B49=E6=9C=8814=E6=
=97=A5=E5=91=A8=E4=B8=80 00:17=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, Sep 13, 2026 at 8:47=E2=80=AFAM Chengfeng Lin <lin2530632123@gmai=
l.com> wrote:
> >
> > Hi Tejun,
> >
> > Thanks. I found this during research into kernel performance regression=
s,
> > using a microbenchmark of cgroup creation and removal. This was not
> > prompted by a production issue.
> >
> > I reported it to document the added removal cost and ask whether some
> > of it could be reduced while preserving the fixes. I agree that the
> > roughly 3 us increase per removal does not, by itself, demonstrate a
> > significant impact on real workloads.
> >
> > Thanks,
> > Chengfeng
> >
> > Tejun Heo <tj@kernel.org> =E4=BA=8E2026=E5=B9=B49=E6=9C=8813=E6=97=A5=
=E5=91=A8=E6=97=A5 23:03=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Hello,
> > >
> > > On Sun, Sep 13, 2026 at 10:43:04PM +0800, Chengfeng Lin wrote:
> > > > I found an increase in empty cgroup removal latency across 507d8ce1=
3f5b
> > > > ("kernfs: Don't set_nlink for directories being removed") and eea5d=
2bb34ba
> > > > ("kernfs: Send IN_DELETE_SELF and IN_IGNORED"). With sched_ext disa=
bled,
> > > > rmdir() went from about 6.5 us to 9.6 us, an increase of 46-47%.
> > > > The result held in two independent runs.
> > >
> > > I don't want to make cgroup removal unnecessarily expensive but at th=
e same
> > > time it's not an operation that I consider to be a hot path, so as lo=
ng as
> > > the operaiton can finish in a reasonable amount of time and single di=
git us
> > > definitely is, performance of rmdir usually isn't something which is =
high in
> > > priority. Can you please detail why this matters for you?
> > >
> > > Thanks.
> > >
> > > --
> > > tejun
>
> Hi Chengfeng and Tejun,
>
> We use this kernfs IN_DELETE_SELF feature on Android where multiple
> cgroups are created and removed frequently on a per-application basis,
> but we hadn't noticed a significant delay due to the inotify
> functionality during cgroup removal. It's probably masked by much
> larger delays (milliseconds) we regularly see due to unreleated issues
> with cgroup locks like priority inversion with cgroup_mutex, and
> contention for cgroup_threadgroup_rwsem.
>
> As far as what we can do, I think avoiding inode lookups for kernfs
> nodes that never had an inode created should improve the situation. It
> doesn't eliminate the locking overhead, which I don't think can easily
> be eliminated. The code below doesn't deal with inode eviction either,
> but at least files which are never accessed won't introduce the inode
> lookup overhead.
>
> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> index 4f9ade82b08a..3ec9f79b1aa2 100644
> --- a/fs/kernfs/dir.c
> +++ b/fs/kernfs/dir.c
> @@ -1523,6 +1523,9 @@ static void kernfs_clear_inode_nlink(struct
> kernfs_node *kn)
>         struct kernfs_root *root =3D kernfs_root(kn);
>         struct kernfs_super_info *info;
>
> +       if (!(kn->flags & KERNFS_INODE_INITED))
> +               return;
> +
>         lockdep_assert_held_read(&root->kernfs_supers_rwsem);
>
>         list_for_each_entry(info, &root->supers, node) {
> diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
> index 38b28aa7cd02..f8b4a8b8ade4 100644
> --- a/fs/kernfs/inode.c
> +++ b/fs/kernfs/inode.c
> @@ -208,6 +208,10 @@ static void kernfs_init_inode(struct kernfs_node
> *kn, struct inode *inode)
>         set_default_inode_attr(inode, kn->mode);
>         kernfs_refresh_inode(kn, inode);
>
> +       down_write(&kernfs_root(kn)->kernfs_iattr_rwsem);
> +       kn->flags |=3D KERNFS_INODE_INITED;
> +       up_write(&kernfs_root(kn)->kernfs_iattr_rwsem);
> +
>         /* initialize inode according to type */
>         switch (kernfs_type(kn)) {
>         case KERNFS_DIR:
> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index e21b2f7f4159..87f074ce19d3 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -113,6 +113,7 @@ enum kernfs_node_flag {
>         KERNFS_EMPTY_DIR        =3D 0x1000,
>         KERNFS_HAS_RELEASE      =3D 0x2000,
>         KERNFS_REMOVING         =3D 0x4000,
> +       KERNFS_INODE_INITED     =3D 0x8000,
>  };
>
> -T.J.
