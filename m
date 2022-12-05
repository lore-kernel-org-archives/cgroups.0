From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 07/18] x86/sgx: Use a list to track to-be-reclaimed
 pages during reclaim
Date: Mon, 05 Dec 2022 10:25:56 -0800
Message-ID: <7017151a739c42516ace0de439679b37016b031c.camel@linux.intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
         <20221202183655.3767674-8-kristen@linux.intel.com>
         <0646275c-0ab9-2fad-8db1-7098656d6e1d@intel.com>
         <931e48dc399eddf8ad9f9dec8783f57df776daa9.camel@linux.intel.com>
         <6668e428-8e4a-0a44-d77c-a540c04d72ed@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670264771; x=1701800771;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6Ibb9FHX6sDZCVR/tQ45ZXWV1fgsrR8xYe8426ATKDs=;
  b=HVMyzuTQbjCHl37OyUHWo8Au1jNGjK6PCJu/rEwXb5T1I+vX6zUg1SeL
   AiIZkD6DjHACUvWoTkHXmlo86d+mcTrMou7nbbggUZA4d08ulznikMv5p
   Cowst5sCHeBKcseF/aBKwiY9did2pruwWU6m24z9kOSza6JHGRwdcc1fr
   ej5YZUT4tMsJhWY+dRXZ7ugMxcMaJM71JIRhSrHB69exUOONwTU88eR3n
   nK3YBtYuXQ1i4xSUhvHb7Tmz0n0ECDgd3QhVdVW5ap7c4naHa/3yvVkjs
   bRmpycocOsyPv7lF6W/1sguczneZRphn6gVy0eeueos+lSrNWNRhUsL+S
   A==;
In-Reply-To: <6668e428-8e4a-0a44-d77c-a540c04d72ed-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, 2022-12-05 at 09:03 -0800, Dave Hansen wrote:
> On 12/5/22 08:33, Kristen Carlson Accardi wrote:
> > The helpers were added because Jarrko requested a queue abstraction
> > for
> > the sgx_epc_lru_lists data structure in the first round of reviews.
> > the
> > simple one line inlines are effectively just renaming to make the
> > queue
> > abstraction more obvious to the reader.
>=20
> Jarkko,
>=20
> Do you have any issues with zapping these helpers?=C2=A0 I really don't
> think
> they add to readability.=C2=A0 The "reclaimable" versus "unreclaimable"
> naming is patently obvious from the structure member names.=C2=A0 I'm not
> sure what value it adds to have them in the function names too.
>=20
>=20


Well, there's sort of 2 things I would want clarity on before my next
revision. One is obviously deleting the wrappers for unreclaimable and
reclaimable pushes etc. The other is deleting the wrappers for the list
operations (the push/pop/peek queue abstractions) and whether those are
desired.

