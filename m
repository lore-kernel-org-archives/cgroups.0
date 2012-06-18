From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/7][TRIVIAL][resend] drivers/pci: cleanup kernel-doc warning
Date: Mon, 18 Jun 2012 12:22:53 -0600
Message-ID: <CAErSpo7REiSBsWP0JNwUGi1m0HdK3H0=e0t2k-3L_Z+b4sMkMw@mail.gmail.com>
References: <1339766154-7470-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=11fxB32nWcuGBeoN9pge6/q5R4lTclypeEbKbNdL3z4=;
        b=idSqagGTVmO9e5sR7iCZrFroTftZzSZk5sOJXBWr2LN/VK7yJ7C12Ew9prMSGDaQNg
         cWf/PlVUabRvSYN4XFREFIXfzTHDGLW/AlUHsErLbMmzEfvdXPOT8Qpu5enMaqGNks5T
         Sx1AC38faKjeM4exzhWwVvE3uxzyWUCKLkjj4zDc97TmBIrJ+X3362g5+iLYDqSW88f8
         pB0Q5OqGqAsnPPnoOPK5xKhonB4u9BEah1WJ5DZRTQigjG5mi75NrGQNPSoo1xhC2P+9
         kqloN0ZnKvCV+nbDJ7LiZGMlKl/3vfIONZryS1I75DB+y3VTeyCWbQ68qcj0E6P26wgZ
         lkCw==
In-Reply-To: <1339766154-7470-1-git-send-email-liwp.linux@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: trivial@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Christoph Lameter <cl@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Milton Miller <miltonm@bga.com>, Nishanth Aravamudan <nacc@us.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Jason Wessel <jason.wessel@windriver.com>, Jan Kiszka <jan.kiszka@siemens.com>, David Howells <dhowells@redhat.com>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Andrew Morton <ak>

On Fri, Jun 15, 2012 at 7:15 AM, Wanpeng Li <liwp.linux@gmail.com> wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>
> Warning(drivers/pci/setup-bus.c:277): No description found for parameter =
'fail_head'
> Warning(drivers/pci/setup-bus.c:277): Excess function parameter 'failed_l=
ist' description in 'assign_requested_resources_sorted'
>
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> ---
> =A0drivers/pci/setup-bus.c | =A0 =A02 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 8fa2d4b..9165d25 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -265,7 +265,7 @@ out:
> =A0* assign_requested_resources_sorted() - satisfy resource requests
> =A0*
> =A0* @head : head of the list tracking requests for resources
> - * @failed_list : head of the list tracking requests that could
> + * @fail_head : head of the list tracking requests that could
> =A0* =A0 =A0 =A0 =A0 =A0 =A0 not be allocated
> =A0*
> =A0* Satisfy resource requests of each element in the list. Add

I applied this; it should appear in my "next" branch tomorrow.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
