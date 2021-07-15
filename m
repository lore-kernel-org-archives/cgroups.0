From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] memcg: charge semaphores and sem_undo objects
Date: Thu, 15 Jul 2021 18:49:04 +0100
Message-ID: <YPB1EPaunr5587h5@casper.infradead.org>
References: <1626333284-1404-1-git-send-email-nglaive@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=INGSnpl1UpF6CdwmxMLPgOIu/v7mSG58jf2OlaWN2WI=; b=I3elTLEKAqHwyiShzj/pAC4cdj
        loGG8gASgYQuRt8tigUzu7jKCXIIchfjOEQKJ4zotfEnlnm02Nm4Q4gMMVPhFM6fqwOWDaLxEDVri
        pIXgQ7ogB8LVZ2ivfcStsBpCktqX8DthN8Rd9SUTdszdJJ9j22PwQX2k9jWTdkIhsLt4sJUODpIus
        2Cj4shRfDtqsNCfRjET45e9wvbkRvq2p4IJfLB0pelAedzrQoF4OUHiYlnmS3iVB5RCemKQwbm6HN
        HCdGV7Z343mVYcaWLc0ZfkBezLidn5096fEal0EuIS5v7XxHP/vahh0f86qSzBbpKO9oYHwexdYuZ
        fm4d4pNw==;
Content-Disposition: inline
In-Reply-To: <1626333284-1404-1-git-send-email-nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org

On Thu, Jul 15, 2021 at 03:14:44AM -0400, Yutian Yang wrote:
> This patch adds accounting flags to semaphores and sem_undo allocation
> sites so that kernel could correctly charge these objects. 
> 
> A malicious user could take up more than 63GB unaccounted memory under 
> default sysctl settings by exploiting the unaccounted objects. She could 
> allocate up to 32,000 unaccounted semaphore sets with up to 32,000 
> unaccounted semaphore objects in each set. She could further allocate one 
> sem_undo unaccounted object for each semaphore set.

Do we really have to account every object that's allocated on behalf of
userspace?  ie how seriously do we take this kind of thing?  Are memcgs
supposed to be a hard limit, or are they just a rough accounting thing?

There could be a very large stream of patches turning GFP_KERNEL into
GFP_KERNEL_ACCOUNT.  For example, file locks (fs/locks.c) are only
allocated with GFP_KERNEL and you can allocate one lock per byte of a
file.  I'm sure there are hundreds more places where we do similar things.
