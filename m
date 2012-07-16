From: Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: containers and cgroups mini-summit @ Linux Plumbers
Date: Mon, 16 Jul 2012 17:08:08 -0400
Message-ID: <CAPhKKr_Z+APbN3tNZX-dqW8ehsB+RC+_3_5hTHAYG401igys3Q@mail.gmail.com>
References: <4FFDF321.4030103@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=5UfGBlbvvdxK3TP9dCE3GhjfO0t7AYPLeLhzqitQdJU=;
        b=UjBeRSTHY9GfRrfekNozHKYko2XbDK4Eoj1MEXCOI9BOhznQcGwVE7zGPqvpymaYES
         M74f+EFRvUG6GQkGJv3RCIfzG0UA4F5iMD1JLCuPLLErf/OjoPN+1hK0UPxfZrB0dt42
         KmoTbYWPyqZP4bEFY2COVg7Dv0HbyDBsA5g/0/CEvzfdr889RE6DIBL8/1MbmHjs6TLM
         44Ez/908M7wHiF2UzPxAcsvbTmt00w3WaJsluXfSUICuZNRO7kgVw2xvWpj4PR6xmgNj
         GKrR2EHiVnqOd5k/gYkQgwXmCdanQjpU9p8ulNHbswXeVBPyBl3qZGReYpXhEU8fYzPX
         NRDw==
In-Reply-To: <4FFDF321.4030103-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kir Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rohit Seth <rohitseth-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Balbir Singh <balbir-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, Dave Kleikamp <dave.kleikamp-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Maxim Patlasov <MPatlasov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Hi,

On Wed, Jul 11, 2012 at 5:41 PM, Kir Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> Gentlemen,
>
> We are organizing containers mini-summit during next Linux Plumbers (San
> Diego, August 29-31).
> The idea is to gather and discuss everything relevant to namespaces,
> cgroups, resource management,
> checkpoint-restore and so on.
>
> We are trying to come up with a list of topics to discuss, so please reply
> with topic suggestions, and
> let me know if you are going to come.
>

I will be at LPC, so I should be able to attend.

> I probably forgot a few more people (such as, I am not sure who else from
> Google is working
> on cgroups stuff), so fill free to forward this to anyone you believe should
> go,
> or just let me know whom I missed.

I would be interested mainly in discussing how cgroups core is
changing, imposing a set of rules on how new subsystems are being
designed (hierarchical vs non-hierarchical, and all that mess).

Dhaval
