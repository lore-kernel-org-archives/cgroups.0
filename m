Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D02D4E50C2
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 15:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790608208; cv=pass; b=bSSThu73VxyU0uGsC9yLvJqSVg+hHfCQVECGPC3i903XkoFrd2gnxAlJWkUOuzA3aKBK0NKfDhbHP0F5JX4CoTE7CvT2DdDRywOEqQ6769lCFtv5dX7OoP9J/dNSB1ZCDm7ROpeikXZPsBhjZkb67+YnQ+ctmd/02Wwy/jyhDY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790608208; c=relaxed/simple;
	bh=4FCRUAOy4qGBOqPeEKjQNXGdyxQDtJohZrPEliiduGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uvex1ZY4X3xHW5wg0PlmKeMaE6s2PeGQpxNJCRln2ACSpl5pW2PpfP9S2Cna68UjQg4LSUvcOcBQLPqnQpzAXirhpveGRi/4xUrinHaVRlTKNmBjTJfiL2OuUwRXDzOzvjZcvwHcJJs7v48itGSpYF7xXxWUHyg4eAFfniAeTRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vcD01ljV; arc=pass smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vcD01ljV"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49e65a8f70eso72115e9.0
        for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 08:10:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790608204; cv=none;
        d=google.com; s=arc-20260327;
        b=E3sVUuEXQRAHsL6PdlqewXEMHEdqZpIOLIO3OjLYQMNmLvcejx4rC2KMKYL4LKrHSx
         e8s92xgDOBF7MUVxkRAFwxrxUSBE8Wu9jWEGVmkNSNXcM9QccbJGJtExWmP1cp30FzLp
         0uGIDEg7gCe8BruWl5bjnX55ZPAZVcbdWWIuNM4YVXKm5EyNuHkwz/DoWRp78HhrO+BW
         jA1akwc8p/ZuF4HXdoYA8GBZTeP2Dip2xAhlVqmHCJDEzn95/2Iv+9DAQo5nqB5IRJDH
         3ULFIBqTuMcYJgcCH6/LOxPFu38gaoqsHsYS6DdGGcw5JdQnwCOgJ4F7uMaCRNSU/WTK
         Ltcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SOdnKdZSsp21Wh1GtsWQOZQyXk9VHFHxURgHVJL/kIM=;
        fh=AnU0Zb4BBqT3Tp2kKe2yToRK7HnqmE1nAWeVNwsiiUI=;
        b=mk6/NzmRD5xN47xFvG1+fP4Q17m5sj+KzYaejtNbW65zLC4bQxg2pYCRPCtpQtHae3
         l1UXWKm+Y2CMpxLq1dWkQZIR6aorZWPvSrrPpi5p2r4UocCoW0CLvsbzl2tzerBn3WlO
         qB0HlHls030VIOt13miqJhauDluRI1tjpRCwcxFpMgInunptrix+HczpdbuzlK5QTs7e
         /cSVPBF4iILJJVW5N6uiDFXK9GS0u98RfPYV6KyxI1kiWCoS3sQVoEytRiI57Z+VpDAm
         kBtdHGc8hZjj/rgAGCJb9b47Y2FIZWG0dS/LvswT4NYe7v7xsjuqz/mvIkHotwVXlbzB
         Mdeg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790608204; x=1791213004; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SOdnKdZSsp21Wh1GtsWQOZQyXk9VHFHxURgHVJL/kIM=;
        b=vcD01ljVTnzDGl70Y8e0CSiQ9y0wIOrAootNzIkwEEMcYlvk+3+R4y+g1KLvafXUt2
         vTllTS31s3X/OvCoVmTGKUCiRBonRh2dnjj192BacWrPq+L+FMbGfO7vCgDvix7PSb6G
         jdu2A5QvD9cUiUSVeT254vnw/dRXJdoUKU/5sMBchmwP6bzf/Inn6DtKak3Qc7pG2Faf
         yZkt3jpNdn6w4eGnTdaCnRx8bmjPTjDr9ZhLQRBm4h2e4q2+YTxj638cvrnAH8xs6VSo
         aHNeR0k21IHr78aLDbXe0V/jI0YzCdYqs6anfe1Mmat0M3HP9HEYNRzYPvQapltj+Umm
         gs/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790608204; x=1791213004;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SOdnKdZSsp21Wh1GtsWQOZQyXk9VHFHxURgHVJL/kIM=;
        b=Hae1mjc34+hL1+b/rHOGL3+9R/Z+0Mwtb3GBT4y+ldT7220/WU3HuxTylJkKxfsNdC
         ZcFyzWluiAPtEO6kqrrzFxDukNmGLcPAmHkycKvrT8BT0bLzh76sDmABgxFQcx+hxw+i
         L8qDqiM4cBtkQCaPXdvWQeUJJbzsgWYwBhk438uCxvaZmEmMXRSar7pq0jJs67mB1s5c
         kxEFw84oKsCc2XA0uzirEhuBydT12pIfeFQE+rfShcTPhq1ABfctnzcQh6YKWLk+34KP
         5um+8mKpy3KSafXeeiUa8mzL8hKHQMonjwFmYdFXGGZWpmh7KrC1s37HNuw4VqkUGufX
         Skfg==
