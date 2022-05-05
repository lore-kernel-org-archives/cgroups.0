From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v6 2/6] cgroup: gpu: Add a cgroup controller for
 allocator attribution of GPU memory
Date: Thu, 5 May 2022 13:50:15 +0200
Message-ID: <20220505115015.GD10890@blackbody.suse.cz>
References: <20220502231944.3891435-1-tjmercier@google.com>
 <20220502231944.3891435-3-tjmercier@google.com>
 <20220504122558.GB24172@blackbody.suse.cz>
 <CABdmKX2DJy0i3XAP7xTduZ8KFVKtgto24w714YJNUb_=pfYiKw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651751416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SFH/x2L4G69sbr6PPcrJ24GF6EKzycaRm+AGvFywOyg=;
        b=Hi7oi4+HvgHIFy7zdrmmaaXxpCzxgIsU/9DIcQEQIsZBrzEnC99VBYyTdl9tCC5Clj0fNo
        S4wfHAcq5GS0FxgqjHIneVl1e76wHk0FgPIrmw1/VLSR1LTsnu6LUe2oRBxPFHVVShOMzR
        bOw8YBZW592ZS2VzcJD/HrayK6QgMM8=
Content-Disposition: inline
In-Reply-To: <CABdmKX2DJy0i3XAP7xTduZ8KFVKtgto24w714YJNUb_=pfYiKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, John Stultz <jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Carlos Llamas <cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Shuah Khan <skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 04, 2022 at 10:19:20AM -0700, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Should I export these now for this series?

Hehe, _I_ don't know.
Depends on the likelihood this lands in and is built upon.

> No, except maybe the gpucg_bucket name which I can add an accessor
> function for. Won't this mean depending on LTO for potential inlining
> of the functions currently implemented in the header?

Yes.  Also depends how much inlining here would be performance relevant.
I suggested this with an OS vendor hat on, i.e. the less such ABI, the
simpler.

> I'm happy to make this change, but I wonder why some parts of the
> kernel take this approach and others do not.

I think there is no convention (see also
Documentation/process/stable-api-nonsense.rst ;-)).

Regards,
Michal
