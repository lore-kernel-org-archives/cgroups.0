From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v6 1/6] gpu: rfc: Proposal for a GPU cgroup controller
Date: Thu, 5 May 2022 13:29:08 +0200
Message-ID: <20220505112908.GC10890@blackbody.suse.cz>
References: <20220502231944.3891435-1-tjmercier@google.com>
 <20220502231944.3891435-2-tjmercier@google.com>
 <20220504121052.GA24172@blackbody.suse.cz>
 <CABdmKX2nbXLrngK8XRFCBCP=Zz-AMgKviiUdpWvEiYc-jOqang@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651750149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QztzfHPTmSF8udy99M+oiNjmEJKR+vOVp0C/C48CDH0=;
        b=fVa9/jQVA7FxoB2Yvgew58chqzIPQcGNV6v5gZHvfXRqjnza7FHT+mNpST0Y3E8/sgE4i4
        kOBTu5dWEezH/1d+DmxP/Q9zc4M+fSwEPDDv3OezauwSF7Lr1avS55OVFjZ3eSNxM2MBzB
        K9wQFZaM4ALSnkcoClgDJbFqZmtQnQY=
Content-Disposition: inline
In-Reply-To: <CABdmKX2nbXLrngK8XRFCBCP=Zz-AMgKviiUdpWvEiYc-jOqang@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Daniel Vetter <daniel@ffwll.ch>, Hridya Valsaraju <hridya@google.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, John Stultz <jstultz@google.com>, Todd Kjos <tkjos@android.com>, Carlos Llamas <cmllamas@google.com>, Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, Kenny.Ho@amd.com, Shuah Khan <skhan@linuxfoundation.org>, kernel-team@android.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, May 04, 2022 at 10:16:50AM -0700, "T.J. Mercier" <tjmercier@google.com> wrote:
> However the only names that would result from this series are the
> names of the dma-buf heaps, with "-heap" appended. So they are
> predictable from the /dev/dma_heap/* names, and only the system and
> cma heaps currently exist upstream.

It's not so important with the read-only stats currently posted (a
crafted sysfs file with these names would be an overlikill)...

> 
> For other future uses of this controller I thought we were headed in
> the direction of "standardized" names which would be
> predefined/hardcoded and documented, so these names wouldn't really
> need to be made available to a user at runtime.
> https://lore.kernel.org/lkml/CABdmKX3gTAohaOwkNccGrQyXN9tzT-oEVibO5ZPF+eP+Vq=AOg@mail.gmail.com/

(Ah, I see.)

...but if writers (limits) are envisioned, the keys should represent
something that the user can derive/construct from available info -- e.g.
the documentation.

OK, so I understand current form just presents some statistics.

Michal
