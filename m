From: Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: Re: [PATCH 17/26] cgroup/misc: Add notifier block list support for
 css events
Date: Mon, 14 Nov 2022 15:17:34 -0800
Message-ID: <f7d63c6ea33b8aacf1e5f1ede91636f397e1b770.camel@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
         <20221111183532.3676646-18-kristen@linux.intel.com>
         <Y3LES3rUIZ/PtwzV@slm.duckdns.org>
         <6f7afaa6811cbda30d12c38d73d4b261ab733a9f.camel@linux.intel.com>
         <Y3LLJypIUOSGKujT@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668467857; x=1700003857;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BJtuGQcejdW0AaDzJi8BImdXcSYnmn5KFjXEYF0+NuY=;
  b=NZwEMtKY5sd9W1hHNCFAjEJaLhtoBbpLFdFJDbEkh3XSBk3W9FAwyLHQ
   zQbSgkBIRu7SpO6CE4EHMm5V2upKqvWXrQZq9E81ffsfKZXlvTB/4+5Sm
   oux6vzzpXtr6Rlp2PfRwPEXKVqXmrbWrggIkcjWXH0LIFn+zfBDoFGCFm
   x/7RjDHGUw10gN7zD9TL6jsMUHDabjBs3jG73xWGo0hu3nhltA0ZJwdDv
   IPekmxM0mHKJJqroRV1vsJVWoWRwDwWzhzyVHPDp3qMsXO5xPttlb2hQ7
   kriGut5HnZZPcUef19+mx47H5d/Prd8t34plCQndMFbKZm+tH5VBe19XA
   g==;
In-Reply-To: <Y3LLJypIUOSGKujT@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: jarkko@kernel.org, dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, zhiquan1.li@intel.com

On Mon, 2022-11-14 at 13:11 -1000, Tejun Heo wrote:
> Hello,
>=20
> On Mon, Nov 14, 2022 at 03:10:05PM -0800, Kristen Carlson Accardi
> wrote:
> > Makes no difference to me TBH - I believe they will be functionally
> > equivalent and from a downstream user perspective equally as easy
> > to
> > use, so whatever you think is easiest for you to maintain.
>=20
> Yeah, functionally they should be equivalent. Hmm... Let's go with
> the ops
> table so that it's more explicit.
>=20
> Thanks.
>=20

OK, in the next version I will make this change, consolidate everything
for the misc controller into 1 or 2 patches as you requested, and also
get rid of the helpers and just access the struct directly. Thanks for
your review.

Kristen

