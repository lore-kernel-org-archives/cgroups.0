Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B5C36167B
	for <cgroups@vger.kernel.org>; Sun, 13 Sep 2026 16:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789316279; cv=pass; b=NhukvLJ9DRKoG7gUQuOo5EYMnXJTDhojmTP9oqUgPGHoOBtxJ5n300KJLl7Bm1ZiYMm3ZOLp/h/ESG4Rx6KtHxLVWxl6xQBUah7wHL9tX7S7gdneoQJi4fXvYcjPrdnshqJmeKSZ5PdILBriTc3svoz4W37GfdNiYo3XhvqCjRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789316279; c=relaxed/simple;
	bh=qrjaa3A/zSN3z/kTwF5pNuuhb8WEmUsn7IuE9lN2/WE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DnK2rV6vZxvis5jsjb2oJCh0kVs4fwmc/M3Wwk/0//xmUr5m/+hJu0uILZjmVEQeo4DXuCIDbBBXiQ6DHYkQfhqUvi+CnnGT2yvYFFmCq4/dUuqjhF2ZUOUIOPvooT5o5CKLMokjB4pUbauSLlddH8Fdp2q4CW7WHMzGRtF6lEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tCVPXk/H; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tCVPXk/H"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccf3bc34cso38045e9.0
        for <cgroups@vger.kernel.org>; Sun, 13 Sep 2026 09:17:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789316273; cv=none;
        d=google.com; s=arc-20260327;
        b=baT0XE60ofawz/oJr49GTsuc7HlFs8Rsx9dkAtKQ/Ek80VI6xM+DbtPFm5F+rjoP4D
         YcHUufKQvQC9aIJCSKqeP0CilCnJ35p2ouD0S+KQSVqWajLrfv0OyXRSyLy3yKCBysvP
         eFl7G5GtKuoCJHE+s9qA5RNJLmqxNnffcz5IQTJHnWP/vEi9uqWUu9nXwznIzH4mcPyV
         M9VTM44A0M50OYffXTquLYOqWCyFX9I2/nAtKgqJfSUKM1+uWCtOWufb+rFHa1gJXhtH
         ZczX+jAgIJ/gO9iVQ8VhjtXSqFCqVWjkGBmQBcYLQFNBAs4OFIbzcbWyCndlXVRuxz7U
         XpHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yt+Ej+RFTyAlxOsRS7i/kggIDyE3eMtCY51oxHgQhKU=;
        fh=sGuri1KfubYvZuJE6Q1AqY6n1pa9fa1iSbmaezyShdo=;
        b=lLOA4Pka7XwBYXOxcFSD3MvzJ3yqzA+enZN2IQfbFOaRZ2gXZNQFYruEuU8qPkt+LU
         n3m/9d1TDDMtj/nPGxkgqFG7KbNk9GH0OI4oKw9I0zsc3D0WEvwAJUzzc6SZlWwrooTy
         zuG7jYUYJrm3oazXLHB6oD5PA1qIjgAKpspnYeCe6TOcX1CEOBi4kixxR/YqaPSeMbw4
         TItX8o0sk75pD2IwOEBKWth+TsZJXkmy6uNrW+B6hnU4U3zp/t0e79XHOHBZ/F/C+GIz
         HHXBgjZFDJsFJqzW+plRO9RKEpjwpo1TqFUmeZU8ZLftALGIB54Nry0v4U7To/QEfsRz
         WX/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789316273; x=1789921073; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yt+Ej+RFTyAlxOsRS7i/kggIDyE3eMtCY51oxHgQhKU=;
        b=tCVPXk/HjBz56vj4DLIPxsFAPBf4WEFz28uWG+bmseZ02lUx3aVTcesxKxChma+YO+
         W6q33Oj2Qo/+e/+PynKd1/AEm3W3som0kepoB5iZ7vwCxYLGUZy5nB2qJk+wIQ61ybZf
         pTCIDVMNiusuJ9LNmK/mFcAMbw+yOao6lcyiBFmJXoHVbf7T9/8n5hAlnzu0kR3gdXxa
         impsYqQtMstf9P611tjjgRK+UYCXkRacITTOIrsIbFwTe/foUDbSpZhbS5XrnBZ17S/k
         ntpi0xLEFoPNbRccDTVJANeOb/EO5RGaHODnXkKPBCwA67WhN7YFjjMRUxfZ5Zth8oft
         wEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789316273; x=1789921073;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yt+Ej+RFTyAlxOsRS7i/kggIDyE3eMtCY51oxHgQhKU=;
        b=UpUN7cb1Aemo+9BdLRB+8dWhmLFQeUmXoywft+0xV9Q3Uol8B8W/uTxLquvyY9yVS4
         immSqeGkAsrrXV0ZfIfyhQB9J/esAGc+XBuTFmH6/n9x9YhHuxZnDjPev/6RNvdpRdaC
         XtNAizAjvu1W9oLk/mrgkI2+N4ycTvA/h7LfniY7Eh3cP+bZ90C/Mpikq+FtWNN0ND0z
         V94IqLQIzajyhsTvjml4pg2UkVvxdEjXTuW3Id5HPOZ2EPJzwBeuGB3nc4TVChG/u932
         yOYez2Q8btk5hfk3oR1XhI23KT/vcTDqhtskrz7IxmE7zGSMl6Km4A4gN/vgUfIbDIiA
         2Ieg==
