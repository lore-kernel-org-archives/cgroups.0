Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C882C3D75B5
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 22:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789509714; cv=pass; b=oEib/1tbej/+RGjYqGiFAslbxkaUiGPPfmx9x5Sl9HrOxgYh2eR7QUvG43ewxMXR9M/8K8YPFEIX/BGOX15NCttoduX38lCK7X/1i8xarLHK+SmicJwfMrvClI0rBSWgHcIv3YvTTQQNJPD8JoOqeXh99507O+Xbnp/xzKh5ofU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789509714; c=relaxed/simple;
	bh=2bFHoxerUuuTMPiNSVaba8huLGLUhURz8QymLN/E2BA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cARE/OnGKb6HUgDIl68mCexswRa+135DDoIDRKtOvOj9Fyts3rL7OEVO3BmEQslCFg2TIGNEwqMVrNTuTf1rtX652KznCFemP1hzaGl1lfJCbE9iJl55/PM8WmP0iV6yqcqPEYFRLNJdHpZZPxCA4BhXiVBzKdb+xda+IT9ng9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wlo5F0Wd; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wlo5F0Wd"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cff3b3b92so6235e9.1
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 15:01:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789509711; cv=none;
        d=google.com; s=arc-20260327;
        b=R4fLQYeexjOGWurc8eXnW1PA2hy7r/UeZ87P66Rrcp+s2L8iwxsCQ4MdIj6+QK+hpr
         Xo74BhEAxy+LlGNglIdkjW+HeDEdCPvRI6HqM/B+MAprQ+Q0Y2zgV8fNJknJnAE2Datp
         JL3UYqu+jtHVS86QGlrWYSwTNmlEG/JEm5mvv71oVQtqporht+xUtSB2xxrAXCZBQSe4
         pCvgXgH9mw+F3AebImgsuXTw6nvSOUx40Zvl0SG38X3KLvj1CzMWUPulNDW/5NkoMi5X
         n45kBoh9lGDzfJTa8knCeCeFBaR7OO/7+fC1BGiaC+yFPrxeoMLtXfxxDisyNo4NIrlA
         GhXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D3QLcS+REcTWvfYukjwwXF89kB5VlKY7f569FzTw3Sg=;
        fh=CKVNOljTjr5mjXxGajRpSxWZNuSwkS6J7rdrrtoPOYE=;
        b=a3q+6AhIAwkojmsORvTHpRSKIue/TaJKkkyw6UEJejGtNDCqY6WBtSe1A26i0uHtmE
         2s5pYem9l8kb6qVcF1rWBxyF3tR4gVMs8dzfqm89zMzwfQtZyrVxxjGwwpA5FzsoQ2mf
         DC7Zyo7ntU2tx9j/hOsa2yhta9jFdbQabRXSE4tIz5vbxaKc3tZyTLlL0NDVPE8UcC6C
         wHOoH3fkGLnXrEzuklhrjtlngpgpBtulbKRUPOeJAXw1xH1PPVf3xsg6yRDug5V/nDNC
         m6pJ4kuA8Jz8F/JaFlGzNBT5t4lagYUrfLfPXS1ImWTUP5s/VEk2X8i6Q76bU/A7U+mY
         FYyA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789509711; x=1790114511; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D3QLcS+REcTWvfYukjwwXF89kB5VlKY7f569FzTw3Sg=;
        b=Wlo5F0Wd1vYS+3y87+zGzNmQYLWA1PR5ej5tcZ4nfNJage0ENF2wVOiHR1YdkAsqNe
         NZ4lK8WPH/BWWplXuT5N0IZ00j4xurqESUcuXk5iSN5BgEYldlHzaCUqDTzYmveH4vuS
         BUzLHVaJN9kRcsEoGqLKzdxKkVCUgD4DHAVMTB4+1HUj2eT2mDcMPvwIITLo85yXbGtM
         UvxWxt4ggdqLvwpqweVv1Z6DsIwckBraO2Tyxkuygr76PGWNje2/9MqdzsUNTCYn2TN/
         ZRfGkFgqfWk3gaaKHvaagFGekfZ5z69vlKyMN1vi5Vn6VX1gcFQ+aMGgbcaX25I9rF5d
         FABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789509711; x=1790114511;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D3QLcS+REcTWvfYukjwwXF89kB5VlKY7f569FzTw3Sg=;
        b=OiOUJvpIhltY1PxXUCZZLIYNzlu2EMivLzgTnGaEzp66NSBqiFCCxVsVLCGCCy8bgH
         2SNu75cJ/1R0UG1QVMvH3gzSPFpM6XJGwGnpnagber6rNlyjOrwEQwmnDtR+2ZmevXgn
         CWfmP+YcTNhPU2oYcBy/m1ziaMfRcuQ4PUN8gv9nhKKd/H+NVE+0Loe5gTidlFkVRxWm
         l5DBN2L25s1pdPTBZAsf1NzKbv+o5l0MPJdtK39+A0WJ/gz+PcHJ9HFx7W9P2p7Bm3Gy
         //8eKhtxu5eC/g15A/nt92WpUpcDw9caBwbJc0dpk+uiEIJ69IOiDvbZDR95YnExm3/N
         GraA==
