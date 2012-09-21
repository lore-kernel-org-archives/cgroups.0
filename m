From: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 09/16] sl[au]b: always get the cache from its page in kfree
Date: Fri, 21 Sep 2012 23:14:45 +0300
Message-ID: <CAOJsxLFgK3=Eu1UQt8NOSe30824UcuxZftxD1xnpkOt3MepOVg@mail.gmail.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
	<1347977530-29755-10-git-send-email-glommer@parallels.com>
	<00000139d9fe8595-8905906d-18ed-4d41-afdb-f4c632c2d50a-000000@email.amazonses.com>
	<5059777E.8060906@parallels.com>
	<CAOJsxLFgwOqUcLHEwYNERwn1Uvp4-8CmvRKTfBFAHD6p_-6c7g@mail.gmail.com>
	<505C33D3.5000202@parallels.com>
	<alpine.LFD.2.02.1209211240410.3619@tux.localdomain>
	<20120921200733.GM7264@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=dr4OpRkwChBxMStycObBZAZdWK4gc10RNJfoT9Smpto=;
        b=QtbVclsuKLDe3PlNY8mXYIo4S6GmOdXE/jH/5rb0oFGGdfgIZB5J+2RyE/gvzaO4Az
         TWbfdjkdcBQVISNccAfLI0Om+oZUd7mXUb8WpE8H9EXUR28c4WeVI/vo53up7mbX5fWs
         fy8c+C4fiCCL5cVBnUJMOy55OCt1QQEP/YOkVWVcF9aC/3F6pa6Bl0ztNuXwmW42vPQ3
         81t6mTm1GrNyuNQzWib/ZdV/kKhQRA8PFJQymOCXMNeB478QNqJqkJZdhyMZqXTXSUTe
         cjtZwolTBpvNukBLm3uOgIWSqYNXV+ALSI12qBjNW5M+m6H4JjKSKQodCCVmGIhDF1iI
         /YXQ==
In-Reply-To: <20120921200733.GM7264-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>

On Fri, Sep 21, 2012 at 11:07 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Not necessarily disagreeing, but I don't think it's helpful to set the
> bar impossibly high.  Even static_key doesn't have "exactly *zero*"
> impact.  Let's stick to as minimal as possible when not in use and
> reasonable in use.

For !CONFIG_MEMCG_KMEM, it should be exactly zero. No need to play
games with static_key.
