Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDDB33A9E1
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 18:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789151597; cv=pass; b=mPB8Gm7j5w+PjpKxIRYq07ydjJ7gyiM4Vw5MzrmooJT5ent37YJ9WIptBKq32jWZr2Hz/ZFMDHIA5tIt2XYNC+mXCbrJwI5BqY0YjMOuEMkwhsHHtqgW4CtMJj2wP7MTu02f9/Hnk4k23muNnZYqi9f0TE1rsQ0dltNI+NYqMRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789151597; c=relaxed/simple;
	bh=BSqo+Pm7bAdch3Iq4rVn9TzBeUZ0xQ4rk5GEyIAS2rQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lKQFcuwFH9xr+Us8suaazj3ylQJ0XgzrFwz1bxQobHp3lAST160TYwQUDFgg4JwKVMt4Nk8iWtFb/NLeqNXz7iqC20FSF5pkeI7u+YuUTTcQCwj74atylRaTp0+LnJt/G0/IWHfHgOTDwAu7qNITLqjcAUGpTqlYwPPIzny/19M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jrPn8K3i; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jrPn8K3i"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa663c2so35079566b.3
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 11:33:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789151594; cv=none;
        d=google.com; s=arc-20260327;
        b=EJyq+s03aZ+T8TwZ5h6gm9AfOE/atN3BcTWUl9hCIp9xZtaLib3edsoP6XnvPf2qFc
         z9AoIcbnYq1XGYWE7hvBEyAI1p3zxOcB2f7fCvl6JB08d/SMChycsy5COTAFWhxsDXl3
         iEeWyYoUE6Po4XbD4mPnzY7f/PfzUdu94lkNCaKzcWWBg3avXydtGsd1vf9NZuD5moAo
         Ewjz66M8qVbcRjoOspK3lfkVO0/mc0xJO9XkLowfejW5YGaeohnydCs1BFwbhmwNqrOJ
         AQAsxm7hIp3GQ7EK8Fkjh6FKkN98U5SqMDAmQaaFA+nFnhpkdZZ0H1pMPtGXL8y1BkAd
         Q3Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qs3HgQRmWYZBaxjbc+wsq8KdyLLiiWdlbvxt2Yh0zD8=;
        fh=8IEckVyH0mX1nVxnYwAjk9U+umr7PW9WERe7wf1xuL8=;
        b=OocQNRl3O0CcEtiyBx6KyH6egDepu5UN7+IPwNApptst4XXfbjXg8nT5Inp5vzh4Yx
         Z//60zsDVYix1eEHt/9W6g3uVaPEA9rmRkyovJHwhZIArMpRWdPqtWq3w7jHfj3iuSVI
         JYY3H1UKsr+rxl7tYPFlVz3Qr3oOZHJV0XURKvwfB6MqAe5c6QZvog5OgSggtC92Ur11
         JDQqqvFzSFZwbAoNC8SP4TBDM3A6LPd1yniZiFYUw7xbKmS6Zdu1YDhnfgAX+NF2yPB5
         mUUCdYNe1t7LE5mWZZSxBlNoKoVjouz63K4ujlFxhzJzdNzjSDhEYm79qVsiF7Y1aSdG
         LyKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789151594; x=1789756394; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qs3HgQRmWYZBaxjbc+wsq8KdyLLiiWdlbvxt2Yh0zD8=;
        b=jrPn8K3iINtytQLPinbUpwdr8ufpP8KaYA2AUbd3FMOGJYjBMN77UG6TdHJGTsUETO
         F77YbXW3OgR6jfkAefGbtjgIaDJh0XgdyZhoTK1IUjGTaQG5/CK5sFQqRaMks8i4grKH
         L1KeZ+818R3bQCOZdtW/d8TzsCGHRM54CyvHsUWK3HQ9+d4Q8p995Ue4UFtCjF9lFajY
         DXT/1nJsQQ26xMGS+O0hmJLpsDJKVjT7RLKjzyT4a7x5B6/UNjLlk7+eJqSLRKMTPEw3
         IglhUmy++jVslRn+W4zg7oPtW7yVfpiH1WryXcvLc07nEw2eU31b4utHnTgHEEWOu8Es
         wD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789151594; x=1789756394;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qs3HgQRmWYZBaxjbc+wsq8KdyLLiiWdlbvxt2Yh0zD8=;
        b=nTjrqny/t/wi/++t3S4fwflzBsm/ddVCFVfMv46KiIZfGUHtGOBMZFgGnzeejswxbY
         gp6tIgha+jD+N3jyDSwEomvvu53DFvgH5Me21KXYWwGG0h1HBTSFy2ZOr49xm3SO+itZ
         ucGeX5UIQYDsq9ytjef4prTqTweMt/52mZBTRd5AZ2jUlhbsyeeuZSTAW66vsChXcXpt
         1jd3ZY8E1Gh8MBCC8WND/46dpAV2gT7mr4Y+Ouc4oXXwRdAQpCOuNxmTkPQaLaFiZEGF
         mCSVBrwCj1COmN90TBbCs3gls2y45buZEWURjqhTFZEexukQDwZl1Ykew34GiCG03ld0
         c+5A==
