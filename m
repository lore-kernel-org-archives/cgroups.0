Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D58F33D512
	for <cgroups@vger.kernel.org>; Fri, 20 Feb 2026 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771609617; cv=pass; b=SuIG5DPcklhY7vK4SpwfkzWudc6e2XbfO7q8cZnRjLkfDqfnDq6Imzq4+jkc/AqTF4PzQlhkpP6SZWu5ef9OitSnfayHy0Rr0aJn+a1N3igoqTY92FyHDKmomn2Y77v5C+DZp72kd4jLmsFAGukpb2UBQw2ElrjLFKuNrBTqgso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771609617; c=relaxed/simple;
	bh=L4LUtbq/AYJ1ibIci7EI6CXd6uhMJdMr550QxtjyFO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HUR2UMqy5xTSgK0cuLIgQyxzwWJHUznA8DfiG8G3RpbAItdEBan6/sIA4RyWeoCmvitm+iGbq9sCHfAOQxSJqVJ0jefAA5PFaE6JB48G5gbaumbARVQurkFnWxwICxk3Z8cjvvSymblexy8gnwskiWadOB7OyM4Bps+QyrIhnpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UErns9a2; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UErns9a2"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48371d2f661so515e9.1
        for <cgroups@vger.kernel.org>; Fri, 20 Feb 2026 09:46:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771609614; cv=none;
        d=google.com; s=arc-20240605;
        b=XZIKandqU9P7KjK4bosdvbeXxzj3tP7cdfASMXhMW6UhyM8uWFDOiK1Y3vc9z5/0sZ
         dm3Uy4EndcuJmo8QJuFHFbMRDUfZ7kPb3hhdeanpvSwUbGagLod+NTbWxxXxUz0QhcH3
         GgZXlXmikh6rrA0Tl5fgQ19vBlIZDEyjNaUw9znDv+UZprV8H34CKVdTMdAUqlFx+L/v
         nPD5B2FpIz8/j57FL4/HjrAKxD+P1fxs5nZUwTH1QurBWW/fxmx/N8dj6krtHf5zerkB
         dFbiK4I1DwkOjKpCdgOUr10u2cAnzHowLpKAfC39F/Si2S46I2WWUoAMQB7axnVfYE+0
         CoyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TtrPaYzDg2FZ0DurUoi+gNF5T1+mzkiQf2zCfT8eyAI=;
        fh=dxdTVv7httc7BHIS6n+R1JNWHtcpwY2yzkdK1Eczlks=;
        b=RBV5NVYtjWFFeKl/IMfH5MQuaaQYclV0vao1TIxM4jwYvN91FSN+gdaewEUr+BbJq5
         w4vBxRPRCUz90VixAu9lXc10bnxPQ5yTZt9VD0lhLJeQZrZIvyWiyWmkin+o0GzMz/jj
         Y5v2yfd3TSQvOWVRqCzJggkb0uzuNxW3POCUo4YpjAZuqoV9V2sQwiPHFTcXXuKHZbsn
         9/X/KEGDgUUlg1PLZ8mOIcz9Fhj2pfAJcsaGp5OA7yNLR/lzop2dJ1JEYGqQ16gETbYJ
         yYIY6lSmlKq/PjMqVYd7Nc62MB19mGrZnuwGqt5wPsqeE+0U2yGRTso7YameejKjQVJO
         sL/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771609614; x=1772214414; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TtrPaYzDg2FZ0DurUoi+gNF5T1+mzkiQf2zCfT8eyAI=;
        b=UErns9a2UGB3xcL2aFLGvcHe1hlRA35qOtTeH6UbuQQGshI4tTFmf9o43Ye8fLQQpA
         Qqsxcg5codC0LRPBqhLOb9cjg+yUV1HL4b7MSJNYu1U6X6ajiyxcH2H+HVsSBe2dDfDd
         idZjlryRA8Qv6V7THMiCvDnzAJH9iJPQFI7wKmPAcoG+r2J59s/lCb7LT95zFnF4g0Ya
         irJGnYmCuPcyS1IH3tAa3wKG3HKNYT2WKWXAnLZIhlTYYE/KxEM+/OXuxBBrXpRBzhi8
         ieOJIb37UHXE9vrwU58Fqjtkj3fQiFEqh+NsAYOaIVAd6brC/aEkxa1TvbgOmi4iUPTA
         xBrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771609614; x=1772214414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TtrPaYzDg2FZ0DurUoi+gNF5T1+mzkiQf2zCfT8eyAI=;
        b=dnvZG5UzcA/PFsQ/7KEeyfhr6O7Ot4d9ToNRD8EeSyxTdpzlh5Gh4z4p963NWhmo7B
         UB161yR1hCWZqqJKQSJx6vmnlUtAHJlQZK+pmNFl9ZJszYHQEWCMo9krHgAKIZXAW6Dy
         VefFgTjQVFlwmSydAjtjofwUoI4KxUmGYRn+Qi2/X9D08hx72Fi4nNhjTkO4B+A1iL/T
         mQJ62U8nY+BDpHW6R9OkkkkiBTaRi3UDm1nvYpBi3sQbFwMSYbiAWf6onUM7eB7bhKv4
         sM15zbBtjkdusrdxDS4PYZK+yQcNc3YvlwFnZ/dCaLEAgEktl4Tjldv7qc6xSPDw2PYF
         vaJA==
