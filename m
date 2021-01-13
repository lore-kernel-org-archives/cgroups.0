From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
Date: Wed, 13 Jan 2021 11:34:46 -0800
Message-ID: <CALvZod57bG02rP7-Pyb_myssxDeROrU_+L6X9bwrrdEzQTxqYg@mail.gmail.com>
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com> <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
 <20210113184753.GB355124@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5x9peSoztZZwP3wRwUEonf3kp2KcQ+8lUkdq4yGVsyU=;
        b=dKHEpR8cis9PjPy0+s2wYpOJqK1jNlMC+AYrUDzd55sLM4EjSEbWjXCDMiHPNN4zdh
         2P193WmaFtrb6GOXbsiKGuG1Wloi2abeZNrFAXtpZZhUOExC5T4Y7XhFOH8g2JUDuMnr
         7QJY6Z40GpV8nHxvfUpsZW3+7c7FoTJPu26hvBTPXgk9p7lrw8JYrysx/Pf29BLn4Ty0
         Dpb5apB5yMbdw7ne2ezOVgWBtKfjA9ZjEpVGRlisyGCZ8Cmxlhu2O9RiI/lRFnLeCCOf
         lwBWTa7PnreEl+34r7HT3Tqu5FroOmAPNFcg2K+79LHu/GPJQHjGE8eCdAyPJW+rJsMh
         C7Ag==
In-Reply-To: <20210113184753.GB355124@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Arjun Roy <arjunroy@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Eric Dumazet <edumazet@google.com>, Andrew Morton <akpm@linux-foundation.org>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, Jan 13, 2021 at 10:48 AM Roman Gushchin <guro@fb.com> wrote:
>
[snip]
> > > Does it mean that a page can be accounted twice (even temporarily)?
> > >
> >
> > This was an actual consideration for this patchset that we went back
> > and forth on a little bit.
> > Short answer, for this patch in its current form: yes. We're calling
> > mem_cgroup_charge_sock_pages() immediately prior to vm_insert_pages();
> > and the skb isn't cleaned up until afterwards. Thus we have a period
> > of double charging.
> >
> > The pseudocode for the approach in this patch is:
> >
> > while skb = next skb in queue is not null:
> >     charge_skb_pages(skb.pages) // sets page.memcg for each page
> >     // at this point pages are double counted
> >     vm_insert_pages(skb.pages)
> >     free(skb) // unrefs the pages, no longer double counted
> >
> > An alternative version of this patch went the other way: have a short
> > period of undercharging.
> >
> > while skb = next skb in queue is not null:
> >     for page in skb.pages set page.memcg
> >     vm_insert_pages(skb.pages)
> >     free(skb) // unrefs the pages. pages are now undercounted
> > charge_skb_pages(nr_pages_mapped, FORCE_CHARGE) // count is now correct again
> > ret
>
> I have to think more, but at the first look the second approach is better.
> IMO forcing the charge is less of a problem than double accounting
> (we're forcing sock memory charging anyway). I'm afraid that even if the
> double counting is temporarily for each individual page, with a constant
> traffic it will create a permanent difference.
>

The double accounting behavior is a bit different in cgroup v1 vs v2
world as skmem is accounted in memory for v2 and a separate tcp
counter for v1. I am fine with either approaches mentioned by Arjun
but I would prefer to not add complexity by doing one approach for v1
and the other for v2.
