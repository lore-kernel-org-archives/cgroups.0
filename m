From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests/cgroup: allow running a specific test with test_memcontrol
Date: Sun, 18 Jun 2023 22:18:54 -0700
Message-ID: <CAJD7tkYspn8LwCDh2fjfGePWbRB405M3d1tgtax_4dGFSk3jBg@mail.gmail.com>
References: <20230619051715.2306134-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687151971; x=1689743971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xkIBRh1CRI7l1b26sTYaQ/9/gUUFxPZU0t2NyWKWH7Q=;
        b=eUeNwGRZOej+JmaNNUaJ6OPJIgJYdwORyCeMfKZTOjdOO76BnXQtHBcPlqW8xlMFQY
         s1nvqNLfu7R+DtrblqmhCcyNv9raxlOUrGUkijSYF2DLN/Fx1lHmAyyGItjJsLQKZ9SB
         GPfMkm2H1dEBHmBvUMD1gOtZO1fVM3k/h0NmiHlxO9RkzW6RQBtin+wJYQW/lxXbrH2y
         2jT67uQLUKUbBewiI+qS3az+zA4/Ja0YIqT9Cp1VvKdGyGO7ldm1/RKTqK5ZdG6UMaPi
         c/6Ert/O4bIexYOn5ii9geuHAbjF/UjC8Wjr754r+o8/7VgLwsDMrXGWCp8mWr05623N
         VqbQ==
In-Reply-To: <20230619051715.2306134-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Jun 18, 2023 at 10:17=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
>
> It is handy during testing and/or debugging to be able to run a single
> test from test_memcontrol. Allow passing in a test name through a
> command line argument (e.g. ./test_memcontrol -t test_memcg_recharge).
>
> Change-Id: I0e0d74d81fdd9d997987389085a816715160467f

I missed removing this gerrit tag, sorry. Will fix it if/when I respin.

> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  .../selftests/cgroup/test_memcontrol.c        | 30 +++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/tes=
ting/selftests/cgroup/test_memcontrol.c
> index a2a90f4bfe9f..d8f8a13bc6c4 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -1308,9 +1308,36 @@ struct memcg_test {
>
>  int main(int argc, char **argv)
>  {
> +       int opt;
>         char root[PATH_MAX];
> +       int selected_test =3D -1;
>         int i, proc_status, ret =3D EXIT_SUCCESS;
>
> +       while ((opt =3D getopt(argc, argv, "ht:")) !=3D -1) {
> +               switch (opt) {
> +               case 't':
> +                       for (i =3D 0; i < ARRAY_SIZE(tests); i++) {
> +                               if (!strcmp(tests[i].name, optarg)) {
> +                                       selected_test =3D i;
> +                                       break;
> +                               }
> +                       }
> +                       if (selected_test >=3D 0)
> +                               break;
> +                       fprintf(stderr, "test %s not found\n", optarg);
> +                       return EXIT_FAILURE;
> +               case 'h':
> +                       fprintf(stderr,
> +                               "Usage: %s [-h] [-t name]\n"
> +                               "\t-h       print help\n"
> +                               "\t-t name  run specific test\n"
> +                               , argv[0]);
> +                       return ret;
> +               default:
> +                       break;
> +               }
> +       }
> +
>         if (cg_find_unified_root(root, sizeof(root)))
>                 ksft_exit_skip("cgroup v2 isn't mounted\n");
>
> @@ -1336,6 +1363,9 @@ int main(int argc, char **argv)
>         has_localevents =3D proc_status;
>
>         for (i =3D 0; i < ARRAY_SIZE(tests); i++) {
> +               if (selected_test >=3D 0 && selected_test !=3D i)
> +                       continue;
> +
>                 switch (tests[i].fn(root)) {
>                 case KSFT_PASS:
>                         ksft_test_result_pass("%s\n", tests[i].name);
> --
> 2.41.0.162.gfafddb0af9-goog
>