X-Forwarded-Encrypted: i=1; AKwUvBy0O4BkcyDUO7F9S62YC5C8Bmzd2Z80EKlkSSH8hAokFvwHA5S5oJ2w1kxVmhhx37OkJQAYQQ2N@vger.kernel.org
X-Gm-Message-State: AFuF++l9Kkw8NXM8kY3pxObW0a72Rc4r4hE3SwtDhXreO/d4rCYC7m2R
	mrhYMaSL3GcAMVV7NPDhZEOa6KPHU71zDWm6Vv2N1n7FVdDevA0vbMkPlbfEY3MQQboKla5kjWs
	D+gE/5wmZ3zR1lKuPnyYfXtrprCqiUYtnNquJo7DAgSvbBz9H5hS29/KUs2s=
X-Gm-Gg: AYBFou0ns9VNAmOcXbdCF2ObqgZV3pI0p8mAAZUQwUM55CSguRjbzcYhhHAPAJwt+t6
	vZ1mz9kWsv+EqVidz2KszcwlMrtmCWjSVw6IOkUwkr8xwUrNWxZTk4fdKcFci3yCKRQnEDikhgR
	BJPOoTdPzKkjIkvLgbwz8XvxBO7Tcd6QjocG2QCfK4/9q2D8ZyWChefeWQhWlJjbmrM2PGl9W/w
	JFcH5A3+V9JWTqnjYO2CV1bAR1d2ZyYtx60cqJvIQAnRA/TYxXsouQRF2BKIayzxA+JPuivjTls
	cwjLbR/dxNwysD/RE8APBkRsde5oxkJ0q/5S3pf1AQlVWyZ1Wxkq4RlmrRr21a9UbNeD0e+G0xK
	qXigoAoHIFXc=
X-Received: by 2002:a17:907:971a:b0:c29:5215:b2d8 with SMTP id
 a640c23a62f3a-c2966694db6mr463210766b.14.1789151593253; Fri, 11 Sep 2026
 11:33:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821050507.2161607-1-shakeel.butt@linux.dev> <20260821050507.2161607-5-shakeel.butt@linux.dev>
In-Reply-To: <20260821050507.2161607-5-shakeel.butt@linux.dev>
From: Sandeep Dhavale <dhavale@google.com>
Date: Fri, 11 Sep 2026 11:33:01 -0700
X-Gm-Features: AcwNN1WDzPUOCqS2ppOsu4mgfPCVT-uVPGILIV5eYTskg-Q1j9_MFgnEnGQqwnI
Message-ID: <CAB=BE-QMyzKT-o=gbhdp3g8JSqQgRiTFzxTX9vEBmCttABrmdw@mail.gmail.com>
Subject: Re: [PATCH 4/4] kernfs: Remove kernfs_rwsem from dentry revalidation
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, 
	Christian Brauner <christian@brauner.io>, Meta kernel team <kernel-team@meta.com>, driver-core@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shakeel and Christian,

