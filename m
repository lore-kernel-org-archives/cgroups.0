From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: restore ss->id_lock to spinlock, using RCU for next
Date: Thu, 19 Jan 2012 04:28:35 -0800
Message-ID: <CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils>
	<1326958401.1113.22.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=BF78hHWqa8gel/pL6n1z7pSk/KzzB1D24rm2i6Q5xoU=;
        b=OoRpnKTamRutuCSEvTtvoIhDkyC7Kk0tvzSeLdhUXwvGFBJ5QjasLq8LNN3DjNv5yk
         KL7HOIs+6Hj9DuJ7wuygVaMAkWyPqJOKeH+yyNo3FCoepNZHF3oDzkyyCPSmGzehTIjY
         X+h6B2jSE4Do3e39lqVq3Oc+/LFqZzeo/mx7M=
In-Reply-To: <1326958401.1113.22.camel@edumazet-laptop>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Manfred Spraul <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Jan 18, 2012 at 11:33 PM, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
> Interesting, but should be a patch on its own.

Yeap, agreed.

> Maybe other idr users can benefit from your idea as well, if patch is
> labeled =A0"idr: allow idr_get_next() from rcu_read_lock" or somethin=
g...
>
> I suggest introducing idr_get_next_rcu() helper to make the check abo=
ut
> rcu cleaner.
>
> idr_get_next_rcu(...)
> {
> =A0 =A0 =A0 =A0WARN_ON_ONCE(!rcu_read_lock_held());
> =A0 =A0 =A0 =A0return idr_get_next(...);
> }

Hmmm... I don't know. Does having a separate set of interface help
much?  It's easy to avoid/miss the test by using the other one.  If we
really worry about it, maybe indicating which locking is to be used
during init is better? We can remember the lockdep map and trigger
WARN_ON_ONCE() if neither the lock or RCU read lock is held.

Thanks.

--=20
tejun
