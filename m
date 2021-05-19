From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: Fw: User-controllable memcg-unaccounted objects of time namespace
Date: Wed, 19 May 2021 15:02:48 +0200
Message-ID: <YKUMePVUQlOYmVoA@dhcp22.suse.cz>
References: <CAELef9p42mQ5fvde3A7RSRZDNoDPP+VkR_3TJ5OPQYWsSQk07g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621429369; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7sb7HjwB7fPx0++dMj/9B9b0asNZublt2Rrsw4OLdEM=;
        b=e0pRHpEmr0ecausFTBJgJXJ+B9iTM3MrhyGwroskLbsCkA5gAKvBwNtJN4fZvwsUFk02cw
        2PwV9h4wVAHx5prtixXUyRZXbE1TSTCSk1lRysbGfqqtTGk+ZJ79A9J4XCdHK0JtonAJfm
        dgd8baxVtJNkdxEUYOtoKH+zGDtuBqs=
Content-Disposition: inline
In-Reply-To: <CAELef9p42mQ5fvde3A7RSRZDNoDPP+VkR_3TJ5OPQYWsSQk07g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glaive Neo <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org" <shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 19-05-21 19:43:56, Glaive Neo wrote:
> CC reply. Sorry for occupying your time. I was unaware that I had to
> use plain text e-mail to make public mailing list accept it, and I
> omitted these addresses to avoid rejecting notification.

HTML email are often dropped but they shouldn't be used as they make any
sensible communication hard (impossible at times). We also use (and
require) to use in-line replies so that it is clear what you are
actually replying to.

I would also strongly recommend to stick with the email thread. There
are tools to download complete email threads based on message-id in case
you do not have them
(https://people.kernel.org/monsieuricon/introducing-b4-and-patch-attestation).

HTH
-- 
Michal Hocko
SUSE Labs
