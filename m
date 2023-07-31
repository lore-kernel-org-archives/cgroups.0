From: Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [bug report] selftests: cgroup: add test_zswap with no kmem
 bypass test
Date: Mon, 31 Jul 2023 16:54:50 +0200
Message-ID: <CA+CLi1gUXg7u4yU7buxZK1DwR6JiX7R__93LP7xnQsX29e=F+Q@mail.gmail.com>
References: <477f3cd4-d2ec-4a0e-8e77-87968467d4a2@moroto.mountain>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690815301; x=1691420101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5B4Sgjqj8PJwtQbsiaEbfotX4EbaMjVvEmJGGtCQmdI=;
        b=MYEXAACmJf/TJazWT/7lXOvZf/LWvCukZvTAiPWDQJV5CRAKOl1c2oZgLTtycDWOJJ
         k4R4ttm63dmwe7HViTCZ6fTS8/Z7yhN+D+TlFSCuyittCBiN4pzQodzV//lD4mUiocb5
         D000Iyb6uiAlphAsyBkeq7DGy+ZMx5MFUv6vz/hn95INrmv2Hqs65nfW8p41K9X5BK7z
         cniR3jqFhhkmmZixJx8PB8HZyRuhbCz98yk1a1iCfhqUxbOVRYlDLHMY9osXnVI4ETxE
         UNm1Ly/epdhMWKPpzeExFLc+MT8nqH6/JK6UYahNKF3EwMZyex+/YF4HfHBs6ZOIlyRB
         l/og==
In-Reply-To: <477f3cd4-d2ec-4a0e-8e77-87968467d4a2-UfLsUWgOF1UQ0Z77HyQ7DA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Dan Carpenter <dan.carpenter-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jul 31, 2023 at 9:23=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> Hello Domenico Cerasuolo,
>
> The patch 7c967f267b1d: "selftests: cgroup: add test_zswap with no
> kmem bypass test" from Jun 21, 2023 (linux-next), leads to the
> following Smatch static checker warning:
>
>         tools/testing/selftests/cgroup/test_zswap.c:211 test_no_kmem_bypa=
ss()
>         warn: unsigned 'stored_pages' is never less than zero.
>
> ./tools/testing/selftests/cgroup/test_zswap.c
>     197         /* Try to wakeup kswapd and let it push child memory to z=
swap */
>     198         set_min_free_kb(min_free_kb_high);
>     199         for (int i =3D 0; i < 20; i++) {
>     200                 size_t stored_pages;
>     201                 char *trigger_allocation =3D malloc(trigger_alloc=
ation_size);
>     202
>     203                 if (!trigger_allocation)
>     204                         break;
>     205                 for (int i =3D 0; i < trigger_allocation_size; i =
+=3D 4095)
>     206                         trigger_allocation[i] =3D 'b';
>     207                 usleep(100000);
>     208                 free(trigger_allocation);
>     209                 if (get_zswap_stored_pages(&stored_pages))
>     210                         break;
> --> 211                 if (stored_pages < 0)
>
> size_t can't be negative.  Is there any reason to check this even?

Hi Dan,

Thanks for reporting this, that check is indeed not needed. I should have
removed it when I refactored get_zswap_stored_pages and added the check
at line 209, I'll send a fix.

Thanks,
Domenico

>
>     212                         break;
>     213                 /* If memory was pushed to zswap, verify it belon=
gs to memcg */
>     214                 if (stored_pages > stored_pages_threshold) {
>     215                         int zswapped =3D cg_read_key_long(test_gr=
oup, "memory.stat", "zswapped ");
>     216                         int delta =3D stored_pages * 4096 - zswap=
ped;
>     217                         int result_ok =3D delta < stored_pages * =
4096 / 4;
>     218
>     219                         ret =3D result_ok ? KSFT_PASS : KSFT_FAIL=
;
>     220                         break;
>     221                 }
>     222         }
>     223
>     224         kill(child_pid, SIGTERM);
>
> regards,
> dan carpenter