X-Forwarded-Encrypted: i=1; AKwUvBwKBFW4XTlsECnjfpqJJP5xGNvrPDnTgtS4pfh8vXsFnOPqooG2QBz98l/w+g1VkN6H1YDXGmrE@vger.kernel.org
X-Gm-Message-State: AFuF++mkmhtnvRmuxswsPl3inioBqMktWagPYJgmnnEBkEEufDVseU9a
	33csZEebjV1qhwwPhuAbd4aVL0Q6JLy0//r4VJWjWjamnbOBIknIw/HGbu9u514iovHNvSXI2T6
	NKweuvyl5cbPs38LqzgxybAGxRRlj+fXLWZwXvDfT
X-Gm-Gg: AYBFou2BHcx+mOl7R8h3ECovaHMZU1dIJgSncHPazTDKPB+//xnX40GcBgDCqnh0BZw
	h9GUhRE5w907ZxQ1Nn+DrmWDheXPj4UppQGgdJfLI+n8gMzKgAUd/k+5QR7eIPKAi41JxTBgbit
	jHHBlSH3N4v+AvbNvTvw2se9Youw5lw4w4EIw26r1Db56ljTiMVQiU7X5RYGIoIPHf4VQRne8zT
	Vgyst8xVREaBmCtn0Gy24F8ZNjuB9QYRlwr09EVH8C32Sf4ezCOVLNOtaoh1kxjiHrvYXJp8CQ7
	Q5LSUQSx4CsBpGdMFWB4U9GLJ76tbLDXuJebhmcFYd8dZHdn7HkGq3wt3g0qMAO4PShVsryLgW0
	5mkT8/A3nNA03evPIR+oj+70QdvJy5Q4cR+i5503WnBv3Dg==
X-Received: by 2002:a7b:c049:0:b0:49d:21ee:1d7c with SMTP id
 5b1f17b1804b1-49ff9060be0mr2197165e9.14.1790608204011; Mon, 28 Sep 2026
 08:10:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926054205.28933-1-sebastian.chlad@suse.com>
In-Reply-To: <20260926054205.28933-1-sebastian.chlad@suse.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 28 Sep 2026 17:09:51 +0200
X-Gm-Features: AclHuK-UI-y0iD6O63glrzneLIs_6v53JO-jYanPzVVSviUMa6FZaP0zTiAkdhs
Message-ID: <CABdmKX27xqreLSwf0u7F=abmVNEKhMFj95WjJVQP=+QZsWH5WA@mail.gmail.com>
Subject: Re: [PATCH] selftests: memcg: Don't hang in the inotify tests without IN_DELETE_SELF
To: Sebastian Chlad <sebastianchlad@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Sebastian Chlad <sebastian.chlad@suse.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 26, 2026 at 7:42=E2=80=AFAM Sebastian Chlad
<sebastianchlad@gmail.com> wrote:

Hi,