X-Forwarded-Encrypted: i=1; AKwUvByIA1XOMhR15FP+EC9L8O0e0qGafXIwN0cMpt7OjZpcOnxShAoV2bD2FQTZzWuyOCgNDdk9HFcg@vger.kernel.org
X-Gm-Message-State: AFuF++mXX+BLbp2/1RzXBRE1R2vNaUvDPNcFJUNnvADtdCslkjYIry88
	EVyhCuMXG60IplD9wt9EJKb3kZgLLgc1NFKT1pIyxecpsM5hLF+M9/Xi8trd/kG1oOth3bS0HSi
	PHUtMQkpu0DHb0c/dSvepkMLAuBPnxY288HtTPg7I
X-Gm-Gg: AYBFou2L+YzDo5499Eyz7RCZunpAY+dTQX9t1RI0AGlVO/nKYMDf6r9sGX1Ih9XuNJT
	10GG635sybcGAan4LpJcXYTMK7+YLnWpJmwvLZ/zjY3W5o1eTsaqS86mCHFbMiIlynf52WZpa1+
	fdb+tQ7ahtE3naaSmTIhJShdlfd0LDXLpQEpx/dFXWvBW8wYScg/BwU9UC+Ez1zA+Rl/G1ID3SO
	d9DGALfHA8C95mFGcf+eczWT6M51bwITFUUfmsaoRyiPDj3AFyxDVuPQuDFKRgBX+xuM9amoriG
	bRrkdIy7I2I4AF83C6O6ZxTFrra85APk/a6Ku2MwzgYXGRdMxVwGizgQczY/tPllRjJ8AP/akJy
	uTcrEyTlbnZ8nD3tVL/tmUn9oINklbjWIwHuK4GtrOg==
X-Received: by 2002:a05:600c:2943:b0:49e:b733:7277 with SMTP id
 5b1f17b1804b1-49eb73372f9mr1535e9.2.1789509710403; Tue, 15 Sep 2026 15:01:50
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANGjgdn=H50AaA-+O_GA-hkE9UwLANmkjx1zRsKUzxF5za8VfQ@mail.gmail.com>
 <aqa7KgIJYGgf7INk@slm.duckdns.org> <CANGjgd=f9n7zEZS=xi71y_dY6Uk75_qgP9qVDkYBusNz9sp2sg@mail.gmail.com>
 <CABdmKX2Oer9wrxWdR8s48Czro8H51HY+S_mfnUj-RvhjCM1RgA@mail.gmail.com> <CANGjgdmKg1_QyzhCSh03T4RStw5_znnhqmFFS8TVwQbm-sZZbA@mail.gmail.com>
In-Reply-To: <CANGjgdmKg1_QyzhCSh03T4RStw5_znnhqmFFS8TVwQbm-sZZbA@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 15 Sep 2026 15:01:38 -0700
X-Gm-Features: AcwNN1VIb8TTEgPexXQPpWCvVpRTIrvOssLFmKmDhlzeafbGOiUocgUp_QNXLZU
Message-ID: <CABdmKX3g7+GTfSBKB42Tr2CDusCNXb5+oPc7TcC1RpVndUzVpw@mail.gmail.com>
Subject: Re: [REGRESSION] kernfs: empty cgroup rmdir latency after
 delete-notification changes
To: Chengfeng Lin <lin2530632123@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Kara <jack@suse.cz>, 
	driver-core@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 11:08=E2=80=AFAM Chengfeng Lin <lin2530632123@gmail=
