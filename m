From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Fri, 18 Jul 2014 17:12:54 +0200
Message-ID: <CAJfpegt9k+YULet3vhmG3br7zSiHy-DRL+MiEE=HRzcs+mLzbw@mail.gmail.com>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
	<1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
	<20140715082545.GA9366@dhcp22.suse.cz>
	<20140715121935.GB9366@dhcp22.suse.cz>
	<20140718071246.GA21565@dhcp22.suse.cz>
	<20140718144554.GG29639@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=v+i6kLJpdqcQf6jou+iOnAw6ah07lWFi7RD5dwINpSc=;
        b=fxmtyEadGFwX6Aq3my2/nP6mojnLrKkspIhuetE3KmIDtCQo3EDKA3CEqNXQoXjsiA
         vvQuxscDWr3+wpxhJ/02doNTWXoqLsQ7tBzAwx3b4bniUov42hhx0sPD5DIhnn5TlBYj
         Cmibig1Qr3tPflUySL/Gdl12psyOMkkzAJV6w=
In-Reply-To: <20140718144554.GG29639@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Jul 18, 2014 at 4:45 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:

> I assumed the source page would always be new, according to this part
> in fuse_try_move_page():
>
>         /*
>          * This is a new and locked page, it shouldn't be mapped or
>          * have any special flags on it
>          */
>         if (WARN_ON(page_mapped(oldpage)))
>                 goto out_fallback_unlock;
>         if (WARN_ON(page_has_private(oldpage)))
>                 goto out_fallback_unlock;
>         if (WARN_ON(PageDirty(oldpage) || PageWriteback(oldpage)))
>                 goto out_fallback_unlock;
>         if (WARN_ON(PageMlocked(oldpage)))
>                 goto out_fallback_unlock;
>
> However, it's in the page cache and I can't really convince myself
> that it's not also on the LRU.  Miklos, I have trouble pinpointing
> where oldpage is instantiated exactly and what state it might be in -
> can it already be on the LRU?

oldpage comes from ->readpages() (*NOT* ->readpage()), i.e. readahead.

AFAICS it is added to the LRU in read_cache_pages(), so it looks like
it is definitely on the LRU at that point.

Thanks,
Miklos

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