On Thu, Aug 20, 2026 at 10:05=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> kernfs_dop_revalidate() takes kernfs_rwsem for read once per path compone=
nt
> of every walk into a kernfs mount. Linux rwsems do not permit reader lock
> stealing once a writer is queued, so a single writer parks the whole
> incoming reader stream in uninterruptible sleep, stalling cgroup-polling
> daemons for minutes.
>
> Nothing the callback reads requires the semaphore. kn->active is an
> atomic_t that kernfs_find_and_get_node_by_id() already tests through
> __kernfs_active(); kn->__parent and kn->name are RCU pointers whose old
> values are freed only after a grace period; kn->ns is now compared rather
> than dereferenced; parent->dir.rev was annotated earlier in this series.
>
> What the semaphore does provide is a coherent snapshot, and that is not
> needed. ->d_revalidate() answers a question about a single instant, and t=
he
> answer is already stale when it returns: a rename landing just after
> up_read() gives the same outcome as one observed mid-read. A lockless
> reader can only return "valid" for the (parent, name, namespace) triple
> identifying the dentry it was handed, and that triple was true when the
> dentry was instantiated, so it reports a genuine past state exactly as th=
e
> locked version did. Removal is backstopped by kernfs_get_active() failing
> in the subsequent open().
>
> Take an RCU read lock instead. kernfs_parent() and kernfs_rcu_name() work
> unchanged: the condition in their rcu_dereference_check() is an alternati=
ve
> to holding the RCU read lock, not an extra requirement. The negative dent=
ry
> path needs nothing, as @dir pins the parent. The namespace check can use
> @parent directly once the preceding check establishes it equals
> kernfs_parent(kn), so the kn_parent local and its NULL test go away.
>
> kernfs_ns_enabled() reads @parent->flags, which KERNFS_ACTIVATED and
> KERNFS_REMOVING update as a plain read-modify-write under kernfs_rwsem.
> Those bits are not read here and KERNFS_NS cannot change once the directo=
ry
> has children, so mark the read data_race() rather than READ_ONCE(), which
> would not silence KCSAN against the unmarked writers anyway.
>
> kernfs_iop_permission() still forces every walk out of RCU-walk before
> children are revalidated, so lifting the LOOKUP_RCU bail here would have =
no
> observable effect; it is left to the series fixing that path.
>
> Readers walking cgroupfs and sysfs against concurrent cgroup and netdev
> churn: kernfs_rwsem read acquisitions drop from 48,593,360 to 1,280,280,
> and kernfs_dop_revalidate() no longer appears among its contention sites.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  fs/kernfs/dir.c | 49 ++++++++++++++++++++-----------------------------
>  1 file changed, 20 insertions(+), 29 deletions(-)
>
> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> index 27949b0e027c..cd7a8ff8b6b2 100644
> --- a/fs/kernfs/dir.c
> +++ b/fs/kernfs/dir.c
> @@ -1171,9 +1171,8 @@ struct kernfs_node *kernfs_create_empty_dir(struct =
kernfs_node *parent,
>  static int kernfs_dop_revalidate(struct inode *dir, const struct qstr *n=
ame,
>                                  struct dentry *dentry, unsigned int flag=
s)
>  {
> -       struct kernfs_node *kn, *kn_parent;
>         struct kernfs_node *parent =3D dir->i_private;
> -       struct kernfs_root *root;
> +       struct kernfs_node *kn;
>         const char *kn_name;
>
>         if (flags & LOOKUP_RCU)
> @@ -1191,49 +1190,41 @@ static int kernfs_dop_revalidate(struct inode *di=
r, const struct qstr *name,
>                  * changes and the lookup re-done so that a new positive
>                  * dentry can be properly created.
>                  */
> -               root =3D kernfs_root(parent);
> -               down_read(&root->kernfs_rwsem);
> -               if (kernfs_dir_changed(parent, dentry)) {
> -                       up_read(&root->kernfs_rwsem);
> -                       return 0;
> -               }
> -               up_read(&root->kernfs_rwsem);
> -
> -               /* The kernfs parent node hasn't changed, leave the
> -                * dentry negative and return success.
> -                */
> -               return 1;
> +               return !kernfs_dir_changed(parent, dentry);
>         }
>
>         kn =3D kernfs_dentry_node(dentry);
> -       root =3D kernfs_root(kn);
> -       down_read(&root->kernfs_rwsem);
> +
> +       guard(rcu)();
>
>         /* The kernfs node has been deactivated */
> -       if (!kernfs_active(kn))
> -               goto out_bad;
> +       if (!__kernfs_active(kn))
> +               return 0;
>

I have couple of reports on android kernel based on 6.12 with callstack

[   41.137176][ T5373] pc : kernfs_dop_revalidate+0x28/0x108
[   41.137180][ T5373] lr : path_openat+0x7ec/0x1b04
[   41.137183][ T5373] sp : ffffffc0b02fbba0
[   41.137184][ T5373] x29: ffffffc0b02fbba0 x28: ffffffc0b02fbda4
x27: ffffff8917f90000
[   41.137187][ T5373] x26: 0000000000000030 x25: ffffff8918985860
x24: 0000000000028000
[   41.137189][ T5373] x23: ffffff8918985040 x22: 0000000000000040
x21: 0000000000000000
[   41.137192][ T5373] x20: ffffff8918985040 x19: ffffff894321d000
x18: ffffffdc3adec8c0
[   41.137194][ T5373] x17: 000000004495e485 x16: 000000004495e485
x15: ffffffffff000000
[   41.137197][ T5373] x14: 7d6770f3f4cee991 x13: 0000000000737365
x12: 0000000000737365
[   41.137199][ T5373] x11: ffffff8918985088 x10: 0000000000000018 x9
: 0000000100000000
[   41.137202][ T5373] x8 : ffffff89dc6c3d30 x7 : 705f636f6c6c6100 x6
: 0080808080808080
[   41.137204][ T5373] x5 : ffffffc0b02fbad0 x4 : 0000000000000000 x3
: 0000000000000000
[   41.137207][ T5373] x2 : 0000000000000000 x1 : 0000000000000100 x0
: ffffff8918985040
[   41.137210][ T5373] Call trace:
[   41.137211][ T5373]  kernfs_dop_revalidate+0x28/0x108
[   41.137213][ T5373]  path_openat+0x7ec/0x1b04
[   41.137215][ T5373]  do_filp_open+0xac/0x130
[   41.137216][ T5373]  do_sys_openat2+0x140/0x21c
[   41.137219][ T5373]  __arm64_sys_openat+0x70/0x9c
[   41.137222][ T5373]  invoke_syscall+0x58/0xf0
[   41.137224][ T5373]  do_el0_svc+0x64/0xe0
[   41.137226][ T5373]  el0_svc+0x4c/0xdc
[   41.137228][ T5373]  el0t_64_sync_handler+0x20/0xf4
[   41.137230][ T5373]  el0t_64_sync+0x1bc/0x1c0

After investigation it seems there is race where
kernfs_dop_revalidate() crashed dereferencing kn->__parent in
kernfs_root(kn) at offset 0x8).
Although your patch eliminates kernfs_root(kn), the underlying race
where kn =3D=3D NULL still exists in this patch and will now crash in
__kernfs_active(kn) at offset 0x4.

Scenario seems to be during lockless VFS path lookup (lookup_fast()),
cached dentries are revalidated without holding dentry locks:

  1. lookup_fast() finds a cached positive dentry where dentry->d_inode !=
=3D NULL.
  2. In kernfs_dop_revalidate(), d_really_is_negative(dentry)
evaluates to false, so it skips the negative dentry branch.
  3. Concurrently, slab memory reclaim under memory pressure evicts
unused dentries:
    shrink_node() -> shrink_slab() -> super_cache_scan()
      -> prune_dcache_sb() -> shrink_dentry_list()
        -> dentry_unlink_inode()
             -> __d_clear_type_and_inode(dentry)
                  -> dentry->d_inode =3D NULL;

  4. kernfs_dop_revalidate() now runs:
    kn =3D kernfs_dentry_node(dentry);
  kernfs_dentry_node() tests if (d_really_is_negative(dentry)) return NULL;=
.
  Because dentry->d_inode was cleared to NULL by
dentry_unlink_inode(), kernfs_dentry_node(dentry) returns NULL

While crafting fix for 6.12, I found this series reworking
kernfs_dop_revalidate().
Just to be clear, your series is not introducing the problem.

But perhaps we can improve this with a check like below?

  -    /* The kernfs node has been deactivated */
  -    if (!__kernfs_active(kn))
  +    /* The kernfs node is unlinked or deactivated */
  +    if (!kn || !__kernfs_active(kn))
             return 0;

Let me know your thoughts or if you want a separate patch

Thanks,
Sandeep.
