From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v2 4/5] blk-iocost: fix sleeping in atomic context
 warnning
Date: Thu, 17 Nov 2022 19:28:50 +0800
Message-ID: <3da991c6-21e4-8ed8-ba75-ccb92059f0ae@huaweicloud.com>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
 <20221104023938.2346986-5-yukuai1@huaweicloud.com>
 <Y3K8MSFWw8eTnxtm@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y3K8MSFWw8eTnxtm-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun!

=D4=DA 2022/11/15 6:07, Tejun Heo =D0=B4=B5=C0:

>=20
> Any chance I can persuade you into updating match_NUMBER() helpers to not
> use match_strdup()? They can easily disable irq/preemption and use percpu
> buffers and we won't need most of this patchset.

Does the following patch match your proposal?

diff --git a/lib/parser.c b/lib/parser.c
index bcb23484100e..ded652471919 100644
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -11,6 +11,24 @@
  #include <linux/slab.h>
  #include <linux/string.h>

+#define U64_MAX_SIZE 20
+
+static DEFINE_PER_CPU(char, buffer[U64_MAX_SIZE]);
+
+static char *get_buffer(void)
+{
+       preempt_disable();
+       local_irq_disable();
+
+       return this_cpu_ptr(buffer);
+}
+
+static void put_buffer(void)
+{
+       local_irq_enable();
+       preempt_enable();
+}
+

Then match_strdup() and kfree() in match_NUMBER() can be replaced with
get_buffer() and put_buffer().

Thanks,
Kuai
>=20
> Thanks.
>=20

