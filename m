From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] cgroup: Replace a seq_printf() call by seq_puts() in
 cgroup_print_ss_mask()
Date: Tue, 2 Jul 2019 19:33:08 +0200
Message-ID: <d465ca81-a870-b88c-0ea2-5e8bfbefb79d@web.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1562088791;
        bh=lVjT2ewFqk1ytdCtHu/OnHNzgzrQYPG56Na/OyfRN9o=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=q+uICQZuVbm+qQliAF3uODVywi7KkRRU9KBxXxXUSQxMyPwTPBiW3F4AHU31/mnM4
         CLQkYfJ/6baG0NINIA4FVk0dCmP5o16egB79auUF/Fzz0H+ns2hKCc+lTbOJdKPLg6
         jQ5mvA7sQsoYJWboDwcmfVBh9QLOrrlXQ60w1fqY=
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 Jul 2019 19:26:59 +0200

A string which did not contain a data format specification should be put
into a sequence. Thus use the corresponding function =E2=80=9Cseq_puts=E2=
=80=9D.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 300b0c416341..9d04e3004e3b 100644
=2D-- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2851,7 +2851,7 @@ static void cgroup_print_ss_mask(struct seq_file *se=
q, u16 ss_mask)
 	do_each_subsys_mask(ss, ssid, ss_mask) {
 		if (printed)
 			seq_putc(seq, ' ');
-		seq_printf(seq, "%s", ss->name);
+		seq_puts(seq, ss->name);
 		printed =3D true;
 	} while_each_subsys_mask();
 	if (printed)
=2D-
2.22.0

