From: =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: "WARNING in cgroup_finalize_control" and "WARNING in
 cgroup_apply_control_disable" should be duplicate crash reports
Date: Thu, 21 Jan 2021 19:33:23 +0800
Message-ID: <CAD-N9QW6VGmAFPtJDcHahO=OQ=0Cy06-zaQf72mYL0=L_MEc_g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=I+cG4Vp0KOKN+ozIhgZ8d42ujiCT1czKBVqBGfsh21E=;
        b=QjcSscZscimEm9YXE5dIYpYuqYcpiIxJB+SPAUkEjYLDPYGtuYJyR1e/+YCFiR0qlC
         pDFpMw5HFKmXcyWysd1FhVkkiwiw7v2DpYdv5H8Un0R46SL6yVpM67dXd67OIZFvtDXY
         dpW0qo3HPREc7uTvFBrV2HliAUzJOjyhbXreHkpZ5NZFYN9Csb2Q44ryDKdkBdzsyg2Q
         VoumBKLrxmHUMCdVBuY/16Za7bqRWVO3VlUPwEvpVv0UDSxxSDwErL3NRwzBqW76e0s+
         zuu9JC1a8X6Oy6MTQX4f5jonI9y7EqxIF9LQv0q6d2eNgRwvrVEBR8JqQdMw10JJcxBZ
         8o1g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: andriin-b10kYP2dOMg@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org
Cc: syzkaller-bugs <syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>

Dear kernel developers,

I found that on the syzbot dashboard, =E2=80=9CWARNING in
cgroup_finalize_control=E2=80=9D [1] and "WARNING in
cgroup_apply_control_disable" [2] should share the same root cause.

The reasons for the above statement:
1) the stack trace is the same, and this title difference is due to
the inline property of "cgroup_apply_control_disable";
2) their PoCs are the same as each other;

If you can have any issues with this statement or our information is
useful to you, please let us know. Thanks very much.

[1] =E2=80=9CWARNING in cgroup_finalize_control=E2=80=9D -
https://syzkaller.appspot.com/bug?id=3Dfe2fee189f1f8babd95615dcbb57871d6d18=
920a

[2] =E2=80=9CWARNING in cgroup_apply_control_disable=E2=80=9D -
https://syzkaller.appspot.com/bug?id=3Dba5a3ed954137643a9337f90782c90e90ba3=
02ed
