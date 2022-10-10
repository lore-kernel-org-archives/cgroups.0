From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: Reorganize css_set_lock and kernfs path
 processing
Date: Mon, 10 Oct 2022 10:22:34 +0200
Message-ID: <Y0PWSlNmWT+1mkvB@blackbook>
References: <20220905170944.23071-1-mkoutny@suse.com>
 <Yxd/sUQ/NB3NlC6f@slm.duckdns.org>
 <YzQw/EvH9Sb58Au2@blackbook>
 <Yz21I9UpXafWMU0K@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1665390156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HJPGZK8y3k1EdlBwZWhtE19zM4qXrS86KACobAplA5c=;
        b=j0gqi2tCSAYg+2GXk/+EeCES7X6tg7S5oB0vr83zi2nQduiHZw+W2Hu5aF1zlINr5XVka4
        pbLxvD7u3GAstRFlR5w2//DEvpjXzNRxEPes7o0VwDIoyv9Why785oh7sj7wVrfeO43mtL
        315BMCvGL8cnHWCnlROYGj6JZaJcGow=
Content-Disposition: inline
In-Reply-To: <Yz21I9UpXafWMU0K-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Wed, Oct 05, 2022 at 06:47:31AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hmm... isn't current's root cgrp guaranteed to be alive?

True on the default hierarchy. v1 hierarchies (singular ones with root
cgroup only) can be unmounted.

> How would cgroup_get_live() fail?

kill_sb is not synchronized via css_set_lock.

> Also, shouldn't cgroup_get() enough for path walking?

If ref count dropped to zero, release callback (css_release_work_fn)
would be queued, cgroup_get would increase the refcount but it won't
cancel this.

Note these were concerns with the first version of the patch that also touched
cgroup_show_path() (that processes v1 hierarchies too). With the
reduction I avoided this.

Strictly speaking, even css_set_lock is unnecessary around
current_cgns_cgroup_from_root() when called with cgrp_dfl_root as the
cset->cgrp_links is not traversed at all.

> If you really wanna do it this way, can you please add a detailed comment
> here why this is safe? But I'd prefer just doing a strightforward ref
> inc/dec around it.

I see the the extraction under css_set_lock without inc/dec turns out
confusing. Let me expand the idea above and avoid css_set_lock
completely (another message).

Michal