X-Forwarded-Encrypted: i=1; AKwUvBxmeDAH98TeascVVAUbm3sKTxbsZ9SUKq3N7PyHa5EZ4kwdH3P68uN9bgpxVeLsyjpEDyeqziJ6@vger.kernel.org
X-Gm-Message-State: AFuF++mMFUrY3V1YXtqqAgnpn8pk94JtVLKLQMBULkN8u39S00Qt3uXD
	hYVghiV3evVkmaS/gaWpGUO54XSwy2pWN9qRLb8gBsZjcu0Hn13l/nPATzqXstbSVkUeg8JpW3c
	KnsAO4b6lAf4gxIPfD15YhiG5Hm64ZvcnR0FbJxMe
X-Gm-Gg: AYBFou1M6a8o38vptt126GE1cR0C/Ou9dqjSH23OM6u9QYMbyFI65ChdzKmipA70P89
	jhZP2ah3AontjgW+sqRLzwkBuktNK/bh3YKZ/Jh65F62hapX9sJZa+awPW3qVab6hqMODNN645L
	JL21f9WkFoT7IJYPzDLfQmmUAPxDeRishkoRR1yLsSp201pwvXKAVGbqlCwc1pDse7mSqbD3tqE
	N7/YNMNn863RAPBialF46LLM0gI6YZ+FZT+XTp3Yzh/R7W6nKsGK1nKZDlK0V801zuk4mr2/2I0
	Flmlbu5iwvtZT71qLVWeB0NB+xJY+WDN9qn2+NL5b9ADsE28DzXA5y88XHufzXewcuvUpRhxvYb
	Jnx4qDgwcwA==
X-Received: by 2002:a05:600c:3593:b0:49a:d4d9:e417 with SMTP id
 5b1f17b1804b1-49e754445b3mr671735e9.6.1789316272535; Sun, 13 Sep 2026
 09:17:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANGjgdn=H50AaA-+O_GA-hkE9UwLANmkjx1zRsKUzxF5za8VfQ@mail.gmail.com>
 <aqa7KgIJYGgf7INk@slm.duckdns.org> <CANGjgd=f9n7zEZS=xi71y_dY6Uk75_qgP9qVDkYBusNz9sp2sg@mail.gmail.com>
In-Reply-To: <CANGjgd=f9n7zEZS=xi71y_dY6Uk75_qgP9qVDkYBusNz9sp2sg@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Sun, 13 Sep 2026 09:17:40 -0700
X-Gm-Features: AcwNN1UGrvqbq3HFY7pcrIOl_jX8tfzTKZIUJ5QTX30rH2G51YS_Yo5JvuNEb8Q
Message-ID: <CABdmKX2Oer9wrxWdR8s48Czro8H51HY+S_mfnUj-RvhjCM1RgA@mail.gmail.com>
Subject: Re: [REGRESSION] kernfs: empty cgroup rmdir latency after
 delete-notification changes
