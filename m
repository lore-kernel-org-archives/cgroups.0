From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] mm/memcontrol: allow to uncharge page without using
 page->lru field
Date: Wed, 5 Jul 2017 20:22:35 +1000
Message-ID: <CAKTCnz=BLs5pteCvmK1ihvdrViTq6kXhoyQzfpRnbh+CgRYynw@mail.gmail.com>
References: <20170703211415.11283-1-jglisse@redhat.com> <20170703211415.11283-5-jglisse@redhat.com>
 <20170704125113.GC14727@dhcp22.suse.cz> <CAKTCnz=zTjYeqeTYZbnOMsT1Ccus4yW=jAws_OgXp3q4xmuSPA@mail.gmail.com>
 <20170705063813.GB10354@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zVypF3WGD3/BXk/TCtxxoV9MFYbJ6bfYx1zHTQozu20=;
        b=YS2EkcD7zI9dmIInoPAYYc9K2C7RekQrNnFWtIR6PLRX6FI1uTscSGM/ozCm055qL6
         RoLyeYr9Nubfha9qEUBY+Ssq3X8wVzApSTsuITmv5P5V/iXTSkb2F6Gxa9CLyKugNG9y
         0POcgdh0YwPpPR4StGwUuL/nwi+YWf8+jb/w36n5pYm4sbi4ywiCcEQkOfSwjO99WHWN
         /FBKzqM8Q0aUuptve9KtABYiX79n8ajzVxK31Ei9zMnXOWx9u3fBQSJHf8ofUYhTdKqg
         HvppF/LhirNa+e5jNKxHc633oTH7d8JQFeuGmei8wFSQV1v9AtOnJmboZpftbcfwroXv
         TbBA==
In-Reply-To: <20170705063813.GB10354-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 5, 2017 at 4:38 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed 05-07-17 13:18:18, Balbir Singh wrote:
>> On Tue, Jul 4, 2017 at 10:51 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > On Mon 03-07-17 17:14:14, J=C3=A9r=C3=B4me Glisse wrote:
>> >> HMM pages (private or public device pages) are ZONE_DEVICE page and
>> >> thus you can not use page->lru fields of those pages. This patch
>> >> re-arrange the uncharge to allow single page to be uncharge without
>> >> modifying the lru field of the struct page.
>> >>
>> >> There is no change to memcontrol logic, it is the same as it was
>> >> before this patch.
>> >
>> > What is the memcg semantic of the memory? Why is it even charged? AFAI=
R
>> > this is not a reclaimable memory. If yes how are we going to deal with
>> > memory limits? What should happen if go OOM? Does killing an process
>> > actually help to release that memory? Isn't it pinned by a device?
>> >
>> > For the patch itself. It is quite ugly but I haven't spotted anything
>> > obviously wrong with it. It is the memcg semantic with this class of
>> > memory which makes me worried.
>> >
>>
>> This is the HMM CDM case. Memory is normally malloc'd and then
>> migrated to ZONE_DEVICE or vice-versa. One of the things we did
>> discuss was seeing ZONE_DEVICE memory in user page tables.
>
> This doesn't answer any of the above questions though.


Jerome is the expert and I am sure he has a better answer, but my understan=
ding
is that this path gets called through release_pages() <-- zap_pte_range().
At first even I pondered about the same thing, but then came across this pa=
th.

Balbir Singh.