X-Forwarded-Encrypted: i=1; AJvYcCXG9SzAXd9e2KyUvqBpCehC0WewbPUnwwLfegFGjGQFy/4o5rX8mWUfqpoZhcfhHPBuwMC/1JO6@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo55yWvaHAPzsqB7AEp6h3tjd0neCPz1uMKQ4oRZLiSpbzF6wI
	0wvVP+gT/VcdONrbW23Io5iBD8PDupo2OmhRH021tSMb7GcWCuCa3XnTP5iNv/7ttMiPm73cE3Q
	WZ5Mcz78w6IAhB9hJyJGSCMigkej2EpJeKQO04RZ3
X-Gm-Gg: AZuq6aLxsnstAAdiChY4saDiqGa5yHjBQxDgYJXqGwU88EXAQnr0YTZKz7WWJ+kIalU
	cc9q6pTslj/6prXmektMtV5kWrCOkYNFRRkO7VOxa+wAuucpwaAeLx3uPe1EpOIsBT8KCuA8Dwu
	Y89jeiARTt09OfPqFvb5eyEZUThj5WRoq1PpuhdA5WJ+56zZmKm1GhNigWkwwNLvq5msIlKkZtB
	TQIAJjni7ZWiBvE5phVwwz2tT41P+oVzItehkbH1Z/pXuSKr7XBHSlfwvjzTvRgT+x4Q01aULR6
	9sfgEWS/OSpYfXoPxZXtX2TkFgPOUJAYWFWW+A==
X-Received: by 2002:a05:600c:3b24:b0:477:2f6f:44db with SMTP id
 5b1f17b1804b1-483a441ed85mr992395e9.5.1771609613577; Fri, 20 Feb 2026
 09:46:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260220055449.3073-1-tjmercier@google.com> <20260220055449.3073-4-tjmercier@google.com>
 <CAOQ4uxiPqUzBQAk8Tic7aFMsHtajEWENCTg+CQPMy5XtmS4kBQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiPqUzBQAk8Tic7aFMsHtajEWENCTg+CQPMy5XtmS4kBQ@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Fri, 20 Feb 2026 09:46:41 -0800
