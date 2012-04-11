From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] remove BUG() in possible but rare condition
Date: Wed, 11 Apr 2012 11:57:56 -0700
Message-ID: <CA+55aFx1GMWGgh0sTAzvvVSzPQsQ_4NKeaNv1zpKrP4fg1dG+Q@mail.gmail.com>
References: <1334167824-19142-1-git-send-email-glommer@parallels.com> <20120411184845.GA24831@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        bh=jb8thJ2AaBLipW9GO08/OvCCckI5+/Ud/GY7TPSaxD4=;
        b=Fsc1TwOGEYT+Gd4R6sDCwq54a02h84TSdPH5SFs5w9T3uutU21/vH3hk/geFww+89t
         LF5GkxbjEeSF3zhdAyZjTFkJo7P1mNA7A9LdN0MzPynUJl44uO1jPNgxm45RxRENU3hG
         8zvjiPxQwMgA1Cd+r8Bg/Oao1PRhWMTItGje96M/ckrr/2+eBhsRtoBKz4ECjHv57j5B
         JsqiLICqkycvazvCwrdBaiqVeRIZIeHZ+zfatqbJD79yieh0JJl99eAIJqOiQVNNKhti
         uTipo42AJIqyRnz7ZHBBH88eKAX28umNsFjCU8MNM0Fi4MThTCJ11hRK0FMv3NrPAqdQ
         4zrg==
In-Reply-To: <20120411184845.GA24831-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed, Apr 11, 2012 at 11:48 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>
> I am not familiar with the code much but a trivial call chain walk up to
> write_dev_supers (in btrfs) shows that we do not check for the return value
> from __getblk so we would nullptr and there might be more.
> I guess these need some treat before the BUG might be removed, right?

Well, realistically, isn't BUG() as bad as a NULL pointer dereference?

Do you care about the exact message on the screen when your machine dies?

                     Linus
