From: Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: Re: [PATCH 17/26] cgroup/misc: Add notifier block list support for
 css events
Date: Mon, 14 Nov 2022 15:10:05 -0800
Message-ID: <6f7afaa6811cbda30d12c38d73d4b261ab733a9f.camel@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
         <20221111183532.3676646-18-kristen@linux.intel.com>
         <Y3LES3rUIZ/PtwzV@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668467414; x=1700003414;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=xegt7ptKTtdJNW416eZFU2xzyfbyFyg07lD2i0oq41Q=;
  b=bEarSPNZtvx1T83GZvW9m36KNUTrCZAKbbqhkMxfty356n6/Sl2glriy
   s8HHrq8+b31UNMmxw4/wMm8M7Q1mW5aT0BotXqqV8dv0Xz/+PBkVeKACy
   NnpgxT3rwFcOr/T1NYhWl6ePQZjtacz3YpzZltz/J+918Bs1jOQRGA8Xr
   42ZElt3RY0EUThXsa+Dv/dc9CSB5NLp0QdV8wmfL9RrT9cB5pXaw3K1EB
   s8H6X4Ue94zJJXjii4nuZwqv80PDCURgL2DYGKGQF4mdQU8lcYKTLLq/f
   yOKwTR4xf8tf+IYPhpYLZ+IneqxdAwx5Ved1ZI8wl56w2vGGwarnQZ8nR
   Q==;
In-Reply-To: <Y3LES3rUIZ/PtwzV@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: jarkko@kernel.org, dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, zhiquan1.li@intel.com

On Mon, 2022-11-14 at 12:42 -1000, Tejun Heo wrote:
> Hello,
>=20
> On Fri, Nov 11, 2022 at 10:35:22AM -0800, Kristen Carlson Accardi
> wrote:
> > +/**
> > + * register_misc_cg_notifier() - Register for css callback events
> > + * @nb: notifier_block to register
> > + *
> > + * Context: Any context.
> > + */
> > +int register_misc_cg_notifier(struct notifier_block *nb)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return
> > blocking_notifier_chain_register(&misc_cg_notify_list, nb);
> > +}
> > +EXPORT_SYMBOL_GPL(register_misc_cg_notifier);
> > +
> > +/**
> > + * unregister_misc_cg_notifier() - unregister for css callback
> > events
> > + * @nb: notifier_block to unregister
> > + *
> > + * Context: Any context.
> > + */
> > +int unregister_misc_cg_notifier(struct notifier_block *nb)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return
> > blocking_notifier_chain_unregister(&misc_cg_notify_list, nb);
> > +}
> > +EXPORT_SYMBOL_GPL(unregister_misc_cg_notifier);
>=20
> So, I'm not necessarily against this but wonder whether it'd be more
> straightforward to add sth like struct misc_res_ops which contains
> the
> optional callbacks and then have an array of pointers to the structs
> which
> are initialized / registered somehow. What do you think?
>=20
> Thanks.
>=20

Makes no difference to me TBH - I believe they will be functionally
equivalent and from a downstream user perspective equally as easy to
use, so whatever you think is easiest for you to maintain.

