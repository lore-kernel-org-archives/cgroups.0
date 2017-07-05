From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] mm/memcontrol: allow to uncharge page without using
 page->lru field
Date: Wed, 5 Jul 2017 13:18:18 +1000
Message-ID: <CAKTCnz=zTjYeqeTYZbnOMsT1Ccus4yW=jAws_OgXp3q4xmuSPA@mail.gmail.com>
References: <20170703211415.11283-1-jglisse@redhat.com> <20170703211415.11283-5-jglisse@redhat.com>
 <20170704125113.GC14727@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LBwBI6OsNmRQUrjdcM5C6Ti2hpyahR5+VAnO87RAVAQ=;
        b=AGC7PSWorpzP9/T/0QkCcrVL58yJE1OZsI4lZ4p3/XggDwr2NLxgigEhzT2v+u7yXa
         7qJUa8t5FkCevCEIas22RqKBB2SYZeyqyIkX3C7uJP8S27SADbqtioaKwDp/bR3U51i2
         OSH+1m+BjiqjmSqPRP+3I2eeePtge4rptLzB45gPGBfLup4HOt+7jXQFFepme6jlKp8L
         zXaKez0Tz71BaxO0glRiEd9RKVL3gwWGmeyR9/2S+4xiY6OXTz6a0moDQsMDq0Or1+7x
         y0/4h4DjQyimCMbfOHG7KPEzpaLJ/ClxaRWdcgk9Ix9ge7wTtXWydiRScurCa9egHt3r
         TRsQ==
In-Reply-To: <20170704125113.GC14727-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jul 4, 2017 at 10:51 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon 03-07-17 17:14:14, J=C3=A9r=C3=B4me Glisse wrote:
>> HMM pages (private or public device pages) are ZONE_DEVICE page and
>> thus you can not use page->lru fields of those pages. This patch
>> re-arrange the uncharge to allow single page to be uncharge without
>> modifying the lru field of the struct page.
>>
>> There is no change to memcontrol logic, it is the same as it was
>> before this patch.
>
> What is the memcg semantic of the memory? Why is it even charged? AFAIR
> this is not a reclaimable memory. If yes how are we going to deal with
> memory limits? What should happen if go OOM? Does killing an process
> actually help to release that memory? Isn't it pinned by a device?
>
> For the patch itself. It is quite ugly but I haven't spotted anything
> obviously wrong with it. It is the memcg semantic with this class of
> memory which makes me worried.
>

This is the HMM CDM case. Memory is normally malloc'd and then
migrated to ZONE_DEVICE or vice-versa. One of the things we did
discuss was seeing ZONE_DEVICE memory in user page tables.

Balbir Singh.