.com> wrote:
>
> Hi T.J.,
>
> Thanks for the patch. Your changes reduced rmdir() latency by
> 21.87-22.86% in the same empty-cgroup benchmark, with sched_ext disabled.
>
> I tested these two states on 2f0c1cf72f46 (7.3-rc2):
>
>   A: baseline + Shakeel's file-handle decoding read-lock fix [1]
>   B: A + your INODE_INITED changes, without modifying your code
>
> I used the original binary on the bare-metal i7-12700KF, pinned to CPU0,
> with full preemption, the performance governor and Turbo disabled.
> Both kernels used GCC 15.2 and the same config except LOCALVERSION.
>
> The clean timing sequence used four fresh boots: A1 -> B1 -> B2 -> A2.
>
>                      A1       B1       B2       A2
>   rmdir (us)        9.727    7.600    7.548    9.784
>
> Each value is the median of nine sample means. Each sample contains
> 128 measured removals after 16 warmups. All four B/A comparisons showed
> the improvement above. Removal CVs were below 2.03%. The drift between
> boots was +0.59% for A and -0.68% for B. The improvement held after
> dropping the first sample from each boot.
>
> Separate, untimed traces showed the same 26 kernfs nodes per removal,
> but ilookup() calls fell from 26 to 1. Deletion lock counts were unchange=
d.
> Basic checks of file/directory deletion notifications and link counts
> with FDs held open passed on both kernels.
>
> I also timed the full mkdir() -> stat() -> rmdir() sequence using a
> separate binary on the same kernels. The latest continuous follow-up used
> four fresh boots, with nine samples per boot. Each sample had 16 warmups
> and 32 measured sequences, with no pauses between them. The full sequence
> fell from 30.07-30.65 us to 27.97-28.34 us, a 5.77-8.76% reduction.
> The maximum CV was 1.76%, and boot drift stayed below 2% in both states.
> In the earlier continuous follow-up with 128 operations per sample, the
> full sequence was 5.15-6.52% shorter, but CVs of 4.52-6.46% were too high
> to establish a stable overall improvement percentage.
>
> Untimed tracing placed the added write lock in first stat(), during inode
> initialization. The patch skips lookups for nodes whose inodes were never
> initialized; it does not move those lookups into stat(). The individual
> mkdir() and stat() timings remained too variable to quantify their change=
s.
>
> I also checked whether the benefit persisted with less frequent operation=
s.
> For this diagnostic, I added 50 and 200 ms pauses between sequences,
> outside the timers. I kept 16 warmups and 32 measured sequences per sampl=
e.
> rmdir() still saved 2.10-2.58 us, but its baseline rose from about 10 us
> to 18 us, reducing the percentage gain. The full sequence was 0.66-2.85%
> shorter, with a maximum CV of 1.53%.
>
> I included [1] because the file-handle path on this base lacks
> kernfs_rwsem protection. Source review suggests a possible wait cycle
> when that path recreates an evicted inode. Initialization waits for
> kernfs_iattr_rwsem, while removal holds it and waits for I_NEW to clear.
> I have not reproduced this possible deadlock in the kernel.
> Does the base for your diff already include [1] or equivalent locking?
>
> [1] [PATCH v2 3/4] kernfs: don't lose IN_DELETE_SELF
>     when decoding a file handle
> https://lists.openwall.net/linux-kernel/2026/09/05/828
>
> Results and reproducers:
> https://github.com/lcf0399/linux-regression-evidence/tree/f101b1b9c0d3dfc=
e07f81b11ca2da2c252150e4c/kernfs-empty-cgroup-removal/bare-metal/inode-init=
ed
>
> Thanks,
> Chengfeng