X-Gm-Features: AaiRm51nxtCKSVmNbDDauz1vLZUs5KV1q654jLHNKJz17gEkMqiQHsF23IMGBCk
Message-ID: <CABdmKX3Pd8sJpzuQD0tfKCznOy3=cDoAOEnN-COQa59weUFrqw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] selftests: memcg: Add tests for IN_DELETE_SELF and IN_IGNORED
To: Amir Goldstein <amir73il@gmail.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, driver-core@lists.linux.dev, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, jack@suse.cz, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 20, 2026 at 9:44=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Fri, Feb 20, 2026 at 6:55=E2=80=AFAM T.J. Mercier <tjmercier@google.co=
m> wrote:
> >
> > Add two new tests that verify inotify events are sent when memcg files
> > or directories are removed with rmdir.
> >
> > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> > Acked-by: Tejun Heo <tj@kernel.org>
> > Acked-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  .../selftests/cgroup/test_memcontrol.c        | 112 ++++++++++++++++++
> >  1 file changed, 112 insertions(+)
> >
> > diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/t=
esting/selftests/cgroup/test_memcontrol.c
> > index 4e1647568c5b..57726bc82757 100644
> > --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> > +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> > @@ -10,6 +10,7 @@
> >  #include <sys/stat.h>
> >  #include <sys/types.h>
> >  #include <unistd.h>
> > +#include <sys/inotify.h>
> >  #include <sys/socket.h>
> >  #include <sys/wait.h>
> >  #include <arpa/inet.h>
> > @@ -1625,6 +1626,115 @@ static int test_memcg_oom_group_score_events(co=
nst char *root)
> >         return ret;
> >  }
> >
> > +static int read_event(int inotify_fd, int expected_event, int expected=
_wd)
> > +{
> > +       struct inotify_event event;
> > +       ssize_t len =3D 0;
> > +
> > +       len =3D read(inotify_fd, &event, sizeof(event));
> > +       if (len < (ssize_t)sizeof(event))
> > +               return -1;
> > +
> > +       if (event.mask !=3D expected_event || event.wd !=3D expected_wd=
) {
> > +               fprintf(stderr,
> > +                       "event does not match expected values: mask %d =
(expected %d) wd %d (expected %d)\n",
> > +                       event.mask, expected_event, event.wd, expected_=
wd);
> > +               return -1;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int test_memcg_inotify_delete_file(const char *root)
> > +{
> > +       int ret =3D KSFT_FAIL;
> > +       char *memcg =3D NULL;
> > +       int fd, wd;
> > +
> > +       memcg =3D cg_name(root, "memcg_test_0");
> > +
> > +       if (!memcg)
> > +               goto cleanup;
> > +
> > +       if (cg_create(memcg))
> > +               goto cleanup;
> > +
> > +       fd =3D inotify_init1(0);
> > +       if (fd =3D=3D -1)
> > +               goto cleanup;
> > +
> > +       wd =3D inotify_add_watch(fd, cg_control(memcg, "memory.events")=
, IN_DELETE_SELF);
> > +       if (wd =3D=3D -1)
> > +               goto cleanup;
> > +
> > +       if (cg_destroy(memcg))
> > +               goto cleanup;
> > +       free(memcg);
> > +       memcg =3D NULL;
> > +
> > +       if (read_event(fd, IN_DELETE_SELF, wd))
> > +               goto cleanup;
> > +
> > +       if (read_event(fd, IN_IGNORED, wd))
> > +               goto cleanup;
> > +
> > +       ret =3D KSFT_PASS;
> > +
> > +cleanup:
> > +       if (fd >=3D 0)
> > +               close(fd);
> > +       if (memcg)
> > +               cg_destroy(memcg);
> > +       free(memcg);
> > +
> > +       return ret;
> > +}
> > +
> > +static int test_memcg_inotify_delete_dir(const char *root)
> > +{
> > +       int ret =3D KSFT_FAIL;
> > +       char *memcg =3D NULL;
> > +       int fd, wd;
> > +
> > +       memcg =3D cg_name(root, "memcg_test_0");
> > +
> > +       if (!memcg)
> > +               goto cleanup;
> > +
> > +       if (cg_create(memcg))
> > +               goto cleanup;
> > +
> > +       fd =3D inotify_init1(0);
> > +       if (fd =3D=3D -1)
> > +               goto cleanup;
> > +
> > +       wd =3D inotify_add_watch(fd, memcg, IN_DELETE_SELF);
> > +       if (wd =3D=3D -1)
> > +               goto cleanup;
> > +
> > +       if (cg_destroy(memcg))
> > +               goto cleanup;
> > +       free(memcg);
> > +       memcg =3D NULL;
> > +
> > +       if (read_event(fd, IN_DELETE_SELF, wd))
> > +               goto cleanup;
>
>
> Does this test pass? I expect that listener would get event mask
> IN_DELETE_SELF | IN_ISDIR?

Yes, I tested on 4 different machines across different filesystems and
none of them set IN_ISDIR with IN_DELETE_SELF. The inotify docs say,
"may be set"... I wonder if that is wishful thinking?