> test_memcg_inotify_delete_file() and test_memcg_inotify_delete_dir()
> wait for IN_DELETE_SELF with a blocking read() on the inotify fd. On a
> kernel that does not send IN_DELETE_SELF for kernfs files and
> directories, the read() never returns and test_memcontrol hangs until
> it is killed by the kselftest timeout. The remaining tests do not run
> and no result is reported for the inotify tests.
>
> Wait for the first event with poll() and a timeout. If IN_DELETE_SELF
> does not arrive in time, report it and fail the test instead of
> blocking, so that test_memcontrol completes and the remaining results
> are reported.

But this polls for every read() through read_event(), not just IN_DELETE_SE=
LF.

> Assisted-by: claude-opus-5-5
> Signed-off-by: Sebastian Chlad <sebastian.chlad@suse.com>
> ---
>  .../selftests/cgroup/test_memcontrol.c        | 27 ++++++++++++++++---
>  1 file changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/tes=
ting/selftests/cgroup/test_memcontrol.c
> index 0ed82347044e..c00420acc9a1 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -11,6 +11,7 @@
>  #include <sys/types.h>
>  #include <unistd.h>
>  #include <sys/inotify.h>
> +#include <poll.h>
>  #include <sys/socket.h>
>  #include <sys/wait.h>
>  #include <arpa/inet.h>
> @@ -1655,10 +1656,20 @@ static int test_memcg_oom_group_score_events(cons=
t char *root)
>         return ret;
>  }
>
> +#define INOTIFY_TIMEOUT_MS 5000
> +
>  static int read_event(int inotify_fd, int expected_event, int expected_w=
d)
>  {
> +       struct pollfd pfd =3D { .fd =3D inotify_fd, .events =3D POLLIN };
>         struct inotify_event event;
>         ssize_t len =3D 0;
> +       int ret;
> +
> +       ret =3D poll(&pfd, 1, INOTIFY_TIMEOUT_MS);
> +       if (ret =3D=3D 0)
> +               return -ETIMEDOUT;

This mixes -1 with -ETIMEDOUT. The lack of consistency for error
handling is kinda weird.

> +       if (ret < 0)
> +               return -1;
>
>         len =3D read(inotify_fd, &event, sizeof(event));
>         if (len < (ssize_t)sizeof(event))
> @@ -1678,7 +1689,7 @@ static int test_memcg_inotify_delete_file(const cha=
r *root)
>  {
>         int ret =3D KSFT_FAIL;
>         char *memcg =3D NULL;
> -       int fd, wd;
> +       int fd, wd, err;
>
>         memcg =3D cg_name(root, "memcg_test_0");
>
> @@ -1701,7 +1712,11 @@ static int test_memcg_inotify_delete_file(const ch=
ar *root)
>         free(memcg);
>         memcg =3D NULL;
>
> -       if (read_event(fd, IN_DELETE_SELF, wd))
> +       err =3D read_event(fd, IN_DELETE_SELF, wd);
> +       if (err =3D=3D -ETIMEDOUT)
> +               fprintf(stderr, "no IN_DELETE_SELF event within %d ms\n",
> +                       INOTIFY_TIMEOUT_MS);
> +       if (err)
>                 goto cleanup;
>
>         if (read_event(fd, IN_IGNORED, wd))
> @@ -1723,7 +1738,7 @@ static int test_memcg_inotify_delete_dir(const char=
 *root)
>  {
>         int ret =3D KSFT_FAIL;
>         char *memcg =3D NULL;
> -       int fd, wd;
> +       int fd, wd, err;
>
>         memcg =3D cg_name(root, "memcg_test_0");
>
> @@ -1746,7 +1761,11 @@ static int test_memcg_inotify_delete_dir(const cha=
r *root)
>         free(memcg);
>         memcg =3D NULL;
>
> -       if (read_event(fd, IN_DELETE_SELF, wd))
> +       err =3D read_event(fd, IN_DELETE_SELF, wd);
> +       if (err =3D=3D -ETIMEDOUT)
> +               fprintf(stderr, "no IN_DELETE_SELF event within %d ms\n",
> +                       INOTIFY_TIMEOUT_MS);
> +       if (err)
>                 goto cleanup;
>
>         if (read_event(fd, IN_IGNORED, wd))

This IN_IGNORED case now fails silently while IN_DELETE_SELF prints a
timeout error message. What about moving the error message up into
read_event? That would address the comment about inconsistent return
values too.
