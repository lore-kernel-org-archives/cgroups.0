From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Fix out-of-bounds on the buf returned
 by memory_stat_format
Date: Sat, 12 Sep 2020 17:42:41 -0700
Message-ID: <20200912174241.eeaa771755915f27babf9322@linux-foundation.org>
References: <20200912155100.25578-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599957762;
        bh=zWEjpsPiw3tRbjW3SotHs8K4FaJz/c98OlcLD4VZ/Dw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G6daZwQC9E45NL2heKtVG8/msTxuibvIJ6YUkqfpGHxV6KdQKOjvb2WwlBnCDDbnP
         paIS6oXa7OSwrOL1GK4t3UQ7V+V4W5dKteT3iN0kfMOuVP2j2uwpHNfeZwJQFBAdyT
         aNQC2h1TvgEYoKNi72Q0OOd/q9XzznkmSAKQVRk4=
In-Reply-To: <20200912155100.25578-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 12 Sep 2020 23:51:00 +0800 Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:

> The memory_stat_format() returns a format string, but the return buf
> may not including the trailing '\0'. So the users may read the buf
> out of bounds.

That sounds serious.  Is a cc:stable appropriate?

