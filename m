From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: default hierarchy interface for memory
 fix - "none"
Date: Tue, 20 Jan 2015 12:00:11 -0500
Message-ID: <CAOS58YNZFuSP6cKLAkYKkK+QUDxwngnKE5UGHmAL7n3PygraaQ@mail.gmail.com>
References: <1421508107-29377-1-git-send-email-hannes@cmpxchg.org>
	<20150120133711.GI25342@dhcp22.suse.cz>
	<20150120143002.GB11181@phnom.home.cmpxchg.org>
	<20150120143644.GL25342@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=zY4UXgSHkH4HOJO09X6fDUsndCb++3gGmlQDnk55fk8=;
        b=uElxMQWufOVWTGcbjDmZwPEOr6PcnsAyimWYDGrz1Gedul80IckU0urvIqIGLCsGK0
         N7hKXdJoyvW567Q/WqYyrwA2fyU58zb6OwYeDxw4Y4P3jtmlAWx0uyizl+OSr5nULK50
         b26aCmvPzkT75Zcy01/rBnXyW706ps0YSRJsnNdavOPu9mMldlmfH0199GTyI+fnWDj8
         wowTqSEbHn0hFljWxSC6wYe06cwYs7fxEJoA3dIEXsqSP6PJzkCpmaNpNTYY/ZWR5QvN
         bye71Fhd73xrNa8i5fb0eiLdJkRlkDei3rLcvftr05z9cVhAgIvAkvz0xnjSy8fXbYVg
         S4LA==
In-Reply-To: <20150120143644.GL25342-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Tue, Jan 20, 2015 at 9:36 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Tue 20-01-15 09:30:02, Johannes Weiner wrote:
> [...]
>> Another possibility would be "infinity",
>
> yes infinity definitely sounds much better to me.

FWIW, I prefer "max". It's shorter and clear enough. I don't think
there's anything ambiguous about "the memory max limit is at its
maximum". No need to introduce a different term.

Thanks.

-- 
tejun
