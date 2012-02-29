From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/10] memcg: Kernel Memory Accounting.
Date: Wed, 29 Feb 2012 11:28:56 -0800
Message-ID: <CABCjUKB5GO18rcr6v=x6=NAOVXKT679OJDQ_NDW+WeUf0N05qg@mail.gmail.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
	<4F4CD0AF.1050508@parallels.com>
	<CABCjUKCQk0RDWH80uQw+SxYsu=1L4GSGBNJWNFD=20o_j8P+ng@mail.gmail.com>
	<4F4E56A8.4000703@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=iGCc/29KO+nFCG1Xf3FTGKwO+nndCCm2FiQVh/vbyIE=;
        b=TwmNsDACQNxmsTWkr/sUwZYACVPZUiCHWPJYHUeLx9U2NtESPn7zkH+Fn/bCwe4bdR
         7MKNIEMFNbp75vJtdnaeWz+sgCcM99LZTNcGf8lnKdp29EMF5kZS4LW8A3ppMCZzfoUO
         Zukt1Q2Nm7KM5jILGdfy2B7AIuJGI4YFDaBYbbWfCH6eEbMXZVFr7Vb/k3s6kjGHuKKZ
         x8DFykiTyXZELQsYIUutroZN31Fgtlb3GT4fjmnIxw41DANdOpSlxkmI8lp9x6pxOnON
         CdPUPKs3ad0lcXfXDAuDITXRZwW8MaZ+LoP7+C5Z/20fFsEGkXIrPXvKEJH3BgthRlpp
         sm+w==
In-Reply-To: <4F4E56A8.4000703-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Wed, Feb 29, 2012 at 8:47 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> On 02/28/2012 07:47 PM, Suleiman Souhlal wrote:
>> I hadn't considered the fact that two cgroups could have the same base
>> name.
>> I think having a name makes it a lot easier for a human to understand
>> which cgroup is using slab, so what about having both the base name of
>> the cgroup AND its css id, so that the caches are named like
>> "dentry(5:foo)"?
>
>
> That would be better, so if you really want to keep names, I'd advise you to
> go this route.
>
> However, what does "5" really means to whoever is reading that? css ids are
> not visible to the user, so there isn't really too much information you can
> extract for that. So why not only dentry-5 ?

dentry-5 gives even less information.. :-)

>> This should let us use the name of the cgroup while still being able
>> to distiguish cgroups that have the same base name.
>
>
> I am fine with name+css_id if you really want names on it.
>
>
>>> I was thinking: How about we don't bother to show them at all, and
>>> instead,
>>> show a proc-like file inside the cgroup with information about that
>>> cgroup?
>>
>>
>> One of the patches in the series adds a per-memcg memory.kmem.slabinfo.
>
> I know. What I was wondering was if we wanted to show only the non-cgroup
> slabs in /proc/slabinfo, and then show the per-cgroup slabs in the cgroup
> only.

I think /proc/slabinfo should show all the slabs in the system, to
avoid confusion.

Thanks for your comments so far.
I will try to get a v2 out soon that addresses them.

-- Suleiman
