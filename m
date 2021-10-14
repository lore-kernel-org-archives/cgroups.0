From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 2/2] memcg: unify memcg stat flushing
Date: Thu, 14 Oct 2021 11:04:06 +0200
Message-ID: <20211014090406.GA62649@blackbody.suse.cz>
References: <20211001190040.48086-1-shakeelb@google.com>
 <20211001190040.48086-2-shakeelb@google.com>
 <20211013180122.GA1007@blackbody.suse.cz>
 <CALvZod6dN5Ub-r9+evXYCaeNuzrDs1byPLY1DAyn=R7rqHoqKg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634202247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lu12yO1VBRDo6VgSvac2BSrF4pgu+g9lquRIF7SLSvU=;
        b=LxA2lYm8DFK5I+Ih+5z2NdWuDvzhjnkebYh3JxYl4ebEJ3ItNSkOB/BILlLXSYlHJuW6MZ
        QJ1PXOanVyHcyZw2ORTbNI0qLl/mbSDt+Wr8zbEEYrPgZCPhCxif9PFVOK03U1NqDlYpM1
        Mg+HGBov+6qE3UB/TTCnohFyupV/o2M=
Content-Disposition: inline
In-Reply-To: <CALvZod6dN5Ub-r9+evXYCaeNuzrDs1byPLY1DAyn=R7rqHoqKg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Oct 13, 2021 at 12:24:31PM -0700, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> 1) The periodic async flush will keep the update tree small and will
> keep infrequent readers cheap.
> 2) Keep things simple for now and come back if someone complains for
> very frequent stats readers.

OK, understood.

Michal