Thanks for testing. I was also not aware of Shakeel's fix [1] so it
was not in my base; I used 2d3090a8aeb5 ("Merge tag 'v7.1-p5' of
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6").

I think you are correct about the deadlock. The synchronization
requirements here are more difficult than I initially realized.
kernfs_iattr_rwsem can't be used because of the deadlock you
mentioned. Additionally, kn->flags is non-atomic and only modified
under down_write(&root->kernfs_rwsem). Inode allocation runs under a
read lock (or locklessly before Shakeel's fix), so setting a flag
there races with writers and risks lost updates on other flags.
Grabbing a write lock in kernfs_init_inode() would add contention to
normal lookup and stat paths. So I'm not seeing a simple way forward
with the KERNFS_INODE_INITED idea.

This is a more straightforward but even less exact way:

@@ -1526,8 +1527,12 @@ static void kernfs_clear_inode_nlink(struct
kernfs_node *kn)
        lockdep_assert_held_read(&root->kernfs_supers_rwsem);

        list_for_each_entry(info, &root->supers, node) {
-               struct inode *inode =3D ilookup(info->sb, kernfs_ino(kn));
+               struct inode *inode;

+               if (!fsnotify_sb_has_watchers(info->sb))
+                       continue;
+
+               inode =3D ilookup(info->sb, kernfs_ino(kn));

I'm not sure that's really worth a few microseconds though.

> T.J. Mercier <tjmercier@google.com> =E4=BA=8E2026=E5=B9=B49=E6=9C=8814=E6=
=97=A5=E5=91=A8=E4=B8=80 00:17=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Sun, Sep 13, 2026 at 8:47=E2=80=AFAM Chengfeng Lin <lin2530632123@gm=
ail.com> wrote:
> > >
> > > Hi Tejun,
> > >
> > > Thanks. I found this during research into kernel performance regressi=
ons,
> > > using a microbenchmark of cgroup creation and removal. This was not
> > > prompted by a production issue.
> > >
> > > I reported it to document the added removal cost and ask whether some
> > > of it could be reduced while preserving the fixes. I agree that the
> > > roughly 3 us increase per removal does not, by itself, demonstrate a
> > > significant impact on real workloads.
> > >
> > > Thanks,
> > > Chengfeng
> > >
> > > Tejun Heo <tj@kernel.org> =E4=BA=8E2026=E5=B9=B49=E6=9C=8813=E6=97=A5=
=E5=91=A8=E6=97=A5 23:03=E5=86=99=E9=81=93=EF=BC=9A
> > > >
> > > > Hello,
> > > >
> > > > On Sun, Sep 13, 2026 at 10:43:04PM +0800, Chengfeng Lin wrote:
> > > > > I found an increase in empty cgroup removal latency across 507d8c=
e13f5b
> > > > > ("kernfs: Don't set_nlink for directories being removed") and eea=
5d2bb34ba
> > > > > ("kernfs: Send IN_DELETE_SELF and IN_IGNORED"). With sched_ext di=
sabled,
> > > > > rmdir() went from about 6.5 us to 9.6 us, an increase of 46-47%.
> > > > > The result held in two independent runs.
> > > >
> > > > I don't want to make cgroup removal unnecessarily expensive but at =
the same
> > > > time it's not an operation that I consider to be a hot path, so as =
long as
> > > > the operaiton can finish in a reasonable amount of time and single =
digit us
> > > > definitely is, performance of rmdir usually isn't something which i=
s high in
> > > > priority. Can you please detail why this matters for you?
> > > >
> > > > Thanks.
> > > >
> > > > --
> > > > tejun
> >
> > Hi Chengfeng and Tejun,
> >
> > We use this kernfs IN_DELETE_SELF feature on Android where multiple
> > cgroups are created and removed frequently on a per-application basis,
> > but we hadn't noticed a significant delay due to the inotify
> > functionality during cgroup removal. It's probably masked by much
> > larger delays (milliseconds) we regularly see due to unreleated issues
> > with cgroup locks like priority inversion with cgroup_mutex, and
> > contention for cgroup_threadgroup_rwsem.
> >
> > As far as what we can do, I think avoiding inode lookups for kernfs
> > nodes that never had an inode created should improve the situation. It
> > doesn't eliminate the locking overhead, which I don't think can easily
> > be eliminated. The code below doesn't deal with inode eviction either,
> > but at least files which are never accessed won't introduce the inode
> > lookup overhead.
> >
> > diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> > index 4f9ade82b08a..3ec9f79b1aa2 100644
> > --- a/fs/kernfs/dir.c
> > +++ b/fs/kernfs/dir.c
> > @@ -1523,6 +1523,9 @@ static void kernfs_clear_inode_nlink(struct
> > kernfs_node *kn)
> >         struct kernfs_root *root =3D kernfs_root(kn);
> >         struct kernfs_super_info *info;
> >
> > +       if (!(kn->flags & KERNFS_INODE_INITED))
> > +               return;
> > +
> >         lockdep_assert_held_read(&root->kernfs_supers_rwsem);
> >
> >         list_for_each_entry(info, &root->supers, node) {
> > diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
> > index 38b28aa7cd02..f8b4a8b8ade4 100644
> > --- a/fs/kernfs/inode.c
> > +++ b/fs/kernfs/inode.c
> > @@ -208,6 +208,10 @@ static void kernfs_init_inode(struct kernfs_node
> > *kn, struct inode *inode)
> >         set_default_inode_attr(inode, kn->mode);
> >         kernfs_refresh_inode(kn, inode);
> >
> > +       down_write(&kernfs_root(kn)->kernfs_iattr_rwsem);
> > +       kn->flags |=3D KERNFS_INODE_INITED;
> > +       up_write(&kernfs_root(kn)->kernfs_iattr_rwsem);
> > +
> >         /* initialize inode according to type */
> >         switch (kernfs_type(kn)) {
> >         case KERNFS_DIR:
> > diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> > index e21b2f7f4159..87f074ce19d3 100644
> > --- a/include/linux/kernfs.h
> > +++ b/include/linux/kernfs.h
> > @@ -113,6 +113,7 @@ enum kernfs_node_flag {
> >         KERNFS_EMPTY_DIR        =3D 0x1000,
> >         KERNFS_HAS_RELEASE      =3D 0x2000,
> >         KERNFS_REMOVING         =3D 0x4000,
> > +       KERNFS_INODE_INITED     =3D 0x8000,
> >  };
> >
> > -T.J.