To: Chengfeng Lin <lin2530632123@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Kara <jack@suse.cz>, 
	driver-core@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 13, 2026 at 8:47=E2=80=AFAM Chengfeng Lin <lin2530632123@gmail.=
com> wrote:
>
> Hi Tejun,
>
> Thanks. I found this during research into kernel performance regressions,
> using a microbenchmark of cgroup creation and removal. This was not
> prompted by a production issue.
>
> I reported it to document the added removal cost and ask whether some
> of it could be reduced while preserving the fixes. I agree that the
> roughly 3 us increase per removal does not, by itself, demonstrate a
> significant impact on real workloads.
>
> Thanks,
> Chengfeng
>
> Tejun Heo <tj@kernel.org> =E4=BA=8E2026=E5=B9=B49=E6=9C=8813=E6=97=A5=E5=
=91=A8=E6=97=A5 23:03=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hello,
> >
> > On Sun, Sep 13, 2026 at 10:43:04PM +0800, Chengfeng Lin wrote:
> > > I found an increase in empty cgroup removal latency across 507d8ce13f=
5b
> > > ("kernfs: Don't set_nlink for directories being removed") and eea5d2b=
b34ba
> > > ("kernfs: Send IN_DELETE_SELF and IN_IGNORED"). With sched_ext disabl=
ed,
> > > rmdir() went from about 6.5 us to 9.6 us, an increase of 46-47%.
> > > The result held in two independent runs.
> >
> > I don't want to make cgroup removal unnecessarily expensive but at the =
same
> > time it's not an operation that I consider to be a hot path, so as long=
 as
> > the operaiton can finish in a reasonable amount of time and single digi=
t us
> > definitely is, performance of rmdir usually isn't something which is hi=
gh in
> > priority. Can you please detail why this matters for you?
> >
> > Thanks.
> >
> > --
> > tejun

Hi Chengfeng and Tejun,

We use this kernfs IN_DELETE_SELF feature on Android where multiple
cgroups are created and removed frequently on a per-application basis,
but we hadn't noticed a significant delay due to the inotify
functionality during cgroup removal. It's probably masked by much
larger delays (milliseconds) we regularly see due to unreleated issues
with cgroup locks like priority inversion with cgroup_mutex, and
contention for cgroup_threadgroup_rwsem.

As far as what we can do, I think avoiding inode lookups for kernfs
nodes that never had an inode created should improve the situation. It
doesn't eliminate the locking overhead, which I don't think can easily
be eliminated. The code below doesn't deal with inode eviction either,
but at least files which are never accessed won't introduce the inode
lookup overhead.

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 4f9ade82b08a..3ec9f79b1aa2 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1523,6 +1523,9 @@ static void kernfs_clear_inode_nlink(struct
kernfs_node *kn)
        struct kernfs_root *root =3D kernfs_root(kn);
        struct kernfs_super_info *info;

+       if (!(kn->flags & KERNFS_INODE_INITED))
+               return;
+
        lockdep_assert_held_read(&root->kernfs_supers_rwsem);

        list_for_each_entry(info, &root->supers, node) {
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 38b28aa7cd02..f8b4a8b8ade4 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -208,6 +208,10 @@ static void kernfs_init_inode(struct kernfs_node
*kn, struct inode *inode)
        set_default_inode_attr(inode, kn->mode);
        kernfs_refresh_inode(kn, inode);

+       down_write(&kernfs_root(kn)->kernfs_iattr_rwsem);
+       kn->flags |=3D KERNFS_INODE_INITED;
+       up_write(&kernfs_root(kn)->kernfs_iattr_rwsem);
+
        /* initialize inode according to type */
        switch (kernfs_type(kn)) {
        case KERNFS_DIR:
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index e21b2f7f4159..87f074ce19d3 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -113,6 +113,7 @@ enum kernfs_node_flag {
        KERNFS_EMPTY_DIR        =3D 0x1000,
        KERNFS_HAS_RELEASE      =3D 0x2000,
        KERNFS_REMOVING         =3D 0x4000,
+       KERNFS_INODE_INITED     =3D 0x8000,
 };

-T.J.
