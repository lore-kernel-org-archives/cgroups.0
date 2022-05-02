From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v4 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in
 secondary pagetable stats
Date: Mon, 2 May 2022 09:41:23 -0700
Message-ID: <CAJD7tka2NBymZaTQtDqGZRKZFwP7eniYU0Qa=HHjrZUkv032Cg@mail.gmail.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-5-yosryahmed@google.com> <Ym+HLD/U0wwrxtaB@google.com>
 <87k0b4i7se.wl-maz@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2488745840893879905=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=62IvqHI1fPfsDTYOxWAZqLaXvv0bxV93yimr+M9jpt0=;
 b=iHyOCwWrlVytNmY5kDXsFKgvgBdgQH093JMTVYtj7C6PiNMnkjycoz77hO2//mqSBu
 0FV0FBD0afAWefBbtJc09h06uiwVGguAhFvxPvI6OoaoXbtGw394E557wKd0p3W9c4RS
 cXnCtuUMM9/47EHG6Y4VC9dKvVdb0tEs2s85Irpc7ugM0EQr2GzExoAWKSD/Y47cljaM
 mDRQk2ukFTBc2sLdpwVcfjIYmaQr9t/I9aQJfVseMfbQNnntZUQ3cUThoWda7/djKML1
 zQgQqYTxkFPqf/yJCXbYGbRlstb5n3iL4Vz0+YKx20H8Fq5s4zVEjqyftbKsnF6Oc31F
 X9ig==
In-Reply-To: <87k0b4i7se.wl-maz@kernel.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <maz@kernel.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu, Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>, linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>

--===============2488745840893879905==
Content-Type: multipart/alternative; boundary="000000000000b0b71305de0a10c8"

--000000000000b0b71305de0a10c8
Content-Type: text/plain; charset="UTF-8"

On Mon, May 2, 2022 at 2:48 AM Marc Zyngier <maz@kernel.org> wrote:

> On Mon, 02 May 2022 08:24:28 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Hi Yosry,
> >
> > On Fri, Apr 29, 2022 at 08:11:31PM +0000, Yosry Ahmed wrote:
> > > Count the pages used by KVM in arm64 for stage2 mmu in secondary
> pagetable
> > > stats.
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > > ---
> > >  arch/arm64/kvm/mmu.c | 35 +++++++++++++++++++++++++++++++----
> > >  1 file changed, 31 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 53ae2c0640bc..fc5030307cce 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -92,9 +92,13 @@ static bool kvm_is_device_pfn(unsigned long pfn)
> > >  static void *stage2_memcache_zalloc_page(void *arg)
> > >  {
> > >     struct kvm_mmu_memory_cache *mc = arg;
> > > +   void *virt;
> > >
> > >     /* Allocated with __GFP_ZERO, so no need to zero */
> > > -   return kvm_mmu_memory_cache_alloc(mc);
> > > +   virt = kvm_mmu_memory_cache_alloc(mc);
> > > +   if (virt)
> > > +           kvm_account_pgtable_pages(virt, +1);
> >
> > Sorry I didn't say it last time around, would now be a good time to
> > clean up the funky sign convention of kvm_mod_used_mmu_pages()? Or limit
> > the funk to just x86 :)
>
> Indeed. I pointed this out in my initial review of this series, and
> expected these to be gone by now.


Hey everyone,

Sorry about that. Will clean that up in the next version.


>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>

--000000000000b0b71305de0a10c8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><br></div><div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=
=3D"gmail_attr">On Mon, May 2, 2022 at 2:48 AM Marc Zyngier &lt;<a href=3D"=
mailto:maz@kernel.org">maz@kernel.org</a>&gt; wrote:<br></div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1p=
x;border-left-style:solid;padding-left:1ex;border-left-color:rgb(204,204,20=
4)">On Mon, 02 May 2022 08:24:28 +0100,<br>
Oliver Upton &lt;<a href=3D"mailto:oupton@google.com" target=3D"_blank">oup=
ton@google.com</a>&gt; wrote:<br>
&gt; <br>
&gt; Hi Yosry,<br>
&gt; <br>
&gt; On Fri, Apr 29, 2022 at 08:11:31PM +0000, Yosry Ahmed wrote:<br>
&gt; &gt; Count the pages used by KVM in arm64 for stage2 mmu in secondary =
pagetable<br>
&gt; &gt; stats.<br>
&gt; &gt; <br>
&gt; &gt; Signed-off-by: Yosry Ahmed &lt;<a href=3D"mailto:yosryahmed@googl=
e.com" target=3D"_blank">yosryahmed@google.com</a>&gt;<br>
&gt; &gt; ---<br>
&gt; &gt;=C2=A0 arch/arm64/kvm/mmu.c | 35 +++++++++++++++++++++++++++++++--=
--<br>
&gt; &gt;=C2=A0 1 file changed, 31 insertions(+), 4 deletions(-)<br>
&gt; &gt; <br>
&gt; &gt; diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c<br>
&gt; &gt; index 53ae2c0640bc..fc5030307cce 100644<br>
&gt; &gt; --- a/arch/arm64/kvm/mmu.c<br>
&gt; &gt; +++ b/arch/arm64/kvm/mmu.c<br>
&gt; &gt; @@ -92,9 +92,13 @@ static bool kvm_is_device_pfn(unsigned long pf=
n)<br>
&gt; &gt;=C2=A0 static void *stage2_memcache_zalloc_page(void *arg)<br>
&gt; &gt;=C2=A0 {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0struct kvm_mmu_memory_cache *mc =3D arg;<br>
&gt; &gt; +=C2=A0 =C2=A0void *virt;<br>
&gt; &gt;=C2=A0 <br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0/* Allocated with __GFP_ZERO, so no need to ze=
ro */<br>
&gt; &gt; -=C2=A0 =C2=A0return kvm_mmu_memory_cache_alloc(mc);<br>
&gt; &gt; +=C2=A0 =C2=A0virt =3D kvm_mmu_memory_cache_alloc(mc);<br>
&gt; &gt; +=C2=A0 =C2=A0if (virt)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kvm_account_pgtable_pag=
es(virt, +1);<br>
&gt; <br>
&gt; Sorry I didn&#39;t say it last time around, would now be a good time t=
o<br>
&gt; clean up the funky sign convention of kvm_mod_used_mmu_pages()? Or lim=
it<br>
&gt; the funk to just x86 :)<br>
<br>
Indeed. I pointed this out in my initial review of this series, and<br>
expected these to be gone by now.</blockquote><div dir=3D"auto"><br></div><=
div dir=3D"auto">Hey everyone,</div><div dir=3D"auto"><br></div><div dir=3D=
"auto">Sorry about that. Will clean that up in the next version.</div><div =
dir=3D"auto"><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0p=
x 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;padding-left:=
1ex;border-left-color:rgb(204,204,204)" dir=3D"auto"><br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 M.<br>
<br>
-- <br>
Without deviation from the norm, progress is not possible.<br>
</blockquote></div></div>

--000000000000b0b71305de0a10c8--

--===============2488745840893879905==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2488745840893879905==--
