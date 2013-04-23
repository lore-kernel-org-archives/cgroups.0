From: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] vmpressure: in-kernel notifications
Date: Tue, 23 Apr 2013 22:13:42 +0300
Message-ID: <CAOJsxLHHvcHZHTKO9WTOOJvNW21NgNsUkreQnzwk3Wp=6XCgPg@mail.gmail.com>
References: <1366705329-9426-1-git-send-email-glommer@openvz.org>
	<1366705329-9426-2-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=gwauIk7PS40bERVd0MorJEjZk8jgVzzp3P7djQE4UAc=;
        b=pUNohl/l/MTtxMqySCexWPr9UHSFRXpFu6nwMSegfrgX783m0r9Z9Y9jxdhT3mCmEL
         wYNPlEjI7WGrMZbSdPrvSabCONvBaky4EZUp26w6cMv9nXw3RnqEHqCSAbfxfqhGEUKP
         MRYOLonTLsOvOVNXb3B/E77kUA6glmSyaj+VoS2C35cdMV31DIJAkMLmYm3FjkbnfMOR
         gAnEB30VcjU6V4m2VKVKxRC0OqfZfseW8k3mHcJ53zuMhIDB9Zv2us1bSEDVsgr9c5dr
         rjqlfcMvzqGd9sPWVwmaJMXesTc9dOT5vfckZi85Ouj6FFePtQtw1uPmeD/rPxi6I581
         R8BA==
In-Reply-To: <1366705329-9426-2-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "<cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue, Apr 23, 2013 at 11:22 AM, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>
> During the past weeks, it became clear to us that the shrinker interface
> we have right now works very well for some particular types of users,
> but not that well for others. The later are usually people interested in
> one-shot notifications, that were forced to adapt themselves to the
> count+scan behavior of shrinkers. To do so, they had no choice than to
> greatly abuse the shrinker interface producing little monsters all over.
>
> During LSF/MM, one of the proposals that popped out during our session
> was to reuse Anton Voronstsov's vmpressure for this. They are designed
> for userspace consumption, but also provide a well-stablished,
> cgroup-aware entry point for notifications.
>
> This patch extends that to also support in-kernel users. Events that
> should be generated for in-kernel consumption will be marked as such,
> and for those, we will call a registered function instead of triggering
> an eventfd notification.
>
> Please note that due to my lack of understanding of each shrinker user,
> I will stay away from converting the actual users, you are all welcome
> to do so.
>
> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Looks good to me.

Acked-by: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
